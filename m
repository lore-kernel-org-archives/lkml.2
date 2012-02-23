Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab2BWAfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 19:35:33 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:56267 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab2BWAfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 19:35:31 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: dave@gnu.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Matthew Wilcox <matthew@wil.cx>, lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <1329737454.3058.3.camel@offbook>
Date: Wed, 22 Feb 2012 16:38:27 -0800
In-Reply-To: <1329737454.3058.3.camel@offbook> (Davidlohr Bueso's message of
	"Mon, 20 Feb 2012 12:30:54 +0100")
Message-ID: <m1r4xmz8n0.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/WrWWrjthuwxzWH4id2HKGitIW8U7NP4I=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: lkml.org]
	* -1.0 XM_URI_RBL_RM URI removed in uri.bl.xmission.com
	*      [URIs: gnu.org]
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 XMBrknScrpt_02 Possible Broken Spam Script
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;dave@gnu.org
X-Spam-Relay-Country: **
Subject: Re: [PATCH] locks: new procfs lockinfo
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davidlohr Bueso <dave@gnu.org> writes:

> From: Davidlohr Bueso <dave@gnu.org>
>
> Based on our previous discussion https://lkml.org/lkml/2012/2/10/462 we came to
> agree on deprecating the current /proc/locks in favor of a more extensible interface.
> The new /proc/lockinfo file exports similar information - except instead of maj:min the
> device name is shown - and entries are formated like those in /proc/cpuinfo, allowing us
> to add new entries without breaking userspace.

You can't know the device name, attempt to say what you don't know seems
very dangerous.  It may be reasonable to simply give the deivce number
and not split the device number into major/minor any more and I am
concerned about reality.

Andrew's question about the pid namespace is answered below.

> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  Documentation/feature-removal-schedule.txt |    9 +++
>  fs/locks.c                                 |  109 ++++++++++++++++++++++++++--
>  2 files changed, 113 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index a0ffac0..1c5e14b 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -524,3 +524,12 @@ Files:	arch/arm/mach-at91/at91cap9.c
>  Why:	The code is not actively maintained and platforms are now hard to find.
>  Who:	Nicolas Ferre <nicolas.ferre@atmel.com>
>  	Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> +
> +---------------------------
> +
> +What:	/proc/locks
> +When:	2014
> +Why:	The current /proc/locks file does not allow modifying entries as it breaks
> +        userspace (most notably lslk(8)). A new /proc/lockinfo interface replaces
> +        this file in a more extendable format (lines per entry), like /proc/cpuinfo.
> +Who:	Davidlohr Bueso <dave@gnu.org>

This is a ancient file of long standing I really doubt that we can
safely remove it any time soon.  Is there any good reason to want to
remove this file?

> diff --git a/fs/locks.c b/fs/locks.c
> index 637694b..f7b27fe 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -112,6 +112,9 @@
>   *  Leases and LOCK_MAND
>   *  Matthew Wilcox <willy@debian.org>, June, 2000.
>   *  Stephen Rothwell <sfr@canb.auug.org.au>, June, 2000.
> + *
> + *  Deprecated /proc/locks in favor of /proc/lockinfo
> + *  Davidlohr Bueso <dave@gnu.org>, February, 2012.
>   */
>  
>  #include <linux/capability.h>
> @@ -2156,6 +2159,10 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
>  	struct inode *inode = NULL;
>  	unsigned int fl_pid;
>  
> +	/* deprecated, see Documentation/feature-removal-schedule.txt */
> +	printk_once(KERN_WARNING "%s (%d): /proc/locks is deprecated please use /proc/lockinfo instead.\n",
> +		    current->comm, task_pid_nr(current));
> +
>  	if (fl->fl_nspid)
>  		fl_pid = pid_vnr(fl->fl_nspid);

Apparently this was overlooked.  Sigh.

We need not to use pid_vnr but instead pid_nr_ns(sb->s_fs_info, fl->fl_nspid);

For using this outside of fs/proc/base.c this clearly needs a trivial
helper instead of raw s_fs_info access, but the point remains that
the proc filesystem when mounted has a pid namespace that it displays
everything relative too and /proc/locks should be the same.

