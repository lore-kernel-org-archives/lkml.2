Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab1JJL4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:56:38 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45072 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab1JJLzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:55:14 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 08/13] drbd: Output signed / unsigned netlink fields correctly
Date: Mon, 10 Oct 2011 13:55:01 +0200
Message-Id: <1318247706-7732-9-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318247706-7732-1-git-send-email-philipp.reisner@linbit.com>
References: <1318247706-7732-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Note: All input values are still treated as signed; unsigned long long values
are still broken.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 include/linux/genl_magic_func.h   |   23 ++++++++++-----
 include/linux/genl_magic_struct.h |   52 +++++++++++++++++++++++++++----------
 2 files changed, 53 insertions(+), 22 deletions(-)

diff --git a/include/linux/genl_magic_func.h b/include/linux/genl_magic_func.h
index e8e1220..a1305b7 100644
--- a/include/linux/genl_magic_func.h
+++ b/include/linux/genl_magic_func.h
@@ -78,12 +78,13 @@ static struct nla_policy s_name ## _nl_policy[] __read_mostly =		\
 { s_fields };
 
 #undef __field
-#define __field(attr_nr, attr_flag, name, nla_type, _type, __get, __put) \
+#define __field(attr_nr, attr_flag, name, nla_type, _type, __get,	\
+		 __put, __is_signed)					\
 	[__nla_type(attr_nr)] = { .type = nla_type },
 
 #undef __array
 #define __array(attr_nr, attr_flag, name, nla_type, _type, maxlen,	\
-		__get, __put)						\
+		__get, __put, __is_signed)				\
 	[__nla_type(attr_nr)] = { .type = nla_type,			\
 		.len = maxlen - (nla_type == NLA_NUL_STRING) },
 
@@ -235,7 +236,8 @@ static int s_name ## _from_attrs(struct s_name *s, struct genl_info *info)	\
 		}
 
 #undef __field
-#define __field(attr_nr, attr_flag, name, nla_type, type, __get, __put)	\
+#define __field(attr_nr, attr_flag, name, nla_type, type, __get, __put,	\
+		__is_signed)						\
 	__assign(attr_nr, attr_flag, name, nla_type, type,		\
 			if (s)						\
 				s->name = __get(nla);			\
@@ -243,7 +245,8 @@ static int s_name ## _from_attrs(struct s_name *s, struct genl_info *info)	\
 
 /* validate_nla() already checked nla_len <= maxlen appropriately. */
 #undef __array
-#define __array(attr_nr, attr_flag, name, nla_type, type, maxlen, __get, __put) \
+#define __array(attr_nr, attr_flag, name, nla_type, type, maxlen,	\
+		__get, __put, __is_signed)				\
 	__assign(attr_nr, attr_flag, name, nla_type, type,		\
 			if (s)						\
 				s->name ## _len =			\
@@ -404,14 +407,16 @@ static inline int s_name ## _to_unpriv_skb(struct sk_buff *skb,		\
 
 
 #undef __field
-#define __field(attr_nr, attr_flag, name, nla_type, type, __get, __put)	\
+#define __field(attr_nr, attr_flag, name, nla_type, type, __get, __put,	\
+		__is_signed)						\
 	if (!exclude_sensitive || !((attr_flag) & GENLA_F_SENSITIVE)) {	\
 		DPRINT_FIELD(">>", nla_type, name, s, NULL);		\
 		__put(skb, attr_nr, s->name);				\
 	}
 
 #undef __array
