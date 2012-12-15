Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946150Ab2LNX6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:58:33 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:58492 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945910Ab2LNX63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:58:29 -0500
Date: Sat, 15 Dec 2012 00:03:38 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/4] userns: Add a more complete capability subset test
 to commit_creds
Message-ID: <20121215000338.GC13659@mail.hallyn.com>
References: <87txroxpgq.fsf@xmission.com>
 <87bodwxpcg.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bodwxpcg.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
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

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  kernel/cred.c |   26 +++++++++++++++++++++++++-
>  1 files changed, 25 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/cred.c b/kernel/cred.c
> index 48cea3d..993a7ea41 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c
> @@ -455,6 +455,30 @@ error_put:
>  	return ret;
>  }
>  

Do you think we need to warn that this can only be used for
commit_creds?  (i.e. if someone tried ot use this in some
other context, the 'creds are subset of target ns is a child
of current_ns' assumption would be wrong)

> +static bool cred_cap_issubset(const struct cred *set, const struct cred *subset)
> +{
> +	const struct user_namespace *set_ns = set->user_ns;
> +	const struct user_namespace *subset_ns = subset->user_ns;
> +
> +	/* If the two credentials are in the same user namespace see if
> +	 * the capabilities of subset are a subset of set.
> +	 */
> +	if (set_ns == subset_ns)
> +		return cap_issubset(subset->cap_permitted, set->cap_permitted);
> +
> +	/* The credentials are in a different user namespaces

This can only happen during setns and CLONE_NEWUSER right?

> +	 * therefore one is a subset of the other only if a set is an
> +	 * ancestor of subset.
> +	 */

> +	while (subset_ns != &init_user_ns) {
> +		if (set_ns == subset_ns->parent)
> +			return true;
> +		subset_ns = subset_ns->parent;
> +	}
> +
> +	return false;
> +}
> +
>  /**
>   * commit_creds - Install new credentials upon the current task
>   * @new: The credentials to be assigned
> @@ -493,7 +517,7 @@ int commit_creds(struct cred *new)
>  	    !gid_eq(old->egid, new->egid) ||
>  	    !uid_eq(old->fsuid, new->fsuid) ||
>  	    !gid_eq(old->fsgid, new->fsgid) ||
> -	    !cap_issubset(new->cap_permitted, old->cap_permitted)) {
> +	    !cred_cap_issubset(old, new)) {
>  		if (task->mm)
>  			set_dumpable(task->mm, suid_dumpable);
>  		task->pdeath_signal = 0;
> -- 
> 1.7.5.4
