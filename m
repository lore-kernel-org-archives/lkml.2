Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab1F2UFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 16:05:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59589 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab1F2UFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 16:05:37 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=_4hiGLoG5BQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=omOdbC7AAAAA:8 a=20KFwNOVAAAA:8 a=stkexhm8AAAA:8 a=meVymXHHAAAA:8 a=6bHyjZoMXetCZ4u7WqQA:9 a=Ebk02luOEdL-IujhWvMA:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=DV8Pb4sAe4kA:10 a=jeBq3FmKZ4MA:10 a=xUltSm8eY51fTQTq:21 a=7OQp_pYCo5204SBq:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [GIT PULL][v3.0] jump_label: Fix jump_label update for modules
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Jason Baron <jbaron@redhat.com>, Avi Kivity <avi@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 29 Jun 2011 16:05:36 -0400
Message-ID: <1309377936.26417.43.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent

Head SHA1: 140fe3b1ab9c082182ef13359fab4ddba95c24c3


Xiao Guangrong (1):
      jump_label: Fix jump_label update for modules

----
 kernel/jump_label.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)
---------------------------
commit 140fe3b1ab9c082182ef13359fab4ddba95c24c3
Author: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Date:   Tue Jun 21 10:35:55 2011 +0800

    jump_label: Fix jump_label update for modules
    
    The jump labels entries for modules do not stop at __stop__jump_table,
    but after mod->jump_entries + mod_num_jump_entries.
    
    By checking the wrong end point, module trace events never get enabled.
    
    Cc: Ingo Molnar <mingo@elte.hu>
    Acked-by: Jason Baron <jbaron@redhat.com>
    Tested-by: Avi Kivity <avi@redhat.com>
    Tested-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
    Link: http://lkml.kernel.org/r/4E00038B.2060404@cn.fujitsu.com
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

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


