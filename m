Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab1LLHP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 02:15:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57187 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab1LLHN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 02:13:58 -0500
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 09/11] kvm tools: narrow the C.S. of compat_mtx
Date: Mon, 12 Dec 2011 15:15:53 +0800
Message-Id: <1323674155-17570-10-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1323674155-17570-1-git-send-email-laijs@cn.fujitsu.com>
References: <1323674155-17570-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-12 15:13:21,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-12 15:13:22,
	Serialize complete at 2011-12-12 15:13:22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The allocation and the copy are not required in the C.S.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 tools/kvm/guest_compat.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/tools/kvm/guest_compat.c b/tools/kvm/guest_compat.c
index fac53f5..de97df5 100644
--- a/tools/kvm/guest_compat.c
+++ b/tools/kvm/guest_compat.c
@@ -21,20 +21,19 @@ int compat__add_message(const char *title, const char *desc)
 {
 	struct compat_message *msg;
 
-	mutex_lock(&compat_mtx);
 	msg = malloc(sizeof(*msg));
 	if (msg == NULL)
 		goto cleanup;
 
-	*msg = (struct compat_message) {
-		.id = id,
-		.title = strdup(title),
-		.desc = strdup(desc),
-	};
+	msg->title = strdup(title);
+	msg->desc = strdup(desc);
 
 	if (msg->title == NULL || msg->desc == NULL)
 		goto cleanup;
 
+	mutex_lock(&compat_mtx);
+
+	msg->id = id;
 	list_add_tail(&msg->list, &messages);
 
 	mutex_unlock(&compat_mtx);
@@ -48,8 +47,6 @@ cleanup:
 		free(msg);
 	}
 
-	mutex_unlock(&compat_mtx);
-
 	return -ENOMEM;
 }
 
@@ -101,4 +98,4 @@ int compat__print_all_messages(void)
 	mutex_unlock(&compat_mtx);
 
 	return 0;
-}
\ No newline at end of file
+}
-- 
1.7.4.4

