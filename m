Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab0JZVlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 17:41:32 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:14079 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab0JZVl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 17:41:29 -0400
Subject: [PATCH v5 4/9] resources: handle overflow when aligning start of
	available area
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
Date: Tue, 26 Oct 2010 15:41:28 -0600
Message-ID: <20101026214128.29808.77226.stgit@bob.kio>
In-Reply-To: <20101026214033.29808.15272.stgit@bob.kio>
References: <20101026214033.29808.15272.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If tmp.start is near ~0, ALIGN(tmp.start) may overflow, which would
make us think there's more available space than there really is.  We
would likely return something that conflicts with a previous resource,
which would cause a failure when allocate_resource() requests the newly-
allocated region.

Reference: https://bugzilla.redhat.com/show_bug.cgi?id=646027
Reported-by: Fabrice Bellet <fabrice@bellet.info>
Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 kernel/resource.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)


diff --git a/kernel/resource.c b/kernel/resource.c
index 89d5041..e15b922 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -392,7 +392,7 @@ static int find_resource(struct resource *root, struct resource *new,
 			 void *alignf_data)
 {
 	struct resource *this = root->child;
-	struct resource tmp = *new, alloc;
+	struct resource tmp = *new, avail, alloc;
 
 	tmp.start = root->start;
 	/*
@@ -410,14 +410,19 @@ static int find_resource(struct resource *root, struct resource *new,
 			tmp.end = root->end;
 
 		resource_clip(&tmp, min, max);
-		tmp.start = ALIGN(tmp.start, align);
 
-		alloc.start = alignf(alignf_data, &tmp, size, align);
-		alloc.end = alloc.start + size - 1;
-		if (resource_contains(&tmp, &alloc)) {
-			new->start = alloc.start;
-			new->end = alloc.end;
-			return 0;
+		/* Check for overflow after ALIGN() */
+		avail = *new;
+		avail.start = ALIGN(tmp.start, align);
+		avail.end = tmp.end;
+		if (avail.start >= tmp.start) {
+			alloc.start = alignf(alignf_data, &avail, size, align);
+			alloc.end = alloc.start + size - 1;
+			if (resource_contains(&avail, &alloc)) {
+				new->start = alloc.start;
+				new->end = alloc.end;
+				return 0;
+			}
 		}
 		if (!this)
 			break;

