Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab1KOB6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 20:58:14 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51527 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1KOB6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 20:58:13 -0500
Message-ID: <4EC1C730.2050000@gmail.com>
Date: Mon, 14 Nov 2011 18:58:08 -0700
From: Dominic Chen <d.c.ddcc@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: rusty@rustcorp.com.au
Subject: [PATCH 1/1] module: Fix dangling pointer after kfree()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove_notes_attrs() calls free_notes_attrs(), which in turn calls
kfree() on mod->notes_attrs, but fails to set this dangling pointer to
NULL. This differs from both module_param_sysfs_remove() and
remove_sect_attrs(), which set the pointers to NULL after calling kfree().

Signed-off-by: Dominic Chen <d.c.ddcc@gmail.com>
---
 kernel/module.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 178333c..9ca0923 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1380,8 +1380,10 @@ static void add_notes_attrs(struct module *mod,
const struct load_info *info)

 static void remove_notes_attrs(struct module *mod)
 {
-	if (mod->notes_attrs)
+	if (mod->notes_attrs) {
 		free_notes_attrs(mod->notes_attrs, mod->notes_attrs->notes);
+		mod->notes_attrs = NULL;
+	}
 }

 #else
-- 
1.7.5.4
