Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab1BWMDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 07:03:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab1BWMDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 07:03:13 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <29256.1298461209@redhat.com>
References: <29256.1298461209@redhat.com> <20110217150306.GB26395@mail.hallyn.com> <20110217150224.GA26334@mail.hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: dhowells@redhat.com, LSM <linux-security-module@vger.kernel.org>,
        Andrew Morton <akpm@osdl.org>, James Morris <jmorris@namei.org>,
        Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com
Subject: Re: [PATCH 2/9] security: Make capabilities relative to the user namespace.
Date: Wed, 23 Feb 2011 12:01:57 +0000
Message-ID: <29617.1298462517@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> >  	int (*capable) (struct task_struct *tsk, const struct cred *cred,
> > -			int cap, int audit);
> > +			struct user_namespace *ns, int cap, int audit);
> 
> Hmmm...  A chunk of the contents of the cred struct are user-namespaced.
> Could you add the user_namespace pointer to the cred struct and thus avoid
> passing it as an argument to other things.

Ah, no...  Ignore that, I think I see that you do need it.

> +int cap_capable(struct task_struct *tsk, const struct cred *cred,
> +		struct user_namespace *targ_ns, int cap, int audit)
>  {
> -	return cap_raised(cred->cap_effective, cap) ? 0 : -EPERM;
> +	for (;;) {
> +		/* The creator of the user namespace has all caps. */
> +		if (targ_ns != &init_user_ns && targ_ns->creator == cred->user)
> +			return 0;

Why is that last comment so?  Why should the creating namespace sport all
possible capabilities?  Do you have to have all capabilities available to you
to be permitted create a new user namespace?

Also, would it be worth having a separate cap_ns_capable()?  Wouldn't most
calls to cap_capable() only be checking the caps granted in the current user
namespace?

David
