Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab2A2SWL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 13:22:11 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34389 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab2A2SWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 13:22:10 -0500
Message-ID: <4F258E4C.8020606@linux.vnet.ibm.com>
Date: Sun, 29 Jan 2012 13:22:04 -0500
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.15
MIME-Version: 1.0
To: John Hughes <john@calvaedi.com>
CC: Jonathan Nieder <jrnieder@gmail.com>, John Hughes <john@atlantech.com>,
        Jeff Layton <jlayton@poochiereds.net>, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [Sony Vaio TX3] TPM chip prevents machine from suspending a second
 time
References: <20110328100846.0ba2e039@tlielax.poochiereds.net> <4D90C472.3090908@linux.vnet.ibm.com> <20110328141241.06a435f8@tlielax.poochiereds.net> <20110328154543.1bb979fd@tlielax.poochiereds.net> <4D91157F.2020502@linux.vnet.ibm.com> <20120121170157.GA18053@burratino> <4F1DC8A3.60901@linux.vnet.ibm.com> <4F252441.3090507@calvaedi.com>
In-Reply-To: <4F252441.3090507@calvaedi.com>
Content-Type: multipart/mixed;
 boundary="------------040304000500020604030201"
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012918-3534-0000-0000-000005007909
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040304000500020604030201
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 01/29/2012 05:49 AM, John Hughes wrote:
> On 23/01/12 21:52, Stefan Berger wrote:
>>
>> Can you apply the patch below to your tpm_tis.c (or somewhere else in 
>> the kernel) and let me/us know what it reports in 'dmesg' upon a 
>> 'modprobe tpm_tis'?
>
> [   48.826151] tpm_tis 00:07: dmi: 0: (null)
> [   48.826157] tpm_tis 00:07: dmi: 1: Phoenix Technologies LTD
> [   48.826161] tpm_tis 00:07: dmi: 2: R0021N3
> [   48.826165] tpm_tis 00:07: dmi: 3: 05/09/2006
> [   48.826169] tpm_tis 00:07: dmi: 4: Sony Corporation
> [   48.826173] tpm_tis 00:07: dmi: 5: VGN-TX3XP_B
> [   48.826177] tpm_tis 00:07: dmi: 6: J001QHZL
> [   48.826181] tpm_tis 00:07: dmi: 7: 28244651-5000176
> [   48.826186] tpm_tis 00:07: dmi: 8: 
> DC744BA0-5B3C-11D9-8822-0013A93CCD4D
> [   48.826190] tpm_tis 00:07: dmi: 9: Sony Corporation
> [   48.826195] tpm_tis 00:07: dmi: 10: VAIO
> [   48.826199] tpm_tis 00:07: dmi: 11: N/A
> [   48.826204] tpm_tis 00:07: dmi: 12: N/A
> [   48.826208] tpm_tis 00:07: dmi: 13: N/A
> [   48.826213] tpm_tis 00:07: dmi: 14: Sony Corporation
> [   48.826217] tpm_tis 00:07: dmi: 15: 10
> [   48.826221] tpm_tis 00:07: dmi: 16: N/A
> [   48.826225] tpm_tis 00:07: dmi: 17: J001QHZL
> [   48.826229] tpm_tis 00:07: dmi: 18:
> [   48.826235] tpm_tis 00:07: 1.2 TPM (device-id 0xB, rev-id 16)
>
Thanks. Please try the attached patch.

I am not sure whether this is the right way to go, though: Is it a 
problem particular to this BIOS + Board or a general problem of this 
BIOS? Is it specific to the TX3 or to all VAIOs?

   Stefan




--------------040304000500020604030201
Content-Type: text/plain;
 name="tpm_resume_quirks.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tpm_resume_quirks.diff"

Add a TPM resume quirk for machines where the BIOS doesn't send the
TPM_Startup(ST_STATE) to the TPM and subsequent suspends fail due
to this. Identify machines by their SMBIOS data and only apply the quirk
on those known to need it.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

---
 drivers/char/tpm/tpm.c |  153 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm.h |    8 ++
 2 files changed, 161 insertions(+)

Index: linux-2.6/drivers/char/tpm/tpm.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm.c
+++ linux-2.6/drivers/char/tpm/tpm.c
@@ -28,6 +28,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/freezer.h>
+#include <linux/dmi.h>
 
 #include "tpm.h"
 
@@ -62,6 +63,131 @@ static LIST_HEAD(tpm_chip_list);
 static DEFINE_SPINLOCK(driver_lock);
 static DECLARE_BITMAP(dev_mask, TPM_NUM_DEVICES);
 
