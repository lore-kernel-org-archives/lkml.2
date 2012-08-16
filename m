Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964856Ab2HPPZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:25:21 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:45025 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288Ab2HPPZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:25:17 -0400
Date: Thu, 16 Aug 2012 11:25:13 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Marti Raudsepp <marti@juffo.org>,
        Kernel hackers <linux-kernel@vger.kernel.org>,
        ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com
Subject: Re: NULL pointer dereference in ext4_ext_remove_space on 3.5.1
Message-ID: <20120816152513.GA31346@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
 <20120816024654.GB3781@thunk.org>
 <20120816111051.GA16036@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120816111051.GA16036@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 07:10:51PM +0800, Fengguang Wu wrote:
> 
> Here is the dmesg. BTW, it seems 3.5.0 don't have this issue.

Fengguang,

It sounds like you have a (at least fairly) reliable reproduction for
this problem?  Is it something you can share?  It would be good to get
this into our test suites, since it was _not_ something that was
caught by xfstests, apparently.

Can you see if this patch addresses it?  (The first two patch hunks
are the same debugging additions I had posted before.)

It looks like the responsible commit is 968dee7722: "ext4: fix hole
punch failure when depth is greater than 0".  I had thought this patch
was low risk if you weren't using the new punch ioctl, but it turns
out it did make a critical change in the non-punch (i.e., truncate)
code path, which is what the addition of "i = 0;" in the patch below
addresses.

Regards,

    	     	       	     	       	  - Ted

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 769151d..fa829dc 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2432,6 +2432,10 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 
 	/* the header must be checked already in ext4_ext_remove_space() */
 	ext_debug("truncate since %u in leaf to %u\n", start, end);
+	if (!path[depth].p_hdr && !path[depth].p_bh) {
+		EXT4_ERROR_INODE(inode, "depth %d", depth);
+		BUG_ON(1);
+	}
 	if (!path[depth].p_hdr)
 		path[depth].p_hdr = ext_block_hdr(path[depth].p_bh);
 	eh = path[depth].p_hdr;
@@ -2730,6 +2734,10 @@ cont:
 		/* this is index block */
 		if (!path[i].p_hdr) {
 			ext_debug("initialize header\n");
+			if (!path[i].p_hdr && !path[i].p_bh) {
+				EXT4_ERROR_INODE(inode, "i=%d", i);
+				BUG_ON(1);
+			}
 			path[i].p_hdr = ext_block_hdr(path[i].p_bh);
 		}
 
@@ -2828,6 +2836,7 @@ out:
 	kfree(path);
 	if (err == -EAGAIN) {
 		path = NULL;
+		i = 0;
 		goto again;
 	}
 	ext4_journal_stop(handle);
