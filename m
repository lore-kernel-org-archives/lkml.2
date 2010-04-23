Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab0DWFpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 01:45:55 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53080 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab0DWFpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 01:45:53 -0400
Message-ID: <4BD13409.5040003@jp.fujitsu.com>
Date: Fri, 23 Apr 2010 14:45:45 +0900
From: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-usb@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH] add usb_add_bus() function for usb bus list
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch makes usbcore driver sort usb bus on the usb_bus_list by busnum when
registering a new bus instance.

In current implementation a new bus instance is simply added in front of existing busses.
Although there is nothing wrong with it in kernel code, reloading HCD may break bus order
of /proc/bus/usb/devices as it makes usbcore re-register the bus to the list as shown in
the example below. and it doesn't look good or it may confuse some users.

# lsmod | grep hcd
uhci_hcd               19324  0 
ehci_hcd               39109  0 
# grep "Bus=" /proc/bus/usb/devices
T:  Bus=05 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
T:  Bus=04 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
T:  Bus=03 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
T:  Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=1.5 MxCh= 0
T:  Bus=02 Lev=01 Prnt=01 Port=01 Cnt=02 Dev#=  3 Spd=12  MxCh= 0
T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480 MxCh= 8
T:  Bus=01 Lev=01 Prnt=01 Port=02 Cnt=01 Dev#=  4 Spd=480 MxCh= 4
# rmmod ehci-hcd; modprobe ehci-hcd
# grep "Bus=" /proc/bus/usb/devices
T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480 MxCh= 8
T:  Bus=01 Lev=01 Prnt=01 Port=02 Cnt=01 Dev#=  4 Spd=480 MxCh= 4
T:  Bus=05 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
T:  Bus=04 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
T:  Bus=03 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
T:  Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  4 Spd=1.5 MxCh= 0
T:  Bus=02 Lev=01 Prnt=01 Port=01 Cnt=02 Dev#=  5 Spd=12  MxCh= 0

With this patch, bus instances on the usb_bus_list is kept in busnum order (from large to
small busnum). As a result /proc/bus/usb/devices prints devices in busnum order regardless
of HCD reloading. Although a few applications (eg.lsusb) use /proc/bus/usb/devices, this
patch has no effect to them.

# lsmod | grep hcd
uhci_hcd               19324  0 
ehci_hcd               39109  0 
# grep "Bus=" /proc/bus/usb/devices
T:  Bus=05 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
T:  Bus=04 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
T:  Bus=03 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
T:  Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=1.5 MxCh= 0
T:  Bus=02 Lev=01 Prnt=01 Port=01 Cnt=02 Dev#=  3 Spd=12  MxCh= 0
T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480 MxCh= 8
T:  Bus=01 Lev=01 Prnt=01 Port=02 Cnt=01 Dev#=  4 Spd=480 MxCh= 4
# rmmod ehci-hcd; modprobe ehci-hcd
# grep "Bus=" /proc/bus/usb/devices
T:  Bus=05 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
T:  Bus=04 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
T:  Bus=03 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
T:  Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  4 Spd=1.5 MxCh= 0
T:  Bus=02 Lev=01 Prnt=01 Port=01 Cnt=02 Dev#=  5 Spd=12  MxCh= 0
T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480 MxCh= 8
T:  Bus=01 Lev=01 Prnt=01 Port=02 Cnt=01 Dev#=  4 Spd=480 MxCh= 4

Thanks,
Tomohiro Kusumi




Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
---

diff -aNur linux-2.6.34-rc5.org/drivers/usb/core/hcd.c linux-2.6.34-rc5/drivers/usb/core/hcd.c
--- linux-2.6.34-rc5.org/drivers/usb/core/hcd.c	2010-04-20 08:29:56.000000000 +0900
+++ linux-2.6.34-rc5/drivers/usb/core/hcd.c	2010-04-23 14:19:50.000000000 +0900
@@ -877,6 +877,23 @@
 /*-------------------------------------------------------------------------*/
 
 /**
+ * usb_add_bus - register the bus to the usb_bus_list,
+ * caller need to hold usb_bus_list_lock
+ * @bus: pointer to the bus to register
+ */
+static void usb_add_bus(struct usb_bus *bus)
+{
+	struct usb_bus *b;
+	list_for_each_entry(b, &usb_bus_list, bus_list) {
+		if (bus->busnum > b->busnum) {
+			list_add_tail(&bus->bus_list, &b->bus_list);
+			return;
+		}
+	}
+	list_add_tail(&bus->bus_list, &usb_bus_list);
+}
+
+/**
  * usb_register_bus - registers the USB host controller with the usb core
  * @bus: pointer to the bus to register
  * Context: !in_interrupt()
@@ -899,7 +916,7 @@
 	bus->busnum = busnum;
 
 	/* Add it to the local list of buses */
-	list_add (&bus->bus_list, &usb_bus_list);
+	usb_add_bus(bus);
 	mutex_unlock(&usb_bus_list_lock);
 
 	usb_notify_add_bus(bus);

