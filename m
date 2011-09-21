Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab1IUNPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 09:15:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37477 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1IUNPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 09:15:19 -0400
Date: Wed, 21 Sep 2011 08:15:14 -0500
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Miquel van Smoorenburg <mikevs@xs4all.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] User namespace: don't allow sysctl in non-init user ns
Message-ID: <20110921131514.GA2979@sergelap>
References: <xs4all.20110915194812.GA24348@sergelap>
 <1316598367.5939.12.camel@n2o.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316598367.5939.12.camel@n2o.xs4all.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miquel van Smoorenburg (mikevs@xs4all.net):
> On Thu, 2011-09-15 at 14:48 -0500, Serge E. Hallyn wrote:
> > sysctl.c has its own custom uid check, which is not user namespace
> > aware.  As discovered by Richard, that allows root in a container
> > privileged access to set all sysctls.
> > 
> > To fix that, just refuse access if current is not in init_user_ns.  We
> > may at some point want to relax that check so that some sysctls are
> > allowed - for instance dmesg_restrict when syslog is containerized.
> > 
> > Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
> > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> > Cc: Vasiliy Kulikov <segoon@openwall.com>
> > Cc: richard@nod.at
> > ---
> >  kernel/sysctl.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> > index 11d65b5..f2b42e2 100644
> > --- a/kernel/sysctl.c
> > +++ b/kernel/sysctl.c
> > @@ -1697,6 +1697,8 @@ void register_sysctl_root(struct ctl_table_root *root)
> >  
> >  static int test_perm(int mode, int op)
> >  {
> > +	if (current_user_ns() != &init_user_ns)
> > +		return -EACCES;
> >  	if (!current_euid())
> >  		mode >>= 6;
> >  	else if (in_egroup_p(0))
> 
> I haven't tested it, but it looks like this denies access to /proc/sys
> completely, right ?

True.  Good point.

> Wouldn't it be better to make access read-only ? 

It'd be better, yes.  For the moment we're trying to focus on making sure
there are no leaks out of the user namespace, so that then we can start
relaxing.  But I think you're right, this is easy enough to do right
from the start.

> For example glibc reads from several /proc/sys/... files for sysconf()
> and pathconf(). That would fail with this patch I think ?
> 
> Something like
> 
> --- a/kernel/sysctl.c.orig	2011-06-24 00:24:26.000000000 +0200
> +++ b/kernel/sysctl.c	2011-09-21 11:40:42.961291629 +0200
> @@ -1892,10 +1892,15 @@
>  
>  static int test_perm(int mode, int op)
>  {
> -	if (!current_euid())
> -		mode >>= 6;
> -	else if (in_egroup_p(0))
> -		mode >>= 3;
> +	if (current_user_ns() != &init_user_ns) {
> +		if (op & MAY_WRITE)
> +			return -EACCES;
> +	} else {
> +		if (!current_euid())
> +			mode >>= 6;
> +		else if (in_egroup_p(0))
> +			mode >>= 3;
> +	}
>  	if ((op & ~mode & (MAY_READ|MAY_WRITE|MAY_EXEC)) == 0)
>  		return 0;
>  	return -EACCES;

How about the following, slightly changed?  It tries to more precisely
follow the rule that access from another (non-ancestor) user-ns is
checked as access from the overflow userid (-1).

	if (current_user_ns() == &init_user_ns) {
		if (!current_euid())
			mode >>= 6;
		else if (in_egroup_p(0))
			mode >>= 3;
	}
  	if ((op & ~mode & (MAY_READ|MAY_WRITE|MAY_EXEC)) == 0)
  		return 0;
  	return -EACCES;

Does that make sense?  Yes it does mean that any world-writeable
files are writeable from a container, but those are the rules
we'd earlier defined.  (File creation (directory write) has to be
a special exception only because we don't have a valid owner to
assign to the new file).

Thanks for pointing this out!

-serge
