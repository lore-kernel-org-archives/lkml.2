Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab1AAXKa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 18:10:30 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:43316 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab1AAXK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 18:10:28 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
References: <20101217152246.GA8221@mail.hallyn.com>
	<20101217152458.GA11162@mail.hallyn.com>
	<20101217152547.GB11162@mail.hallyn.com>
	<20101217152625.GC11162@mail.hallyn.com>
	<20101217152659.GD11162@mail.hallyn.com>
	<m14oacryar.fsf@fess.ebiederm.org>
	<20101217200903.GA15528@mail.hallyn.com>
	<m1d3p0qhl5.fsf@fess.ebiederm.org>
	<20110101044522.GA26476@mail.hallyn.com>
Date: Sat, 01 Jan 2011 15:10:19 -0800
In-Reply-To: <20110101044522.GA26476@mail.hallyn.com> (Serge E. Hallyn's
	message of "Sat, 1 Jan 2011 04:45:22 +0000")
Message-ID: <m1zkrkuso4.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+xcEdKcHyz8g5z9duBwdLk0Ch/0TM4fC4=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
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

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> "Serge E. Hallyn" <serge@hallyn.com> writes:
>> 
>> > Quoting Eric W. Biederman (ebiederm@xmission.com):
>> >> > --- a/kernel/signal.c
>> >> > +++ b/kernel/signal.c
>> >> > @@ -659,11 +686,7 @@ static int check_kill_permission(int sig, struct siginfo *info,
>> >> >  	cred = current_cred();
>> >> >  	tcred = __task_cred(t);
>> >> Nit pick  you don't need to compute cred and tcred here now.
>> >
>> > Just to make sure I understand right: you mean wait until after the
>> > same_thread_group() check to save calculation in that case, right?
>> 
>> I mean cred and tcred are only use in kill_ok_by_cred.
>> So we can eliminate those two variables from check_kill_permission.
>
> Thanks for the review.  Here is an updated version.

This one looks good.

Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

>
> Subject: [PATCH 4/5] allow killing tasks in your own or child userns
>
> Changelog:
> 	Dec 8: Fixed bug in my check_kill_permission pointed out by
> 	       Eric Biederman.
> 	Dec 13: Apply Eric's suggestion to pass target task into kill_ok_by_cred()
> 	        for clarity
> 	Dec 31: address comment by Eric Biederman:
> 		don't need cred/tcred in check_kill_permission.
>
> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> ---
>  kernel/signal.c |   36 ++++++++++++++++++++++++++++--------
>  1 files changed, 28 insertions(+), 8 deletions(-)
>
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 4e3cff1..d890c99 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -636,13 +636,39 @@ static inline bool si_fromuser(const struct siginfo *info)
>  }
>  
>  /*
> + * called with RCU read lock from check_kill_permission()
> + */
> +static inline int kill_ok_by_cred(struct task_struct *t)
> +{
> +	struct cred *cred = current_cred();
> +	struct cred *tcred = __task_cred(t);
> +
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
> @@ -656,14 +682,8 @@ static int check_kill_permission(int sig, struct siginfo *info,
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