-#define __array(attr_nr, attr_flag, name, nla_type, type, maxlen, __get, __put) \
+#define __array(attr_nr, attr_flag, name, nla_type, type, maxlen,	\
+		__get, __put, __is_signed)				\
 	if (!exclude_sensitive || !((attr_flag) & GENLA_F_SENSITIVE)) {	\
 		DPRINT_ARRAY(">>",nla_type, name, s, NULL);		\
 		__put(skb, attr_nr, min_t(int, maxlen,			\
@@ -425,9 +430,11 @@ static inline int s_name ## _to_unpriv_skb(struct sk_buff *skb,		\
 /* Functions for initializing structs to default values.  */
 
 #undef __field
-#define __field(attr_nr, attr_flag, name, nla_type, type, __get, __put)
+#define __field(attr_nr, attr_flag, name, nla_type, type, __get, __put,	\
+		__is_signed)
 #undef __array
-#define __array(attr_nr, attr_flag, name, nla_type, type, maxlen, __get, __put)
+#define __array(attr_nr, attr_flag, name, nla_type, type, maxlen,	\
+		__get, __put, __is_signed)
 #undef __u32_field_def
 #define __u32_field_def(attr_nr, attr_flag, name, default)		\
 	x->name = default;
diff --git a/include/linux/genl_magic_struct.h b/include/linux/genl_magic_struct.h
index 0fca21f..ba911da 100644
--- a/include/linux/genl_magic_struct.h
+++ b/include/linux/genl_magic_struct.h
@@ -87,28 +87,28 @@ enum {
 /* possible field types */
 #define __flg_field(attr_nr, attr_flag, name) \
 	__field(attr_nr, attr_flag, name, NLA_U8, char, \
-			nla_get_u8, NLA_PUT_U8)
+			nla_get_u8, NLA_PUT_U8, false)
 #define __u8_field(attr_nr, attr_flag, name)	\
 	__field(attr_nr, attr_flag, name, NLA_U8, unsigned char, \
-			nla_get_u8, NLA_PUT_U8)
+			nla_get_u8, NLA_PUT_U8, false)
 #define __u16_field(attr_nr, attr_flag, name)	\
 	__field(attr_nr, attr_flag, name, NLA_U16, __u16, \
-			nla_get_u16, NLA_PUT_U16)
+			nla_get_u16, NLA_PUT_U16, false)
 #define __u32_field(attr_nr, attr_flag, name)	\
 	__field(attr_nr, attr_flag, name, NLA_U32, __u32, \
-			nla_get_u32, NLA_PUT_U32)
+			nla_get_u32, NLA_PUT_U32, false)
 #define __s32_field(attr_nr, attr_flag, name)	\
 	__field(attr_nr, attr_flag, name, NLA_U32, __s32, \
-			nla_get_u32, NLA_PUT_U32)
+			nla_get_u32, NLA_PUT_U32, true)
 #define __u64_field(attr_nr, attr_flag, name)	\
 	__field(attr_nr, attr_flag, name, NLA_U64, __u64, \
-			nla_get_u64, NLA_PUT_U64)
+			nla_get_u64, NLA_PUT_U64, false)
 #define __str_field(attr_nr, attr_flag, name, maxlen) \
 	__array(attr_nr, attr_flag, name, NLA_NUL_STRING, char, maxlen, \
-			nla_strlcpy, NLA_PUT)
+			nla_strlcpy, NLA_PUT, false)
 #define __bin_field(attr_nr, attr_flag, name, maxlen) \
 	__array(attr_nr, attr_flag, name, NLA_BINARY, char, maxlen, \
-			nla_memcpy, NLA_PUT)
+			nla_memcpy, NLA_PUT, false)
 
 /* fields with default values */
 #define __flg_field_def(attr_nr, attr_flag, name, default) \
@@ -174,11 +174,13 @@ enum {								\
 };
 
 #undef __field
-#define __field(attr_nr, attr_flag, name, nla_type, type, __get, __put)	\
+#define __field(attr_nr, attr_flag, name, nla_type, type,	\
+		__get, __put, __is_signed)			\
 	T_ ## name = (__u16)(attr_nr | attr_flag),
 
 #undef __array
-#define __array(attr_nr, attr_flag, name, nla_type, type, maxlen, __get, __put) \
+#define __array(attr_nr, attr_flag, name, nla_type, type,	\
+		maxlen, __get, __put, __is_signed)		\
 	T_ ## name = (__u16)(attr_nr | attr_flag),
 
 #include GENL_MAGIC_INCLUDE_FILE
@@ -238,11 +240,13 @@ static inline void ct_assert_unique_ ## s_name ## _attributes(void)	\
 }
 
 #undef __field
-#define __field(attr_nr, attr_flag, name, nla_type, type, __get, __put)	\
+#define __field(attr_nr, attr_flag, name, nla_type, type, __get, __put,	\
+		__is_signed)						\
 	case attr_nr:
 
 #undef __array
-#define __array(attr_nr, attr_flag, name, nla_type, type, maxlen, __get, __put) \
+#define __array(attr_nr, attr_flag, name, nla_type, type, maxlen,	\
+		__get, __put, __is_signed)				\
 	case attr_nr:
 
 #include GENL_MAGIC_INCLUDE_FILE
@@ -260,16 +264,36 @@ static inline void ct_assert_unique_ ## s_name ## _attributes(void)	\
 struct s_name { s_fields };
 
 #undef __field
-#define __field(attr_nr, attr_flag, name, nla_type, type, __get, __put) \
+#define __field(attr_nr, attr_flag, name, nla_type, type, __get, __put,	\
+		__is_signed)						\
 	type name;
 
 #undef __array
-#define __array(attr_nr, attr_flag, name, nla_type, type, maxlen, __get, __put) \
+#define __array(attr_nr, attr_flag, name, nla_type, type, maxlen,	\
+		__get, __put, __is_signed)				\
 	type name[maxlen];	\
 	__u32 name ## _len;
 
 #include GENL_MAGIC_INCLUDE_FILE
 
+#undef GENL_struct
+#define GENL_struct(tag_name, tag_number, s_name, s_fields)		\
+enum {									\
+	s_fields							\
+};
+
+#undef __field
+#define __field(attr_nr, attr_flag, name, nla_type, type, __get, __put,	\
+		is_signed)						\
+	F_ ## name ## _IS_SIGNED = is_signed,
+
+#undef __array
+#define __array(attr_nr, attr_flag, name, nla_type, type, maxlen,	\
+		__get, __put, is_signed)				\
+	F_ ## name ## _IS_SIGNED = is_signed,
+
+#include GENL_MAGIC_INCLUDE_FILE
+
 /* }}}1 */
 #endif /* GENL_MAGIC_STRUCT_H */
 /* vim: set foldmethod=marker nofoldenable : */
-- 
1.7.4.1

