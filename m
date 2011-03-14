Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab1CNUCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:02:46 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:50468 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab1CNUCo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:02:44 -0400
From: Richard Weinberger <richard@nod.at>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Subject: Re: [PATCH] Restrict write access to dmesg_restrict
Date: Mon, 14 Mar 2011 21:02:39 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
Cc: akpm@linux-foundation.org, mingo@elte.hu, davem@davemloft.net,
        dzickus@redhat.com, randy.dunlap@oracle.com,
        linux-kernel@vger.kernel.org
References: <1300131356-24389-1-git-send-email-richard@nod.at> <1300132195.2194.6.camel@dan>
In-Reply-To: <1300132195.2194.6.camel@dan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103142102.39673.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 14 März 2011, 20:49:55 schrieb Dan Rosenberg:
> On Mon, 2011-03-14 at 20:35 +0100, Richard Weinberger wrote:
> > When dmesg_restrict is set to 1 CAP_SYS_ADMIN is needed
> > to read the kernel ring buffer.
> > But a root user without CAP_SYS_ADMIN is able to reset
> > dmesg_restrict to 0.
> 
> A minor correction, CAP_SYSLOG is needed to read the kernel syslog.  But
> I think requiring CAP_SYS_ADMIN is appropriate to modify the value of
> the sysctl, so assuming the commit message reflects this:

Thanks for the info!
I did not notice commit ce6ada3 (security: Define CAP_SYSLOG).
But as you said, writing to dmesg_restrict should still require CAP_SYS_ADMIN.

> Acked-by: Dan Rosenberg <drosenberg@vsecurity.com>
> 
> > This is an issue when e.g. LXC (Linux Containers) are used
> > and complete user space is running without CAP_SYS_ADMIN.
> > A unprivileged and jailed root user can bypass the
> > dmesg_restrict protection.
> > 
> > With this patch writing to dmesg_restrict is only allowed
> > when root has CAP_SYS_ADMIN.
> > 
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> > ---
> > 
> >  kernel/sysctl.c |   18 +++++++++++++++++-
> >  1 files changed, 17 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> > index 4eed0af..f90c8f6 100644
> > --- a/kernel/sysctl.c
> > +++ b/kernel/sysctl.c
> > @@ -169,6 +169,11 @@ static int proc_taint(struct ctl_table *table, int
> > write,
> > 
> >  			       void __user *buffer, size_t *lenp, loff_t *ppos);
> >  
> >  #endif
> > 
> > +#ifdef CONFIG_PRINTK
> > +static int proc_dmesg_restrict(struct ctl_table *table, int write,
> > +				void __user *buffer, size_t *lenp, loff_t *ppos);
> > +#endif
> > +
> > 
> >  #ifdef CONFIG_MAGIC_SYSRQ
> >  /* Note: sysrq code uses it's own private copy */
> >  static int __sysrq_enabled = SYSRQ_DEFAULT_ENABLE;
> > 
> > @@ -704,7 +709,7 @@ static struct ctl_table kern_table[] = {
> > 
> >  		.data		= &dmesg_restrict,
> >  		.maxlen		= sizeof(int),
> >  		.mode		= 0644,
> > 
> > -		.proc_handler	= proc_dointvec_minmax,
> > +		.proc_handler	= proc_dmesg_restrict,
> > 
> >  		.extra1		= &zero,
> >  		.extra2		= &one,
> >  	
> >  	},
> > 
> > @@ -2397,6 +2402,17 @@ static int proc_taint(struct ctl_table *table, int
> > write,
> > 
> >  	return err;
> >  
> >  }
> > 
> > +#ifdef CONFIG_PRINTK
> > +static int proc_dmesg_restrict(struct ctl_table *table, int write,
> > +				void __user *buffer, size_t *lenp, loff_t *ppos)
> > +{
> > +	if (write && !capable(CAP_SYS_ADMIN))
> > +		return -EPERM;
> > +
> > +	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
> > +}
> > +#endif
> > +
> > 
> >  struct do_proc_dointvec_minmax_conv_param {
> >  
> >  	int *min;
> >  	int *max;

