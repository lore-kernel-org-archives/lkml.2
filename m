Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab2JJDZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 23:25:13 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:59983 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab2JJDZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 23:25:09 -0400
Date: Tue, 9 Oct 2012 20:25:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Cristian =?iso-8859-1?Q?Rodr=EDguez?= <crrodriguez@opensuse.org>,
        linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>
Subject: Re: include/linux/cgroup.h:566 suspicious rcu_dereference_check()
 usage!
Message-ID: <20121010032503.GB13994@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <506F649F.4050109@opensuse.org>
 <20121008194921.GF2453@linux.vnet.ibm.com>
 <20121010010859.GA3210@swordfish.datadirect.datadirectnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121010010859.GA3210@swordfish.datadirect.datadirectnet.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101003-2398-0000-0000-00000C1D64FB
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00181143; UDB=6.00041028; UTC=2012-10-10
 03:25:07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 06:08:59PM -0700, Sergey Senozhatsky wrote:
> On (10/08/12 12:49), Paul E. McKenney wrote:
> > 
> > ------------------------------------------------------------------------
> > 
> > device_cgroup: Restore rcu_read_lock() protection to devcgroup_inode_mknod()
> > 
> > Commit ad676077 (device_cgroup: convert device_cgroup internally to
> > policy + exceptions) restructured devcgroup_inode_mknod(), removing
> > rcu_read_lock() in the process.  However, RCU read-side protection
> > is required by the call to task_devcgroup(), so this commit restores
> > the rcu_read_lock() and rcu_read_unlock().
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> > index 44dfc41..c686110 100644
> > --- a/security/device_cgroup.c
> > +++ b/security/device_cgroup.c
> > @@ -576,9 +576,12 @@ int __devcgroup_inode_permission(struct inode *inode, int mask)
> >  
> >  int devcgroup_inode_mknod(int mode, dev_t dev)
> >  {
> > -	struct dev_cgroup *dev_cgroup = task_devcgroup(current);
> > +	struct dev_cgroup *dev_cgroup;
> > +	int ret;
> >  	short type;
> >  
> > +	rcu_read_lock();
> > +	dev_cgroup = task_devcgroup(current);
> >  	if (!S_ISBLK(mode) && !S_ISCHR(mode))
> >  		return 0;
> >  
> > @@ -587,7 +590,9 @@ int devcgroup_inode_mknod(int mode, dev_t dev)
> >  	else
> >  		type = DEV_CHAR;
> >  
> > -	return __devcgroup_check_permission(dev_cgroup, type, MAJOR(dev),
> > +	ret =  __devcgroup_check_permission(dev_cgroup, type, MAJOR(dev),
> >  					    MINOR(dev), ACC_MKNOD);
> > +	rcu_read_unlock();
> > +	return ret;
> >  
> >  }
> > 
> 
> 
> I believe the same should be done for __devcgroup_inode_permission() as well. And we
> probably can call task_devcgroup() and rcu_read_lock() after "S_ISBLK(mode) && !S_ISCHR(mode)"
> checks (I guess we also need to unlock RCU on `return 0').

Looks sane to me!  Dropping my patch.

							Thanx, Paul

> ----------------------------------------------------------------------------
> 
> Commit ad676077
>  | Author: Aristeu Rozanski <aris@redhat.com>
>  | Date:   Thu Oct 4 17:15:17 2012 -0700
>  |   device_cgroup: convert device_cgroup internally to policy + exceptions
> 
> moved RCU read-side protection from devcgroup_inode_mknod(), which, however is required
> by task_devcgroup(). Patch also add RCU read-side protection to __devcgroup_inode_permission()
> function, introduced in commit ad676077.
> 
> [    0.946303] include/linux/cgroup.h:566 suspicious rcu_dereference_check() usage!
> [    0.946511] 
> [    0.946606] 2 locks held by kdevtmpfs/28:
> [    0.946684]  #0:  (sb_writers){.+.+.+}, at: [<ffffffff81144bcb>] mnt_want_write+0x24/0x4b
> [    0.947083]  #1:  (&sb->s_type->i_mutex_key#3/1){+.+.+.}, at: [<ffffffff81133d04>] kern_path_create+0x83/0x144
> [    0.947598] 
> [    0.947787] Call Trace:
> [    0.947868]  [<ffffffff81089644>] lockdep_rcu_suspicious+0x109/0x112
> [    0.947958]  [<ffffffff81258fa0>] devcgroup_inode_mknod+0x9e/0xee
> [    0.948043]  [<ffffffff81132ee7>] vfs_mknod+0x8a/0xed
> [    0.948129]  [<ffffffff813b98af>] handle_create.isra.2+0x144/0x1b5
> [    0.948214]  [<ffffffff813b99bf>] ? devtmpfsd+0x9f/0x138
> [    0.948298]  [<ffffffff81295d5c>] ? do_raw_spin_lock+0x67/0xde
> [    0.948384]  [<ffffffff81295e92>] ? do_raw_spin_unlock+0x8f/0x98
> [    0.948469]  [<ffffffff813b9920>] ? handle_create.isra.2+0x1b5/0x1b5
> [    0.948554]  [<ffffffff813b9a04>] devtmpfsd+0xe4/0x138
> [    0.948638]  [<ffffffff813b9920>] ? handle_create.isra.2+0x1b5/0x1b5
> [    0.948724]  [<ffffffff810582b6>] kthread+0xd5/0xdd
> [    0.948814]  [<ffffffff814db664>] kernel_thread_helper+0x4/0x10
> [    0.948900]  [<ffffffff814d2973>] ? retint_restore_args+0x13/0x13
> [    0.948985]  [<ffffffff810581e1>] ? __init_kthread_worker+0x5a/0x5a
> [    0.949069]  [<ffffffff814db660>] ? gs_change+0x13/0x13
> 
> 
> devcgroup_inode_mknod() part submitted by Paul E. McKenney.
> 
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> ---
> 
>  security/device_cgroup.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index 44dfc41..043eb00 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -558,7 +558,8 @@ static int __devcgroup_check_permission(struct dev_cgroup *dev_cgroup,
> 
>  int __devcgroup_inode_permission(struct inode *inode, int mask)
>  {
> -	struct dev_cgroup *dev_cgroup = task_devcgroup(current);
> +	struct dev_cgroup *dev_cgroup;
> +	int ret;
>  	short type, access = 0;
> 
>  	if (S_ISBLK(inode->i_mode))
> @@ -570,13 +571,20 @@ int __devcgroup_inode_permission(struct inode *inode, int mask)
>  	if (mask & MAY_READ)
>  		access |= ACC_READ;
> 
> -	return __devcgroup_check_permission(dev_cgroup, type, imajor(inode),
> +	rcu_read_lock();
> +
> +	dev_cgroup = task_devcgroup(current);
> +	ret = __devcgroup_check_permission(dev_cgroup, type, imajor(inode),
>  					    iminor(inode), access);
> +
> +	rcu_read_unlock();
> +	return ret;
>  }
> 
>  int devcgroup_inode_mknod(int mode, dev_t dev)
>  {
> -	struct dev_cgroup *dev_cgroup = task_devcgroup(current);
> +	struct dev_cgroup *dev_cgroup;
> +	int ret;
>  	short type;
> 
>  	if (!S_ISBLK(mode) && !S_ISCHR(mode))
> @@ -587,7 +595,12 @@ int devcgroup_inode_mknod(int mode, dev_t dev)
>  	else
>  		type = DEV_CHAR;
> 
> -	return __devcgroup_check_permission(dev_cgroup, type, MAJOR(dev),
> +	rcu_read_lock();
> +
> +	dev_cgroup = task_devcgroup(current);
> +	ret = __devcgroup_check_permission(dev_cgroup, type, MAJOR(dev),
>  					    MINOR(dev), ACC_MKNOD);
> 
> +	rcu_read_unlock();
> +	return ret; 
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

