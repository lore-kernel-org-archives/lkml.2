Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab0IBPUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:20:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285Ab0IBPUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:20:22 -0400
Message-ID: <4C7FC0B4.3040005@redhat.com>
Date: Thu, 02 Sep 2010 17:20:20 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix integer overflow in groups_search
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


gid_t is a unsigned int. If group_info contains a gid greater than
MAX_INT, groups_search() function may look on the wrong side of the 
search tree.
This solves some unfair "permission denied" problems.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
diff --git a/kernel/groups.c b/kernel/groups.c
index 53b1916..253dc0f 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -143,10 +143,9 @@ int groups_search(const struct group_info *group_info, gid_t grp)
 	right = group_info->ngroups;
 	while (left < right) {
 		unsigned int mid = (left+right)/2;
-		int cmp = grp - GROUP_AT(group_info, mid);
-		if (cmp > 0)
+		if (grp > GROUP_AT(group_info, mid))
 			left = mid + 1;
-		else if (cmp < 0)
+		else if (grp < GROUP_AT(group_info, mid))
 			right = mid;
 		else
 			return 1;
