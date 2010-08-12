Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165Ab0HLAQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:16:51 -0400
Received: from kroah.org ([198.145.64.141]:47802 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933105Ab0HLAIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:08:18 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:15 2010
Message-Id: <20100812000614.963113748@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:05:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Myron Stowe <myron.stowe@hp.com>, Corey Minyard <minyard@acm.org>
Subject: [25/67] ipmi: fix ACPI detection with regspacing
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit d9e1b6c45059ccfff647a120769ae86da78dfdc4 upstream.

After the commit that changed ipmi_si detecting sequence from SMBIOS/ACPI
to ACPI/SMBIOS,

| commit 754d453185275951d39792865927ec494fa1ebd8
| Author: Matthew Garrett <mjg@redhat.com>
| Date:   Wed May 26 14:43:47 2010 -0700
|
|    ipmi: change device discovery order
|
|    The ipmi spec provides an ordering for si discovery.  Change the driver to
|    match, with the exception of preferring smbios to SPMI as HPs (at least)
|    contain accurate information in the former but not the latter.

ipmi_si can not be initialized.

[  138.799739] calling  init_ipmi_devintf+0x0/0x109 @ 1
[  138.805050] ipmi device interface
[  138.818131] initcall init_ipmi_devintf+0x0/0x109 returned 0 after 12797 usecs
[  138.822998] calling  init_ipmi_si+0x0/0xa90 @ 1
[  138.840276] IPMI System Interface driver.
[  138.846137] ipmi_si: probing via ACPI
[  138.849225] ipmi_si 00:09: [io  0x0ca2] regsize 1 spacing 1 irq 0
[  138.864438] ipmi_si: Adding ACPI-specified kcs state machine
[  138.870893] ipmi_si: probing via SMBIOS
[  138.880945] ipmi_si: Adding SMBIOS-specified kcs state machineipmi_si: duplicate interface
[  138.896511] ipmi_si: probing via SPMI
[  138.899861] ipmi_si: Adding SPMI-specified kcs state machineipmi_si: duplicate interface
[  138.917095] ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[  138.928658] ipmi_si: Interface detection failed
[  138.953411] initcall init_ipmi_si+0x0/0xa90 returned 0 after 110847 usecs

in smbios has
DMI/SMBIOS
Handle 0x00C5, DMI type 38, 18 bytes
IPMI Device Information
        Interface Type: KCS (Keyboard Control Style)
        Specification Version: 2.0
        I2C Slave Address: 0x00
        NV Storage Device: Not Present
        Base Address: 0x0000000000000CA2 (I/O)
        Register Spacing: 32-bit Boundaries
in DSDT has
                    Device (BMC)
                    {

                        Name (_HID, EisaId ("IPI0001"))
                        Method (_STA, 0, NotSerialized)
                        {
                            If (LEqual (OSN, Zero))
                            {
                                Return (Zero)
                            }

                            Return (0x0F)
                        }

                        Name (_STR, Unicode ("IPMI_KCS"))
                        Name (_UID, Zero)
                        Name (_CRS, ResourceTemplate ()
                        {
                            IO (Decode16,
                                0x0CA2,             // Range Minimum
                                0x0CA2,             // Range Maximum
                                0x00,               // Alignment
                                0x01,               // Length
                                )
                            IO (Decode16,
                                0x0CA6,             // Range Minimum
                                0x0CA6,             // Range Maximum
                                0x00,               // Alignment
                                0x01,               // Length
                                )
                        })
                        Method (_IFT, 0, NotSerialized)
                        {
                            Return (One)
                        }

                        Method (_SRV, 0, NotSerialized)
                        {
                            Return (0x0200)
                        }
                    }

so the reg spacing should be 4 instead of 1.

Try to calculate regspacing for this kind of system.

Observed on a Sun Fire X4800.  Other OSes work and pass certification.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Myron Stowe <myron.stowe@hp.com>
Cc: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/ipmi/ipmi_si_intf.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2176,6 +2176,14 @@ static int __devinit ipmi_pnp_probe(stru
 	info->io.addr_data = res->start;
 
 	info->io.regspacing = DEFAULT_REGSPACING;
+	res = pnp_get_resource(dev,
+			       (info->io.addr_type == IPMI_IO_ADDR_SPACE) ?
+					IORESOURCE_IO : IORESOURCE_MEM,
+			       1);
+	if (res) {
+		if (res->start > info->io.addr_data)
+			info->io.regspacing = res->start - info->io.addr_data;
+	}
 	info->io.regsize = DEFAULT_REGSPACING;
 	info->io.regshift = 0;
 


