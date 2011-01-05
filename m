Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab1AERKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:10:44 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57791 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab1AERKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:10:43 -0500
From: Eric B Munson <emunson@mgebm.net>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, caiqian@redhat.com,
        mel@csn.ul.ie, Eric B Munson <emunson@mgebm.net>
Subject: [PATCH] Do not allow pagesize >= MAX_ORDER pool adjustment
Date: Wed,  5 Jan 2011 10:10:29 -0700
Message-Id: <1294247429-11768-1-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huge pages with order >= MAX_ORDER must be allocated at boot via
the kernel command line, they cannot be allocated or freed once
the kernel is up and running.  Currently we allow values to be
written to the sysctl files controling pool size for these huge
page sizes.  This patch makes the store functions for nr_hugepages
and nr_overcommit_hugepages return -EINVAL when the pool for
a page size >= MAX_ORDER is changed.

Reported-by: CAI Qian <caiqian@redhat.com>

Signed-off-by: Eric B Munson <emunson@mgebm.net>
---
 mm/hugetlb.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 5cb71a9..9da2481 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1443,6 +1443,12 @@ static ssize_t nr_hugepages_store_common(bool obey_mempolicy,
 		return -EINVAL;
 
 	h = kobj_to_hstate(kobj, &nid);
+
+	if (h->order >= MAX_ORDER) {
+		NODEMASK_FREE(nodes_allowed);
+		return -EINVAL;
+	}
+
 	if (nid == NUMA_NO_NODE) {
 		/*
 		 * global hstate attribute
@@ -1517,6 +1523,9 @@ static ssize_t nr_overcommit_hugepages_store(struct kobject *kobj,
 	unsigned long input;
 	struct hstate *h = kobj_to_hstate(kobj, NULL);
 
+	if (h->order >= MAX_ORDER)
+		return -EINVAL;
+
 	err = strict_strtoul(buf, 10, &input);
 	if (err)
 		return -EINVAL;
-- 
1.7.1

