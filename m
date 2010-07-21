Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761Ab0GUVbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 17:31:48 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:64734 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab0GUVbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 17:31:46 -0400
Date: Wed, 21 Jul 2010 17:31:27 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Yu, Luming" <luming.yu@intel.com>, Philip Langdale <philipl@overt.org>,
        Jeff Garrett <jeff@jgarrett.org>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "venki@google.com" <venki@google.com>
Subject: [PATCH] ACPI: make acpi_idle Nehalem-aware
In-reply-to: <20100525185507.GA15997@srcf.ucam.org>
Message-id: <alpine.LFD.2.00.1007211729550.409@localhost.localdomain>
References: <alpine.LFD.2.00.1002051238280.4050@localhost.localdomain>
 <20100426194002.586fbaa5@fido5> <20100427124703.GA16706@jgarrett.org>
 <alpine.LFD.2.00.1004301218280.2489@sony>
 <20100430174447.GA14889@srcf.ucam.org>
 <d7f2dd35a4361e5156079278543769a0@localhost>
 <alpine.LFD.2.00.1005250125590.20648@localhost.localdomain>
 <CE761E84DADF2947A4AF22FB8D97A4731E0366B5@shsmsx501.ccr.corp.intel.com>
 <20100525124325.GC7876@srcf.ucam.org>
 <alpine.LFD.2.00.1005251114420.4114@localhost.localdomain>
 <20100525185507.GA15997@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

The BIOS exports deep C-states on modern Intel processors
as "C3-type" to satisfy various legacy Operating Systems.

However, the hardware actually supports C2-type, and does
not require the extra costs of C3-type.

One of the costs is to check the BM_STS (Bus Master Status)
bit before entering C3, and instead choose a shallower C-state
if there was "recent bus master activity".

We have found a number of systems in the field that erroneously
set BM_STS and prevent entry into deep C-states.
Re-define BIOS presented C3-type states as C2-type states
on modern processors to avoid this issue.

If a device in the system really does want to prevent use
of a deep C-state, its Linux driver should register its
constraints via pm_qos_add_request().

https://bugzilla.kernel.org/show_bug.cgi?id=15886

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/processor_idle.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index b1b3856..14d1a0c 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -607,6 +607,38 @@ static void acpi_processor_power_verify_c3(struct acpi_processor *pr,
 	return;
 }
 
+/*
+ * Modern Intel processors support only ACPI C2-type C-states.
+ * But the BIOS tends to report its deepest C-state as C3-type
+ * to satisfy various old operating systems.  We can skip
+ * C3 OS overhead by treating the deep-states as C2-type.
+ * Also, we can avoid checking BM_STS, which on some systems
+ * erroneously prevents entry into C3-type states.
+ */
+static int acpi_c3type_is_really_c2type(void) {
+
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+		return 0;
+
+	if (boot_cpu_data.x86 != 6)
+		return 0;
+
+	switch(boot_cpu_data.x86_model) {
+	case 0x1A:	/* Core i7, Xeon 5500 series */
+	case 0x1E:	/* Core i7 and i5 Processor */
+	case 0x1F:	/* Core i7 and i5 Processor */
+	case 0x2E:	/* NHM-EX Xeon */
+	case 0x2F:	/* WSM-EX Xeon */
+	case 0x25:	/* WSM */
+	case 0x2C:	/* WSM */
+	case 0x2A:	/* SNB */
+	case 0x2D:	/* SNB Xeon */
+		return 1;
+	default:
+		return 0;
+	}
+}
+
 static int acpi_processor_power_verify(struct acpi_processor *pr)
 {
 	unsigned int i;
@@ -617,6 +649,12 @@ static int acpi_processor_power_verify(struct acpi_processor *pr)
 	for (i = 1; i < ACPI_PROCESSOR_MAX_POWER && i <= max_cstate; i++) {
 		struct acpi_processor_cx *cx = &pr->power.states[i];
 
+		if ((cx->type == ACPI_STATE_C3)
+			&& acpi_c3type_is_really_c2type()) {
+				ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Redefining C3-type to C2\n"));
+				cx->type = ACPI_STATE_C2;
+		}
+
 		switch (cx->type) {
 		case ACPI_STATE_C1:
 			cx->valid = 1;
-- 
1.7.2.rc3.43.g24e7a


