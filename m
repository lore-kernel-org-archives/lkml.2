Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192Ab2FHCIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 22:08:38 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:50341 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760090Ab2FHCIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 22:08:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>, Sage Weil <sage@newdream.net>
In-Reply-To: <20120608003604.GK30000@ZenIV.linux.org.uk> (Al Viro's message of
	"Fri, 8 Jun 2012 01:36:04 +0100")
References: <20120606230040.GA18089@redhat.com>
	<CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
	<20120606235403.GC30000@ZenIV.linux.org.uk>
	<20120607002914.GB22223@redhat.com>
	<CA+55aFyp2GUbc218eb5BDyAqz+cOPTJMVcb4ptk+f1_RBB+-mg@mail.gmail.com>
	<20120607011915.GA17566@redhat.com>
	<20120607012900.GE30000@ZenIV.linux.org.uk>
	<20120607193607.GI30000@ZenIV.linux.org.uk>
	<873966n2c2.fsf@xmission.com>
	<CA+55aFxxS3+NmZacr76qNmEu9=-=aw61gW1Ebugg8hdMNgKiJA@mail.gmail.com>
	<20120608003604.GK30000@ZenIV.linux.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Thu, 07 Jun 2012 19:08:04 -0700
Message-ID: <87mx4eimij.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX191Owq2RSLiPOSFJu4ze62pNQVGSS2ALnI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: Re: processes hung after sys_renameat, and 'missing' processes
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Thu, Jun 07, 2012 at 04:57:13PM -0700, Linus Torvalds wrote:
>
>> Any per-filesystem mutex should do, so if sysfs always holds the
>> sysfs_mutex - and never allows user-initiated renames - it should be
>> safe.
>
> Frankly, I would very much prefer to have the same locking rules wherever
> possible.  The locking system is already overcomplicated and making its
> analysis fs-dependent as well... <shudder>  Sure, we can do that, and that
> might even work, until we find out that some piece of code that started
> as a helper to some function never called on sysfs dentries had been
> reused on the path that *is* reachable on sysfs.  At which point we are
> suddenly in trouble.

Staring at it I see what I was missing.   The practical issue is
lock_rename(), and any parts of the vfs that depend on lock_rename().

d_move and the dcache are made safe just by rename_lock.  However other
parts of the vfs that care about using d_ancestor are not.  I can't
immediately see a case that really cares but I can't rule such a case
out easily either.

> I wouldn't be bothered so much if the overall picture had been simpler;
> unfortunately, it isn't.
>
> Eric, how about this - if nothing else, that makes code in there simpler
> and less dependent on details of VFS guts:
>
> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index e6bb9b2..5579826 100644
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -363,7 +363,7 @@ static void sysfs_dentry_iput(struct dentry *dentry, struct inode *inode)
>  	iput(inode);
>  }
>  
> -static const struct dentry_operations sysfs_dentry_ops = {
> +const struct dentry_operations sysfs_dentry_ops = {
>  	.d_revalidate	= sysfs_dentry_revalidate,
>  	.d_delete	= sysfs_dentry_delete,
>  	.d_iput		= sysfs_dentry_iput,
> @@ -795,16 +795,8 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
>  	}
>  
>  	/* instantiate and hash dentry */
> -	ret = d_find_alias(inode);
> -	if (!ret) {
> -		d_set_d_op(dentry, &sysfs_dentry_ops);
> -		dentry->d_fsdata = sysfs_get(sd);
> -		d_add(dentry, inode);
> -	} else {
> -		d_move(ret, dentry);
> -		iput(inode);
> -	}
> -
> +	dentry->d_fsdata = sysfs_get(sd);
> +	ret = d_materialise_unique(dentry, inode);

I have a small problem with d_materialise_unique.  For renames of files
d_materialise_unique calls __d_instantiate_unique. __d_instantiate_unique
does not detect renames of files.  Which at least misses the rename
of sysfs symlinks.

Could we put together a d_materialise_unalias for inodes that we know
they always only have one dentry?  That I would be happy to use.

I think the reason I would up with my own version was that the dcache
did no provide what I needed and it was just a few lines to code my own.

> diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
> index 52c3bdb..c15a7a3 100644
> --- a/fs/sysfs/mount.c
> +++ b/fs/sysfs/mount.c
> @@ -68,6 +68,7 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
>  	}
>  	root->d_fsdata = &sysfs_root;
>  	sb->s_root = root;
> +	sb->s_d_op = &sysfs_dentry_ops;

I have no problem with this bit.  To answer your earlier question s_d_op
predates this code which is why sysfs was not using it.
>  	return 0;
>  }
>  
> diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
> index 661a963..d73c093 100644
> --- a/fs/sysfs/sysfs.h
> +++ b/fs/sysfs/sysfs.h
> @@ -157,6 +157,7 @@ extern struct kmem_cache *sysfs_dir_cachep;
>   */
>  extern struct mutex sysfs_mutex;
>  extern spinlock_t sysfs_assoc_lock;
> +extern const struct dentry_operations sysfs_dentry_ops;
>  
>  extern const struct file_operations sysfs_dir_operations;
>  extern const struct inode_operations sysfs_dir_inode_operations;
