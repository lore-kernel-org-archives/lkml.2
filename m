Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab2LMPEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:04:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44133 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233Ab2LMODL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:03:11 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 040/241] target: Don't return success from module_init() if setup fails
Date: Thu, 13 Dec 2012 11:56:45 -0200
Message-Id: <1355407206-17100-41-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 0d0f9dfb31e0a6c92063e235417b42df185b3275 upstream.

If the call to core_dev_release_virtual_lun0() fails, then nothing
sets ret to anything other than 0, so even though everything is
torn down and freed, target_core_init_configfs() will seem to succeed
and the module will be loaded.  Fix this by passing the return value
on up the chain.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/target/target_core_configfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 06aca11..ac0b69f 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3214,7 +3214,8 @@ static int __init target_core_init_configfs(void)
 	if (ret < 0)
 		goto out;
 
-	if (core_dev_setup_virtual_lun0() < 0)
+	ret = core_dev_setup_virtual_lun0();
+	if (ret < 0)
 		goto out;
 
 	return 0;
-- 
1.7.9.5

