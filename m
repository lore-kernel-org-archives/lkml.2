Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761525Ab2FHFHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:07:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43121 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758365Ab2FHFHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:09 -0400
Message-Id: <20120608041841.577227826@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:18:45 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Boaz Harrosh <bharrosh@panasas.com>,
        Johannes Schild <JSchild@gmx.de>
Subject: [ 05/82] exofs: Fix CRASH on very early IO errors.
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boaz Harrosh <bharrosh@panasas.com>

commit 6abe4a87f7bc7978705c386dbba0ca0c7790b3ec upstream.

If at exofs_fill_super() we had an early termination
do to any error, like an IO error while reading the
super-block. We would crash inside exofs_free_sbi().

This is because sbi->oc.numdevs was set to 1, before
we actually have a device table at all.

Fix it by moving the sbi->oc.numdevs = 1 to after the
allocation of the device table.

Reported-by: Johannes Schild <JSchild@gmx.de>

Stable: This is a bug since v3.2.0
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/exofs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 735ca06..59e0849 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -745,7 +745,6 @@ static int exofs_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->one_comp.obj.partition = opts->pid;
 	sbi->one_comp.obj.id = 0;
 	exofs_make_credential(sbi->one_comp.cred, &sbi->one_comp.obj);
-	sbi->oc.numdevs = 1;
 	sbi->oc.single_comp = EC_SINGLE_COMP;
 	sbi->oc.comps = &sbi->one_comp;
 
@@ -804,6 +803,7 @@ static int exofs_fill_super(struct super_block *sb, void *data, int silent)
 			goto free_sbi;
 
 		ore_comp_set_dev(&sbi->oc, 0, od);
+		sbi->oc.numdevs = 1;
 	}
 
 	__sbi_read_stats(sbi);


