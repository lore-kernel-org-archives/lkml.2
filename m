Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab2B0WZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 17:25:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38801 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939Ab2B0WXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 17:23:46 -0500
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 3/7] AppArmor: Update dfa matching routines.
Date: Mon, 27 Feb 2012 14:23:13 -0800
Message-Id: <1330381397-5352-4-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1330381397-5352-1-git-send-email-john.johansen@canonical.com>
References: <1330381397-5352-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update aa_dfa_match so that it doesn't result in an input string being
walked twice (once to get its length and another time to match)

Add a single step functions
  aa_dfa_next

Signed-off-by: John Johansen <john.johansen@canonical.com>
Acked-by: Kees Cook <kees@ubuntu.com>
---
 security/apparmor/include/apparmor.h |    2 +-
 security/apparmor/include/match.h    |    3 +
 security/apparmor/match.c            |   80 ++++++++++++++++++++++++++++++++-
 3 files changed, 81 insertions(+), 4 deletions(-)

diff --git a/security/apparmor/include/apparmor.h b/security/apparmor/include/apparmor.h
index df36495..248c408 100644
--- a/security/apparmor/include/apparmor.h
+++ b/security/apparmor/include/apparmor.h
@@ -81,7 +81,7 @@ static inline unsigned int aa_dfa_null_transition(struct aa_dfa *dfa,
 						  unsigned int start)
 {
 	/* the null transition only needs the string's null terminator byte */
-	return aa_dfa_match_len(dfa, start, "", 1);
+	return aa_dfa_next(dfa, start, 0);
 }
 
 static inline bool mediated_filesystem(struct inode *inode)
diff --git a/security/apparmor/include/match.h b/security/apparmor/include/match.h
index a4a8639..775843e 100644
--- a/security/apparmor/include/match.h
+++ b/security/apparmor/include/match.h
@@ -116,6 +116,9 @@ unsigned int aa_dfa_match_len(struct aa_dfa *dfa, unsigned int start,
 			      const char *str, int len);
 unsigned int aa_dfa_match(struct aa_dfa *dfa, unsigned int start,
 			  const char *str);
+unsigned int aa_dfa_next(struct aa_dfa *dfa, unsigned int state,
+			 const char c);
+
 void aa_dfa_free_kref(struct kref *kref);
 
 /**
diff --git a/security/apparmor/match.c b/security/apparmor/match.c
index 94de6b4..90971a8 100644
--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -335,12 +335,12 @@ unsigned int aa_dfa_match_len(struct aa_dfa *dfa, unsigned int start,
 }
 
 /**
- * aa_dfa_next_state - traverse @dfa to find state @str stops at
+ * aa_dfa_match - traverse @dfa to find state @str stops at
  * @dfa: the dfa to match @str against  (NOT NULL)
  * @start: the state of the dfa to start matching in
  * @str: the null terminated string of bytes to match against the dfa (NOT NULL)
  *
- * aa_dfa_next_state will match @str against the dfa and return the state it
+ * aa_dfa_match will match @str against the dfa and return the state it
  * finished matching in. The final state can be used to look up the accepting
  * label, or as the start state of a continuing match.
  *
@@ -349,5 +349,79 @@ unsigned int aa_dfa_match_len(struct aa_dfa *dfa, unsigned int start,
 unsigned int aa_dfa_match(struct aa_dfa *dfa, unsigned int start,
 			  const char *str)
 {
-	return aa_dfa_match_len(dfa, start, str, strlen(str));
+	u16 *def = DEFAULT_TABLE(dfa);
+	u32 *base = BASE_TABLE(dfa);
+	u16 *next = NEXT_TABLE(dfa);
+	u16 *check = CHECK_TABLE(dfa);
+	unsigned int state = start, pos;
+
+	if (state == 0)
+		return 0;
+
+	/* current state is <state>, matching character *str */
+	if (dfa->tables[YYTD_ID_EC]) {
+		/* Equivalence class table defined */
+		u8 *equiv = EQUIV_TABLE(dfa);
+		/* default is direct to next state */
+		while (*str) {
+			pos = base[state] + equiv[(u8) *str++];
+			if (check[pos] == state)
+				state = next[pos];
+			else
+				state = def[state];
+		}
+	} else {
+		/* default is direct to next state */
+		while (*str) {
+			pos = base[state] + (u8) *str++;
+			if (check[pos] == state)
+				state = next[pos];
+			else
+				state = def[state];
+		}
+	}
+
+	return state;
+}
+
+/**
+ * aa_dfa_next - step one character to the next state in the dfa
+ * @dfa: the dfa to tranverse (NOT NULL)
+ * @state: the state to start in
+ * @c: the input character to transition on
+ *
+ * aa_dfa_match will step through the dfa by one input character @c
+ *
+ * Returns: state reach after input @c
+ */
+unsigned int aa_dfa_next(struct aa_dfa *dfa, unsigned int state,
+			  const char c)
+{
+	u16 *def = DEFAULT_TABLE(dfa);
+	u32 *base = BASE_TABLE(dfa);
+	u16 *next = NEXT_TABLE(dfa);
+	u16 *check = CHECK_TABLE(dfa);
+	unsigned int pos;
+
+	/* current state is <state>, matching character *str */
+	if (dfa->tables[YYTD_ID_EC]) {
+		/* Equivalence class table defined */
+		u8 *equiv = EQUIV_TABLE(dfa);
+		/* default is direct to next state */
+
+		pos = base[state] + equiv[(u8) c];
+		if (check[pos] == state)
+			state = next[pos];
+		else
+			state = def[state];
+	} else {
+		/* default is direct to next state */
+		pos = base[state] + (u8) c;
+		if (check[pos] == state)
+			state = next[pos];
+		else
+			state = def[state];
+	}
+
+	return state;
 }
-- 
1.7.9

