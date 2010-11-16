Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068Ab0KPBYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 20:24:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:57843 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754711Ab0KPBYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 20:24:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,203,1288594800"; 
   d="scan'208";a="677838727"
Subject: Re: [REGRESSION] [2.6.37-rc1] Fan noise after suspend to ram/disk
From: Zhang Rui <rui.zhang@intel.com>
To: "maciej.rutecki@gmail.com" <maciej.rutecki@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <201011152139.46261.maciej.rutecki@gmail.com>
References: <201011041706.59046.maciej.rutecki@gmail.com>
	 <201011081835.05733.maciej.rutecki@gmail.com>
	 <1289790995.8148.1819.camel@rui>
	 <201011152139.46261.maciej.rutecki@gmail.com>
Content-Type: multipart/mixed; boundary="=-wqMHYkESA4X14MuEyQzB"
Date: Tue, 16 Nov 2010 09:26:15 +0800
Message-ID: <1289870775.8148.2020.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wqMHYkESA4X14MuEyQzB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

On Tue, 2010-11-16 at 04:39 +0800, Maciej Rutecki wrote:
> On poniedziałek, 15 listopada 2010 o 04:16:35 Zhang Rui wrote:
> > On Tue, 2010-11-09 at 01:35 +0800, Maciej Rutecki wrote:
> > > On poniedziałek, 8 listopada 2010 o 07:58:52 Zhang Rui wrote:
> > > > IMO, the only one that may cause this regression is commit
> > > > c57b62f5b1e6dd69ff8c96f6db7f86ea31c0e21f
> > > > some app may enable polling via procfs and update the thermal zone
> > > > status.
> > > 
> > > I revert this commit from 2.6.37-rc1. Still the same:
> > could you please apply the patch attached, on top of 2.6.37-rc1, and
> > then attach the dmesg output if the fan is noise after suspend/resume.
> > 
> 
> Dmesg in attachement.
> 
> Starting suspend to ram from:
> [  104.602674] PM: Syncing filesystems ... done.
> resume OK, but next:
> [  144.298104] PM: Syncing filesystems ... done.
> after resume fan starts on full speed.
> 
it seems that it's not the thermal driver that changes the Fan speed.
Please apply the debug patch attached, rebuild with CONFIG_ACPI_DEBUG
set and reboot with "acpi.debug_level=0x004
acpi.debug_layer=0x04A10000", and then attach the dmesg output after the
same test.
Please attach the acpidump output of this laptop as well.

thanks,
rui

> Regards


--=-wqMHYkESA4X14MuEyQzB
Content-Disposition: attachment; filename="patch-thermal-debug-2"
Content-Type: text/x-vhdl; name="patch-thermal-debug-2"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

---
 drivers/acpi/bus.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/drivers/acpi/bus.c
===================================================================
--- linux-2.6.orig/drivers/acpi/bus.c
+++ linux-2.6/drivers/acpi/bus.c
@@ -256,6 +256,11 @@ int acpi_bus_set_power(acpi_handle handl
 	if (result)
 		return result;
 
+	if (!strcmp(acpi_device_hid(device), "PNP0C0B")) {
+		printk("Rui: Change %s state from %d to %d\n", device->pnp.bus_id, device->power.state, state);
+		dump_stack();
+	}
+
 	if ((state < ACPI_STATE_D0) || (state > ACPI_STATE_D3))
 		return -EINVAL;
 

--=-wqMHYkESA4X14MuEyQzB--

