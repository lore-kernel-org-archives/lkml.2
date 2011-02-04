Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1BDPzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 10:55:37 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:41272
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752180Ab1BDPzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 10:55:36 -0500
Date: Fri, 4 Feb 2011 15:56:15 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Bastian Blank <bastian@waldi.eu.org>
Subject: Re: [PATCH 03/08] allow sethostname in a container
Message-ID: <20110204155615.GA12062@mail.hallyn.com>
References: <20110111064342.GA27515@mail.hallyn.com>
 <20110111064420.GD27515@mail.hallyn.com>
 <20110111161431.GA1406@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110111161431.GA1406@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serge@hallyn.com):
> Quoting Serge E. Hallyn (serge@hallyn.com):
> > Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> > ---
> >  kernel/sys.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/sys.c b/kernel/sys.c
> > index 2745dcd..9b9b03b 100644
> > --- a/kernel/sys.c
> > +++ b/kernel/sys.c
> > @@ -1171,7 +1171,7 @@ SYSCALL_DEFINE2(sethostname, char __user *, name, int, len)
> >  	int errno;
> >  	char tmp[__NEW_UTS_LEN];
> >  
> > -	if (!capable(CAP_SYS_ADMIN))
> > +	if (!ns_capable(current->nsproxy->uts_ns->user_ns, CAP_SYS_ADMIN))
> >  		return -EPERM;
> >  	if (len < 0 || len > __NEW_UTS_LEN)
> >  		return -EINVAL;
> > -- 
> > 1.7.0.4
> 
> An interesting note here is that since the task doing ns_exec (and
> therefore in the init_user_ns) requires CAP_SYS_ADMIN to unshare,
> this check will actually always be true if uts_ns was not unshared.

Noone ever called me on this, so for the sake of posterity reading the
m-l archives:  what I said above is not true.  If uts_ns was not
unshared, then current->nsproxy->uts_ns->user_ns != current_user_ns(),
so current should not have ns_capable(current->nsproxy->uts_ns->user_ns,
CAP_SYS_ADMIN).  So the check will always return false.

> If uts is unshared, then regular capabilities semantics in the
> child user_ns apply (that is, root can do sethostname, unpriv user
> cannot)  The intent is that user namespaces will eventually allow
> unprivileged users to unshare, after which this will make much more
> sense.
> 
> -serge
