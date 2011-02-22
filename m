Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab1BVWVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:21:41 -0500
Received: from kroah.org ([198.145.64.141]:46686 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370Ab1BVWVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:36 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:39 2011
Message-Id: <20110222221839.576485991@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Josef Bacik <josef@redhat.com>, Chris Mason <chris.mason@oracle.com>
Subject: [25/70] btrfs: prevent heap corruption in btrfs_ioctl_space_info()
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 51788b1bdd0d68345bab0af4301e7fa429277228 upstream.

Commit bf5fc093c5b625e4259203f1cee7ca73488a5620 refactored
btrfs_ioctl_space_info() and introduced several security issues.

space_args.space_slots is an unsigned 64-bit type controlled by a
possibly unprivileged caller.  The comparison as a signed int type
allows providing values that are treated as negative and cause the
subsequent allocation size calculation to wrap, or be truncated to 0.
By providing a size that's truncated to 0, kmalloc() will return
ZERO_SIZE_PTR.  It's also possible to provide a value smaller than the
slot count.  The subsequent loop ignores the allocation size when
copying data in, resulting in a heap overflow or write to ZERO_SIZE_PTR.

The fix changes the slot count type and comparison typecast to u64,
which prevents truncation or signedness errors, and also ensures that we
don't copy more data than we've allocated in the subsequent loop.  Note
that zero-size allocations are no longer possible since there is already
an explicit check for space_args.space_slots being 0 and truncation of
this value is no longer an issue.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Josef Bacik <josef@redhat.com>
Reviewed-by: Josef Bacik <josef@redhat.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/btrfs/ioctl.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2087,7 +2087,7 @@ long btrfs_ioctl_space_info(struct btrfs
 	int num_types = 4;
 	int alloc_size;
 	int ret = 0;
-	int slot_count = 0;
+	u64 slot_count = 0;
 	int i, c;
 
 	if (copy_from_user(&space_args,
@@ -2126,7 +2126,7 @@ long btrfs_ioctl_space_info(struct btrfs
 		goto out;
 	}
 
-	slot_count = min_t(int, space_args.space_slots, slot_count);
+	slot_count = min_t(u64, space_args.space_slots, slot_count);
 
 	alloc_size = sizeof(*dest) * slot_count;
 
@@ -2146,6 +2146,9 @@ long btrfs_ioctl_space_info(struct btrfs
 	for (i = 0; i < num_types; i++) {
 		struct btrfs_space_info *tmp;
 
+		if (!slot_count)
+			break;
+
 		info = NULL;
 		rcu_read_lock();
 		list_for_each_entry_rcu(tmp, &root->fs_info->space_info,
@@ -2167,7 +2170,10 @@ long btrfs_ioctl_space_info(struct btrfs
 				memcpy(dest, &space, sizeof(space));
 				dest++;
 				space_args.total_spaces++;
+				slot_count--;
 			}
+			if (!slot_count)
+				break;
 		}
 		up_read(&info->groups_sem);
 	}


