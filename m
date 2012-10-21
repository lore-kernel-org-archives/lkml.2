Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab2JUJ2h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 05:28:37 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48940 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab2JUJ2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 05:28:34 -0400
From: Benjamin Poirier <benjamin.poirier@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Jean Sacren <sakiwit@gmail.com>, Arnaud Lacombe <lacombar@gmail.com>,
        Wang YanQing <udknight@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Davidlohr Bueso <dave@gnu.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Yaakov Selkowitz <yselkowitz@users.sourceforge.net>
Subject: [PATCH v2] menuconfig: Replace CIRCLEQ by list_head-style lists.
Date: Sun, 21 Oct 2012 05:27:53 -0400
Message-Id: <1350811673-26081-1-git-send-email-benjamin.poirier@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350754935-20014-1-git-send-email-benjamin.poirier@gmail.com>
References: <1350754935-20014-1-git-send-email-benjamin.poirier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Poirier <bpoirier@suse.de>

sys/queue.h and CIRCLEQ in particular have proven to cause portability
problems (reported on Debian Sarge, Cygwin and FreeBSD)

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: Yaakov Selkowitz <yselkowitz@users.sourceforge.net>
Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
---

Changes v1-v2:
* integrate the patch/suggestion from Yann to fix problems related to the
  usage of list.h with xconfig/c++
	* "new" keyword
	* offsetof redefinition
* silly #endif placement mistake

Thanks to Tetsuo, Yann and Yaakov for thorough testing.

 scripts/kconfig/expr.h      |    5 +--
 scripts/kconfig/list.h      |   91 +++++++++++++++++++++++++++++++++++++++++++
 scripts/kconfig/lkc_proto.h |    4 +-
 scripts/kconfig/mconf.c     |    6 +--
 scripts/kconfig/menu.c      |   14 ++++---
 5 files changed, 106 insertions(+), 14 deletions(-)
 create mode 100644 scripts/kconfig/list.h

diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index bd2e098..cdd4860 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -12,7 +12,7 @@ extern "C" {
 
 #include <assert.h>
 #include <stdio.h>
-#include <sys/queue.h>
+#include "list.h"
 #ifndef __cplusplus
 #include <stdbool.h>
 #endif
@@ -175,12 +175,11 @@ struct menu {
 #define MENU_ROOT		0x0002
 
 struct jump_key {
-	CIRCLEQ_ENTRY(jump_key) entries;
+	struct list_head entries;
 	size_t offset;
 	struct menu *target;
 	int index;
 };
-CIRCLEQ_HEAD(jk_head, jump_key);
 
 #define JUMP_NB			9
 
diff --git a/scripts/kconfig/list.h b/scripts/kconfig/list.h
new file mode 100644
index 0000000..0ae730b
--- /dev/null
+++ b/scripts/kconfig/list.h
@@ -0,0 +1,91 @@
+#ifndef LIST_H
+#define LIST_H
+
+/*
+ * Copied from include/linux/...
+ */
+
+#undef offsetof
+#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
+
+/**
+ * container_of - cast a member of a structure out to the containing structure
+ * @ptr:        the pointer to the member.
+ * @type:       the type of the container struct this is embedded in.
+ * @member:     the name of the member within the struct.
+ *
+ */
+#define container_of(ptr, type, member) ({                      \
+	const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
+	(type *)( (char *)__mptr - offsetof(type,member) );})
+
+
+struct list_head {
+	struct list_head *next, *prev;
+};
+
+
+#define LIST_HEAD_INIT(name) { &(name), &(name) }
+
+#define LIST_HEAD(name) \
+	struct list_head name = LIST_HEAD_INIT(name)
+
+/**
+ * list_entry - get the struct for this entry
+ * @ptr:	the &struct list_head pointer.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_entry(ptr, type, member) \
+	container_of(ptr, type, member)
+
+/**
+ * list_for_each_entry	-	iterate over list of given type
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_for_each_entry(pos, head, member)				\
+	for (pos = list_entry((head)->next, typeof(*pos), member);	\
+	     &pos->member != (head); 	\
+	     pos = list_entry(pos->member.next, typeof(*pos), member))
+
+/**
+ * list_empty - tests whether a list is empty
+ * @head: the list to test.
+ */
+static inline int list_empty(const struct list_head *head)
+{
+	return head->next == head;
+}
+
+/*
+ * Insert a new entry between two known consecutive entries.
+ *
+ * This is only for internal list manipulation where we know
+ * the prev/next entries already!
+ */
+static inline void __list_add(struct list_head *_new,
+			      struct list_head *prev,
+			      struct list_head *next)
+{
+	next->prev = _new;
+	_new->next = next;
+	_new->prev = prev;
+	prev->next = _new;
+}
+
+/**
+ * list_add_tail - add a new entry
+ * @new: new entry to be added
+ * @head: list head to add it before
+ *
+ * Insert a new entry before the specified head.
+ * This is useful for implementing queues.
+ */
+static inline void list_add_tail(struct list_head *_new, struct list_head *head)
+{
+	__list_add(_new, head->prev, head);
+}
+
+#endif
diff --git a/scripts/kconfig/lkc_proto.h b/scripts/kconfig/lkc_proto.h
index 1d1c085..ef1a738 100644
--- a/scripts/kconfig/lkc_proto.h
+++ b/scripts/kconfig/lkc_proto.h
@@ -21,9 +21,9 @@ P(menu_get_root_menu,struct menu *,(struct menu *menu));
 P(menu_get_parent_menu,struct menu *,(struct menu *menu));
 P(menu_has_help,bool,(struct menu *menu));
 P(menu_get_help,const char *,(struct menu *menu));
