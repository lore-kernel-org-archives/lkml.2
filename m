Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab2LNCdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 21:33:39 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:37735 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab2LNCdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 21:33:35 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org
References: <87ip88uw4n.fsf@xmission.com> <50CA2B55.5070402@amacapital.net>
	<87mwxhtxve.fsf@xmission.com> <87zk1hshk7.fsf_-_@xmission.com>
	<CALCETrXLLcUu8Rajjx7+3N_6j5E0T0CR1h=hD+gcc5_r4Umyqw@mail.gmail.com>
Date: Thu, 13 Dec 2012 18:33:27 -0800
In-Reply-To: <CALCETrXLLcUu8Rajjx7+3N_6j5E0T0CR1h=hD+gcc5_r4Umyqw@mail.gmail.com>
	(Andy Lutomirski's message of "Thu, 13 Dec 2012 15:21:24 -0800")
Message-ID: <876245jrbc.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+VfImLVsoIww368j/XAF9ydI432ur7vbg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3051]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH] Fix cap_capable to only allow owners in the parent user namespace to have caps.
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andy thank you for your review.

Andy Lutomirski <luto@amacapital.net> writes:
> This is confusing enough that I can't immediately tell whether it's
> correct.  I think it's close but out of order.

Yeah.  That is the trick. Figuring out how to write that code so it is
correct and obvious.

I have added a comment at the top and removed the extra variable I was
adding.

The order except for verifying a user_ns->parent is valid by checking
for targ_ns == &init_user_ns doesn't make a difference.  Because
cred->user_ns can only be one of targ_ns or targ_ns->parent.

> Should this be transitive?

Yes.
>  I.e. suppose uid 1 owns a child of
> init_user_ns and uid 2 (mapped in the first ns as the identity) owns
> an inner ns.  Does uid 2 in the root ns have all caps inside?  I'd say
> no, but I don't have a great argument for that. 

I also say no.  It is more code and it doesn't fit my nice small
definition.  You have to be the owner and you have to be in the parent
of the target user namespace.  Being able to remember the rules in
your head is important.

> But uid 1 presumably
> does have caps because it could enter the parent with setns, then
> change uid, then enter the child.

Yes. uid 1 does have caps.

> How about (severely whitespace damaged):

You know that makes the termination condition a bit clearer.  But it
looses the nice place to put a comment when we loop again.  This loop
is just subtle enough that I want to preserve my comments.

I think I must have put -EPERM towards the end for the same reason to
make it clear that is the termination condition.

In practice I think it is important to have the cap_raised case first,
as that is the common case, and if we can be clear and still test that
case first it means the code will be faster.  With my reordering it is
obvious that nothing strange happens in the initial user namespace with
the owner test after the exit when we are the initial user namespace.

> int cap_capable(const struct cred *cred, struct user_namespace *targ_ns,
>                 int cap, int audit)
> {
>         struct user_namespace *here = targ_ns;
>
>         /* Walk up the namespace hierarchy until we find our own namespace. */
>         for (;;) {
>                 /* The owner of an ancestor namespace has all caps, if
> that owner is in the parent ns. */
>                 if (cred->user_ns == here->parent &&
> uid_eq(targ_ns->owner, cred->euid))
>                         return 0;

This would have needed a check that (here != &init_user_ns).  Because
the init_user_ns does not have a parent.

>                 /* Do we have the necessary capabilities? */
>                 if (here == cred->user_ns)
>                         return cap_raised(cred->cap_effective, cap) ?
> 0 : -EPERM;
>
>                 /* Have we tried all of the parent namespaces? */
>                 if (here == &init_user_ns)
>                         return -EPERM;
>                 else
>                         here = targ_ns->parent;
>         }
> }

