Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab2CRCJS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 22:09:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34977 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab2CRCJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 22:09:11 -0400
From: santosh nayak <santoshprasadnayak@gmail.com>
To: takedakn@nttdata.co.jp
Cc: penguin-kernel@I-love.SAKURA.ne.jp, james.l.morris@oracle.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Santosh Nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH] TOMOYO: Return error if fails to delete a domain.
Date: Sun, 18 Mar 2012 07:37:44 +0530
Message-Id: <1332036464-9538-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Nayak <santoshprasadnayak@gmail.com>

'tomoyo_write_domain' should return error from tomoyo_delete_domain()
to its caller.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 security/tomoyo/common.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index c47d3ce..d13b9a7 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -1081,7 +1081,7 @@ static int tomoyo_delete_domain(char *domainname)
 	name.name = domainname;
 	tomoyo_fill_path_info(&name);
 	if (mutex_lock_interruptible(&tomoyo_policy_lock))
-		return 0;
+		return -EINTR;
 	/* Is there an active domain? */
 	list_for_each_entry_rcu(domain, &tomoyo_domain_list, list) {
 		/* Never delete tomoyo_kernel_domain */
@@ -1164,15 +1164,16 @@ static int tomoyo_write_domain(struct tomoyo_io_buffer *head)
 	bool is_select = !is_delete && tomoyo_str_starts(&data, "select ");
 	unsigned int profile;
 	if (*data == '<') {
+		int ret = 0;
 		domain = NULL;
 		if (is_delete)
-			tomoyo_delete_domain(data);
+			ret = tomoyo_delete_domain(data);
 		else if (is_select)
 			domain = tomoyo_find_domain(data);
 		else
 			domain = tomoyo_assign_domain(data, false);
 		head->w.domain = domain;
-		return 0;
+		return ret;
 	}
 	if (!domain)
 		return -EINVAL;
-- 
1.7.4.4

