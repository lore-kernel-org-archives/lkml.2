Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab0JZVl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 17:41:27 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:16347 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758504Ab0JZVlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 17:41:25 -0400
Subject: [PATCH v5 3/9] resources: ensure callback doesn't allocate outside
	available space
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
Date: Tue, 26 Oct 2010 15:41:23 -0600
Message-ID: <20101026214123.29808.24645.stgit@bob.kio>
In-Reply-To: <20101026214033.29808.15272.stgit@bob.kio>
References: <20101026214033.29808.15272.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The alignment callback returns a proposed location, which may have been
adjusted to avoid ISA aliases or for other architecture-specific reasons.

We already had a check ("tmp.start < tmp.end") to make sure the callback
doesn't return an area that extends past the available area.  This patch
reworks the check to make sure it doesn't return an area that extends
either below or above the available area.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 kernel/resource.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)


diff --git a/kernel/resource.c b/kernel/resource.c
index 26e9f25..89d5041 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -374,6 +374,11 @@ static void resource_clip(struct resource *res, resource_size_t min,
 		res->end = max;
 }
 
+static bool resource_contains(struct resource *res1, struct resource *res2)
+{
+	return res1->start <= res2->start && res1->end >= res2->end;
+}
+
 /*
  * Find empty slot in the resource tree given range and alignment.
  */
@@ -387,7 +392,7 @@ static int find_resource(struct resource *root, struct resource *new,
 			 void *alignf_data)
 {
 	struct resource *this = root->child;
-	struct resource tmp = *new;
+	struct resource tmp = *new, alloc;
 
 	tmp.start = root->start;
 	/*
@@ -407,10 +412,11 @@ static int find_resource(struct resource *root, struct resource *new,
 		resource_clip(&tmp, min, max);
 		tmp.start = ALIGN(tmp.start, align);
 
-		tmp.start = alignf(alignf_data, &tmp, size, align);
-		if (tmp.start < tmp.end && tmp.end - tmp.start >= size - 1) {
-			new->start = tmp.start;
-			new->end = tmp.start + size - 1;
+		alloc.start = alignf(alignf_data, &tmp, size, align);
+		alloc.end = alloc.start + size - 1;
+		if (resource_contains(&tmp, &alloc)) {
+			new->start = alloc.start;
+			new->end = alloc.end;
 			return 0;
 		}
 		if (!this)

