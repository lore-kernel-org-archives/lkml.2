Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520Ab0JZVlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 17:41:23 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:14040 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760402Ab0JZVlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 17:41:21 -0400
Subject: [PATCH v5 2/9] resources: factor out resource_clip() to simplify
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
Date: Tue, 26 Oct 2010 15:41:18 -0600
Message-ID: <20101026214118.29808.48356.stgit@bob.kio>
In-Reply-To: <20101026214033.29808.15272.stgit@bob.kio>
References: <20101026214033.29808.15272.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This factors out the min/max clipping to simplify find_resource().
No functional change.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 kernel/resource.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)


diff --git a/kernel/resource.c b/kernel/resource.c
index 7dc8ad2..26e9f25 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -365,6 +365,15 @@ static resource_size_t simple_align_resource(void *data,
 	return avail->start;
 }
 
+static void resource_clip(struct resource *res, resource_size_t min,
+			  resource_size_t max)
+{
+	if (res->start < min)
+		res->start = min;
+	if (res->end > max)
+		res->end = max;
+}
+
 /*
  * Find empty slot in the resource tree given range and alignment.
  */
@@ -394,10 +403,8 @@ static int find_resource(struct resource *root, struct resource *new,
 			tmp.end = this->start - 1;
 		else
 			tmp.end = root->end;
-		if (tmp.start < min)
-			tmp.start = min;
-		if (tmp.end > max)
-			tmp.end = max;
+
+		resource_clip(&tmp, min, max);
 		tmp.start = ALIGN(tmp.start, align);
 
 		tmp.start = alignf(alignf_data, &tmp, size, align);

