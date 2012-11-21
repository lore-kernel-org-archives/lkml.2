Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab2KUHKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:10:21 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:36685 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775Ab2KUHKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:10:19 -0500
Date: Wed, 21 Nov 2012 00:10:15 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Peter.Huewe@infineon.com
Cc: key@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net
Subject: [PATCH resend] TPM: Issue TPM_STARTUP at driver load if the TPM
 has not been started
Message-ID: <20121121071015.GD19837@obsidianresearch.com>
References: <20120930233012.GH30637@obsidianresearch.com>
 <74A44E99E3274B4CB570415926B37D440EAA91@MUCSE501.eu.infineon.com>
 <20121001161536.GC31620@obsidianresearch.com>
 <20121001171003.GA1117@ennui.austin.ibm.com>
 <20121001173908.GA22342@obsidianresearch.com>
 <20121004174114.GA6520@ennui.austin.ibm.com>
 <74A44E99E3274B4CB570415926B37D440EC19C@MUCSE501.eu.infineon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74A44E99E3274B4CB570415926B37D440EC19C@MUCSE501.eu.infineon.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TPM will respond to TPM_GET_CAP with TPM_ERR_INVALID_POSTINIT if
TPM_STARTUP has not been issued. Detect this and automatically
issue TPM_STARTUP.

This is for embedded applications where the kernel is the first thing
to touch the TPM.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/tpm.c |   43 +++++++++++++++++++++++++++++++++++++++----
 drivers/char/tpm/tpm.h |    6 ++++++
 2 files changed, 45 insertions(+), 4 deletions(-)

Discussion on this got a bit sidetracked talking about
suspend/resume.. To be clear, this fixes a real, serious, problem on
normal embedded cases where the kernel refuses to attach the TPM driver
at all.

Key, are you happy with this as-is for the next merge window?

This version is rebased and retested to 3.7-rc6. Tested on Atmel
and Nuvoton LPC TPMs on PPC32.

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 93211df..c576718 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -468,7 +468,7 @@ static ssize_t transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
 		return -EFAULT;
 
 	err = be32_to_cpu(cmd->header.out.return_code);
-	if (err != 0)
+	if (err != 0 && desc)
 		dev_err(chip->dev, "A TPM error (%d) occurred %s\n", err, desc);
 
 	return err;
@@ -485,6 +485,16 @@ static const struct tpm_input_header tpm_getcap_header = {
 	.ordinal = TPM_ORD_GET_CAP
 };
 
+#define TPM_ORD_STARTUP cpu_to_be32(153)
+#define TPM_ST_CLEAR cpu_to_be16(1)
+#define TPM_ST_STATE cpu_to_be16(2)
+#define TPM_ST_DEACTIVATED cpu_to_be16(3)
+static const struct tpm_input_header tpm_startup_header = {
+	.tag = TPM_TAG_RQU_COMMAND,
+	.length = cpu_to_be32(12),
+	.ordinal = TPM_ORD_STARTUP
+};
+
 ssize_t tpm_getcap(struct device *dev, __be32 subcap_id, cap_t *cap,
 		   const char *desc)
 {
@@ -528,6 +538,15 @@ void tpm_gen_interrupt(struct tpm_chip *chip)
 }
 EXPORT_SYMBOL_GPL(tpm_gen_interrupt);
 
+static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
+{
+	struct tpm_cmd_t start_cmd;
+	start_cmd.header.in = tpm_startup_header;
+	start_cmd.params.startup_in.startup_type = startup_type;
+	return transmit_cmd(chip, &start_cmd, TPM_INTERNAL_RESULT_SIZE,
+			    "attempting to start the TPM");
+}
+
 int tpm_get_timeouts(struct tpm_chip *chip)
 {
 	struct tpm_cmd_t tpm_cmd;
@@ -541,11 +560,27 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
 	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
 	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
+	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0);
 
-	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
-			"attempting to determine the timeouts");
-	if (rc)
+	if (rc == TPM_ERR_INVALID_POSTINIT) {
+		/* The TPM is not started, we are the first to talk to it.
+		   Execute a startup command. */
+		dev_info(chip->dev, "Issuing TPM_STARTUP");
+		if (tpm_startup(chip, TPM_ST_CLEAR))
+			return rc;
+
+		tpm_cmd.header.in = tpm_getcap_header;
+		tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
+		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
+		tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
+		rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0);
+	}
+	if (rc) {
+		dev_err(chip->dev,
+			"A TPM error (%d) occurred attempting to determine the timeouts\n",
+			rc);
 		goto duration;
+	}
 
 	if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
 	    be32_to_cpu(tpm_cmd.header.out.length)
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 8ef7649..8971b12 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -47,6 +47,7 @@ enum tpm_addr {
 #define TPM_WARN_DOING_SELFTEST 0x802
 #define TPM_ERR_DEACTIVATED     0x6
 #define TPM_ERR_DISABLED        0x7
+#define TPM_ERR_INVALID_POSTINIT 38
 
 #define TPM_HEADER_SIZE		10
 extern ssize_t tpm_show_pubek(struct device *, struct device_attribute *attr,
@@ -291,6 +292,10 @@ struct tpm_getrandom_in {
 	__be32 num_bytes;
 }__attribute__((packed));
 
+struct tpm_startup_in {
+	__be16	startup_type;
+} __packed;
+
 typedef union {
 	struct	tpm_getcap_params_out getcap_out;
 	struct	tpm_readpubek_params_out readpubek_out;
@@ -301,6 +306,7 @@ typedef union {
 	struct	tpm_pcrextend_in pcrextend_in;
 	struct	tpm_getrandom_in getrandom_in;
 	struct	tpm_getrandom_out getrandom_out;
+	struct tpm_startup_in startup_in;
 } tpm_cmd_params;
 
 struct tpm_cmd_t {
-- 
1.7.4.1

