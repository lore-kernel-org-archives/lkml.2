Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab0HBMEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 08:04:52 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46874 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab0HBMEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 08:04:51 -0400
Message-ID: <4C56B45E.9010601@canonical.com>
Date: Mon, 02 Aug 2010 14:04:46 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Lightning/1.0b1 Thunderbird/3.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
        Eric Sandeen <sandeen@redhat.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [116/165] ext4: dont return to userspace after
 freezing the fs with a mutex held
References: <20100730171510.105264205@clark.site>
In-Reply-To: <20100730171510.105264205@clark.site>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have reports about this patch breaking lvm snapshhots. Eric, there is a patch
mentioned which is supposed to fix things but its not upstream, yet.
Do you know what happened to that?

-Stefan

PATCH] ext4: fix freeze deadlock under IO

Commit 6b0310fbf087ad6 caused a regression resulting in deadlocks
when freezing a filesystem which had active IO; the vfs_check_frozen
level (SB_FREEZE_WRITE) did not let the freeze-related IO syncing
through.  Duh.

Changing the test to FREEZE_TRANS should let the normal freeze
syncing get through the fs, but still block any transactions from
starting once the fs is completely frozen.

I tested this by running fsstress in the background while periodically
snapshotting the fs and running fsck on the result.  I ran into
occasional deadlocks, but different ones.  I think this is a
fine fix for the problem at hand, and the other deadlocky things
will need more investigation.

Reported-by: Phillip Susi <psusi@cfl.rr.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4e8983a..a45ced9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -241,7 +241,7 @@ handle_t *ext4_journal_start_sb(struct super_block *sb, int
nblocks)
 	if (sb->s_flags & MS_RDONLY)
 		return ERR_PTR(-EROFS);

-	vfs_check_frozen(sb, SB_FREEZE_WRITE);
+	vfs_check_frozen(sb, SB_FREEZE_TRANS);
 	/* Special case here: if the journal has aborted behind our
 	 * backs (eg. EIO in the commit thread), then we still need to
 	 * take the FS itself readonly cleanly. */
@@ -3491,7 +3491,7 @@ int ext4_force_commit(struct super_block *sb)

 	journal = EXT4_SB(sb)->s_journal;
 	if (journal) {
-		vfs_check_frozen(sb, SB_FREEZE_WRITE);
+		vfs_check_frozen(sb, SB_FREEZE_TRANS);
 		ret = ext4_journal_force_commit(journal);
 	}



On 07/30/2010 07:15 PM, Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> commit 6b0310fbf087ad6e9e3b8392adca97cd77184084 upstream (as of v2.6.34-git13)
> 
> ext4_freeze() used jbd2_journal_lock_updates() which takes
> the j_barrier mutex, and then returns to userspace.  The
> kernel does not like this:
> 
> ================================================
> [ BUG: lock held when returning to user space! ]
> ------------------------------------------------
> lvcreate/1075 is leaving the kernel with locks still held!
> 1 lock held by lvcreate/1075:
>  #0:  (&journal->j_barrier){+.+...}, at: [<ffffffff811c6214>]
> jbd2_journal_lock_updates+0xe1/0xf0
> 
> Use vfs_check_frozen() added to ext4_journal_start_sb() and
> ext4_force_commit() instead.
> 
> Addresses-Red-Hat-Bugzilla: #568503
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  fs/ext4/super.c |   20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -227,6 +227,7 @@ handle_t *ext4_journal_start_sb(struct s
>  	if (sb->s_flags & MS_RDONLY)
>  		return ERR_PTR(-EROFS);
>  
> +	vfs_check_frozen(sb, SB_FREEZE_WRITE);
>  	/* Special case here: if the journal has aborted behind our
>  	 * backs (eg. EIO in the commit thread), then we still need to
>  	 * take the FS itself readonly cleanly. */
> @@ -3391,8 +3392,10 @@ int ext4_force_commit(struct super_block
>  		return 0;
>  
>  	journal = EXT4_SB(sb)->s_journal;
> -	if (journal)
> +	if (journal) {
> +		vfs_check_frozen(sb, SB_FREEZE_WRITE);
>  		ret = ext4_journal_force_commit(journal);
> +	}
>  
>  	return ret;
>  }
> @@ -3441,18 +3444,16 @@ static int ext4_freeze(struct super_bloc
>  	 * the journal.
>  	 */
>  	error = jbd2_journal_flush(journal);
> -	if (error < 0) {
> -	out:
> -		jbd2_journal_unlock_updates(journal);
> -		return error;
> -	}
> +	if (error < 0)
> +		goto out;
>  
>  	/* Journal blocked and flushed, clear needs_recovery flag. */
>  	EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
>  	error = ext4_commit_super(sb, 1);
> -	if (error)
> -		goto out;
> -	return 0;
> +out:
> +	/* we rely on s_frozen to stop further updates */
> +	jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
> +	return error;
>  }
>  
>  /*
> @@ -3469,7 +3470,6 @@ static int ext4_unfreeze(struct super_bl
>  	EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
>  	ext4_commit_super(sb, 1);
>  	unlock_super(sb);
> -	jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
>  	return 0;
>  }
>  
> 
> 
> _______________________________________________
> Stable-review mailing list
> Stable-review@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable-review

