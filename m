Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab1BWLkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 06:40:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356Ab1BWLk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 06:40:28 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110217150306.GB26395@mail.hallyn.com>
References: <20110217150306.GB26395@mail.hallyn.com> <20110217150224.GA26334@mail.hallyn.com>
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
Date: Wed, 23 Feb 2011 11:40:09 +0000
Message-ID: <29256.1298461209@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serge@hallyn.com> wrote:

>  	int (*capable) (struct task_struct *tsk, const struct cred *cred,
> -			int cap, int audit);
> +			struct user_namespace *ns, int cap, int audit);

Hmmm...  A chunk of the contents of the cred struct are user-namespaced.
Could you add the user_namespace pointer to the cred struct and thus avoid
passing it as an argument to other things.

In fact, I think you probably have to do this so that cachefiles, for example,
can override the user namespace when it operates on behalf of a process that's
in another namespace.

In fact, looking later on in your patch, I see:

> -		    || (cap_capable(current, current_cred(), CAP_SETPCAP,
> +		    || (cap_capable(current, current_cred(),
> +				    current_cred()->user->user_ns, CAP_SETPCAP,

so the user_ns _is_ already available through the creds.  So is there really a
need to pass it as an argument to anything that already takes a cred?

>   *	@cred contains the credentials to use.
> + *      @ns contains the user namespace we want the capability in
>   *	@cap contains the capability <include/linux/capability.h>.

That should be tabbed to match the lines either side.

David
