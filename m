Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394Ab2IQUFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:05:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42119 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab2IQUFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 16:05:10 -0400
Message-ID: <50578272.1020902@kdau.com>
Date: Mon, 17 Sep 2012 13:05:06 -0700
From: Kevin Daughtridge <kevin@kdau.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usbhid: call report_fixup before comparing descriptors
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hid_post_reset checks the stored report descriptor against what is currently
returned by the device. An HID driver's report_fixup method may have 
changed the
stored descriptor, however, creating false positives. These leave some 
devices
nonfunctional after a resume, with a "reset_resume error 1" reported. 
This patch
passes the new descriptor to the driver's report_fixup method, if any, 
before it
is compared to the stored one.

BugLink: http://bugs.launchpad.net/bugs/1049623
Signed-off-by: Kevin Daughtridge <kevin@kdau.com>
---
--- a/drivers/hid/usbhid/hid-core.c    2012-08-20 10:17:09.000000000 -0700
+++ b/drivers/hid/usbhid/hid-core.c    2012-09-16 18:51:45.381868737 -0700
@@ -1436,6 +1436,10 @@ static int hid_post_reset(struct usb_int
          kfree(rdesc);
          return 1;
      }
+
+    if (hid->driver && hid->driver->report_fixup)
+        rdesc = hid->driver->report_fixup(hid, rdesc, &status);
+
      status = memcmp(rdesc, hid->rdesc, hid->rsize);
      kfree(rdesc);
      if (status != 0) {
