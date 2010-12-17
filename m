Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab0LQTbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 14:31:47 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:48646 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab0LQTbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 14:31:44 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <michael.kerrisk@gmail.com>
References: <20101217152246.GA8221@mail.hallyn.com>
	<20101217152458.GA11162@mail.hallyn.com>
	<20101217152547.GB11162@mail.hallyn.com>
	<20101217152625.GC11162@mail.hallyn.com>
	<20101217152659.GD11162@mail.hallyn.com>
Date: Fri, 17 Dec 2010 11:31:40 -0800
In-Reply-To: <20101217152659.GD11162@mail.hallyn.com> (Serge E. Hallyn's
	message of "Fri, 17 Dec 2010 15:26:59 +0000")
Message-ID: <m14oacryar.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/0n9dcrllCWv5m8ESAYEth8MWYX4XMgqo=
X-SA-Exim-Connect-IP: 98.207.157.188
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
Subject: Re: [RFC 4/5] user namespaces: allow killing tasks in your own or child userns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Changelog:
> 	Dec 8: Fixed bug in my check_kill_permission pointed out by
> 	       Eric Biederman.
> 	Dec 13: Apply Eric's suggestion to pass target task into kill_ok_by_cred()
> 	        for clarity
>
> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> ---
>  kernel/signal.c |   33 ++++++++++++++++++++++++++++-----
>  1 files changed, 28 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 4e3cff1..499bd36 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -659,11 +686,7 @@ static int check_kill_permission(int sig, struct siginfo *info,
>  	cred = current_cred();
>  	tcred = __task_cred(t);
Nit pick  you don't need to compute cred and tcred here now.

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
