Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab1FUCd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 22:33:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58219 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab1FUCd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 22:33:56 -0400
Message-ID: <4E00038B.2060404@cn.fujitsu.com>
Date: Tue, 21 Jun 2011 10:35:55 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] jump_label: fix jump_label update
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-21 10:33:29,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-21 10:33:30,
	Serialize complete at 2011-06-21 10:33:30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The key of module is out of __stop___jump_table, it causes the events
of modules does not work

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 kernel/jump_label.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index fa27e75..a8ce450 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -375,15 +375,19 @@ int jump_label_text_reserved(void *start, void *end)
 
 static void jump_label_update(struct jump_label_key *key, int enable)
 {
-	struct jump_entry *entry = key->entries;
-
-	/* if there are no users, entry can be NULL */
-	if (entry)
-		__jump_label_update(key, entry, __stop___jump_table, enable);
+	struct jump_entry *entry = key->entries, *stop = __stop___jump_table;
 
 #ifdef CONFIG_MODULES
+	struct module *mod = __module_address((jump_label_t)key);
+
 	__jump_label_mod_update(key, enable);
+
+	if (mod)
+		stop = mod->jump_entries + mod->num_jump_entries;
 #endif
+	/* if there are no users, entry can be NULL */
+	if (entry)
+		__jump_label_update(key, entry, stop, enable);
 }
 
 #endif
-- 
1.7.5.4