+/***** tpm quirks *****/
+
+#ifdef CONFIG_DMI
+
+struct tpm_dmi_entry {
+	enum dmi_field id;
+	const char **value;
+};
+
+struct tpm_resume_quirks {
+	const char *quirk_name;
+	const struct tpm_dmi_entry *dmi_entry;
+};
+
+#define TPM_DMI_ENTRY_LAST \
+	{ .id = DMI_NONE, .value = (const char*[]) { NULL }, }
+
+static const struct tpm_resume_quirks tpm_resume_quirks[] = {
+	{
+		.quirk_name = "Sony Vaio TX3",
+		.dmi_entry = (struct tpm_dmi_entry[]) {
+			{
+				.id = DMI_BIOS_VENDOR,
+				.value = (const char*[]) {
+					"Phoenix Technologies LTD",
+					NULL,
+				},
+			},
+			{
+				.id = DMI_SYS_VENDOR,
+				.value = (const char*[]) {
+					"Sony Corporation",
+					NULL,
+				},
+			},
+			{
+				.id = DMI_PRODUCT_NAME,
+				.value = (const char*[]) {
+					"VGN-TX3XP_B",
+					NULL,
+				},
+			},
+			{
+				.id = DMI_BOARD_NAME,
+				.value = (const char*[]) {
+					"VAIO",
+					NULL,
+				},
+			},
+			TPM_DMI_ENTRY_LAST
+		}
+	}
+};
+
+bool find_str_in_array(const char **array, const char *val)
+{
+	int i = 0;
+
+	while (array[i]) {
+		if (!strcmp(array[i++], val))
+			return true;
+	}
+
+	return false;
+}
+
+static bool tpm_resume_quirk_dmi(struct tpm_chip *chip)
+{
+	int i, j, rc;
+	bool found = false, handled = false;
+	const char *val;
+	const struct tpm_dmi_entry *dmi_entry;
+
+	for (i = 0; i < ARRAY_SIZE(tpm_resume_quirks) && !handled; i++) {
+		j = 0;
+		found = true;
+
+		while (true) {
+			dmi_entry = &tpm_resume_quirks[i].dmi_entry[j];
+
+			if (dmi_entry->id == DMI_NONE)
+				break;
+
+			val = dmi_get_system_info(dmi_entry->id);
+			if (!val) {
+				found = false;
+				break;
+			}
+
+			found = find_str_in_array(dmi_entry->value, val);
+			if (!found)
+				break;
+			j++;
+		}
+
+		if (found) {
+			dev_info(chip->dev,
+				 "Using tpm resume quirk '%s'.\n",
+				 tpm_resume_quirks[i].quirk_name);
+			rc = tpm_startup_ststate(chip);
+			if (rc < 0)
+				dev_err(chip->dev,
+					"quirk: TPM startup(ST_STATE) "
+					"failed.\n");
+			handled = true;
+			break;
+		}
+	}
+	return handled;
+}
+
+#else
+
+static bool tpm_resume_quirk_dmi(struct tpm_chip *tpm_chip)
+{
+	return false;
+}
+
+#endif
+
+static void tpm_resume_quirk(struct tpm_chip *tpm_chip)
+{
+	tpm_resume_quirk_dmi(tpm_chip);
+}
+
 /*
  * Array with one entry per ordinal defining the maximum amount
  * of time the chip could take to return the result.  The ordinal
@@ -864,6 +990,31 @@ int tpm_do_selftest(struct tpm_chip *chi
 }
 EXPORT_SYMBOL_GPL(tpm_do_selftest);
 
+/**
+ * tpm_startup_ststate - send a ststartup to the TPM
+ */
+#define TPM_ORD_STARTUP 153
+#define STARTUP_RESULT_SIZE 10
+
+static struct tpm_input_header startup_ststate_header = {
+	.tag = TPM_TAG_RQU_COMMAND,
+	.length = cpu_to_be32(10),
+	.ordinal = cpu_to_be32(TPM_ORD_STARTUP),
+};
+
+int tpm_startup_ststate(struct tpm_chip *chip)
+{
+	int rc;
+	struct tpm_cmd_t cmd;
+
+	cmd.header.in = startup_ststate_header;
+	cmd.params.startup_in.state = cpu_to_be16(TPM_ST_STATE);
+	rc = transmit_cmd(chip, &cmd, STARTUP_RESULT_SIZE,
+			  "startup(st_state)");
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm_startup_ststate);
+
 int tpm_send(u32 chip_num, void *cmd, size_t buflen)
 {
 	struct tpm_chip *chip;
@@ -1313,6 +1464,8 @@ int tpm_pm_resume(struct device *dev)
 	if (chip == NULL)
 		return -ENODEV;
 
+	tpm_resume_quirk(chip);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_pm_resume);
Index: linux-2.6/drivers/char/tpm/tpm.h
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm.h
+++ linux-2.6/drivers/char/tpm/tpm.h
@@ -42,6 +42,8 @@ enum tpm_addr {
 #define TPM_ERR_DEACTIVATED     0x6
 #define TPM_ERR_DISABLED        0x7
 
+#define TPM_ST_STATE            0x2
+
 #define TPM_HEADER_SIZE		10
 extern ssize_t tpm_show_pubek(struct device *, struct device_attribute *attr,
 				char *);
@@ -269,6 +271,10 @@ struct tpm_pcrextend_in {
 	u8	hash[TPM_DIGEST_SIZE];
 }__attribute__((packed));
 
+struct tpm_startup_in {
+	__be16 state;
+} __packed;
+
 typedef union {
 	struct	tpm_getcap_params_out getcap_out;
 	struct	tpm_readpubek_params_out readpubek_out;
@@ -277,6 +283,7 @@ typedef union {
 	struct	tpm_pcrread_in	pcrread_in;
 	struct	tpm_pcrread_out	pcrread_out;
 	struct	tpm_pcrextend_in pcrextend_in;
+	struct  tpm_startup_in startup_in;
 } tpm_cmd_params;
 
 struct tpm_cmd_t {
@@ -289,6 +296,7 @@ ssize_t	tpm_getcap(struct device *, __be
 extern int tpm_get_timeouts(struct tpm_chip *);
 extern void tpm_gen_interrupt(struct tpm_chip *);
 extern int tpm_do_selftest(struct tpm_chip *);
+extern int tpm_startup_ststate(struct tpm_chip *);
 extern unsigned long tpm_calc_ordinal_duration(struct tpm_chip *, u32);
 extern struct tpm_chip* tpm_register_hardware(struct device *,
 				 const struct tpm_vendor_specific *);

--------------040304000500020604030201--

