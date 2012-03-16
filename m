Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab2CPS4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 14:56:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40079 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab2CPS43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 14:56:29 -0400
From: santosh nayak <santoshprasadnayak@gmail.com>
To: takedakn@nttdata.co.jp
Cc: penguin-kernel@I-love.SAKURA.ne.jp, james.l.morris@oracle.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Santosh Nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH] TOMOYO: Return error if fails to delete a domain.
Date: Sat, 17 Mar 2012 00:25:00 +0530
Message-Id: <1331924100-26033-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Nayak <santoshprasadnayak@gmail.com>

Call sequence:
tomoyo_write_domain() --> tomoyo_delete_domain()

In 'tomoyo_delete_domain',  return  -EINTR if locking attempt is
interrupted by signal.

At present it returns success to its caller 'tomoyo_write_domain()'
even though domain is not deleted. 'tomoyo_write_domain()' assumes
domain is deleted and returns success to its caller. This is
wrong behaviour.

'tomoyo_write_domain' should return error '-EAGAIN' to its caller if
tomoyo_delete_domain() returns -EINTR.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 security/tomoyo/common.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index c47d3ce..3ee1c3a 100644
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
@@ -1163,16 +1163,20 @@ static int tomoyo_write_domain(struct tomoyo_io_buffer *head)
 	const bool is_delete = head->w.is_delete;
 	bool is_select = !is_delete && tomoyo_str_starts(&data, "select ");
 	unsigned int profile;
+	int ret = 0;
 	if (*data == '<') {
 		domain = NULL;
-		if (is_delete)
-			tomoyo_delete_domain(data);
+		if (is_delete) {
+			ret = tomoyo_delete_domain(data);
+			if (ret)
+				return -EAGAIN;
+		}
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

