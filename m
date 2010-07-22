Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008Ab0GVVkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 17:40:25 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:49734 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759731Ab0GVVkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 17:40:22 -0400
Date: Thu, 22 Jul 2010 17:40:02 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Yu, Luming" <luming.yu@intel.com>,
        Philip Langdale <philipl@overt.org>, Jeff Garrett <jeff@jgarrett.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "venki@google.com" <venki@google.com>
Subject: [PATCH] ACPI: create "processor.bm_check_disable" boot param
In-reply-to: <alpine.LFD.2.00.1007221720270.7970@localhost.localdomain>
Message-id: <alpine.LFD.2.00.1007221739260.7970@localhost.localdomain>
References: <20100427124703.GA16706@jgarrett.org>
 <alpine.LFD.2.00.1004301218280.2489@sony>
 <20100430174447.GA14889@srcf.ucam.org>
 <d7f2dd35a4361e5156079278543769a0@localhost>
 <alpine.LFD.2.00.1005250125590.20648@localhost.localdomain>
 <CE761E84DADF2947A4AF22FB8D97A4731E0366B5@shsmsx501.ccr.corp.intel.com>
 <20100525124325.GC7876@srcf.ucam.org>
 <alpine.LFD.2.00.1005251114420.4114@localhost.localdomain>
 <20100525185507.GA15997@srcf.ucam.org>
 <alpine.LFD.2.00.1007211729550.409@localhost.localdomain>
 <20100722074750.GA22520@one.firstfloor.org>
 <alpine.LFD.2.00.1007221153120.3164@localhost.localdomain>
 <alpine.LFD.2.00.1007221720270.7970@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

processor.bm_check_disable=1" prevents Linux from checking BM_STS
before entering C3-type cpu power states.

This may be useful for a system running acpi_idle
where the BIOS exports FADT C-states, _CST IO C-states,
or _CST FFH C-states with the BM_STS bit set;
while configuring the chipset to set BM_STS
more frequently than perhaps is optimal.

Note that such systems may have been developed
using a tickful OS that would quickly clear BM_STS,
rather than a tickless OS that may go for some time
between checking and clearing BM_STS.

Note also that an alternative for newer systems
is to use the intel_idle driver, which always
ignores BM_STS, relying Linux device drivers
to register constraints explicitly via PM_QOS.

https://bugzilla.kernel.org/show_bug.cgi?id=15886

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/processor_idle.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index b351342..1d41048 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -76,6 +76,8 @@ static unsigned int max_cstate __read_mostly = ACPI_PROCESSOR_MAX_POWER;
 module_param(max_cstate, uint, 0000);
 static unsigned int nocst __read_mostly;
 module_param(nocst, uint, 0000);
+static int bm_check_disable __read_mostly;
+module_param(bm_check_disable, uint, 0000);
 
 static unsigned int latency_factor __read_mostly = 2;
 module_param(latency_factor, uint, 0644);
@@ -763,6 +765,9 @@ static int acpi_idle_bm_check(void)
 {
 	u32 bm_status = 0;
 
+	if (bm_check_disable)
+		return 0;
+
 	acpi_read_bit_register(ACPI_BITREG_BUS_MASTER_STATUS, &bm_status);
 	if (bm_status)
 		acpi_write_bit_register(ACPI_BITREG_BUS_MASTER_STATUS, 1);
-- 
1.7.2


