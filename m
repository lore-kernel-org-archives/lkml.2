Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab1I1WTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:19:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34740 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485Ab1I1WTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:19:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: PME via interrupt or SCI mechanism?
Date: Thu, 29 Sep 2011 00:21:28 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <20110912171003.GA7939@xanatos> <201109272254.47232.rjw@sisk.pl> <20110927235216.GA5765@xanatos>
In-Reply-To: <20110927235216.GA5765@xanatos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109290021.28407.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 28, 2011, Sarah Sharp wrote:
> On Tue, Sep 27, 2011 at 10:54:47PM +0200, Rafael J. Wysocki wrote:
> > On Tuesday, September 27, 2011, Sarah Sharp wrote:
> > > On Tue, Sep 27, 2011 at 12:20:26AM +0200, Rafael J. Wysocki wrote:
> > > > On Sunday, September 25, 2011, Rafael J. Wysocki wrote:
> > > > > On Thursday, September 22, 2011, Sarah Sharp wrote:
> > > > > > On Mon, Sep 19, 2011 at 11:43:33PM +0200, Rafael J. Wysocki wrote:
> > > > > Without looking at the tables at the moment (I'll do that later),
> > > > > I think that they are missing the information that GPE 0D is a wakeup
> > > > > GPE for the xHCI device.
> > > > 
> > > > The DSDT appears to contain that information, so I'm not sure what's
> > > > going on.  Perhaps you can put a debug printk into acpi_dev_run_wake()
> > > > to see if that function is called for the xHCI controllers?
> > > 
> > > I put a printk in acpi_dev_run_wake(), and that shows up in the original
> > > dmesg I sent:
> > > 
> > > Sep 22 10:47:09 talon kernel: [ 2026.211933] xhci_hcd 0000:00:14.0: acpi_pci_run_wake - enable dev wake
> > > Sep 22 10:47:09 talon kernel: [ 2026.211936] acpi device:34: acpi_dev_run_wake - enable dev wake
> > > Sep 22 10:47:09 talon kernel: [ 2026.211955] acpi device:34: acpi_dev_run_wake - return -19
> > 
> > OK, can you printk() dev->wakeup.gpe_number here?
> > 
> > [/me realizes that "error" is not really used in this function.  Bah.]
> 
> Ok, here's what dmesg says (I used %u not 0x%x for the GPE number):
> 
> Sep 27 16:30:34 talon kernel: [  882.301023] xhci_hcd 0000:00:14.0: xhci_pci_suspend
> Sep 27 16:30:34 talon kernel: [  882.301029] xhci_hcd 0000:00:14.0: xhci_suspend
> Sep 27 16:30:34 talon kernel: [  882.301039] xhci_hcd 0000:00:14.0: // Setting command ring address to 0x30c3f001
> Sep 27 16:30:34 talon kernel: [  882.301090] xhci_hcd 0000:00:14.0: hcd_pci_runtime_suspend: 0
> Sep 27 16:30:34 talon kernel: [  882.301140] acpi_bus_power_manageable - result 0, device->flags.power_manageable 0
> Sep 27 16:30:34 talon kernel: [  882.301143] xhci_hcd 0000:00:14.0: acpi_pci_power_manageable - dev is not power manageable
> Sep 27 16:30:34 talon kernel: [  882.301146] acpi_bus_power_manageable - result 0, device->flags.power_manageable 0
> Sep 27 16:30:34 talon kernel: [  882.301149] xhci_hcd 0000:00:14.0: __pci_enable_wake - enable runtimewake
> Sep 27 16:30:34 talon kernel: [  882.301156] xhci_hcd 0000:00:14.0: PME# enabled
> Sep 27 16:30:34 talon kernel: [  882.301159] xhci_hcd 0000:00:14.0: acpi_pci_run_wake - enable dev wake
> Sep 27 16:30:34 talon kernel: [  882.301162] acpi device:34: acpi_dev_run_wake - enable dev wake
> Sep 27 16:30:34 talon kernel: [  882.301175] acpi device:34: acpi_dev_run_wake - enable gpe 13
> Sep 27 16:30:34 talon kernel: [  882.301185] acpi device:34: acpi_dev_run_wake - return -19
> Sep 27 16:30:34 talon kernel: [  882.301188] xhci_hcd 0000:00:14.0: pci_raw_set_power_state from 0 to 3
> Sep 27 16:30:34 talon kernel: [  882.312288] acpi_bus_power_manageable - result 0, device->flags.power_manageable 0
> Sep 27 16:30:34 talon kernel: [  882.312293] xhci_hcd 0000:00:14.0: acpi_pci_power_manageable - dev is not power manageable
> Sep 27 16:30:34 talon kernel: [  882.312296] acpi_bus_power_manageable - result 0, device->flags.power_manageable 0
> Sep 27 16:30:34 talon kernel: [  882.312299] xhci_hcd 0000:00:14.0: pci_platform_power_transition - is NOT power managable
> 
> If I wake up the host controller by plugging in a webcam into an external hub:
> 
> Sep 27 16:31:46 talon kernel: [  953.645014] ehci_hcd 0000:00:1d.0: pci_acpi_wake_dev
> Sep 27 16:31:46 talon kernel: [  953.645023] ehci_hcd 0000:00:1a.0: pci_acpi_wake_dev
> Sep 27 16:31:46 talon kernel: [  953.645029] snd_hda_intel 0000:00:1b.0: pci_acpi_wake_dev
> Sep 27 16:31:46 talon kernel: [  953.645034] e1000e 0000:00:19.0: pci_acpi_wake_dev
> Sep 27 16:31:46 talon kernel: [  953.645089] ehci_hcd 0000:00:1d.0: pci_acpi_wake_dev
> Sep 27 16:31:46 talon kernel: [  953.645094] ehci_hcd 0000:00:1a.0: pci_acpi_wake_dev
> Sep 27 16:31:46 talon kernel: [  953.645098] snd_hda_intel 0000:00:1b.0: pci_acpi_wake_dev
> Sep 27 16:31:46 talon kernel: [  953.645103] e1000e 0000:00:19.0: pci_acpi_wake_dev
> 
> Those lines repeat constantly until I echo on to the power/control file
> for the xHCI device.
> 
> If I cat the /sys/firmware/acpi/interrupts/gpe0D file *before* I disable
> D3, I see:
> 
> root@talon:/sys/firmware/acpi/interrupts# cat gpe0D
>   211327   enabled
> root@talon:/sys/firmware/acpi/interrupts# 
> 
> I think I was catting the file after I ran `echo on > power/control`
> previously.  Sorry for the confusion.
> 
> So it looks like gpe 0xD is enabled when the host goes into D3, and
> acpi_dev_run_wake is calling acpi_enable_gpe() with GPE 13 (i.e. 0xD),
> correct?

Yes, that's correct.

Moreover, evidently, the event is signaled and it causes pci_acpi_wake_dev()
to be called for multiple devices, _except_ for the xhci_hcd.  Perhaps
the notifier is not installed for that device for some reason.

Please add an additional debug printk()s to pci_acpi_add_pm_notifier()
for both pci_dev and dev and for the result returned by add_pm_notifier().

Thanks,
Rafael
