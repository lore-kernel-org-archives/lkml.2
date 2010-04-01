Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab0DAW6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 18:58:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:58931 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757478Ab0DAW6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 18:58:18 -0400
Date: Thu, 1 Apr 2010 22:57:59 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de
In-Reply-To: <4BB416D7.6090203@kernel.org>
References: <4BB416D7.6090203@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] bootmem, x86: Fix 32bit numa system without RAM on node 0
Message-ID: <tip-aa235fc712f379d4194cff9217f07026c452c141@git.kernel.org>
Git-Commit-ID: aa235fc712f379d4194cff9217f07026c452c141
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 01 Apr 2010 22:58:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aa235fc712f379d4194cff9217f07026c452c141
Gitweb:     http://git.kernel.org/tip/aa235fc712f379d4194cff9217f07026c452c141
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 31 Mar 2010 20:45:27 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 1 Apr 2010 14:41:19 -0700

bootmem, x86: Fix 32bit numa system without RAM on node 0

When 32bit numa is used, free_all_bootmem() will still only go over with
node id 0.

If node 0 doesn't have RAM installed, the lowest populated node
becomes low RAM.

This one fixes BOOTMEM path by iterating over the bdata_list.

-v3: add more comments, and fix bootmem path too.
-v4: seperate from one big patch

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4BB416D7.6090203@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 mm/bootmem.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 2058cb7..ba37d62 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -312,7 +312,13 @@ unsigned long __init free_all_bootmem(void)
 	 */
 	return free_all_memory_core_early(MAX_NUMNODES);
 #else
-	return free_all_bootmem_core(NODE_DATA(0)->bdata);
+	unsigned long total_pages = 0;
+	bootmem_data_t *bdata;
+
+	list_for_each_entry(bdata, &bdata_list, list)
+		total_pages += free_all_bootmem_core(bdata);
+
+	return total_pages;
 #endif
 }
 
