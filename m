Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936551Ab2C3WdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:33:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935524Ab2C3VJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:09:43 -0400
Message-Id: <20120330194837.028871599@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:48:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 019/149] usb: renesas_usbhs: bugfix: add .release function to gpriv->gadget.dev
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

commit 3b2a2e47174cd978258bbb0fdf2e2b1b5ec2144c upstream.

This patch fixup below warning on device_unregister()

renesas_usbhs renesas_usbhs.1: host probed
renesas_usbhs renesas_usbhs.1: gadget probed
renesas_usbhs renesas_usbhs.1: irq request err
------------[ cut here ]------------
WARNING: at ${LINUX}/drivers/base/core.c:1)
Device 'gadget' does not have a release() function, it is broken and must be fi.
Modules linked in:
[<c000e25c>] (unwind_backtrace+0x0/0xe4) from [<c0016960>] (warn_slowpath_commo)
[<c0016960>] (warn_slowpath_common+0x4c/0x64) from [<c00169f8>] (warn_slowpath_)
[<c00169f8>] (warn_slowpath_fmt+0x2c/0x3c) from [<c0185b80>] (device_release+0x)
[<c0185b80>] (device_release+0x70/0x84) from [<c013e300>] (kobject_cleanup+0x58)
[<c013e300>] (kobject_cleanup+0x58/0x6c) from [<c01cba14>] (usbhs_mod_gadget_re)
[<c01cba14>] (usbhs_mod_gadget_remove+0x3c/0x6c) from [<c01c8384>] (usbhs_mod_p)
[<c01c8384>] (usbhs_mod_probe+0x68/0x80) from [<c01c7f84>] (usbhs_probe+0x1cc/0)
...

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/renesas_usbhs/mod_gadget.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -816,6 +816,11 @@ static int usbhsg_stop(struct usbhs_priv
 	return usbhsg_try_stop(priv, USBHSG_STATUS_STARTED);
 }
 
+static void usbhs_mod_gadget_release(struct device *pdev)
+{
+	/* do nothing */
+}
+
 int usbhs_mod_gadget_probe(struct usbhs_priv *priv)
 {
 	struct usbhsg_gpriv *gpriv;
@@ -864,6 +869,7 @@ int usbhs_mod_gadget_probe(struct usbhs_
 	 */
 	dev_set_name(&gpriv->gadget.dev, "gadget");
 	gpriv->gadget.dev.parent	= dev;
+	gpriv->gadget.dev.release	= usbhs_mod_gadget_release;
 	gpriv->gadget.name		= "renesas_usbhs_udc";
 	gpriv->gadget.ops		= &usbhsg_gadget_ops;
 	gpriv->gadget.is_dualspeed	= 1;


