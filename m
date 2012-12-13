Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab2LMXVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 18:21:49 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:55033 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab2LMXVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 18:21:45 -0500
MIME-Version: 1.0
In-Reply-To: <87zk1hshk7.fsf_-_@xmission.com>
References: <87ip88uw4n.fsf@xmission.com> <50CA2B55.5070402@amacapital.net>
 <87mwxhtxve.fsf@xmission.com> <87zk1hshk7.fsf_-_@xmission.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Dec 2012 15:21:24 -0800
Message-ID: <CALCETrXLLcUu8Rajjx7+3N_6j5E0T0CR1h=hD+gcc5_r4Umyqw@mail.gmail.com>
Subject: Re: [RFC][PATCH] Fix cap_capable to only allow owners in the parent
 user namespace to have caps.
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 2:39 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Andy Lutomirski pointed out that the current behavior of allowing the
> owner of a user namespace to have all caps when that owner is not in a
> parent user namespace is wrong.
>
> This is a bug introduced by the kuid conversion which made it possible
> for the owner of a user namespace to live in a child user namespace.  I
> goofed and totally missed this implication.
>
> Serge and can you please take a look and see if my corrected cap_capable
> reads correctly to you.
>
> Andy or anyone else that wants to give me a second eyeball and double
> check me on this I would appreciate it.
>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> ---
>
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 6dbae46..4639f44 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -70,37 +70,44 @@ int cap_netlink_send(struct sock *sk, struct sk_buff *skb)
>   *
>   * NOTE WELL: cap_has_capability() cannot be used like the kernel's capable()
>   * and has_capability() functions.  That is, it has the reverse semantics:
>   * cap_has_capability() returns 0 when a task has a capability, but the
>   * kernel's capable() and has_capability() returns 1 for this case.
>   */
>  int cap_capable(const struct cred *cred, struct user_namespace *targ_ns,
>                 int cap, int audit)
>  {
>         for (;;) {
> -               /* The owner of the user namespace has all caps. */
> -               if (targ_ns != &init_user_ns && uid_eq(targ_ns->owner, cred->euid))
> -                       return 0;
> +               struct user_namespace *parent_ns;
>
>                 /* Do we have the necessary capabilities? */
>                 if (targ_ns == cred->user_ns)
>                         return cap_raised(cred->cap_effective, cap) ? 0 : -EPERM;
>
>                 /* Have we tried all of the parent namespaces? */
>                 if (targ_ns == &init_user_ns)
>                         return -EPERM;
>
> +               parent_ns = targ_ns->parent;
> +
> +               /*
> +                * The owner of the user namespace in the parent user
> +                * namespace has all caps.
> +                */
> +               if ((parent_ns == cred->user_ns) && uid_eq(targ_ns->owner, cred->euid))
> +                       return 0;

This is confusing enough that I can't immediately tell whether it's
correct.  I think it's close but out of order.

Should this be transitive?  I.e. suppose uid 1 owns a child of
init_user_ns and uid 2 (mapped in the first ns as the identity) owns
an inner ns.  Does uid 2 in the root ns have all caps inside?  I'd say
no, but I don't have a great argument for that.  But uid 1 presumably
does have caps because it could enter the parent with setns, then
change uid, then enter the child.

How about (severely whitespace damaged):

int cap_capable(const struct cred *cred, struct user_namespace *targ_ns,
                int cap, int audit)
{
        struct user_namespace *here = targ_ns;

        /* Walk up the namespace hierarchy until we find our own namespace. */
        for (;;) {
                /* The owner of an ancestor namespace has all caps, if
that owner is in the parent ns. */
                if (cred->user_ns == here->parent &&
uid_eq(targ_ns->owner, cred->euid))
                        return 0;

                /* Do we have the necessary capabilities? */
                if (here == cred->user_ns)
                        return cap_raised(cred->cap_effective, cap) ?
0 : -EPERM;

                /* Have we tried all of the parent namespaces? */
                if (here == &init_user_ns)
                        return -EPERM;
                else
                        here = targ_ns->parent;
        }
}

--Andy
