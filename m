Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab0G3G64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 02:58:56 -0400
Received: from sh.osrg.net ([192.16.179.4]:58837 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647Ab0G3G6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 02:58:54 -0400
Date: Fri, 30 Jul 2010 15:58:04 +0900
To: rjw@sisk.pl, mchehab@redhat.com
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
        maciej.rutecki@gmail.com, zdenek.kabelac@gmail.com, greg@kroah.com
Subject: Re: [Bug #15977] WARNING: at lib/dma-debug.c:866 check_for_stack
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <PRbv8sgxY6G.A.ksG.eWYSMB@chimera>
References: <wQMMFC59mnE.A.v-E.iUYSMB@chimera>
	<PRbv8sgxY6G.A.ksG.eWYSMB@chimera>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100730155605S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 30 Jul 2010 15:58:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jul 2010 14:15:49 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.33 and 2.6.34.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15977
> Subject		: WARNING: at lib/dma-debug.c:866 check_for_stack
> Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
> Date		: 2010-05-14 8:56 (71 days old)
> Message-ID	: <AANLkTikyx2eaxaiUCFDSfpmn1UG0t2GOxArz6F4wp1LJ@mail.gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=127382742729825&w=2

looks like easy to fix this. But seems that linux-next still has the
bug. Or a fix was already posted somewhere else?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] DVB: dib0700: fix the usage of stack buffers for DMA

We can't use a stack buffer for DMA.

This should fix:

http://bugzilla.kernel.org/show_bug.cgi?id=15977

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/media/dvb/dvb-usb/dib0700_core.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index 7deade7..54a0d2c 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -301,14 +301,23 @@ struct i2c_algorithm dib0700_i2c_algo = {
 int dib0700_identify_state(struct usb_device *udev, struct dvb_usb_device_properties *props,
 			struct dvb_usb_device_description **desc, int *cold)
 {
-	u8 b[16];
-	s16 ret = usb_control_msg(udev, usb_rcvctrlpipe(udev,0),
-		REQUEST_GET_VERSION, USB_TYPE_VENDOR | USB_DIR_IN, 0, 0, b, 16, USB_CTRL_GET_TIMEOUT);
+	void *b;
+	s16 ret;
+
+	b = kmalloc(16, GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
+
+	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev,0),
+			      REQUEST_GET_VERSION, USB_TYPE_VENDOR | USB_DIR_IN,
+			      0, 0, b, 16, USB_CTRL_GET_TIMEOUT);
 
 	deb_info("FW GET_VERSION length: %d\n",ret);
 
 	*cold = ret <= 0;
 
+	kfree(b);
+
 	deb_info("cold: %d\n", *cold);
 	return 0;
 }
-- 
1.6.5

