Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965289Ab1C3VKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:10:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:38344 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965271Ab1C3VKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:10:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411279183"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: tyhicks@linux.vnet.ibm.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [252/275] eCryptfs: Unlock page in write_begin error path
Message-Id: <20110330210819.0691F3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

commit 50f198ae16ac66508d4b8d5a40967a8507ad19ee upstream.

Unlock the page in error path of ecryptfs_write_begin(). This may
happen, for example, if decryption fails while bring the page
up-to-date.

Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/ecryptfs/mmap.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6.35.y/fs/ecryptfs/mmap.c
===================================================================
--- linux-2.6.35.y.orig/fs/ecryptfs/mmap.c	2011-03-29 22:50:10.327994152 -0700
+++ linux-2.6.35.y/fs/ecryptfs/mmap.c	2011-03-29 23:03:03.518210148 -0700
@@ -368,6 +368,11 @@
 	    && (pos != 0))
 		zero_user(page, 0, PAGE_CACHE_SIZE);
 out:
+	if (unlikely(rc)) {
+		unlock_page(page);
+		page_cache_release(page);
+		*pagep = NULL;
+	}
 	return rc;
 }
 