-P(get_symbol_str, void, (struct gstr *r, struct symbol *sym, struct jk_head
+P(get_symbol_str, void, (struct gstr *r, struct symbol *sym, struct list_head
 			 *head));
-P(get_relations_str, struct gstr, (struct symbol **sym_arr, struct jk_head
+P(get_relations_str, struct gstr, (struct symbol **sym_arr, struct list_head
 				   *head));
 P(menu_get_ext_help,void,(struct menu *menu, struct gstr *help));
 
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 48f6744..53975cf 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -312,7 +312,7 @@ static void set_config_filename(const char *config_filename)
 
 
 struct search_data {
-	struct jk_head *head;
+	struct list_head *head;
 	struct menu **targets;
 	int *keys;
 };
@@ -323,7 +323,7 @@ static void update_text(char *buf, size_t start, size_t end, void *_data)
 	struct jump_key *pos;
 	int k = 0;
 
-	CIRCLEQ_FOREACH(pos, data->head, entries) {
+	list_for_each_entry(pos, data->head, entries) {
 		if (pos->offset >= start && pos->offset < end) {
 			char header[4];
 
@@ -375,7 +375,7 @@ again:
 
 	sym_arr = sym_re_search(dialog_input);
 	do {
-		struct jk_head head = CIRCLEQ_HEAD_INITIALIZER(head);
+		LIST_HEAD(head);
 		struct menu *targets[JUMP_NB];
 		int keys[JUMP_NB + 1], i;
 		struct search_data data = {
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index a3cade6..e98a05c 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -508,7 +508,7 @@ const char *menu_get_help(struct menu *menu)
 }
 
 static void get_prompt_str(struct gstr *r, struct property *prop,
-			   struct jk_head *head)
+			   struct list_head *head)
 {
 	int i, j;
 	struct menu *submenu[8], *menu, *location = NULL;
@@ -544,12 +544,13 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
 		} else
 			jump->target = location;
 
-		if (CIRCLEQ_EMPTY(head))
+		if (list_empty(head))
 			jump->index = 0;
 		else
-			jump->index = CIRCLEQ_LAST(head)->index + 1;
+			jump->index = list_entry(head->prev, struct jump_key,
+						 entries)->index + 1;
 
-		CIRCLEQ_INSERT_TAIL(head, jump, entries);
+		list_add_tail(&jump->entries, head);
 	}
 
 	if (i > 0) {
@@ -573,7 +574,8 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
 /*
  * head is optional and may be NULL
  */
-void get_symbol_str(struct gstr *r, struct symbol *sym, struct jk_head *head)
+void get_symbol_str(struct gstr *r, struct symbol *sym,
+		    struct list_head *head)
 {
 	bool hit;
 	struct property *prop;
@@ -612,7 +614,7 @@ void get_symbol_str(struct gstr *r, struct symbol *sym, struct jk_head *head)
 	str_append(r, "\n\n");
 }
 
-struct gstr get_relations_str(struct symbol **sym_arr, struct jk_head *head)
+struct gstr get_relations_str(struct symbol **sym_arr, struct list_head *head)
 {
 	struct symbol *sym;
 	struct gstr res = str_new();
-- 
1.7.10.4

