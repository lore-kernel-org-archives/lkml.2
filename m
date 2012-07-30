Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab2G3Uv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 16:51:26 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33711 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267Ab2G3UvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 16:51:23 -0400
Date: Mon, 30 Jul 2012 15:51:16 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Kent Yoder <shpedoikal@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, James Morris <jmorris@namei.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net,
        Peter Huewe <peter.huewe@infineon.com>,
        Bryan Freed <bfreed@chromium.org>,
        David Safford <safford@linux.vnet.ibm.com>
Subject: Re: [GIT PULL] New TPM driver, hwrng driver and fixes
Message-ID: <20120730205116.GA22156@linux.vnet.ibm.com>
References: <20120727181436.GA6271@linux.vnet.ibm.com>
 <5012DCF9.7010408@zytor.com>
 <20120727203000.GA22684@linux.vnet.ibm.com>
 <5013118D.2030601@zytor.com>
 <CAM0nabH2629Qx_inhzDuAGggy6rwZJ=rO68yrXie9TtEP6qKuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0nabH2629Qx_inhzDuAGggy6rwZJ=rO68yrXie9TtEP6qKuQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073020-5112-0000-0000-00000A8F93CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Perhaps we should just do the same "err = total ? total : -EIO;" here
> > and the above statement can just turn into a break;.
> 
>   Yeah, this seems like the right thing to do.
> 
> >> -     ret = my_get_random(hash, SHA1_DIGEST_SIZE);
> >> +     ret = tpm_get_random(TPM_ANY_NUM, hash, SHA1_DIGEST_SIZE);
> >>       if (ret < 0)
> >>               return ret;
> >
> > You are still not checking the return values correctly!
> 
>   Dave, can you weigh in on these individual cases?  In some cases
> like capping a pcr I think using uninitialized stack data could be
> better than failing...

I got in touch with Dave today, who'd like the full checking done now
that we can. Here's a new patch, let me know what you think...

Thanks,
Kent

commit 85d3caa4bb08da4d1761560ae0fdf13f94abf53a
Author: Kent Yoder <key@linux.vnet.ibm.com>
Date:   Thu Jun 7 13:47:14 2012 -0500

    tpm: Move tpm_get_random api into the TPM device driver
    
    Move the tpm_get_random api from the trusted keys code into the TPM
    device driver itself so that other callers can make use of it. Also,
    change the api slightly so that the number of bytes read is returned in
    the call, since the TPM command can potentially return fewer bytes than
    requested.
    
    Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
    Acked-by: David Safford <safford@linux.vnet.ibm.com>

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index beb98c3..43753ec 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -32,12 +32,6 @@
 #include "tpm.h"
 #include "tpm_eventlog.h"
 
