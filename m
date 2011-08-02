Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab1HBOZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 10:25:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46197 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab1HBOZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 10:25:35 -0400
X-Greylist: delayed 1014 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Aug 2011 10:25:35 EDT
Date: Tue, 2 Aug 2011 09:08:32 -0500
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, dhowells@redhat.com,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/14] allow root in container to copy namespaces (v3)
Message-ID: <20110802140832.GA26646@sergelap>
References: <1311706717-7398-1-git-send-email-serge@hallyn.com>
 <1311706717-7398-3-git-send-email-serge@hallyn.com>
 <m1hb67fh9l.fsf@fess.ebiederm.org>
 <20110729172748.GB18935@hallyn.com>
 <m1ei146a6t.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ei146a6t.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> The dangers of changing the namespace of a process remain the same,
> confused suid programs.  I don't believe there are any unique new
> dangers. 
> 
> Not allowing joining namespaces you already have a copy of is just
> a matter of making it hard to get things wrong.
> 
> I would feel more a bit more comfortable if the way we did this was
> to move all of the capable calls into the per namespace methods
> and then changed them one namespace at a time.  I don't think

The patch belows moves them into the per namespace methods, for
what it's worth.  If you like I can change them, for now, to
'capable(CAP_SYS_ADMIN)' targeted at init_user_ns, but if we're
targetting at the userns owning the destination namespace, it
seems this must be sufficient...

> there are any fundmanetal dangers of allowing unshare without
> the global CAP_SYS_ADMIN, but it would be good to be able to audit

If you have suspicions that there may in fact be dangers, then
perhaps this whole patch should be delayed, and copy_namespaces()
and unshare_nsproxy_namespaces() should continue to check global
CAP_SYS_ADMIN?  The only part which would remain would be the
moving of the setns capable check into the per-ns ->install
method, but it would check the global CAP_SYS_ADMIN?

> and make or revoke the decision one namespace at a time.
> 
> Eric
> 
> 
> > Changelog:
> >   Jul 29: setns: target capability check for setns
> >           When changing to another namespace, make sure that we have
> >           the CAP_SYS_ADMIN capability targeted at the user namespace
> >           owning the new ns.
> >
> > Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> > Cc: Eric W. Biederman <ebiederm@xmission.com>
> > ---
> >  ipc/namespace.c          |    3 +++
> >  kernel/fork.c            |    4 ++--
> >  kernel/nsproxy.c         |    7 ++-----
> >  kernel/utsname.c         |    3 +++
> >  net/core/net_namespace.c |    3 +++
> >  5 files changed, 13 insertions(+), 7 deletions(-)
> >
> > diff --git a/ipc/namespace.c b/ipc/namespace.c
> > index ce0a647..f527e49 100644
> > --- a/ipc/namespace.c
> > +++ b/ipc/namespace.c
> > @@ -163,6 +163,9 @@ static void ipcns_put(void *ns)
> >  
> >  static int ipcns_install(struct nsproxy *nsproxy, void *ns)
> >  {
> > +	struct ipc_namespace *newns = ns;
> > +	if (!ns_capable(newns->user_ns, CAP_SYS_ADMIN))
> > +		return -1;
> >  	/* Ditch state from the old ipc namespace */
> >  	exit_sem(current);
> >  	put_ipc_ns(nsproxy->ipc_ns);
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index e7ceaca..f9fac70 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -1488,8 +1488,8 @@ long do_fork(unsigned long clone_flags,
> >  		/* hopefully this check will go away when userns support is
> >  		 * complete
> >  		 */
> > -		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SETUID) ||
> > -				!capable(CAP_SETGID))
> > +		if (!nsown_capable(CAP_SYS_ADMIN) || !nsown_capable(CAP_SETUID) ||
> > +				!nsown_capable(CAP_SETGID))
> >  			return -EPERM;
> >  	}
> >  
> > diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> > index 9aeab4b..cadcee0 100644
> > --- a/kernel/nsproxy.c
> > +++ b/kernel/nsproxy.c
> > @@ -134,7 +134,7 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
> >  				CLONE_NEWPID | CLONE_NEWNET)))
> >  		return 0;
> >  
> > -	if (!capable(CAP_SYS_ADMIN)) {
> > +	if (!nsown_capable(CAP_SYS_ADMIN)) {
> >  		err = -EPERM;
> >  		goto out;
> >  	}
> > @@ -191,7 +191,7 @@ int unshare_nsproxy_namespaces(unsigned long unshare_flags,
> >  			       CLONE_NEWNET)))
> >  		return 0;
> >  
> > -	if (!capable(CAP_SYS_ADMIN))
> > +	if (!nsown_capable(CAP_SYS_ADMIN))
> >  		return -EPERM;
> >  
> >  	*new_nsp = create_new_namespaces(unshare_flags, current,
> > @@ -241,9 +241,6 @@ SYSCALL_DEFINE2(setns, int, fd, int, nstype)
> >  	struct file *file;
> >  	int err;
> >  
> > -	if (!capable(CAP_SYS_ADMIN))
> > -		return -EPERM;
> > -
> >  	file = proc_ns_fget(fd);
> >  	if (IS_ERR(file))
> >  		return PTR_ERR(file);
> > diff --git a/kernel/utsname.c b/kernel/utsname.c
> > index bff131b..8f648cc 100644
> > --- a/kernel/utsname.c
> > +++ b/kernel/utsname.c
> > @@ -104,6 +104,9 @@ static void utsns_put(void *ns)
> >  
> >  static int utsns_install(struct nsproxy *nsproxy, void *ns)
> >  {
> > +	struct uts_namespace *newns = ns;
> > +	if (!ns_capable(newns->user_ns, CAP_SYS_ADMIN))
> > +		return -1;
> >  	get_uts_ns(ns);
> >  	put_uts_ns(nsproxy->uts_ns);
> >  	nsproxy->uts_ns = ns;
> > diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
> > index 5bbdbf0..90c97f6 100644
> > --- a/net/core/net_namespace.c
> > +++ b/net/core/net_namespace.c
> > @@ -620,6 +620,9 @@ static void netns_put(void *ns)
> >  
> >  static int netns_install(struct nsproxy *nsproxy, void *ns)
> >  {
> > +	struct net *net = ns;
> > +	if (!ns_capable(net->user_ns, CAP_SYS_ADMIN))
> > +		return -1;
> >  	put_net(nsproxy->net_ns);
> >  	nsproxy->net_ns = get_net(ns);
> >  	return 0;
