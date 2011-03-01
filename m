Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab1CAUzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:55:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40858 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757393Ab1CAUzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:55:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: 2.6.38 regression caused by commit 415e12b
Date: Tue, 1 Mar 2011 21:55:33 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.4.4; x86_64; ; )
Cc: linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ozan Caglayan <ozan@pardus.org.tr>
References: <20110228014218.GA11083@xanatos> <201102282129.56835.rjw@sisk.pl> <20110301183057.GA2359@xanatos>
In-Reply-To: <20110301183057.GA2359@xanatos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201103012155.34182.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 01, 2011, Sarah Sharp wrote:
> On Mon, Feb 28, 2011 at 09:29:56PM +0100, Rafael J. Wysocki wrote:
> > On Monday, February 28, 2011, Sarah Sharp wrote:
> > > I'm having an issue with an xHCI (USB 3.0 host controller) Express Card.
> > > This card works fine on 2.6.37, but on 2.6.38-rc5, when I plug in the
> > > card, I get this output in dmesg:
> > > 
> > > Feb 22 16:32:28 xanatos kernel: [  119.345996] irq 23: nobody cared (try booting with the "irqpoll" option)
> > > Feb 22 16:32:28 xanatos kernel: [  119.346002] Pid: 0, comm: kworker/0:0 Not tainted 2.6.38-rc5+ #745
> > > Feb 22 16:32:28 xanatos kernel: [  119.346005] Call Trace:
> > > Feb 22 16:32:28 xanatos kernel: [  119.346007]  <IRQ>  [<ffffffff8109a1f6>] ? __report_bad_irq+0x26/0xa0
> > > Feb 22 16:32:28 xanatos kernel: [  119.346019]  [<ffffffff8109a3fc>] ? note_interrupt+0x18c/0x1d0
> > > Feb 22 16:32:28 xanatos kernel: [  119.346024]  [<ffffffff8109ad7d>] ? handle_fasteoi_irq+0xcd/0x100
> > > Feb 22 16:32:28 xanatos kernel: [  119.346029]  [<ffffffff8100543d>] ? handle_irq+0x1d/0x30
> > > Feb 22 16:32:28 xanatos kernel: [  119.346032]  [<ffffffff81004bb8>] ? do_IRQ+0x58/0xd0
> > > Feb 22 16:32:28 xanatos kernel: [  119.346037]  [<ffffffff8149f5d3>] ? ret_from_intr+0x0/0xe
> > > Feb 22 16:32:28 xanatos kernel: [  119.346040]  <EOI>  [<ffffffff8126f2d0>] ? acpi_idle_enter_c1+0x7e/0x99
> > > Feb 22 16:32:28 xanatos kernel: [  119.346048]  [<ffffffff8126f2b2>] ? acpi_idle_enter_c1+0x60/0x99
> > > Feb 22 16:32:28 xanatos kernel: [  119.346054]  [<ffffffff8138ac92>] ? cpuidle_idle_call+0x82/0xf0
> > > Feb 22 16:32:28 xanatos kernel: [  119.346059]  [<ffffffff81001906>] ? cpu_idle+0x56/0xb0
> > > Feb 22 16:32:28 xanatos kernel: [  119.346064]  [<ffffffff8149861b>] ? start_secondary+0x1c1/0x1c8
> > > Feb 22 16:32:28 xanatos kernel: [  119.346068]  [<ffffffff81263386>] ? acpi_ns_parse_table+0x2e/0x34
> > > Feb 22 16:32:28 xanatos kernel: [  119.346073]  [<ffffffff81267a8c>] ? acpi_load_tables+0x9c/0x15d
> > > Feb 22 16:32:28 xanatos kernel: [  119.346076] handlers:
> > > Feb 22 16:32:28 xanatos kernel: [  119.346078] [<ffffffffa0123500>] (usb_hcd_irq+0x0/0x70 [usbcore])
> > > Feb 22 16:32:28 xanatos kernel: [  119.346100] Disabling IRQ #23
> > > 
> > > This happens before the xHCI driver has a chance to start PCI
> > > initialization.
> > > 
> > > I've been trying to bisect this on a slow laptop, so I haven't had a
> > > chance to test with the latest tree from Linus to see if this is already
> > > fixed.  I'll do that later this evening.
> > > 
> > > I've bisected the issue down to this commit:
> > > 
> > > 415e12b2379239973feab91850b0dce985c6058a is first bad commit
> > > commit 415e12b2379239973feab91850b0dce985c6058a
> > > Author: Rafael J. Wysocki <rjw@sisk.pl>
> > > Date:   Fri Jan 7 00:55:09 2011 +0100
> > > 
> > >     PCI/ACPI: Request _OSC control once for each root bridge (v3)
> > >     
> > >     Move the evaluation of acpi_pci_osc_control_set() (to request control of
> > >     PCI Express native features) into acpi_pci_root_add() to avoid calling
> > >     it many times for the same root complex with the same arguments.
> > >     Additionally, check if all of the requisite _OSC support bits are set
> > >     before calling acpi_pci_osc_control_set() for a given root complex.
> > >     
> > >     References: https://bugzilla.kernel.org/show_bug.cgi?id=20232
> > >     Reported-by: Ozan Caglayan <ozan@pardus.org.tr>
> > >     Tested-by: Ozan Caglayan <ozan@pardus.org.tr>
> > >     Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > >     Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> > > 
> > > :040000 040000 531c48ec0c23b72f0ca1b5f33828ea63808e4033 7ffa298e34dd842e1f84f0b1fea6dc5af1f70514 M	drivers
> > > :040000 040000 4e484ec0cab0ebc7c82a029c4860802617b7aaf2 01b429bcaeb7b50af04667664cf25453058e803f M	include
> > > 
> > > lspci from a kernel where the Express Card works is attached.
> > 
> > Most likely your card requires PCIe hotplug to work which doesn't with the
> > above commit applied due to some dependencies that aren't met.
> > 
> > May I see full dmesg output with and without the above commit?
> > 
> > It may be more convenient to add a Bugzilla entry for it.
> 
> The kernel.org bugzilla seems to be broken for me right now:
> 
> https://picasaweb.google.com/lh/photo/zjqHkSPY1RiCv0KjA4pYvA?feat=directlink
> 
> Attached is the dmesg on the latest tree (broken-dmesg.txt), and the
> dmesg from a kernel built starting from the commit below 415e12b23
> (good-dmesg.txt).  I tried to revert that commit, but I didn't resolve
> the conflicts correctly and the kernel didn't compile.

Please check if the appended patch (on top of the Linus' current) helps.

Thanks,
Rafael

---
 drivers/acpi/pci_root.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux-2.6/drivers/acpi/pci_root.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_root.c
+++ linux-2.6/drivers/acpi/pci_root.c
@@ -48,10 +48,7 @@ static int acpi_pci_root_add(struct acpi
 static int acpi_pci_root_remove(struct acpi_device *device, int type);
 static int acpi_pci_root_start(struct acpi_device *device);
 
-#define ACPI_PCIE_REQ_SUPPORT (OSC_EXT_PCI_CONFIG_SUPPORT \
-				| OSC_ACTIVE_STATE_PWR_SUPPORT \
-				| OSC_CLOCK_PWR_CAPABILITY_SUPPORT \
-				| OSC_MSI_SUPPORT)
+#define ACPI_PCIE_REQ_SUPPORT (OSC_EXT_PCI_CONFIG_SUPPORT | OSC_MSI_SUPPORT)
 
 static const struct acpi_device_id root_device_ids[] = {
 	{"PNP0A03", 0},
