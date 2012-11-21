Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab2KUI73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 03:59:29 -0500
Received: from smtp2.infineon.com ([217.10.60.23]:41787 "EHLO
	smtp2.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2KUI72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 03:59:28 -0500
X-SBRS: None
From: <Peter.Huewe@infineon.com>
To: <jgunthorpe@obsidianresearch.com>, <key@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <tpmdd-devel@lists.sourceforge.net>
Subject: RE: [PATCH resend] TPM: Issue TPM_STARTUP at driver load if the TPM
 has not been started
Thread-Topic: [PATCH resend] TPM: Issue TPM_STARTUP at driver load if the
 TPM has not been started
Thread-Index: AQHNx7dElapQS2HSZE2eryDfqZhcBpfz8S/A
Date: Wed, 21 Nov 2012 08:59:24 +0000
Message-ID: <74A44E99E3274B4CB570415926B37D440F7675@MUCSE501.eu.infineon.com>
References: <20120930233012.GH30637@obsidianresearch.com>
 <74A44E99E3274B4CB570415926B37D440EAA91@MUCSE501.eu.infineon.com>
 <20121001161536.GC31620@obsidianresearch.com>
 <20121001171003.GA1117@ennui.austin.ibm.com>
 <20121001173908.GA22342@obsidianresearch.com>
 <20121004174114.GA6520@ennui.austin.ibm.com>
 <74A44E99E3274B4CB570415926B37D440EC19C@MUCSE501.eu.infineon.com>
 <20121121071015.GD19837@obsidianresearch.com>
In-Reply-To: <20121121071015.GD19837@obsidianresearch.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.8.249]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason, Hi Kent,
>
>Discussion on this got a bit sidetracked talking about
>suspend/resume.. To be clear, this fixes a real, serious, problem on
>normal embedded cases where the kernel refuses to attach the TPM driver
>at all.
>
>Key, are you happy with this as-is for the next merge window?
>
>This version is rebased and retested to 3.7-rc6. Tested on Atmel
>and Nuvoton LPC TPMs on PPC32.

Sorry I was tied up at work with other stuff, so I couldn't try out your initial patch.
Thanks for resubmitting!

I just gave the new version a run on my beagleboard with our Infineon SLB9635 TT 1.2 Soft I2C TPM
and it seems to work as expected. (Tested with and without previous startup).

Tested-by: Peter Huewe <peter.huewe@infineon.com>

I just have some minor comments - please see below.


>+++ b/drivers/char/tpm/tpm.c
>+#define TPM_ORD_STARTUP cpu_to_be32(153)
>+#define TPM_ST_CLEAR cpu_to_be16(1)
>+#define TPM_ST_STATE cpu_to_be16(2)
>+#define TPM_ST_DEACTIVATED cpu_to_be16(3)
>+static const struct tpm_input_header tpm_startup_header = {
>+	.tag = TPM_TAG_RQU_COMMAND,
>+	.length = cpu_to_be32(12),
>+	.ordinal = TPM_ORD_STARTUP
>+};
>+
> ssize_t tpm_getcap(struct device *dev, __be32 subcap_id, cap_t *cap,
> 		   const char *desc)
> {


Purely cosmetic question, but why did you define this before the tpm_getcap and not tpm_startup?
All the other definitions are made before they are used - so this should perhaps better be moved directly before tpm_startup.
(Maybe we should move out these definitions to a common location? Header?)




>@@ -541,11 +560,27 @@ int tpm_get_timeouts(struct tpm_chip *chip)
> 	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
> 	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
> 	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
>+	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0);

Please use NULL instead of 0, otherwise sparse complains - so 
-	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0);
+	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, NULL);


>+	if (rc == TPM_ERR_INVALID_POSTINIT) {
>	...
>+		rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0);

Same here 
please use NULL instead of 0, otherwise sparse complains - so 
-		rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0);
+		rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, NULL);


>diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> extern ssize_t tpm_show_pubek(struct device *, struct device_attribute *attr,
>@@ -291,6 +292,10 @@ struct tpm_getrandom_in {
> 	__be32 num_bytes;
> }__attribute__((packed));
> 
>+struct tpm_startup_in {
>+	__be16	startup_type;
>+} __packed;


All the other user
__attribute__((packed));
Care to change to be consistent?


Apart from these three minor topics also a 
Reviewed-by: Peter Huewe <peter.huewe@infineon.com>

Thanks,
Peter
