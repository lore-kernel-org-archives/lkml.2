Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab2I1Bqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 21:46:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35703 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab2I1Bql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 21:46:41 -0400
Date: Thu, 27 Sep 2012 18:46:26 -0700
From: tip-bot for Thomas Renninger <trenn@suse.de>
Message-ID: <tip-4901b402c957d4ebaff123ffc34fafe3cef99542@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, lenb@kernel.org, eric.piel@tremplin-utc.net,
        tglx@linutronix.de, trenn@suse.de, hpa@linux.intel.com,
        robert.moore@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, lenb@kernel.org, eric.piel@tremplin-utc.net,
        tglx@linutronix.de, trenn@suse.de, hpa@linux.intel.com,
        robert.moore@intel.com
In-Reply-To: <1348661941-71287-7-git-send-email-trenn@suse.de>
References: <1348661941-71287-7-git-send-email-trenn@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/acpi] ACPI: Document ACPI table overriding via initrd
Git-Commit-ID: 4901b402c957d4ebaff123ffc34fafe3cef99542
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 27 Sep 2012 18:46:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4901b402c957d4ebaff123ffc34fafe3cef99542
Gitweb:     http://git.kernel.org/tip/4901b402c957d4ebaff123ffc34fafe3cef99542
Author:     Thomas Renninger <trenn@suse.de>
AuthorDate: Wed, 26 Sep 2012 14:19:01 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 27 Sep 2012 15:01:43 -0700

ACPI: Document ACPI table overriding via initrd

Signed-off-by: Thomas Renninger <trenn@suse.de>
Link: http://lkml.kernel.org/r/1348661941-71287-7-git-send-email-trenn@suse.de
Cc: Len Brown <lenb@kernel.org>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/acpi/initrd_table_override.txt |   94 ++++++++++++++++++++++++++
 1 files changed, 94 insertions(+), 0 deletions(-)

diff --git a/Documentation/acpi/initrd_table_override.txt b/Documentation/acpi/initrd_table_override.txt
new file mode 100644
index 0000000..35c3f54
--- /dev/null
+++ b/Documentation/acpi/initrd_table_override.txt
@@ -0,0 +1,94 @@
+Overriding ACPI tables via initrd
+=================================
+
+1) Introduction (What is this about)
+2) What is this for
+3) How does it work
+4) References (Where to retrieve userspace tools)
+
+1) What is this about
+---------------------
+
+If the ACPI_INITRD_TABLE_OVERRIDE compile option is true, it is possible to
+override nearly any ACPI table provided by the BIOS with an instrumented,
+modified one.
+
+For a full list of ACPI tables that can be overridden, take a look at
+the char *table_sigs[MAX_ACPI_SIGNATURE]; definition in drivers/acpi/osl.c
+All ACPI tables iasl (Intel's ACPI compiler and disassembler) knows should
+be overridable, except:
+   - ACPI_SIG_RSDP (has a signature of 6 bytes)
+   - ACPI_SIG_FACS (does not have an ordinary ACPI table header)
+Both could get implemented as well.
+
+
+2) What is this for
+-------------------
+
+Please keep in mind that this is a debug option.
+ACPI tables should not get overridden for productive use.
+If BIOS ACPI tables are overridden the kernel will get tainted with the
+TAINT_OVERRIDDEN_ACPI_TABLE flag.
+Complain to your platform/BIOS vendor if you find a bug which is so sever
+that a workaround is not accepted in the Linux kernel.
+
+Still, it can and should be enabled in any kernel, because:
+  - There is no functional change with not instrumented initrds
+  - It provides a powerful feature to easily debug and test ACPI BIOS table
+    compatibility with the Linux kernel.
+
+
+3) How does it work
+-------------------
+
+# Extract the machine's ACPI tables:
+cd /tmp
+acpidump >acpidump
+acpixtract -a acpidump
+# Disassemble, modify and recompile them:
+iasl -d *.dat
+# For example add this statement into a _PRT (PCI Routing Table) function
+# of the DSDT:
+Store("HELLO WORLD", debug)
+iasl -sa dsdt.dsl
+# Add the raw ACPI tables to an uncompressed cpio archive.
+# They must be put into a /kernel/firmware/acpi directory inside the
+# cpio archive.
+# The uncompressed cpio archive must be the first.
+# Other, typically compressed cpio archives, must be
+# concatenated on top of the uncompressed one.
+mkdir -p kernel/firmware/acpi
+cp dsdt.aml kernel/firmware/acpi
+# A maximum of: #define ACPI_OVERRIDE_TABLES 10
+# tables are  currently allowed (see osl.c):
+iasl -sa facp.dsl
+iasl -sa ssdt1.dsl
+cp facp.aml kernel/firmware/acpi
+cp ssdt1.aml kernel/firmware/acpi
+# Create the uncompressed cpio archive and concatenate the original initrd
+# on top:
+find kernel | cpio -H newc --create > /boot/instrumented_initrd
+cat /boot/initrd >>/boot/instrumented_initrd
+# reboot with increased acpi debug level, e.g. boot params:
+acpi.debug_level=0x2 acpi.debug_layer=0xFFFFFFFF
+# and check your syslog:
+[    1.268089] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
+[    1.272091] [ACPI Debug]  String [0x0B] "HELLO WORLD"
+
+iasl is able to disassemble and recompile quite a lot different,
+also static ACPI tables.
+
+
+4) Where to retrieve userspace tools
+------------------------------------
+
+iasl and acpixtract are part of Intel's ACPICA project:
+http://acpica.org/
+and should be packaged by distributions (for example in the acpica package
+on SUSE).
+
+acpidump can be found in Len Browns pmtools:
+ftp://kernel.org/pub/linux/kernel/people/lenb/acpi/utils/pmtools/acpidump
+This tool is also part of the acpica package on SUSE.
+Alternatively, used ACPI tables can be retrieved via sysfs in latest kernels:
+/sys/firmware/acpi/tables
