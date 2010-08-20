Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab0HTItP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:49:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851Ab0HTIq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:46:57 -0400
From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH 13/19] Add /dev/crypto auditing infrastructure
Date: Fri, 20 Aug 2010 10:45:57 +0200
Message-Id: <1282293963-27807-15-git-send-email-mitr@redhat.com>
In-Reply-To: <1282293963-27807-1-git-send-email-mitr@redhat.com>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Posted separately for review on linux-audit
---
 include/linux/audit.h |   38 ++++++++++++++
 kernel/auditfilter.c  |    2 +
 kernel/auditsc.c      |  136 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 176 insertions(+), 0 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 3c7a358..8faa4e0 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -122,6 +122,9 @@
 #define AUDIT_MAC_UNLBL_STCADD	1416	/* NetLabel: add a static label */
 #define AUDIT_MAC_UNLBL_STCDEL	1417	/* NetLabel: del a static label */
 
+#define AUDIT_CRYPTO_STORAGE_KEY    1600 /* Key storage key configured */
+#define AUDIT_CRYPTO_USERSPACE_OP   1601 /* User-space crypto operation */
+
 #define AUDIT_FIRST_KERN_ANOM_MSG   1700
 #define AUDIT_LAST_KERN_ANOM_MSG    1799
 #define AUDIT_ANOM_PROMISCUOUS      1700 /* Device changed promiscuous mode */
@@ -207,6 +210,7 @@
 #define AUDIT_OBJ_TYPE	21
 #define AUDIT_OBJ_LEV_LOW	22
 #define AUDIT_OBJ_LEV_HIGH	23
+#define AUDIT_CRYPTO_OP	24
 
 				/* These are ONLY useful when checking
 				 * at syscall exit time (AUDIT_AT_EXIT). */
