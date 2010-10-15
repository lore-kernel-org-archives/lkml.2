Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab0JOEOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 00:14:39 -0400
Received: from szxga04-in.huawei.com ([119.145.14.67]:20606 "EHLO
	szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab0JOEOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 00:14:38 -0400
Date: Fri, 15 Oct 2010 12:14:37 +0800
From: m00150988@huawei.com
Subject: [PATCH] fix oops in usbserial_cleanup function;
To: linux-usb@vger.kernel.org, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Franko Fang <huananhu@huawei.com>, greg@kroah.com, greg@kroah.com
Message-id: <faf7c73f11ba6.11ba6faf7c73f@huawei.com>
MIME-version: 1.0
X-Mailer: iPlanet Messenger Express 5.2 HotFix 2.14 (built Aug  8 2006)
Content-type: text/plain; charset=us-ascii
Content-language: zh-CN
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-Accept-Language: zh-CN
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: marui <m00150988@huawei.com>

1. I find this bug on OpenSUSE 11.3 which kernel vesion is 2.6.34, but the latest kernel vesion 2.6.36-rc7 aslo have this bug. This patch is based on the kernel of 2.6.36-rc7.
2. Bug report:
   a. Install huawei datacard dashboard on OpenSUSE 11.3
   b. Plug in huawei datacard into OpenSUSE 11.3 which kernel verison is 2.6.36-rc7
   c. After the dashboard has detected the device, I  pull out the usb datacard
   d. close datashboard,then kernel panic will happen in usbserial_cleanup function. 
 
 
3. fix the bug:
   I find usbserial_cleanup should judge the usb device wheher has been disconnected firtly.

Signed-off-by: marui<m00150988@huawei.com>


--- linux-2.6.36-rc7_orig/drivers/usb/serial/usb-serial.c	2010-10-06 16:39:52.000000000 -0400
+++ linux-2.6.36-rc7/drivers/usb/serial/usb-serial.c	2010-10-14 20:59:47.000000000 -0400
@@ -328,6 +328,20 @@ static void serial_cleanup(struct tty_st
 	/* The console is magical.  Do not hang up the console hardware
 	 * or there will be tears.
 	 */
+        dbg("%s start\n",__func__);
+        if(NULL == port)
+        {
+            dbg("%s NULL == port\n",__func__);
+            return;
+        }
+	mutex_lock(&port->serial->disc_mutex);
+	if (port->serial->disconnected)
+        {
+                dbg("%s port->serial->disconnected\n",__func__);
+                return_serial(port->serial);
+		return;
+        }
+	mutex_unlock(&port->serial->disc_mutex);
 	if (port->port.console)
 		return;
 

 
