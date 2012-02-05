Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab2BEW0V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:26:21 -0500
Received: from 1wt.eu ([62.212.114.60]:61800 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab2BEW0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:06 -0500
Message-Id: <20120205220949.578775063@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:09:52 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: David Rientjes <rientjes@google.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 03/91] set memory ranges in N_NORMAL_MEMORY when onlined
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit d9b41e0b54fd7e164daf1e9c539c1070398aa02e upstream.

When a DISCONTIGMEM memory range is brought online as a NUMA node, it
also needs to have its bet set in N_NORMAL_MEMORY.  This is necessary for
generic kernel code that utilizes N_NORMAL_MEMORY as a subset of N_ONLINE
for memory savings.

These types of hacks can hopefully be removed once DISCONTIGMEM is either
removed or abstracted away from CONFIG_NUMA.

Fixes a panic in the slub code which only initializes structures for
N_NORMAL_MEMORY to save memory:

	Backtrace:
	 [<000000004021c938>] add_partial+0x28/0x98
	 [<000000004021faa0>] __slab_free+0x1d0/0x1d8
	 [<000000004021fd04>] kmem_cache_free+0xc4/0x128
	 [<000000004033bf9c>] ida_get_new_above+0x21c/0x2c0
	 [<00000000402a8980>] sysfs_new_dirent+0xd0/0x238
	 [<00000000402a974c>] create_dir+0x5c/0x168
	 [<00000000402a9ab0>] sysfs_create_dir+0x98/0x128
	 [<000000004033d6c4>] kobject_add_internal+0x114/0x258
	 [<000000004033d9ac>] kobject_add_varg+0x7c/0xa0
	 [<000000004033df20>] kobject_add+0x50/0x90
	 [<000000004033dfb4>] kobject_create_and_add+0x54/0xc8
	 [<00000000407862a0>] cgroup_init+0x138/0x1f0
	 [<000000004077ce50>] start_kernel+0x5a0/0x840
	 [<000000004011fa3c>] start_parisc+0xa4/0xb8
	 [<00000000404bb034>] packet_ioctl+0x16c/0x208
	 [<000000004049ac30>] ip_mroute_setsockopt+0x260/0xf20

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/parisc/mm/init.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

Index: longterm-2.6.27/arch/parisc/mm/init.c
===================================================================
--- longterm-2.6.27.orig/arch/parisc/mm/init.c	2012-02-05 22:34:34.989914901 +0100
+++ longterm-2.6.27/arch/parisc/mm/init.c	2012-02-05 22:34:35.362915231 +0100
@@ -265,8 +265,10 @@
 	}
 	memset(pfnnid_map, 0xff, sizeof(pfnnid_map));
 
-	for (i = 0; i < npmem_ranges; i++)
+	for (i = 0; i < npmem_ranges; i++) {
+		node_set_state(i, N_NORMAL_MEMORY);
 		node_set_online(i);
+	}
 #endif
 
 	/*


