Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964775Ab1GNWHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 18:07:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52392 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab1GNWHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 18:07:05 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
From: Takao Indoh <indou.takao@jp.fujitsu.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Cc: Cong Wang <amwang@redhat.com>, ebiederm@xmission.com, vgoyal@redhat.com,
        rdunlap@xenotime.net, lenb@kernel.org, linux-doc@vger.kernel.org,
        linux-acpi@vger.kernel.org, mjg@redhat.com
Subject: Re: [PATCH v2] acpi: introduce "acpi_rsdp=" parameter for kdump
Date: Thu, 14 Jul 2011 18:05:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Mailer: HidemaruMail 5.38 (WinNT,501)
In-Reply-To: <20110712133119.GA7377@dumpdata.com>
References: <E8CC3FDD41FF9Findou.takao@jp.fujitsu.com> <4E1C223A.9000705@redhat.com> <20110712133119.GA7377@dumpdata.com>
Message-Id: <FFCC42721FF9ADindou.takao@jp.fujitsu.com>
X-Antivirus: avast! (VPS 110714-0, 2011/07/14), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>The only comment I've is that it would be good to include in the
>patch description which sysfs attribute is used by the kexec tools
>to read in the physical address to be passed in.
>
>Otherwise it looks good to me too.

Thanks for your review. I added it.

---
From: Takao Indoh <indou.takao@jp.fujitsu.com>
Subject: [PATCH v2] acpi: introduce "acpi_rsdp=" parameter for kdump

There is a problem with putting the first kernel in EFI virtual mode,
it is that when the second kernel comes up it tries to initialize the
EFI again and once we have put EFI in virtual mode we can not really
do that.

Actually, EFI is not necessary for kdump, we can boot the second kernel
with "noefi" parameter, but the boot will mostly fail because 2nd kernel
cannot find RSDP.

In this situation, we introduced "acpi_rsdp=" kernel parameter, so that
kexec-tools can pass the "noefi acpi_rsdp=X" to the second kernel to
make kdump works. The physical address of the RSDP can be got from
sysfs(/sys/firmware/efi/systab).

Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
Reviewed-by: WANG Cong <amwang@redhat.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 Documentation/kernel-parameters.txt |    5 +++++
 drivers/acpi/osl.c                  |   15 +++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index fd248a3..b88b8f1 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -163,6 +163,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 			See also Documentation/power/pm.txt, pci=noacpi
 
+	acpi_rsdp=	[ACPI,EFI,KEXEC]
+			Pass the RSDP address to the kernel, mostly used
+			on machines running EFI runtime service to boot the
+			second kernel for kdump.
+
 	acpi_apic_instance=	[ACPI, IOAPIC]
 			Format: <int>
 			2: use 2nd APIC table, if available
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 52ca964..27cd140 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -237,8 +237,23 @@ void acpi_os_vprintf(const char *fmt, va_list args)
 #endif
 }
 
+#ifdef CONFIG_KEXEC
+static unsigned long acpi_rsdp;
+static int __init setup_acpi_rsdp(char *arg)
+{
+	acpi_rsdp = simple_strtoul(arg, NULL, 16);
+	return 0;
+}
+early_param("acpi_rsdp", setup_acpi_rsdp);
+#endif
+
 acpi_physical_address __init acpi_os_get_root_pointer(void)
 {
+#ifdef CONFIG_KEXEC
+	if (acpi_rsdp)
+		return acpi_rsdp;
+#endif
+
 	if (efi_enabled) {
 		if (efi.acpi20 != EFI_INVALID_TABLE_ADDR)
 			return efi.acpi20;