@@ -314,6 +318,20 @@ enum {
 #define AUDIT_PERM_READ		4
 #define AUDIT_PERM_ATTR		8
 
+#define AUDIT_CRYPTO_OP_CONTEXT_NEW	1
+#define AUDIT_CRYPTO_OP_CONTEXT_DEL	2
+#define AUDIT_CRYPTO_OP_SESSION_INIT	3
+#define AUDIT_CRYPTO_OP_SESSION_OP	4
+#define AUDIT_CRYPTO_OP_SESSION_FINAL	5
+#define AUDIT_CRYPTO_OP_KEY_IMPORT	6
+#define AUDIT_CRYPTO_OP_KEY_EXPORT	7
+#define AUDIT_CRYPTO_OP_KEY_WRAP	8
+#define AUDIT_CRYPTO_OP_KEY_UNWRAP	9
+#define AUDIT_CRYPTO_OP_KEY_GEN		10
+#define AUDIT_CRYPTO_OP_KEY_DERIVE	11
+#define AUDIT_CRYPTO_OP_KEY_ZEROIZE	12
+#define AUDIT_CRYPTO_OP_KEY_GET_INFO	13
+
 struct audit_status {
 	__u32		mask;		/* Bit mask for valid entries */
 	__u32		enabled;	/* 1 = enabled, 0 = disabled */
@@ -479,6 +497,10 @@ extern int __audit_log_bprm_fcaps(struct linux_binprm *bprm,
 				  const struct cred *new,
 				  const struct cred *old);
 extern void __audit_log_capset(pid_t pid, const struct cred *new, const struct cred *old);
+extern int __audit_log_crypto_op(int op, int context, int session,
+				 const char *operation, const char *algorithm,
+				 int key1, void *key1_id, size_t key1_id_size,
+				 int key2, void *key2_id, size_t key2_id_size);
 
 static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
 {
@@ -532,6 +554,21 @@ static inline void audit_log_capset(pid_t pid, const struct cred *new,
 		__audit_log_capset(pid, new, old);
 }
 
+static inline int audit_log_crypto_op(int op, int context, int session,
+				      const char *operation,
+				      const char *algorithm, int key1,
+				      void *key1_id, size_t key1_id_size,
+				      int key2, void *key2_id,
+				      size_t key2_id_size)
+{
+	if (unlikely(!audit_dummy_context()))
+		return __audit_log_crypto_op(op, context, session, operation,
+					     algorithm, key1, key1_id,
+					     key1_id_size, key2, key2_id,
+					     key2_id_size);
+	return 0;
+}
+
 extern int audit_n_rules;
 extern int audit_signals;
 #else
@@ -565,6 +602,7 @@ extern int audit_signals;
 #define audit_mq_getsetattr(d,s) ((void)0)
 #define audit_log_bprm_fcaps(b, ncr, ocr) ({ 0; })
 #define audit_log_capset(pid, ncr, ocr) ((void)0)
+#define audit_log_crypto_op(op, context, session, key1, key1_id, key1_id_size, key2, key2_id, key2_id_size) (0)
 #define audit_ptrace(t) ((void)0)
 #define audit_n_rules 0
 #define audit_signals 0
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index a706040..a25a587 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -363,6 +363,7 @@ static struct audit_entry *audit_rule_to_entry(struct audit_rule *rule)
 		case AUDIT_DEVMINOR:
 		case AUDIT_EXIT:
 		case AUDIT_SUCCESS:
+		case AUDIT_CRYPTO_OP:
 			/* bit ops are only useful on syscall args */
 			if (f->op == Audit_bitmask || f->op == Audit_bittest)
 				goto exit_free;
@@ -457,6 +458,7 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 		case AUDIT_ARG1:
 		case AUDIT_ARG2:
 		case AUDIT_ARG3:
+		case AUDIT_CRYPTO_OP:
 			break;
 		case AUDIT_ARCH:
 			entry->rule.arch_f = f;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index fc0f928..47c1cc4 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -50,6 +50,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/mount.h>
+#include <linux/ncr.h>
 #include <linux/socket.h>
 #include <linux/mqueue.h>
 #include <linux/audit.h>
@@ -157,6 +158,21 @@ struct audit_aux_data_capset {
 	struct audit_cap_data	cap;
 };
 
+struct audit_crypto_op {
+	struct list_head list;
+	int op;
+	int context;
+	int session;
+	const char *operation;
+	const char *algorithm;
+	int key1;
+	unsigned char key1_id[MAX_KEY_ID_SIZE];
+	size_t key1_id_size;
+	int key2;
+	unsigned char key2_id[MAX_KEY_ID_SIZE];
+	size_t key2_id_size;
+};
+
 struct audit_tree_refs {
 	struct audit_tree_refs *next;
 	struct audit_chunk *c[31];
@@ -181,6 +197,7 @@ struct audit_context {
 	struct audit_context *previous; /* For nested syscalls */
 	struct audit_aux_data *aux;
 	struct audit_aux_data *aux_pids;
+	struct list_head crypto;
 	struct sockaddr_storage *sockaddr;
 	size_t sockaddr_len;
 				/* Save things to print about task_struct */
@@ -632,6 +649,18 @@ static int audit_filter_rules(struct task_struct *tsk,
 		case AUDIT_FILETYPE:
 			result = audit_match_filetype(ctx, f->val);
 			break;
+		case AUDIT_CRYPTO_OP:
+			if (ctx) {
+				struct audit_crypto_op *ax;
+
+				list_for_each_entry(ax, &ctx->crypto, list) {
+					result = audit_comparator(ax->op, f->op,
+								  f->val);
+					if (result)
+						break;
+				}
+			}
+			break;
 		}
 
 		if (!result) {
@@ -827,6 +856,7 @@ static inline void audit_free_names(struct audit_context *context)
 static inline void audit_free_aux(struct audit_context *context)
 {
 	struct audit_aux_data *aux;
+	struct audit_crypto_op *crypto, *tmp;
 
 	while ((aux = context->aux)) {
 		context->aux = aux->next;
@@ -836,6 +866,10 @@ static inline void audit_free_aux(struct audit_context *context)
 		context->aux_pids = aux->next;
 		kfree(aux);
 	}
+	list_for_each_entry_safe(crypto, tmp, &context->crypto, list) {
+		list_del(&crypto->list);
+		kfree(crypto);
+	}
 }
 
 static inline void audit_zero_context(struct audit_context *context,
@@ -853,6 +887,7 @@ static inline struct audit_context *audit_alloc_context(enum audit_state state)
 	if (!(context = kmalloc(sizeof(*context), GFP_KERNEL)))
 		return NULL;
 	audit_zero_context(context, state);
+	INIT_LIST_HEAD(&context->crypto);
 	INIT_LIST_HEAD(&context->killed_trees);
 	return context;
 }
@@ -1316,6 +1351,7 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 	int i, call_panic = 0;
 	struct audit_buffer *ab;
 	struct audit_aux_data *aux;
+	struct audit_crypto_op *crypto;
 	const char *tty;
 
 	/* tsk == current */
@@ -1442,6 +1478,58 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 				call_panic = 1;
 	}
 
+	list_for_each_entry(crypto, &context->crypto, list) {
+		static const char *const ops[] = {
+			[AUDIT_CRYPTO_OP_CONTEXT_NEW] = "context_new",
+			[AUDIT_CRYPTO_OP_CONTEXT_DEL] = "context_del",
+			[AUDIT_CRYPTO_OP_SESSION_INIT] = "session_init",
+			[AUDIT_CRYPTO_OP_SESSION_OP] = "session_op",
+			[AUDIT_CRYPTO_OP_SESSION_FINAL] = "session_final",
+			[AUDIT_CRYPTO_OP_KEY_IMPORT] = "key_import",
+			[AUDIT_CRYPTO_OP_KEY_EXPORT] = "key_export",
+			[AUDIT_CRYPTO_OP_KEY_WRAP] = "key_wrap",
+			[AUDIT_CRYPTO_OP_KEY_UNWRAP] = "key_unwrap",
+			[AUDIT_CRYPTO_OP_KEY_GEN] = "key_gen",
+			[AUDIT_CRYPTO_OP_KEY_DERIVE] = "key_derive",
+			[AUDIT_CRYPTO_OP_KEY_ZEROIZE] = "key_zeroize",
+			[AUDIT_CRYPTO_OP_KEY_GET_INFO] = "key_get_info",
+		};
+
+		ab = audit_log_start(context, GFP_KERNEL,
+				     AUDIT_CRYPTO_USERSPACE_OP);
+		if (!ab)
+			continue;
+		if (crypto->op < ARRAY_SIZE(ops) && ops[crypto->op] != NULL)
+			audit_log_format(ab, "crypto_op=%s", ops[crypto->op]);
+		else
+			audit_log_format(ab, "crypto_op=%d", crypto->op);
+		audit_log_format(ab, " ctx=%d", crypto->context);
+		if (crypto->session != -1)
+			audit_log_format(ab, " session=%d", crypto->session);
+		if (crypto->operation != NULL)
+			audit_log_format(ab, " operation=%s",
+					 crypto->operation);
+		if (crypto->algorithm != NULL)
+			audit_log_format(ab, " algo=%s", crypto->algorithm);
+		if (crypto->key1 != -1) {
+			audit_log_format(ab, " key1=%d", crypto->key1);
+			if (crypto->key1_id_size > 0) {
+				audit_log_format(ab, " key1_id=");
+				audit_log_n_untrustedstring(ab, crypto->key1_id,
+							    crypto->key1_id_size);
+			}
+		}
+		if (crypto->key2 != -1) {
+			audit_log_format(ab, " key2=%d", crypto->key2);
+			if (crypto->key2_id_size > 0) {
+				audit_log_format(ab, " key2_id=");
+				audit_log_n_untrustedstring(ab, crypto->key2_id,
+							    crypto->key2_id_size);
+			}
+		}
+		audit_log_end(ab);
+	}
+
 	if (context->target_pid &&
 	    audit_log_pid_context(context, context->target_pid,
 				  context->target_auid, context->target_uid,
@@ -2486,6 +2574,54 @@ void __audit_log_capset(pid_t pid,
 }
 
 /**
+ * __audit_log_crypto_op - store information about an user-space crypto op
+ * @op: AUDIT_CRYPTO_OP_*
+ * @context: user-space context ID
+ * @session: session ID within @context, or -1
+ * @operation: more detailed operation description, or NULL
+ * @algorithm: algorithm (crypto API transform) name, or NULL
+ * @key1: ID of key 1 within @context, or -1
+ * @key1_id: user-space ID of key 1 set from user-space if @key1 != -1
+ * @key1_id_size: Size of @key1_id
+ * @key2: ID of key 2 within @context, or -1
+ * @key2_id: user-space ID of key 2 set from user-space if @key2 != -1
+ * @key2_id_size: Size of @key2_id
+ */
+int __audit_log_crypto_op(int op, int context, int session,
+			  const char *operation, const char *algorithm,
+			  int key1, void *key1_id, size_t key1_id_size,
+			  int key2, void *key2_id, size_t key2_id_size)
+{
+	struct audit_crypto_op *ax;
+	struct audit_context *ctx = current->audit_context;
+
+	ax = kmalloc(sizeof(*ax), GFP_KERNEL);
+	if (!ax)
+		return -ENOMEM;
+
+	ax->op = op;
+	ax->context = context;
+	ax->session = session;
+	ax->operation = operation;
+	ax->algorithm = algorithm;
+	ax->key1 = key1;
+	if (key1 != -1) {
+		ax->key1_id_size = min(key1_id_size, sizeof(ax->key1_id));
+		memcpy(ax->key1_id, key1_id, ax->key1_id_size);
+	} else
+		ax->key1_id_size = 0;
+	ax->key2 = key2;
+	if (key2 != -1) {
+		ax->key2_id_size = min(key2_id_size, sizeof(ax->key2_id));
+		memcpy(ax->key2_id, key2_id, ax->key2_id_size);
+	} else
+		ax->key2_id_size = 0;
+	list_add_tail(&ax->list, &ctx->crypto);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__audit_log_crypto_op);
+
+/**
  * audit_core_dumps - record information about processes that end abnormally
  * @signr: signal value
  *
-- 
1.7.2.1

