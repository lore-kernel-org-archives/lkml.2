Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab1F3JVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 05:21:18 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63933 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab1F3JVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 05:21:10 -0400
Date: Thu, 30 Jun 2011 13:21:03 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-hardening@lists.openwall.com, Randy Dunlap <rdunlap@xenotime.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [RFC] ipc: introduce shm_rmid_forced sysctl
Message-ID: <20110630092103.GA4252@albatros>
References: <20110622152514.GA9521@albatros>
 <20110629151436.9be479fb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629151436.9be479fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 15:14 -0700, Andrew Morton wrote:
> What a horrid patch.  But given the POSIX (mis?)feature I don't see a
> better way, and the feature seems desirable.  Sigh.
> 
> What sort of users would want to turn this on, and why?

A shared environment, e.g. a shared web hosting.  With multiple ipc
namespaces (on a VPS) each namespace can steal a few megabytes of memory
without any per user accounting.  Even if all user's processes are
killed, the orphaned shm is still kept in RAM.  It doesn't lead to OOM,
but it prevents from creating new segments and just annoys.


> > --- a/include/linux/ipc_namespace.h
> > +++ b/include/linux/ipc_namespace.h
> > @@ -44,6 +44,7 @@ struct ipc_namespace {
> >  	size_t		shm_ctlall;
> >  	int		shm_ctlmni;
> >  	int		shm_tot;
> > +	int		shm_rmid_forced;
> >  
> >  	struct notifier_block ipcns_nb;
> 
> Please send a patch which adds a nice comment to this field.

OK.

> Perhaps shm_rmid_forced should have had bool type.

OK.  The sysctl handler should parse it OK if feed it with sizeof(bool).

> > --- a/ipc/shm.c
> > +++ b/ipc/shm.c
> > @@ -74,6 +74,7 @@ void shm_init_ns(struct ipc_namespace *ns)
> >  	ns->shm_ctlmax = SHMMAX;
> >  	ns->shm_ctlall = SHMALL;
> >  	ns->shm_ctlmni = SHMMNI;
> > +	ns->shm_rmid_forced = 0;
> >  	ns->shm_tot = 0;
> >  	ipc_init_ids(&shm_ids(ns));
> >  }
> 
> The problem is that nobody will test your feature.  So for testing
> purposes, let's enable the feature by default.  I assume this:
> 
> --- a/ipc/shm.c~ipc-introduce-shm_rmid_forced-sysctl-ipc-introduce-shm_rmid_forced-sysctl-testing
> +++ a/ipc/shm.c
> @@ -74,7 +74,7 @@ void shm_init_ns(struct ipc_namespace *n
>  	ns->shm_ctlmax = SHMMAX;
>  	ns->shm_ctlall = SHMALL;
>  	ns->shm_ctlmni = SHMMNI;
> -	ns->shm_rmid_forced = 0;
> +	ns->shm_rmid_forced = 1;
>  	ns->shm_tot = 0;
>  	ipc_init_ids(&shm_ids(ns));
>  }
> 
> will do that?

Sure if it helps testing :)

> > +static bool shm_may_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
> > +{
> > +	return (shp->shm_nattch == 0) &&
> > +	       (ns->shm_rmid_forced ||
> > +		(shp->shm_perm.mode & SHM_DEST));
> > +}
> 
> Just because the existing code is crappily documented doesn't mean that
> we have to copy that ;)

OK ;)


Thank you!

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
