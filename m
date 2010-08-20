Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab0HTIqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:46:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752Ab0HTIqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:46:37 -0400
From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH 05/19] Add internal /dev/crypto implementation headers
Date: Fri, 20 Aug 2010 10:45:48 +0200
Message-Id: <1282293963-27807-6-git-send-email-mitr@redhat.com>
In-Reply-To: <1282293963-27807-1-git-send-email-mitr@redhat.com>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's it, .c files will finally follow in the next patch.
---
 crypto/userspace/cryptodev_int.h |   82 +++++++++++++
 crypto/userspace/ncr-dh.h        |   25 ++++
 crypto/userspace/ncr-int.h       |  245 ++++++++++++++++++++++++++++++++++++++
 crypto/userspace/ncr-pk.h        |   55 +++++++++
 4 files changed, 407 insertions(+), 0 deletions(-)
 create mode 100644 crypto/userspace/cryptodev_int.h
 create mode 100644 crypto/userspace/ncr-dh.h
 create mode 100644 crypto/userspace/ncr-int.h
 create mode 100644 crypto/userspace/ncr-pk.h

diff --git a/crypto/userspace/cryptodev_int.h b/crypto/userspace/cryptodev_int.h
new file mode 100644
index 0000000..6754427
--- /dev/null
+++ b/crypto/userspace/cryptodev_int.h
@@ -0,0 +1,82 @@
+/* cipher stuff */
+#ifndef CRYPTODEV_INT_H
+# define CRYPTODEV_INT_H
+
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/fdtable.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/ncr.h>
+#include <linux/scatterlist.h>
+
+#define PFX "cryptodev: "
+#define dprintk(level,severity,format,a...)			\
+	do {						\
+		if (level <= cryptodev_verbosity)				\
+			printk(severity PFX "%s[%u]: " format,	\
+			       current->comm, current->pid,	\
+			       ##a);				\
+	} while (0)
+
+extern int cryptodev_verbosity;
+
+/* For zero copy */
+int __get_userbuf(uint8_t __user *addr, uint32_t len, int write,
+		int pgcount, struct page **pg, struct scatterlist *sg);
+void release_user_pages(struct page **pg, int pagecount);
+
+/* last page - first page + 1 */
+#define PAGECOUNT(buf, buflen) \
+        ((((unsigned long)(buf + buflen - 1) & PAGE_MASK) >> PAGE_SHIFT) - \
+         (((unsigned long) buf               & PAGE_MASK) >> PAGE_SHIFT) + 1)
+
+#define DEFAULT_PREALLOC_PAGES 32
+
+struct cipher_data
+{
+	int init; /* 0 uninitialized */
+	int blocksize;
+	int ivsize;
+	struct {
+		struct crypto_ablkcipher* s;
+		struct cryptodev_result *result;
+		struct ablkcipher_request *request;
+		uint8_t iv[NCR_CIPHER_MAX_BLOCK_LEN];
+	} async;
+};
+
+int cryptodev_cipher_init(struct cipher_data* out, const char* alg_name, uint8_t * key, size_t keylen);
+void cryptodev_cipher_deinit(struct cipher_data* cdata);
+ssize_t cryptodev_cipher_decrypt( struct cipher_data* cdata, const struct scatterlist *sg1, struct scatterlist *sg2, size_t len);
+ssize_t cryptodev_cipher_encrypt( struct cipher_data* cdata, const struct scatterlist *sg1, struct scatterlist *sg2, size_t len);
+
+void cryptodev_cipher_set_iv(struct cipher_data* cdata, void* iv, size_t iv_size);
+int _cryptodev_cipher_decrypt(struct cipher_data* cdata, const void* ciphertext,
+	size_t ciphertext_size, void* plaintext, size_t plaintext_size);
+int _cryptodev_cipher_encrypt(struct cipher_data* cdata, const void* plaintext,
+	size_t plaintext_size, void* ciphertext, size_t ciphertext_size);
+
+/* hash stuff */
+struct hash_data
+{
+	int init; /* 0 uninitialized */
+	int digestsize;
+	struct {
+		struct crypto_ahash *s;
+		struct cryptodev_result *result;
+		struct ahash_request *request;
+	} async;
+};
+
+int cryptodev_hash_final( struct hash_data* hdata, void* output);
+ssize_t cryptodev_hash_update( struct hash_data* hdata, struct scatterlist *sg, size_t len);
+ssize_t _cryptodev_hash_update( struct hash_data* hdata, const void* data, size_t len);
+int cryptodev_hash_reset( struct hash_data* hdata);
+void cryptodev_hash_deinit(struct hash_data* hdata);
+int cryptodev_hash_init( struct hash_data* hdata, const char* alg_name, int hmac_mode, void* mackey, size_t mackeylen);
+
+#endif /* CRYPTODEV_INT_H */
diff --git a/crypto/userspace/ncr-dh.h b/crypto/userspace/ncr-dh.h
new file mode 100644
index 0000000..cc45d32
--- /dev/null
+++ b/crypto/userspace/ncr-dh.h
@@ -0,0 +1,25 @@
+#ifndef NCR_DH_H
+# define NCR_DH_H
+
+#include <tomcrypt.h>
+
+typedef struct {
+	int type; /* PK_PRIVATE or PK_PUBLIC */
+	mp_int p;
+	mp_int g;
+	mp_int x; /* private */
+	mp_int y; /* public: y=g^x */
+} dh_key;
+
+int dh_generate_key(dh_key * key);
+int dh_import_params(dh_key * key, uint8_t* p, size_t p_size, uint8_t* g, size_t g_size);
+void dh_free(dh_key * key);
+int dh_generate_public(dh_key * public, dh_key* private);
+
+int dh_export(uint8_t *out, unsigned long *outlen, int type, dh_key *key);
+int dh_import(const uint8_t *in, size_t inlen, dh_key *key);
+
+int dh_derive_gxy(struct key_item_st* newkey, dh_key * key,
+	void* pk, size_t pk_size);
+
+#endif
diff --git a/crypto/userspace/ncr-int.h b/crypto/userspace/ncr-int.h
new file mode 100644
index 0000000..c7e1dfb
--- /dev/null
+++ b/crypto/userspace/ncr-int.h
@@ -0,0 +1,245 @@
+#ifndef NCR_INT_H
+# define NCR_INT_H
+
+#include <linux/compat.h>
+#include <linux/idr.h>
+#include <linux/mutex.h>
+#include <linux/ncr.h>
+#include <asm/atomic.h>
+#include "cryptodev_int.h"
+#include <ncr-pk.h>
+#include <ncr-dh.h>
+
+#define KEY_DATA_MAX_SIZE 3*1024
+#define NCR_CIPHER_MAX_KEY_LEN 1024
+
+#define err() printk(KERN_DEBUG"ncr: %s: %s: %d\n", __FILE__, __func__, __LINE__)
+
+struct nlattr;
+struct ncr_out;
+
+// Not all known algorithms - only for quick internal identification
+enum ncr_algorithm {
+	NCR_ALG_NONE__,
+	NCR_ALG_NULL,
+
+	NCR_ALG_MD5,
+	NCR_ALG_SHA1,
+	NCR_ALG_SHA2_224,
+	NCR_ALG_SHA2_256,
+	NCR_ALG_SHA2_384,
+	NCR_ALG_SHA2_512,
+
+	NCR_ALG_RSA,
+	NCR_ALG_DSA,
+	NCR_ALG_DH,
+};
+
+struct algo_properties_st {
+	enum ncr_algorithm algo;
+	const char *kstr;
+	size_t kstr_len;
+	unsigned needs_iv:1;
+	unsigned is_hmac:1;
+	unsigned can_sign:1;
+	unsigned can_digest:1;
+	unsigned can_encrypt:1;
+	unsigned can_kx:1; /* key exchange */
+	unsigned is_symmetric:1;
+	unsigned is_pk:1;
+	int digest_size;
+	/* NCR_KEY_TYPE_SECRET if for a secret key algorithm or MAC,
+	 * NCR_KEY_TYPE_PUBLIC for a public key algorithm.
+	 */
+	ncr_key_type_t key_type;
+};
+
+struct session_item_st {
+	const struct algo_properties_st *algorithm;
+	ncr_crypto_op_t op;
+
+	/* contexts for various options.
+	 * simpler to have them like that than
+	 * in a union.
+	 */
+	struct cipher_data cipher;
+	struct ncr_pk_ctx pk;
+	struct hash_data hash;
+
+	struct scatterlist *sg;
+	struct page **pages;
+	unsigned array_size;
+	unsigned available_pages;
+	struct mutex mem_mutex; /* down when the
+		* values above are changed.
+		*/
+
+	struct key_item_st* key;
+
+	atomic_t refcnt;
+	ncr_session_t desc;
+};
+
+struct key_item_st {
+	/* This object is also not protected from concurrent access.
+	 */
+	ncr_key_type_t type;
+	unsigned int flags;
+	const struct algo_properties_st *algorithm; /* non-NULL for public/private keys */
+	uint8_t key_id[MAX_KEY_ID_SIZE];
+	size_t key_id_size;
+
+	union {
+		struct {
+			uint8_t data[NCR_CIPHER_MAX_KEY_LEN];
+			size_t size;
+		} secret;
+		union {
+			rsa_key rsa;
+			dsa_key dsa;
+			dh_key dh;
+		} pk;
+	} key;
+
+	atomic_t refcnt;
+	atomic_t writer;
+
+	/* owner. The one charged with this */
+	uid_t uid;
+	pid_t pid;
+
+	int context_id;		/* Only for auditing */
+	ncr_key_t desc;
+};
+
+/* all the data associated with the open descriptor
+ * are here.
+ */
+struct ncr_lists {
+	int id;			/* Used only for auditing */
+
+	struct mutex key_idr_mutex;
+	struct idr key_idr;
+
+	/* sessions */
+	struct mutex session_idr_mutex;
+	struct idr session_idr;
+};
+
+struct ncr_lists *ncr_init_lists(void);
+void ncr_deinit_lists(struct ncr_lists *lst);
+
+int ncr_ioctl(struct ncr_lists *lst, unsigned int cmd, unsigned long arg);
+long ncr_compat_ioctl(struct ncr_lists *lst, unsigned int cmd,
+		      unsigned long arg);
+
+/* key derivation */
+int ncr_key_derive(struct ncr_lists *lst, const struct ncr_key_derive *data,
+		   struct nlattr *tb[]);
+
+/* key handling */
+int ncr_key_init(struct ncr_lists *lst);
+int ncr_key_deinit(struct ncr_lists *lst, ncr_key_t desc);
+int ncr_key_export(struct ncr_lists *lst, const struct ncr_key_export *data,
+		   struct nlattr *tb[]);
+int ncr_key_import(struct ncr_lists *lst, const struct ncr_key_import *data,
+		   struct nlattr *tb[]);
+void ncr_key_list_deinit(struct ncr_lists *lst);
+int ncr_key_generate(struct ncr_lists *lst, const struct ncr_key_generate *gen,
+		     struct nlattr *tb[]);
+int ncr_key_get_info(struct ncr_lists *lst, struct ncr_out *out,
+		     const struct ncr_key_get_info *info, struct nlattr *tb[]);
+
+int ncr_key_generate_pair(struct ncr_lists *lst,
+			  const struct ncr_key_generate_pair *gen,
+			  struct nlattr *tb[]);
+int ncr_key_get_public(struct ncr_lists *lst, void __user* arg);
+
+int ncr_key_item_get_read(struct key_item_st**st, struct ncr_lists *lst,
+	ncr_key_t desc);
+/* get key item for writing */
+int ncr_key_item_get_write( struct key_item_st** st,
+	struct ncr_lists *lst, ncr_key_t desc);
+void _ncr_key_item_put( struct key_item_st* item);
+
+typedef enum {
+	LIMIT_TYPE_KEY,
+	NUM_LIMIT_TYPES
+} limits_type_t;
+
+void ncr_limits_remove(uid_t uid, pid_t pid, limits_type_t type);
+int ncr_limits_add_and_check(uid_t uid, pid_t pid, limits_type_t type);
+void ncr_limits_init(void);
+void ncr_limits_deinit(void);
+
+int ncr_key_wrap(struct ncr_lists *lst, const struct ncr_key_wrap *wrap,
+		 struct nlattr *tb[]);
+int ncr_key_unwrap(struct ncr_lists *lst, const struct ncr_key_unwrap *wrap,
+		   struct nlattr *tb[]);
+int ncr_key_storage_wrap(struct ncr_lists *lst,
+			 const struct ncr_key_storage_wrap *wrap,
+			 struct nlattr *tb[]);
+int ncr_key_storage_unwrap(struct ncr_lists *lst,
+			   const struct ncr_key_storage_unwrap *wrap,
+			   struct nlattr *tb[]);
+
+/* sessions */
+struct session_item_st* ncr_session_new(struct ncr_lists *lst);
+void _ncr_sessions_item_put( struct session_item_st* item);
+struct session_item_st* ncr_sessions_item_get(struct ncr_lists *lst, ncr_session_t desc);
+void ncr_sessions_list_deinit(struct ncr_lists *lst);
+
+int ncr_session_init(struct ncr_lists *lists,
+		     const struct ncr_session_init *session,
+		    struct nlattr *tb[]);
+int ncr_session_update(struct ncr_lists *lists,
+		       const struct ncr_session_update *op, struct nlattr *tb[],
+		       int compat);
+int ncr_session_final(struct ncr_lists *lists,
+		      const struct ncr_session_final *op, struct nlattr *tb[],
+		      int compat);
+int ncr_session_once(struct ncr_lists *lists,
+		     const struct ncr_session_once *once, struct nlattr *tb[],
+		     int compat);
+
+/* master key */
+extern struct key_item_st master_key;
+
+void ncr_master_key_reset(void);
+
+/* storage */
+int key_from_storage_data(struct key_item_st* key, const void* data, size_t data_size);
+int key_to_storage_data( uint8_t** data, size_t * data_size, const struct key_item_st *key);
+
+
+/* misc helper macros */
+
+const struct algo_properties_st *_ncr_algo_to_properties(const char *algo);
+const struct algo_properties_st *_ncr_nla_to_properties(const struct nlattr *nla);
+const char *ncr_algorithm_name(const struct algo_properties_st *algo);
+
+/* CONFIG_COMPAT handling */
+
+#ifdef CONFIG_COMPAT
+struct compat_ncr_session_input_data {
+	compat_uptr_t data;
+	compat_size_t data_size;
+};
+
+struct compat_ncr_session_output_buffer {
+	compat_uptr_t buffer;
+	compat_size_t buffer_size;
+	compat_uptr_t result_size_ptr;
+};
+#endif
+
+int ncr_session_input_data_from_nla(struct ncr_session_input_data *dest,
+				    const struct nlattr *nla, int compat);
+
+int ncr_session_output_buffer_from_nla(struct ncr_session_output_buffer *dest,
+				       const struct nlattr *nla, int compat);
+
+int ncr_session_output_buffer_set_size(const struct ncr_session_output_buffer *dest,
+				       size_t size, int compat);
+
+#endif
diff --git a/crypto/userspace/ncr-pk.h b/crypto/userspace/ncr-pk.h
new file mode 100644
index 0000000..412caf5
--- /dev/null
+++ b/crypto/userspace/ncr-pk.h
@@ -0,0 +1,55 @@
+#ifndef NCR_PK_H
+# define NCR_PK_H
+
+#include <tomcrypt.h>
+
+struct nlattr;
+
+struct ncr_pk_ctx {
+	const struct algo_properties_st *algorithm; /* algorithm */
+	
+	const struct algo_properties_st *sign_hash; /* for verification */
+	
+	const struct algo_properties_st *oaep_hash;
+	int salt_len; /* for RSA-PSS signatures */
+	
+	int type; /* libtomcrypt type */
+	int init; /* non zero if initialized */
+	
+	struct key_item_st * key;
+};
+
+/* PK */
+void ncr_pk_clear(struct key_item_st* key);
+int ncr_pk_generate(const struct algo_properties_st *algo, struct nlattr *tb[],
+	struct key_item_st* private, struct key_item_st* public);
+int ncr_pk_pack( const struct key_item_st * key, uint8_t * packed, uint32_t * packed_size);
+int ncr_pk_unpack( struct key_item_st * key, const void * packed, size_t packed_size);
+
+/* encryption/decryption */
+int ncr_pk_cipher_init(const struct algo_properties_st *algo,
+		       struct ncr_pk_ctx* ctx, struct nlattr *tb[],
+		       struct key_item_st *key,
+		       const struct algo_properties_st *sign_hash);
+void ncr_pk_cipher_deinit(struct ncr_pk_ctx* ctx);
+
+int ncr_pk_cipher_encrypt(const struct ncr_pk_ctx* ctx, 
+	const struct scatterlist* isg, unsigned int isg_cnt, size_t isg_size,
+	struct scatterlist *osg, unsigned int osg_cnt, size_t* osg_size);
+
+int ncr_pk_cipher_decrypt(const struct ncr_pk_ctx* ctx,
+ 	const struct scatterlist* isg, unsigned int isg_cnt, size_t isg_size,
+	struct scatterlist *osg, unsigned int osg_cnt, size_t* osg_size);
+
+int ncr_pk_cipher_sign(const struct ncr_pk_ctx *ctx, const void *hash,
+		       size_t hash_size, void *sig, size_t *sig_size);
+	
+int ncr_pk_cipher_verify(const struct ncr_pk_ctx* ctx, const void *sig,
+			 size_t sig_size, const void *hash, size_t hash_size);
+
+int _ncr_tomerr(int err);
+
+int ncr_pk_derive(struct key_item_st* newkey, struct key_item_st* oldkey,
+		  struct nlattr *tb[]);
+
+#endif
-- 
1.7.2.1

