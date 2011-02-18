Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab1BRDAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:00:52 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:35365 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab1BRDAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:00:50 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
References: <20110217150224.GA26334@mail.hallyn.com>
	<20110217150325.GD26395@mail.hallyn.com>
Date: Thu, 17 Feb 2011 19:00:44 -0800
In-Reply-To: <20110217150325.GD26395@mail.hallyn.com> (Serge E. Hallyn's
	message of "Thu, 17 Feb 2011 15:03:25 +0000")
Message-ID: <m162si9hcz.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18gn+gip1meC/cufmD/ZpzKjydi9X2+j2k=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 4/9] allow killing tasks in your own or child userns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Changelog:
> 	Dec  8: Fixed bug in my check_kill_permission pointed out by
> 	        Eric Biederman.
> 	Dec 13: Apply Eric's suggestion to pass target task into kill_ok_by_cred()
> 	        for clarity
> 	Dec 31: address comment by Eric Biederman:
> 		don't need cred/tcred in check_kill_permission.
> 	Jan  1: use const cred struct.
> 	Jan 11: Per Bastian Blank's advice, clean up kill_ok_by_cred().
> 	Feb 16: kill_ok_by_cred: fix bad parentheses

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

>
> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> ---
>  kernel/signal.c |   30 ++++++++++++++++++++++--------
>  1 files changed, 22 insertions(+), 8 deletions(-)
>
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 4e3cff1..ffe4bdf 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -636,13 +636,33 @@ static inline bool si_fromuser(const struct siginfo *info)
>  }
>  
>  /*
> + * called with RCU read lock from check_kill_permission()
> + */
> +static inline int kill_ok_by_cred(struct task_struct *t)
> +{
> +	const struct cred *cred = current_cred();
> +	const struct cred *tcred = __task_cred(t);
> +
> +	if (cred->user->user_ns == tcred->user->user_ns &&
> +	    (cred->euid == tcred->suid ||
> +	     cred->euid == tcred->uid ||
> +	     cred->uid  == tcred->suid ||
> +	     cred->uid  == tcred->uid))
> +		return 1;
> +
> +	if (ns_capable(tcred->user->user_ns, CAP_KILL))
> +		return 1;
> +
> +	return 0;
> +}
> +
> +/*
>   * Bad permissions for sending the signal
>   * - the caller must hold the RCU read lock
>   */
>  static int check_kill_permission(int sig, struct siginfo *info,
>  				 struct task_struct *t)
>  {
> -	const struct cred *cred, *tcred;
>  	struct pid *sid;
>  	int error;
>  
> @@ -656,14 +676,8 @@ static int check_kill_permission(int sig, struct siginfo *info,
>  	if (error)
>  		return error;
>  
> -	cred = current_cred();
> -	tcred = __task_cred(t);
>  	if (!same_thread_group(current, t) &&
> -	    (cred->euid ^ tcred->suid) &&
> -	    (cred->euid ^ tcred->uid) &&
> -	    (cred->uid  ^ tcred->suid) &&
> -	    (cred->uid  ^ tcred->uid) &&
> -	    !capable(CAP_KILL)) {
> +	    !kill_ok_by_cred(t)) {
>  		switch (sig) {
>  		case SIGCONT:
>  			sid = task_session(t);
