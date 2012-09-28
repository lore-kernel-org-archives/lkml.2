Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030968Ab2I1TOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:14:54 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35065 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759190Ab2I1TFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:05:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Douglas Bagnall <douglas@paradise.net.nz>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [ 233/262] media: Avoid sysfs oops when an rc_devs raw device is absent
Date: Fri, 28 Sep 2012 11:52:42 -0700
Message-Id: <20120928183025.808730472@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Bagnall <douglas@paradise.net.nz>

commit 720bb6436ff30fccad05cf5bdf961ea5b1f5686d upstream.

For some reason, when the lirc daemon learns that a usb remote control
has been unplugged, it wants to read the sysfs attributes of the
disappearing device. This is useful for uncovering transient
inconsistencies, but less so for keeping the system running when such
inconsistencies exist.

Under some circumstances (like every time I unplug my dvb stick from
my laptop), lirc catches an rc_dev whose raw event handler has been
removed (presumably by ir_raw_event_unregister), and proceeds to
interrogate the raw protocols supported by the NULL pointer.

This patch avoids the NULL dereference, and ignores the issue of how
this state of affairs came about in the first place.

Version 2 incorporates changes recommended by Mauro Carvalho Chehab
(-ENODEV instead of -EINVAL, and a signed-off-by).

Signed-off-by: Douglas Bagnall <douglas@paradise.net.nz>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/rc/rc-main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -775,10 +775,11 @@ static ssize_t show_protocols(struct dev
 	if (dev->driver_type == RC_DRIVER_SCANCODE) {
 		enabled = dev->rc_map.rc_type;
 		allowed = dev->allowed_protos;
-	} else {
+	} else if (dev->raw) {
 		enabled = dev->raw->enabled_protocols;
 		allowed = ir_raw_get_allowed_protocols();
-	}
+	} else
+		return -ENODEV;
 
 	IR_dprintk(1, "allowed - 0x%llx, enabled - 0x%llx\n",
 		   (long long)allowed,


