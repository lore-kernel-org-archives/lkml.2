Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab2LQTIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:08:42 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:43112 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab2LQTIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:08:40 -0500
MIME-Version: 1.0
In-Reply-To: <87lid0rvh9.fsf@xmission.com>
References: <87txroxpgq.fsf@xmission.com> <87bodwxpcg.fsf@xmission.com>
 <20121215000338.GC13659@mail.hallyn.com> <87r4msrx6t.fsf@xmission.com>
 <20121215004735.GA14295@mail.hallyn.com> <87lid0rvh9.fsf@xmission.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 17 Dec 2012 11:08:19 -0800
Message-ID: <CALCETrXYMHoGy6JSy4yTaZJPeUhSXpZ9Ae8F0wdAXGq7G_jPkA@mail.gmail.com>
Subject: Re: [PATCH 3/4] userns: Add a more complete capability subset test to commit_creds
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 4:48 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> When unsharing a user namespace we reduce our credentials to just what
> can be done in that user namespace.  This is a subset of the credentials
> we previously had.  Teach commit_creds to recognize this is a subset
> of the credentials we have had before and don't clear the dumpability flag.
>
> This allows an unprivileged  program to do:
> unshare(CLONE_NEWUSER);
> fd = open("/proc/self/uid_map", O_RDWR);
>
> Where previously opening the uid_map writable would fail because
> the the task had been made non-dumpable.
>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  kernel/cred.c |   27 ++++++++++++++++++++++++++-
>  1 files changed, 26 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/cred.c b/kernel/cred.c
> index 48cea3d..709d521 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c
> @@ -455,6 +455,31 @@ error_put:
>         return ret;
>  }
>
> +static bool cred_cap_issubset(const struct cred *set, const struct cred *subset)
> +{
> +       const struct user_namespace *set_ns = set->user_ns;
> +       const struct user_namespace *subset_ns = subset->user_ns;
> +
> +       /* If the two credentials are in the same user namespace see if
> +        * the capabilities of subset are a subset of set.
> +        */
> +       if (set_ns == subset_ns)
> +               return cap_issubset(subset->cap_permitted, set->cap_permitted);
> +
> +       /* The credentials are in a different user namespaces
> +        * therefore one is a subset of the other only if a set is an
> +        * ancestor of subset and set->euid is owner of subset or one
> +        * of subsets ancestors.
> +        */
> +       for (;subset_ns != &init_user_ns; subset_ns = subset_ns->parent) {
> +               if ((set_ns == subset_ns->parent)  &&
> +                   uid_eq(subset_ns->owner, set->euid))
> +                       return true;
> +       }
> +
> +       return false;
> +}
> +
>  /**
>   * commit_creds - Install new credentials upon the current task
>   * @new: The credentials to be assigned
> @@ -493,7 +518,7 @@ int commit_creds(struct cred *new)
>             !gid_eq(old->egid, new->egid) ||
>             !uid_eq(old->fsuid, new->fsuid) ||
>             !gid_eq(old->fsgid, new->fsgid) ||
> -           !cap_issubset(new->cap_permitted, old->cap_permitted)) {
> +           !cred_cap_issubset(old, new)) {
>                 if (task->mm)
>                         set_dumpable(task->mm, suid_dumpable);
>                 task->pdeath_signal = 0;
> --
> 1.7.5.4
>

Acked-by: Andy Lutomirski <luto@amacapital.net>
