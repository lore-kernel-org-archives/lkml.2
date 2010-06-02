Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab0FBWZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 18:25:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758807Ab0FBWZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 18:25:32 -0400
Message-ID: <4C06D91F.2060105@redhat.com>
Date: Wed, 02 Jun 2010 18:20:15 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091210 Fedora/3.0-4.el6 Thunderbird/3.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, mjg@redhat.com,
       x86@kernel.org
Subject: Re: [PATCH]: x86: use acpi flags for apic mapping
References: <20100602192418.2706.35192.sendpatchset@prarit.bos.redhat.com> <20100602194956.GB5264@lenovo>
In-Reply-To: <20100602194956.GB5264@lenovo>
Content-Type: multipart/mixed;
 boundary="------------000708040405000008030502"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000708040405000008030502
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


>>
>> +#ifdef CONFIG_ACPI
>> +enum apic_acpi_map_status apic_is_acpi_clustered_box(void)
>> +{
>
> It's a bit strange that function is "is" prefixed and returns not true or false
> but enum, perhaps we may name it apic_acpi_dst_model() or something like
> that?
>

Sure, np -- new patch.

P.

--------------000708040405000008030502
Content-Type: text/plain;
 name="acpi_apic-v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="acpi_apic-v2.patch"

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 1fa03e0..6b63f95 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -252,6 +252,14 @@ static inline int apic_is_clustered_box(void)
 }
 #endif
 
+enum apic_acpi_map_status {
+	APIC_ACPI_BOTH,
+	APIC_ACPI_CLUSTER,
+	APIC_ACPI_PHYSICAL,
+	APIC_ACPI_NONE
+};
+extern enum apic_acpi_map_status apic_acpi_dst_model(void);
+
 extern u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask);
 extern u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask);
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index e5a4a1e..e94a189 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2189,6 +2189,30 @@ static const __cpuinitconst struct dmi_system_id multi_dmi_table[] = {
 	{}
 };
 
+#ifdef CONFIG_ACPI
+enum apic_acpi_map_status apic_acpi_dst_model(void)
+{
+	if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID) {
+		if (acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL &&
+		    acpi_gbl_FADT.flags & ACPI_FADT_APIC_CLUSTER) {
+			/*
+			 * The rest of the code assumes physical flat
+			 * in this case.
+			 */
+			return APIC_ACPI_BOTH;
+		}
+
+		if (acpi_gbl_FADT.flags & ACPI_FADT_APIC_CLUSTER)
+			return APIC_ACPI_CLUSTER;
+
+		if (acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL)
+			return APIC_ACPI_PHYSICAL;
+	}
+
+	return APIC_ACPI_NONE;
+}
+#endif
+
 static void __cpuinit dmi_check_multi(void)
 {
 	if (multi_checked)
@@ -2208,6 +2232,20 @@ static void __cpuinit dmi_check_multi(void)
  */
 __cpuinit int apic_is_clustered_box(void)
 {
+#ifdef CONFIG_ACPI
+	switch (apic_acpi_dst_model()) {
+		case APIC_ACPI_PHYSICAL:
+		case APIC_ACPI_BOTH: /* assume physical flat in this case */
+			return 0;
+			break;
+		case APIC_ACPI_CLUSTER:
+			return 1;
+			break;
+		default:
+			break;
+	}
+#endif
+
 	dmi_check_multi();
 	if (multi)
 		return 1;
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 09d3b17..c2318ac 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -231,14 +231,32 @@ static int physflat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 #ifdef CONFIG_ACPI
 	/*
-	 * Quirk: some x86_64 machines can only use physical APIC mode
-	 * regardless of how many processors are present (x86_64 ES7000
-	 * is an example).
+	 * Some x86_64 machines can only use clustered or physical APIC
+	 * mode regardless of how many processors are present.
 	 */
-	if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID &&
-		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL)) {
-		printk(KERN_DEBUG "system APIC only can use physical flat");
-		return 1;
+	switch (apic_acpi_dst_model()) {
+		case APIC_ACPI_BOTH:
+			printk(KERN_WARNING FW_BUG "ACPI has set apic mode to "
+			       "both clustered and physical flat.  Please "
+			       "contact your firmware vendor for an update.\n");
+			/*
+			 * In this case assume physical flat as only a very
+			 * limited number of systems use cluster
+			 */
+			printk(KERN_DEBUG "system APIC using physical flat\n");
+			return 1;
+			break;
+		case APIC_ACPI_CLUSTER:
+			printk(KERN_DEBUG "system APIC can only use cluster\n");
+			return 0;
+			break;
+		case APIC_ACPI_PHYSICAL:
+			printk(KERN_DEBUG "system APIC can only use physical"
+			       " flat\n");
+			return 1;
+			break;
+		default:
+			break;
 	}
 
 	if (!strncmp(oem_id, "IBM", 3) && !strncmp(oem_table_id, "EXA", 3)) {

--------------000708040405000008030502--
