Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965725Ab2EOCSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:18:48 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53143 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964913Ab2EOCQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:45 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 056/179] xen: off by one errors in multicalls.c
Date: Mon, 14 May 2012 22:12:32 -0400
Message-ID: <1337048075-6132-57-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit f124c6ae59e193705c9ddac57684d50006d710e6 upstream.

b->args[] has MC_ARGS elements, so the comparison here should be
">=" instead of ">".  Otherwise we read past the end of the array
one space.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/xen/multicalls.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/multicalls.c b/arch/x86/xen/multicalls.c
index 8bff7e7..1b2b73f 100644
--- a/arch/x86/xen/multicalls.c
+++ b/arch/x86/xen/multicalls.c
@@ -189,10 +189,10 @@ struct multicall_space __xen_mc_entry(size_t args)
 	unsigned argidx = roundup(b->argidx, sizeof(u64));
 
 	BUG_ON(preemptible());
-	BUG_ON(b->argidx > MC_ARGS);
+	BUG_ON(b->argidx >= MC_ARGS);
 
 	if (b->mcidx == MC_BATCH ||
-	    (argidx + args) > MC_ARGS) {
+	    (argidx + args) >= MC_ARGS) {
 		mc_stats_flush(b->mcidx == MC_BATCH ? FL_SLOTS : FL_ARGS);
 		xen_mc_flush();
 		argidx = roundup(b->argidx, sizeof(u64));
@@ -206,7 +206,7 @@ struct multicall_space __xen_mc_entry(size_t args)
 	ret.args = &b->args[argidx];
 	b->argidx = argidx + args;
 
-	BUG_ON(b->argidx > MC_ARGS);
+	BUG_ON(b->argidx >= MC_ARGS);
 	return ret;
 }
 
@@ -216,7 +216,7 @@ struct multicall_space xen_mc_extend_args(unsigned long op, size_t size)
 	struct multicall_space ret = { NULL, NULL };
 
 	BUG_ON(preemptible());
-	BUG_ON(b->argidx > MC_ARGS);
+	BUG_ON(b->argidx >= MC_ARGS);
 
 	if (b->mcidx == 0)
 		return ret;
@@ -224,14 +224,14 @@ struct multicall_space xen_mc_extend_args(unsigned long op, size_t size)
 	if (b->entries[b->mcidx - 1].op != op)
 		return ret;
 
-	if ((b->argidx + size) > MC_ARGS)
+	if ((b->argidx + size) >= MC_ARGS)
 		return ret;
 
 	ret.mc = &b->entries[b->mcidx - 1];
 	ret.args = &b->args[b->argidx];
 	b->argidx += size;
 
-	BUG_ON(b->argidx > MC_ARGS);
+	BUG_ON(b->argidx >= MC_ARGS);
 	return ret;
 }
 
-- 
1.7.9.6