>  	else
> @@ -2199,15 +2206,10 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
>  			       : (fl->fl_type & F_WRLCK) ? "WRITE" : "READ ");
>  	}
>  	if (inode) {
> -#ifdef WE_CAN_BREAK_LSLK_NOW
> -		seq_printf(f, "%d %s:%ld ", fl_pid,
> -				inode->i_sb->s_id, inode->i_ino);
> -#else
>  		/* userspace relies on this representation of dev_t ;-( */
>  		seq_printf(f, "%d %02x:%02x:%ld ", fl_pid,
>  				MAJOR(inode->i_sb->s_dev),
>  				MINOR(inode->i_sb->s_dev), inode->i_ino);
> -#endif
>  	} else {
>  		seq_printf(f, "%d <none>:0 ", fl_pid);
>  	}
> @@ -2275,9 +2277,106 @@ static const struct file_operations proc_locks_operations = {
>  	.release	= seq_release_private,
>  };
>  
> +static void lockinfo_get_status(struct seq_file *f, struct file_lock *fl,
> +				loff_t id)
> +{
> +	struct inode *inode = NULL;
> +	unsigned int fl_pid;
> +
> +	if (fl->fl_nspid)
> +		fl_pid = pid_vnr(fl->fl_nspid);

We shouldn't copy the wrong definition for fl_pid from the old code but
should instead get this right.

> +	else
> +		fl_pid = fl->fl_pid;
> +
> +	if (fl->fl_file != NULL)
> +		inode = fl->fl_file->f_path.dentry->d_inode;
> +
> +	if (IS_POSIX(fl)) {
> +		seq_printf(f, "Personality:\t %s\n",
> +			   (fl->fl_flags & FL_ACCESS) ? "ACCESS" : "POSIX ");
> +		seq_printf(f, "Type:\t\t %s\n",
> +			   (!inode) ? "*NOINODE*" : mandatory_lock(inode)
> +			   ? "MANDATORY" : "ADVISORY ");
> +	} else if (IS_FLOCK(fl)) {
> +		seq_printf(f, "Personality:\t FLOCK\n");
> +		seq_printf(f, "Type:\t\t %s\n",
> +			   (fl->fl_type & LOCK_MAND) ? "MSNFS" : "ADVISORY");
> +	} else if (IS_LEASE(fl)) {
> +		seq_printf(f, "Personality:\t LEASE\n");
> +		seq_printf(f, "Type:\t\t %s\n",
> +			   (lease_breaking(fl)) ? "BREAKING"
> +			   : (fl->fl_file) ? "ACTIVE" : "BREAKER");
> +	} else {
> +		seq_printf(f, "Personality:\t UNKNOWN\n");
> +		seq_printf(f, "Type:\t\t UNKNOWN\n");
> +	}
> +
> +	if (fl->fl_type & LOCK_MAND) {
> +		seq_printf(f, "Access:\t\t %s\n",
> +			   (fl->fl_type & LOCK_READ)
> +			   ? (fl->fl_type & LOCK_WRITE) ? "RW   " : "READ "
> +			   : (fl->fl_type & LOCK_WRITE) ? "WRITE" : "NONE ");
> +	} else {
> +		seq_printf(f, "Access:\t\t %s\n",
> +			   (lease_breaking(fl))
> +			   ? (fl->fl_type & F_UNLCK) ? "UNLCK" : "READ "
> +			   : (fl->fl_type & F_WRLCK) ? "WRITE" : "READ ");
> +	}
> +
> +	seq_printf(f, "PID:\t\t %d\n", fl_pid);
> +
> +	if (inode) {
> +		seq_printf(f, "Device:\t\t %s\n",  inode->i_sb->s_id);

Hmm.  The label on this is wrong.    What if this comes from a
filesystem that is not block device based?  I expect it is ok to print
sb->s_id here but it needs a less confusing label.

> +		seq_printf(f, "Inode:\t\t %ld\n", inode->i_ino);
> +	}
> +
> +	if (IS_POSIX(fl)) {
> +		if (fl->fl_end == OFFSET_MAX)
> +			seq_printf(f, "Start-end:\t %Ld-EOF\n\n", fl->fl_start);
> +		else
> +			seq_printf(f, "Start-end:\t %Ld-%Ld\n\n", fl->fl_start, fl->fl_end);
> +	} else {
> +		seq_printf(f, "Start-end:\t 0-EOF\n\n");
> +	}
> +}
> +
> +static int lockinfo_show(struct seq_file *f, void *v)
> +{
> +	struct file_lock *fl, *bfl;
> +
> +	fl = list_entry(v, struct file_lock, fl_link);
> +
> +	lockinfo_get_status(f, fl, *((loff_t *)f->private));
> +
> +	list_for_each_entry(bfl, &fl->fl_block, fl_block)
> +		lockinfo_get_status(f, bfl, *((loff_t *)f->private));
> +
> +	return 0;
> +}
> +
> +static const struct seq_operations lockinfo_seq_operations = {
> +	.start	= locks_start,
> +	.next	= locks_next,
> +	.stop	= locks_stop,
> +	.show	= lockinfo_show,
> +};
> +
> +static int lockinfo_open(struct inode *inode, struct file *filp)
> +{
> +	return seq_open_private(filp, &lockinfo_seq_operations, sizeof(loff_t));
> +}
> +
> +static const struct file_operations proc_lockinfo_operations = {
> +	.open		= lockinfo_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= seq_release,
> +};
> +
>  static int __init proc_locks_init(void)
>  {
>  	proc_create("locks", 0, NULL, &proc_locks_operations);
> +	proc_create("lockinfo", 0, NULL, &proc_lockinfo_operations);
>  	return 0;
>  }
>  module_init(proc_locks_init);
