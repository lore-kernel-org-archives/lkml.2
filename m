Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab2JRRdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:33:53 -0400
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:20895 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab2JRRdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:33:51 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Benjamin Poirier <bpoirier@suse.de>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Yaakov Selkowitz <yselkowitz@gmail.com>
Subject: [PATCH] kconfig/menuconfig: use TAILQ instead of CIRCLEQ
Date: Thu, 18 Oct 2012 19:33:45 +0200
Message-Id: <1350581625-23153-1-git-send-email-yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some systems (eg. Cygwin, FreeBSD) are missing the CIRCLEQ macros.
They were removed in Y2000 from FreeBSD:
    http://svnweb.freebsd.org/base?view=revision&revision=70469

The reason was that TAILQ are perfectly capable of doing the exact
same things:
    http://www.mavetju.org/mail/view_thread.php?list=freebsd-arch&id=915145&thread=yes

(Thank Yaakov for the pointers!)

So, switch to using TAILQ instead, which are more portable.

Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Reported-by: Benjamin Poirier <bpoirier@suse.de>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Yaakov Selkowitz <yselkowitz@gmail.com>
---
 scripts/kconfig/expr.h  |    4 ++--
 scripts/kconfig/mconf.c |    4 ++--
 scripts/kconfig/menu.c  |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index bd2e098..c6a8b99 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -175,12 +175,12 @@ struct menu {
 #define MENU_ROOT		0x0002
 
 struct jump_key {
-	CIRCLEQ_ENTRY(jump_key) entries;
+	TAILQ_ENTRY(jump_key) entries;
 	size_t offset;
 	struct menu *target;
 	int index;
 };
-CIRCLEQ_HEAD(jk_head, jump_key);
+TAILQ_HEAD(jk_head, jump_key);
 
 #define JUMP_NB			9
 
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 48f6744..f1ee1c9 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -323,7 +323,7 @@ static void update_text(char *buf, size_t start, size_t end, void *_data)
 	struct jump_key *pos;
 	int k = 0;
 
-	CIRCLEQ_FOREACH(pos, data->head, entries) {
+	TAILQ_FOREACH(pos, data->head, entries) {
 		if (pos->offset >= start && pos->offset < end) {
 			char header[4];
 
@@ -375,7 +375,7 @@ again:
 
 	sym_arr = sym_re_search(dialog_input);
 	do {
-		struct jk_head head = CIRCLEQ_HEAD_INITIALIZER(head);
+		struct jk_head head = TAILQ_HEAD_INITIALIZER(head);
 		struct menu *targets[JUMP_NB];
 		int keys[JUMP_NB + 1], i;
 		struct search_data data = {
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index a3cade6..9eff451 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -544,12 +544,12 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
 		} else
 			jump->target = location;
 
-		if (CIRCLEQ_EMPTY(head))
+		if (TAILQ_EMPTY(head))
 			jump->index = 0;
 		else
-			jump->index = CIRCLEQ_LAST(head)->index + 1;
+			jump->index = TAILQ_LAST(head, jk_head)->index + 1;
 
-		CIRCLEQ_INSERT_TAIL(head, jump, entries);
+		TAILQ_INSERT_TAIL(head, jump, entries);
 	}
 
 	if (i > 0) {
-- 
1.7.2.5

