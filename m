Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab1L1Pvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 10:51:53 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:39249 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab1L1Pvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 10:51:50 -0500
Date: Wed, 28 Dec 2011 13:52:25 -0200
From: Gustavo Padovan <padovan@profusion.mobi>
To: Rene Herman <rene.herman@gmail.com>
Cc: Andre Guedes <andre.guedes@openbossa.org>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [bluetooth] linux-3.x regression (bisected)
Message-ID: <20111228155225.GA23292@joana>
Mail-Followup-To: Rene Herman <rene.herman@gmail.com>,
	Andre Guedes <andre.guedes@openbossa.org>,
	linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
References: <4EF3BACA.1080405@gmail.com>
 <CACJA=fVezGGcgAtbzG=+ouWq0PiHbgXN1YPwL+VDUphWS7wnrw@mail.gmail.com>
 <4EFA1EB8.9090005@gmail.com>
 <20111227203008.GA13870@joana>
 <4EFA447C.3030906@gmail.com>
 <20111228012248.GC13870@joana>
 <20111228012850.GD13870@joana>
 <4EFA7696.6060506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EFA7696.6060506@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rene,

* Rene Herman <rene.herman@gmail.com> [2011-12-28 02:53:26 +0100]:

> On 28-12-11 02:28, Gustavo Padovan wrote:
> 
> >>For some reason your adapter is returning here the same value of
> >>Read Local Features. I would say your device is broken.  The only
> >>fix I have in mind now is throw away the device.
> >
> >Yes, I have one of these ISSC devices, it's completely broken
> >device.
> 
> It worked well upto and including 2.6.29 though.

We never used Extended Features before 2.6.39

> 
> This would seem to be the kind of thing other subsystems use quirk
> handling for. The device identifies itself as "1131:1004":
> 
> Bus 002 Device 002: ID 1131:1004 Integrated System Solution Corp.
> Bluetooth Device
> 
> Do you guys have infra-structure in place for adapter-specific
> (quitk) handling?

I think this patch can do handling, let's see what others think.

	Gustavo


---
Author: Gustavo F. Padovan <padovan@profusion.mobi>
Date:   Wed Dec 28 13:40:02 2011 -0200

    Bluetooth: Fix lmp_host_le_capable() check for broken devices
    
    Some dongles reports a wrong Local Extended Features leading the kernel
    think that dongle support LE while it don't.
    
    The fix here is just rely on a bit in Local Features (LE Capable) to tell
    us if the device really supports LE.
    
    LE Host Capable is the only bit used from Local Extended Features in our
    kernel.
    
    Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 5e2e984..c693111 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -676,7 +676,11 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
 #define lmp_le_capable(dev)        ((dev)->features[4] & LMP_LE)
 
 /* ----- Extended LMP capabilities ----- */
-#define lmp_host_le_capable(dev)   ((dev)->extfeatures[0] & LMP_HOST_LE)
+/* Some crap dongles does not report a proper Local Extended Features causing
+ * the kernel to wrongly init it as a LE device. So first check if it is LE
+ * capable (controller) which is a info from the Local Features */
+#define lmp_host_le_capable(dev)    ( lmp_le_capable(dev) && \
+                                       (dev)->extfeatures[0] & LMP_HOST_LE)
 
 /* ----- HCI protocols ----- */
 static inline int hci_proto_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr,
