Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab1DUC1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 22:27:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:62424 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1DUC1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 22:27:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=OlWwQRw9W8jMpl4EAbFqqDMBV4nsW0uBqrIOEVe7l2NWyKd8Be63BAw/YqQz3FxyzS
         ZvJSNnVyKSDEBkgj3cgw==
Date: Wed, 20 Apr 2011 19:27:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
        James Bottomley <jejb@parisc-linux.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org
Subject: [patch] parisc: set memory ranges in N_NORMAL_MEMORY when onlined
In-Reply-To: <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1104201926300.15661@chino.kir.corp.google.com>
References: <20110420161615.462D.A69D9226@jp.fujitsu.com> <BANLkTimfpY3gq8oY6bPDajBW7JN6Hp+A0A@mail.gmail.com> <20110420174027.4631.A69D9226@jp.fujitsu.com> <1303317178.2587.30.camel@mulgrave.site>
 <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Tested-by: James Bottomley <James.Bottomley@hansenpartnership.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/parisc/mm/init.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -266,8 +266,10 @@ static void __init setup_bootmem(void)
 	}
 	memset(pfnnid_map, 0xff, sizeof(pfnnid_map));
 
-	for (i = 0; i < npmem_ranges; i++)
+	for (i = 0; i < npmem_ranges; i++) {
+		node_set_state(i, N_NORMAL_MEMORY);
 		node_set_online(i);
+	}
 #endif
 
 	/*
