Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934632Ab0EEM6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 08:58:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113Ab0EEM6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 08:58:47 -0400
Date: Wed, 5 May 2010 14:58:40 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Oliver Neukum <oneukum@suse.de>, linux-pm@lists.linux-foundation.org,
       USB@smtp1.linux-foundation.org, list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] s2ram slow (radeon) / failing (usb)
In-Reply-To: <20100504230415.6097a767@neptune.home>
Message-ID: <alpine.LNX.2.00.1005051457460.9849@pobox.suse.cz>
References: <20100503214642.67577f91@neptune.home> <20100503225735.6b5e2687@neptune.home> <20100503231154.486c27d6@neptune.home> <201005040842.35260.oneukum@suse.de> <alpine.LNX.2.00.1005041028300.9849@pobox.suse.cz> <20100504230415.6097a767@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 May 2010, Bruno Prémont wrote:

> > Bruno, could you, for testing purposes, check, whether the patch below 
> > changes the behavior you are seeing (and also check what the actual return 
> > value from device_add() was, see the added printk()).
> 
> Well, it's said to return 0:
> 
> [  286.872739] generic-usb 0003:058F:9462.0003: input: USB HID v1.10 Keyboard [Multimedia USB Keyboard Multimedia USB Keyboard] on usb-0000:00:13.0-2.1/input0
> [  286.890136] HID: device_add() returned 0
> 
> [  286.919698] generic-usb: probe of 0003:058F:9462.0004 failed with error -22
> [  286.929363] HID: device_add() returned 0
> 
> or with debug=1 for HID:
> [  559.982958] /usr/src/linux-2.6-git/drivers/hid/usbhid/hid-core.c: HID probe called for ifnum 1
> [  560.011698] /usr/src/linux-2.6-git/drivers/hid/hid-core.c: usage index exceeded
> [  560.011704] /usr/src/linux-2.6-git/drivers/hid/hid-core.c: hid_add_usage failed
> [  560.011710] /usr/src/linux-2.6-git/drivers/hid/hid-core.c: item 0 2 2 2 parsing failed
> [  560.011732] /usr/src/linux-2.6-git/drivers/hid/usbhid/hid-core.c: parsing report descriptor failed
> [  560.011747] generic-usb: probe of 0003:058F:9462.0006 failed with error -22
> [  560.021718] HID: device_add() returned 0

Could you please verify with this patch? Thanks.



 drivers/hid/hid-core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 2e2aa75..8df19d3 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1486,8 +1486,10 @@ static int hid_device_probe(struct device *dev)
 			if (!ret)
 				ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 		}
-		if (ret)
+		if (ret) {
 			hdev->driver = NULL;
+			ret = -ENODEV;
+		}
 	}
 	return ret;
 }

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
