Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab0DMV1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 17:27:24 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:26802 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab0DMV1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 17:27:22 -0400
Message-ID: <4BC4E0E9.7000203@oracle.com>
Date: Tue, 13 Apr 2010 14:23:53 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andy Isaacson <adi@hexapodia.org>,
       guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: [PATCH -v3 2/3] x86,pci, acpi: host bridge windows inherit BUSY flag
 from parent
References: <20100409223532.GC11130@hexapodia.org>	 <4BBFB1D8.6090802@oracle.com> <20100410000030.GE11130@hexapodia.org>	 <4BBFD019.9040405@oracle.com> <20100410014308.GG11130@hexapodia.org>	 <4BBFD8EF.6020108@oracle.com> <20100410015711.GH11130@hexapodia.org>	 <4BBFE66C.2040603@oracle.com> <20100412185416.GA19959@hexapodia.org>	 <4BC375D9.4040503@oracle.com> <20100412200224.GO11130@hexapodia.org>	 <4BC39F67.4090407@oracle.com> <1271192527.6035.44.camel@dc7800.home> <4BC4DD85.5030203@zytor.com> <4BC4DDEA.60202@oracle.com> <4BC4DFAD.9020600@zytor.com>
In-Reply-To: <4BC4DFAD.9020600@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BC4E17C.01A5:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



If a host bridge window falls inside a region the architecture has
marked busy, the window should inherit the busy flag so we don't
try to assign that region to a device.

[commit log is from Bjorn]

Tested-by: Andy Isaacson <adi@hexapodia.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/acpi.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/arch/x86/pci/acpi.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/acpi.c
+++ linux-2.6/arch/x86/pci/acpi.c
@@ -175,6 +175,10 @@ setup_resource(struct acpi_resource *acp
 			"conflicts with %s %pR\n",
 			res, conflict->name, conflict);
 	} else {
+		/* In case it falls in big reserved region */
+		if (res->parent->flags & IORESOURCE_BUSY)
+			res->flags |= IORESOURCE_BUSY;
+
 		pci_bus_add_resource(info->bus, res, 0);
 		info->res_num++;
 		if (addr.translation_offset)