-enum tpm_const {
-	TPM_MINOR = 224,	/* officially assigned */
-	TPM_BUFSIZE = 4096,
-	TPM_NUM_DEVICES = 256,
-};
-
 enum tpm_duration {
 	TPM_SHORT = 0,
 	TPM_MEDIUM = 1,
@@ -483,6 +477,7 @@ static ssize_t transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
 #define TPM_INTERNAL_RESULT_SIZE 200
 #define TPM_TAG_RQU_COMMAND cpu_to_be16(193)
 #define TPM_ORD_GET_CAP cpu_to_be32(101)
+#define TPM_ORD_GET_RANDOM cpu_to_be32(70)
 
 static const struct tpm_input_header tpm_getcap_header = {
 	.tag = TPM_TAG_RQU_COMMAND,
@@ -1327,6 +1322,58 @@ int tpm_pm_resume(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(tpm_pm_resume);
 
+#define TPM_GETRANDOM_RESULT_SIZE	18
+static struct tpm_input_header tpm_getrandom_header = {
+	.tag = TPM_TAG_RQU_COMMAND,
+	.length = cpu_to_be32(14),
+	.ordinal = TPM_ORD_GET_RANDOM
+};
+
+/**
+ * tpm_get_random() - Get random bytes from the tpm's RNG
+ * @chip_num: A specific chip number for the request or TPM_ANY_NUM
+ * @out: destination buffer for the random bytes
+ * @max: the max number of bytes to write to @out
+ *
+ * Returns < 0 on error and the number of bytes read on success
+ */
+int tpm_get_random(u32 chip_num, u8 *out, size_t max)
+{
+	struct tpm_chip *chip;
+	struct tpm_cmd_t tpm_cmd;
+	u32 recd, num_bytes = min_t(u32, max, TPM_MAX_RNG_DATA);
+	int err, total = 0, retries = 5;
+	u8 *dest = out;
+
+	chip = tpm_chip_find_get(chip_num);
+	if (chip == NULL)
+		return -ENODEV;
+
+	if (!out || !num_bytes || max > TPM_MAX_RNG_DATA)
+		return -EINVAL;
+
+	do {
+		tpm_cmd.header.in = tpm_getrandom_header;
+		tpm_cmd.params.getrandom_in.num_bytes = cpu_to_be32(num_bytes);
+
+		err = transmit_cmd(chip, &tpm_cmd,
+				   TPM_GETRANDOM_RESULT_SIZE + num_bytes,
+				   "attempting get random");
+		if (err)
+			break;
+
+		recd = be32_to_cpu(tpm_cmd.params.getrandom_out.rng_data_len);
+		memcpy(dest, tpm_cmd.params.getrandom_out.rng_data, recd);
+
+		dest += recd;
+		total += recd;
+		num_bytes -= recd;
+	} while (retries-- && total < max);
+
+	return total ? total : -EIO;
+}
+EXPORT_SYMBOL_GPL(tpm_get_random);
+
 /* In case vendor provided release function, call it too.*/
 
 void tpm_dev_vendor_release(struct tpm_chip *chip)
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index b1c5280..610fe42 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -28,6 +28,12 @@
 #include <linux/io.h>
 #include <linux/tpm.h>
 
+enum tpm_const {
+	TPM_MINOR = 224,	/* officially assigned */
+	TPM_BUFSIZE = 4096,
+	TPM_NUM_DEVICES = 256,
+};
+
 enum tpm_timeout {
 	TPM_TIMEOUT = 5,	/* msecs */
 };
@@ -269,6 +275,21 @@ struct tpm_pcrextend_in {
 	u8	hash[TPM_DIGEST_SIZE];
 }__attribute__((packed));
 
+/* 128 bytes is an arbitrary cap. This could be as large as TPM_BUFSIZE - 18
+ * bytes, but 128 is still a relatively large number of random bytes and
+ * anything much bigger causes users of struct tpm_cmd_t to start getting
+ * compiler warnings about stack frame size. */
+#define TPM_MAX_RNG_DATA	128
+
+struct tpm_getrandom_out {
+	__be32 rng_data_len;
+	u8     rng_data[TPM_MAX_RNG_DATA];
+}__attribute__((packed));
+
+struct tpm_getrandom_in {
+	__be32 num_bytes;
+}__attribute__((packed));
+
 typedef union {
 	struct	tpm_getcap_params_out getcap_out;
 	struct	tpm_readpubek_params_out readpubek_out;
@@ -277,6 +298,8 @@ typedef union {
 	struct	tpm_pcrread_in	pcrread_in;
 	struct	tpm_pcrread_out	pcrread_out;
 	struct	tpm_pcrextend_in pcrextend_in;
+	struct	tpm_getrandom_in getrandom_in;
+	struct	tpm_getrandom_out getrandom_out;
 } tpm_cmd_params;
 
 struct tpm_cmd_t {
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index fdc718a..fcb627f 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -32,6 +32,7 @@
 extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
 extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
 extern int tpm_send(u32 chip_num, void *cmd, size_t buflen);
+extern int tpm_get_random(u32 chip_num, u8 *data, size_t max);
 #else
 static inline int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf) {
 	return -ENODEV;
@@ -42,5 +43,8 @@ static inline int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash) {
 static inline int tpm_send(u32 chip_num, void *cmd, size_t buflen) {
 	return -ENODEV;
 }
+static inline int tpm_get_random(u32 chip_num, u8 *data, size_t max) {
+	return -ENODEV;
+}
 #endif
 #endif
diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index 2d5d041..3f163d0 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -369,38 +369,6 @@ static int trusted_tpm_send(const u32 chip_num, unsigned char *cmd,
 }
 
 /*
- * get a random value from TPM
- */
-static int tpm_get_random(struct tpm_buf *tb, unsigned char *buf, uint32_t len)
-{
-	int ret;
-
-	INIT_BUF(tb);
-	store16(tb, TPM_TAG_RQU_COMMAND);
-	store32(tb, TPM_GETRANDOM_SIZE);
-	store32(tb, TPM_ORD_GETRANDOM);
-	store32(tb, len);
-	ret = trusted_tpm_send(TPM_ANY_NUM, tb->data, sizeof tb->data);
-	if (!ret)
-		memcpy(buf, tb->data + TPM_GETRANDOM_SIZE, len);
-	return ret;
-}
-
-static int my_get_random(unsigned char *buf, int len)
-{
-	struct tpm_buf *tb;
-	int ret;
-
-	tb = kmalloc(sizeof *tb, GFP_KERNEL);
-	if (!tb)
-		return -ENOMEM;
-	ret = tpm_get_random(tb, buf, len);
-
-	kfree(tb);
-	return ret;
-}
-
-/*
  * Lock a trusted key, by extending a selected PCR.
  *
  * Prevents a trusted key that is sealed to PCRs from being accessed.
@@ -413,8 +381,8 @@ static int pcrlock(const int pcrnum)
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	ret = my_get_random(hash, SHA1_DIGEST_SIZE);
-	if (ret < 0)
+	ret = tpm_get_random(TPM_ANY_NUM, hash, SHA1_DIGEST_SIZE);
+	if (ret != SHA1_DIGEST_SIZE)
 		return ret;
 	return tpm_pcr_extend(TPM_ANY_NUM, pcrnum, hash) ? -EINVAL : 0;
 }
@@ -429,8 +397,8 @@ static int osap(struct tpm_buf *tb, struct osapsess *s,
 	unsigned char ononce[TPM_NONCE_SIZE];
 	int ret;
 
-	ret = tpm_get_random(tb, ononce, TPM_NONCE_SIZE);
-	if (ret < 0)
+	ret = tpm_get_random(TPM_ANY_NUM, ononce, TPM_NONCE_SIZE);
+	if (ret != TPM_NONCE_SIZE)
 		return ret;
 
 	INIT_BUF(tb);
@@ -524,8 +492,8 @@ static int tpm_seal(struct tpm_buf *tb, uint16_t keytype,
 	if (ret < 0)
 		goto out;
 
-	ret = tpm_get_random(tb, td->nonceodd, TPM_NONCE_SIZE);
-	if (ret < 0)
+	ret = tpm_get_random(TPM_ANY_NUM, td->nonceodd, TPM_NONCE_SIZE);
+	if (ret != TPM_NONCE_SIZE)
 		goto out;
 	ordinal = htonl(TPM_ORD_SEAL);
 	datsize = htonl(datalen);
@@ -634,8 +602,8 @@ static int tpm_unseal(struct tpm_buf *tb,
 
 	ordinal = htonl(TPM_ORD_UNSEAL);
 	keyhndl = htonl(SRKHANDLE);
-	ret = tpm_get_random(tb, nonceodd, TPM_NONCE_SIZE);
-	if (ret < 0) {
+	ret = tpm_get_random(TPM_ANY_NUM, nonceodd, TPM_NONCE_SIZE);
+	if (ret != TPM_NONCE_SIZE) {
 		pr_info("trusted_key: tpm_get_random failed (%d)\n", ret);
 		return ret;
 	}
@@ -935,6 +903,7 @@ static int trusted_instantiate(struct key *key, const void *data,
 	char *datablob;
 	int ret = 0;
 	int key_cmd;
+	size_t key_len;
 
 	if (datalen <= 0 || datalen > 32767 || !data)
 		return -EINVAL;
@@ -974,8 +943,9 @@ static int trusted_instantiate(struct key *key, const void *data,
 			pr_info("trusted_key: key_unseal failed (%d)\n", ret);
 		break;
 	case Opt_new:
-		ret = my_get_random(payload->key, payload->key_len);
-		if (ret < 0) {
+		key_len = payload->key_len;
+		ret = tpm_get_random(TPM_ANY_NUM, payload->key, key_len);
+		if (ret != key_len) {
 			pr_info("trusted_key: key_create failed (%d)\n", ret);
 			goto out;
 		}

