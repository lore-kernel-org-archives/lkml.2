Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab2BWKnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 05:43:40 -0500
Received: from damascus.uab.es ([158.109.168.135]:10316 "EHLO damascus.uab.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab2BWKni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 05:43:38 -0500
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Feb 2012 05:43:38 EST
Date: Thu, 23 Feb 2012 11:44:14 +0100
From: Davidlohr Bueso <dave@gnu.org>
Subject: Re: [PATCH] locks: new procfs lockinfo
In-reply-to: <m1r4xmz8n0.fsf@fess.ebiederm.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Matthew Wilcox <matthew@wil.cx>, lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Message-id: <1329993854.30585.3.camel@offworld>
Organization: GNU
MIME-version: 1.0
X-Mailer: Evolution 3.0.3-2
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
X-Spam-Tests: ALL_TRUSTED=-1
X-imss-version: 2.054
X-imss-result: Passed
X-imss-scanInfo: M:P L:N SM:0
X-imss-tmaseResult: TT:0 TS:0.0000 TC:00 TRN:0 TV:6.5.1024(18728.005)
X-imss-scores: Clean:99.90000 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:3 C:3 M:3 S:3 R:3 (0.5000 0.5000)
References: <1329737454.3058.3.camel@offbook> <m1r4xmz8n0.fsf@fess.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-22 at 16:38 -0800, Eric W. Biederman wrote:
> Davidlohr Bueso <dave@gnu.org> writes:
> 
> > From: Davidlohr Bueso <dave@gnu.org>
> >
> > Based on our previous discussion https://lkml.org/lkml/2012/2/10/462 we came to
> > agree on deprecating the current /proc/locks in favor of a more extensible interface.
> > The new /proc/lockinfo file exports similar information - except instead of maj:min the
> > device name is shown - and entries are formated like those in /proc/cpuinfo, allowing us
> > to add new entries without breaking userspace.
> 
> You can't know the device name, attempt to say what you don't know seems
> very dangerous.  It may be reasonable to simply give the deivce number
> and not split the device number into major/minor any more and I am
> concerned about reality.
> 
> Andrew's question about the pid namespace is answered below.
> 
> > Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> > ---
> >  Documentation/feature-removal-schedule.txt |    9 +++
> >  fs/locks.c                                 |  109 ++++++++++++++++++++++++++--
> >  2 files changed, 113 insertions(+), 5 deletions(-)
> >
> > diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> > index a0ffac0..1c5e14b 100644
> > --- a/Documentation/feature-removal-schedule.txt
> > +++ b/Documentation/feature-removal-schedule.txt
> > @@ -524,3 +524,12 @@ Files:	arch/arm/mach-at91/at91cap9.c
> >  Why:	The code is not actively maintained and platforms are now hard to find.
> >  Who:	Nicolas Ferre <nicolas.ferre@atmel.com>
> >  	Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > +
> > +---------------------------
> > +
> > +What:	/proc/locks
> > +When:	2014
> > +Why:	The current /proc/locks file does not allow modifying entries as it breaks
> > +        userspace (most notably lslk(8)). A new /proc/lockinfo interface replaces
> > +        this file in a more extendable format (lines per entry), like /proc/cpuinfo.
> > +Who:	Davidlohr Bueso <dave@gnu.org>
> 
> This is a ancient file of long standing I really doubt that we can
> safely remove it any time soon.  Is there any good reason to want to
> remove this file?
> 
> > diff --git a/fs/locks.c b/fs/locks.c
> > index 637694b..f7b27fe 100644
> > --- a/fs/locks.c
> > +++ b/fs/locks.c
> > @@ -112,6 +112,9 @@
> >   *  Leases and LOCK_MAND
> >   *  Matthew Wilcox <willy@debian.org>, June, 2000.
> >   *  Stephen Rothwell <sfr@canb.auug.org.au>, June, 2000.
> > + *
> > + *  Deprecated /proc/locks in favor of /proc/lockinfo
> > + *  Davidlohr Bueso <dave@gnu.org>, February, 2012.
> >   */
> >  
> >  #include <linux/capability.h>
> > @@ -2156,6 +2159,10 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
> >  	struct inode *inode = NULL;
> >  	unsigned int fl_pid;
> >  
> > +	/* deprecated, see Documentation/feature-removal-schedule.txt */
> > +	printk_once(KERN_WARNING "%s (%d): /proc/locks is deprecated please use /proc/lockinfo instead.\n",
> > +		    current->comm, task_pid_nr(current));
> > +
> >  	if (fl->fl_nspid)
> >  		fl_pid = pid_vnr(fl->fl_nspid);
> 
> Apparently this was overlooked.  Sigh.
> 
> We need not to use pid_vnr but instead pid_nr_ns(sb->s_fs_info, fl->fl_nspid);
> 
> For using this outside of fs/proc/base.c this clearly needs a trivial
> helper instead of raw s_fs_info access, but the point remains that
> the proc filesystem when mounted has a pid namespace that it displays
> everything relative too and /proc/locks should be the same.
> 
> >  	else
> > @@ -2199,15 +2206,10 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
> >  			       : (fl->fl_type & F_WRLCK) ? "WRITE" : "READ ");
> >  	}
> >  	if (inode) {
> > -#ifdef WE_CAN_BREAK_LSLK_NOW
> > -		seq_printf(f, "%d %s:%ld ", fl_pid,
> > -				inode->i_sb->s_id, inode->i_ino);
> > -#else
> >  		/* userspace relies on this representation of dev_t ;-( */
> >  		seq_printf(f, "%d %02x:%02x:%ld ", fl_pid,
> >  				MAJOR(inode->i_sb->s_dev),
> >  				MINOR(inode->i_sb->s_dev), inode->i_ino);
> > -#endif
> >  	} else {
> >  		seq_printf(f, "%d <none>:0 ", fl_pid);
> >  	}
> > @@ -2275,9 +2277,106 @@ static const struct file_operations proc_locks_operations = {
> >  	.release	= seq_release_private,
> >  };
> >  
> > +static void lockinfo_get_status(struct seq_file *f, struct file_lock *fl,
> > +				loff_t id)
> > +{
> > +	struct inode *inode = NULL;
> > +	unsigned int fl_pid;
> > +
> > +	if (fl->fl_nspid)
> > +		fl_pid = pid_vnr(fl->fl_nspid);
> 
> We shouldn't copy the wrong definition for fl_pid from the old code but
> should instead get this right.

Will correct.

> 
> > +	else
> > +		fl_pid = fl->fl_pid;
> > +
> > +	if (fl->fl_file != NULL)
> > +		inode = fl->fl_file->f_path.dentry->d_inode;
> > +
> > +	if (IS_POSIX(fl)) {
> > +		seq_printf(f, "Personality:\t %s\n",
> > +			   (fl->fl_flags & FL_ACCESS) ? "ACCESS" : "POSIX ");
> > +		seq_printf(f, "Type:\t\t %s\n",
> > +			   (!inode) ? "*NOINODE*" : mandatory_lock(inode)
> > +			   ? "MANDATORY" : "ADVISORY ");
> > +	} else if (IS_FLOCK(fl)) {
> > +		seq_printf(f, "Personality:\t FLOCK\n");
> > +		seq_printf(f, "Type:\t\t %s\n",
> > +			   (fl->fl_type & LOCK_MAND) ? "MSNFS" : "ADVISORY");
> > +	} else if (IS_LEASE(fl)) {
> > +		seq_printf(f, "Personality:\t LEASE\n");
> > +		seq_printf(f, "Type:\t\t %s\n",
> > +			   (lease_breaking(fl)) ? "BREAKING"
> > +			   : (fl->fl_file) ? "ACTIVE" : "BREAKER");
> > +	} else {
> > +		seq_printf(f, "Personality:\t UNKNOWN\n");
> > +		seq_printf(f, "Type:\t\t UNKNOWN\n");
> > +	}
> > +
> > +	if (fl->fl_type & LOCK_MAND) {
> > +		seq_printf(f, "Access:\t\t %s\n",
> > +			   (fl->fl_type & LOCK_READ)
> > +			   ? (fl->fl_type & LOCK_WRITE) ? "RW   " : "READ "
> > +			   : (fl->fl_type & LOCK_WRITE) ? "WRITE" : "NONE ");
> > +	} else {
> > +		seq_printf(f, "Access:\t\t %s\n",
> > +			   (lease_breaking(fl))
> > +			   ? (fl->fl_type & F_UNLCK) ? "UNLCK" : "READ "
> > +			   : (fl->fl_type & F_WRLCK) ? "WRITE" : "READ ");
> > +	}
> > +
> > +	seq_printf(f, "PID:\t\t %d\n", fl_pid);
> > +
> > +	if (inode) {
> > +		seq_printf(f, "Device:\t\t %s\n",  inode->i_sb->s_id);
> 
> Hmm.  The label on this is wrong.    What if this comes from a
> filesystem that is not block device based?  I expect it is ok to print
> sb->s_id here but it needs a less confusing label.

I think that even if its not a block based device, the "Device" label is
pretty obvious. 

I'll send a v2 of this patch with the corrections and documenting the
new file in Documentation/filesystems/proc.txt

Thanks,
Davidlohr


