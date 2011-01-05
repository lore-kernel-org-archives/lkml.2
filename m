Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab1AEURL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 15:17:11 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55326 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab1AEURK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 15:17:10 -0500
From: Eric B Munson <emunson@mgebm.net>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, mel@csn.ul.ie,
        caiqian@redhat.com, mhocko@suse.cz, Eric B Munson <emunson@mgebm.net>,
        stable@kernel.org
Subject: [PATCH V2] Fix handling of parse errors in sysfs
Date: Wed,  5 Jan 2011 13:16:33 -0700
Message-Id: <1294258593-15009-1-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When parsing changes to the huge page pool sizes made from userspace
via the sysfs interface, bogus input values are being covered up
by nr_hugepages_store_common and nr_overcommit_hugepages_store
returning 0 when strict_strtoul returns an error.  This can cause an
infinite loop in the nr_hugepages_store code.  This patch changes
the return value for these functions to -EINVAL when strict_strtoul
returns an error.

Reported-by: CAI Qian <caiqian@redhat.com>

Signed-off-by: Eric B Munson <emunson@mgebm.net>
Cc: stable@kernel.org
---
Changes from V1
 Reword leader to show problem that is fixed by the patch
 Add stable@kernel.org as a CC to handle stable submission the right way

 mm/hugetlb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8585524..5cb71a9 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1440,7 +1440,7 @@ static ssize_t nr_hugepages_store_common(bool obey_mempolicy,
 
 	err = strict_strtoul(buf, 10, &count);
 	if (err)
-		return 0;
+		return -EINVAL;
 
 	h = kobj_to_hstate(kobj, &nid);
 	if (nid == NUMA_NO_NODE) {
@@ -1519,7 +1519,7 @@ static ssize_t nr_overcommit_hugepages_store(struct kobject *kobj,
 
 	err = strict_strtoul(buf, 10, &input);
 	if (err)
-		return 0;
+		return -EINVAL;
 
 	spin_lock(&hugetlb_lock);
 	h->nr_overcommit_huge_pages = input;
-- 
1.7.1

