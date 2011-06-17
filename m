Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab1FQUCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 16:02:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54795 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933048Ab1FQUCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 16:02:04 -0400
Message-ID: <4DFBB2D5.2060003@cn.fujitsu.com>
Date: Sat, 18 Jun 2011 04:02:29 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jason Baron <jbaron@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] jump_label: fix  jump_label update
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-18 04:00:06,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-18 04:01:42,
	Serialize complete at 2011-06-18 04:01:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The key of module is out of __stop___jump_table, it causes the events
of modules does not work

This bug is introduced by commit: 7cbc5b8d4a775a43875a09e29c49a2a8195b5b2d

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 kernel/jump_label.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index fa27e75..dcad2fb 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -375,11 +375,15 @@ int jump_label_text_reserved(void *start, void *end)
 
 static void jump_label_update(struct jump_label_key *key, int enable)
 {
-	struct jump_entry *entry = key->entries;
+	struct jump_entry *entry = key->entries, *stop = __stop___jump_table;
+	struct module *mod = __module_address((jump_label_t)key);
+
+	if (mod)
+		stop = mod->jump_entries + mod->num_jump_entries;
 
 	/* if there are no users, entry can be NULL */
 	if (entry)
-		__jump_label_update(key, entry, __stop___jump_table, enable);
+		__jump_label_update(key, entry, stop, enable);
 
 #ifdef CONFIG_MODULES
 	__jump_label_mod_update(key, enable);
-- 
1.7.5.4
