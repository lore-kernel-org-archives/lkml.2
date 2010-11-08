Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab0KHH3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 02:29:48 -0500
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:57490 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753033Ab0KHH3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 02:29:46 -0500
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, paulmck@linux.vnet.ibm.com
Subject: fs: inode rcu freeing and hash walking V2
Date: Mon,  8 Nov 2010 18:28:21 +1100
Message-Id: <1289201305-14866-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

The following four patches implement the extra functionality you
wanted on top of the inode lock breakup. They lift the i_lock up out
of writeback_single_inode(), implements RCU freeing of inodes via
SLAB_DESTROY_BY_RCU, converts inode hash lookup operations to use
RCU list walks. Comments are welcome.

I'm undecided whether passing the bucket identifier along with the
hash head is the best way to handle the hash-chain-being-jumped
detection. It might be cleaner to just push the hash chain
calculation all the way in.

Most of the changes in this version are as a result of Eric
Dumazet's initial review.

Version 2:
- split the inode slabcache config changes into a separate patch.
- convert inode hash lists to use hlist_nulls variant to enable
  simple checking of whether RCU hash list traversals jumped chains.
- recheck i_ino and i_sb after gaining i_lock during RCU lookups to
  ensure we've got a hold of the correct inode.
- clear i_ino when destroying an inode to allow hash lookups to
  discover freed inodes without needing to lock the inode.
- moved inode->i_lock initialisation to slab constructor so that it
  can be safely used during RCU traversals
- introduced hlist_nulls_add_fake() and converted filesystems to use
  that
