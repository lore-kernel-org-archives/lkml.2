Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab0LJLQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 06:16:45 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:52674 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab0LJLQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 06:16:43 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>,
        containers@lists.linux-foundation.org,
        Kees Cook <kees.cook@canonical.com>,
        kernel list <linux-kernel@vger.kernel.org>
References: <20101209172027.GA10085@mail.hallyn.com>
	<20101209172843.GA10155@mail.hallyn.com>
	<20101209173050.GA10206@mail.hallyn.com>
	<20101209173245.GB10206@mail.hallyn.com>
Date: Fri, 10 Dec 2010 03:16:34 -0800
In-Reply-To: <20101209173245.GB10206@mail.hallyn.com> (Serge E. Hallyn's
	message of "Thu, 9 Dec 2010 17:32:45 +0000")
Message-ID: <m14oal3mjx.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19m5Mammbwmpgk2hPxABWzRhNay56VvBMQ=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH 4/4] allow killing tasks in your own or child userns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Changelog:
> 	Dec 8: Fixed bug in my check_kill_permission pointed out by
> 	       Eric Biederman.
>
> To test:
> 	1. Test killing tasks as usual.  No change.
> 	2. Clone a new user namespace without a new pidns.
> 	   a. You CAN kill -CONT tasks in your thread group but outside
> 	      your user ns.
> 	   b. You can NOT otherwise kill tasks outside your user_ns.
> 	   c. Inside your new userns, signal semantics are as normal
> 	      with respect to userids, CAP_KILL, and thread groups.
>
> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> ---
>  kernel/signal.c |   27 ++++++++++++++++++++++-----
>  1 files changed, 22 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 4e3cff1..677025c 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -635,6 +635,27 @@ static inline bool si_fromuser(const struct siginfo *info)
>  		(!is_si_special(info) && SI_FROMUSER(info));
>  }
>  
> +static inline int kill_ok_by_cred(struct cred *cred, struct cred *tcred)
> +{
Nit: You should just pass in the target task here.
Making it abundantly clear where current and tcred come from.
ns_capable implicitly uses current which is a little surprising
when everything else is being passed in, but makes perfect sense
in this context.

> +	if (cred->user->user_ns != tcred->user->user_ns) {
> +		/* userids are not equivalent - either you have the
> +		   capability to the target user ns or you don't */
> +		if (ns_capable(tcred->user->user_ns, CAP_KILL))
> +			return 1;
> +		return 0;
> +	}
> +
> +	/* same user namespace - usual credentials checks apply */
> +	if ((cred->euid ^ tcred->suid) &&
> +	    (cred->euid ^ tcred->uid) &&
> +	    (cred->uid  ^ tcred->suid) &&
> +	    (cred->uid  ^ tcred->uid) &&
> +	    !ns_capable(tcred->user->user_ns, CAP_KILL))
> +		return 0;
> +
> +	return 1;
> +}
> +
>  /*
>   * Bad permissions for sending the signal
>   * - the caller must hold the RCU read lock
> @@ -659,11 +680,7 @@ static int check_kill_permission(int sig, struct siginfo *info,
>  	cred = current_cred();
>  	tcred = __task_cred(t);
>  	if (!same_thread_group(current, t) &&
> -	    (cred->euid ^ tcred->suid) &&
> -	    (cred->euid ^ tcred->uid) &&
> -	    (cred->uid  ^ tcred->suid) &&
> -	    (cred->uid  ^ tcred->uid) &&
> -	    !capable(CAP_KILL)) {
> +	    !kill_ok_by_cred(cred, tcred)) {
>  		switch (sig) {
>  		case SIGCONT:
>  			sid = task_session(t);
