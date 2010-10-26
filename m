Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760503Ab0JZVlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 17:41:20 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:20317 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760386Ab0JZVlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 17:41:17 -0400
Subject: [PATCH v5 1/9] resources: add a default alignf to simplify
	find_resource()
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Bob Picco <bpicco@redhat.com>, Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-pci@vger.kernel.org,
        "Horst H. von Brand" <vonbrand@inf.utfsm.cl>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Stefan Becker <chemobejk@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
        Fabrice Bellet <fabrice@bellet.info>, Yinghai Lu <yinghai@kernel.org>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 26 Oct 2010 15:41:13 -0600
Message-ID: <20101026214113.29808.49847.stgit@bob.kio>
In-Reply-To: <20101026214033.29808.15272.stgit@bob.kio>
References: <20101026214033.29808.15272.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This removes a test from find_resource(), which is getting cluttered.
No functional change.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 kernel/resource.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)


diff --git a/kernel/resource.c b/kernel/resource.c
index 7b36976..7dc8ad2 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -357,6 +357,14 @@ int __weak page_is_ram(unsigned long pfn)
 	return walk_system_ram_range(pfn, 1, NULL, __is_ram) == 1;
 }
 
+static resource_size_t simple_align_resource(void *data,
+					     const struct resource *avail,
+					     resource_size_t size,
+					     resource_size_t align)
+{
+	return avail->start;
+}
+
 /*
  * Find empty slot in the resource tree given range and alignment.
  */
@@ -391,8 +399,8 @@ static int find_resource(struct resource *root, struct resource *new,
 		if (tmp.end > max)
 			tmp.end = max;
 		tmp.start = ALIGN(tmp.start, align);
-		if (alignf)
-			tmp.start = alignf(alignf_data, &tmp, size, align);
+
+		tmp.start = alignf(alignf_data, &tmp, size, align);
 		if (tmp.start < tmp.end && tmp.end - tmp.start >= size - 1) {
 			new->start = tmp.start;
 			new->end = tmp.start + size - 1;
@@ -428,6 +436,9 @@ int allocate_resource(struct resource *root, struct resource *new,
 {
 	int err;
 
+	if (!alignf)
+		alignf = simple_align_resource;
+
 	write_lock(&resource_lock);
 	err = find_resource(root, new, size, min, max, align, alignf, alignf_data);
 	if (err >= 0 && __request_resource(root, new))

