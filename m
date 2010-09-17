Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab0IQWcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 18:32:15 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:43401 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab0IQWcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 18:32:14 -0400
Subject: [PATCH v2 1/4] resources: ensure alignment callback doesn't allocate
	below available start
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Becker <chemobejk@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Fri, 17 Sep 2010 16:32:12 -0600
Message-ID: <20100917223212.24687.3519.stgit@bob.kio>
In-Reply-To: <20100917223109.24687.17697.stgit@bob.kio>
References: <20100917223109.24687.17697.stgit@bob.kio>
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
doesn't return a location above the available area.

This patch adds a check to make sure the callback doesn't return something
*below* the available area, as may happen if the callback tries to allocate
top-down.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 kernel/resource.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)


diff --git a/kernel/resource.c b/kernel/resource.c
index 7b36976..ace2269 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -371,6 +371,7 @@ static int find_resource(struct resource *root, struct resource *new,
 {
 	struct resource *this = root->child;
 	struct resource tmp = *new;
+	resource_size_t start;
 
 	tmp.start = root->start;
 	/*
@@ -391,8 +392,13 @@ static int find_resource(struct resource *root, struct resource *new,
 		if (tmp.end > max)
 			tmp.end = max;
 		tmp.start = ALIGN(tmp.start, align);
-		if (alignf)
-			tmp.start = alignf(alignf_data, &tmp, size, align);
+		if (alignf) {
+			start = alignf(alignf_data, &tmp, size, align);
+			if (tmp.start <= start && start <= tmp.end)
+				tmp.start = start;
+			else
+				tmp.start = tmp.end;
+		}
 		if (tmp.start < tmp.end && tmp.end - tmp.start >= size - 1) {
 			new->start = tmp.start;
 			new->end = tmp.start + size - 1;

