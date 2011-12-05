Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab1LEUbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 15:31:50 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47755 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932262Ab1LEUbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 15:31:49 -0500
X-Sasl-enc: n8lsDXgCMi8srgr3lBWxDFm28StB6dZdwN4lxMYn2Ebu 1323117108
Date: Mon, 5 Dec 2011 12:30:57 -0800
From: Greg KH <greg@kroah.com>
To: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [usb] kernel BUG at arch/x86/mm/physaddr.c:15
Message-ID: <20111205203057.GA24674@kroah.com>
References: <4ED8B66F.9020705@cwi.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED8B66F.9020705@cwi.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 11:28:47AM +0000, Wouter M. Koolen wrote:
> Hi Greg,
> 
> (get_maintainer.pl points to you, but that may be too general.
> Please forward as necessary)

No, this works :)

> I am hitting this one every once in a while during boot:
> 
> kernel BUG at arch/x86/mm/physaddr.c:15!
> invalid opcode: 0000 [#1] SMP
> CPU 0
> Modules linked in: isight_firmware(+) usbhid hid
> snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwde
> p arc4 snd_pcm_oss snd_mixer_oss sr_mod b43 snd_pcm cdrom mac80211
> cfg80211 rfkill rng_core snd_seq uhci_hcd ehci_hcd ssb firewire_ohci
> snd_
> timer snd_seq_device firewire_core mmc_core snd soundcore applesmc
> input_polldev crc_itu_t usbcore sky2 snd_page_alloc i2c_i801 pcspkr
> ac pr
> ocessor evdev battery power_supply apple_bl ext4 mbcache jbd2 crc16
> sd_mod crc_t10dif ata_piix libata scsi_mod
> 
> Pid: 454, comm: modprobe Not tainted 3.1.4.debug+ #38 Apple Inc.
> MacBook4,1/Mac-F22788A9
> RIP: 0010:[<ffffffff81027112>]  [<ffffffff81027112>] __phys_addr+0x62/0x70
> RSP: 0018:ffff88006f425ab8  EFLAGS: 00010212
> RAX: 000000002022b02e RBX: ffff88006f510740 RCX: 0000000000000001
> RDX: 0000000000000000 RSI: 000000006f4e6c77 RDI: ffffffffa022b02e
> RBP: ffff88006f425ab8 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff880070ec14b8
> R13: ffff88007addd090 R14: 0000000000000001 R15: ffffffffa022b02e
> FS:  00007f6463aca700(0000) GS:ffff88007da00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007f9e0066a520 CR3: 000000006f422000 CR4: 00000000000006f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process modprobe (pid: 454, threadinfo ffff88006f424000, task
> ffff880070f5a100)
> Stack:
> ffff88006f425b18 ffffffffa017c7f5 ffff88006f425af8 0000000000000001
> ffffffffa0194e48 ffffffff81008470 ffffffff8108cabe ffff88006f510740
> 000000000000012c ffff880070ec14b8 0000000000000010 0000000000000001
> Call Trace:
> [<ffffffffa017c7f5>] usb_hcd_map_urb_for_dma+0x3d5/0x480 [usbcore]
> [<ffffffff81008470>] ? nommu_map_sg+0xf0/0xf0
> [<ffffffff8108cabe>] ? is_module_address+0x1e/0x30
> [<ffffffffa017c9cd>] usb_hcd_submit_urb+0x12d/0x680 [usbcore]
> [<ffffffffa017d99c>] usb_submit_urb+0xec/0x300 [usbcore]
> [<ffffffffa017ee06>] usb_start_wait_urb+0x76/0x110 [usbcore]
> [<ffffffffa017f105>] usb_control_msg+0xd5/0x110 [usbcore]
> [<ffffffffa022a0c5>] isight_firmware_load+0xb5/0x2d8 [isight_firmware]

Ick, ok, can you try the patch here and let me know if that solves it or
not?

thanks,

greg k-h

diff --git a/drivers/usb/misc/isight_firmware.c b/drivers/usb/misc/isight_firmware.c
index fe1d443..8f725f6 100644
--- a/drivers/usb/misc/isight_firmware.c
+++ b/drivers/usb/misc/isight_firmware.c
@@ -55,8 +55,9 @@ static int isight_firmware_load(struct usb_interface *intf,
 
 	ptr = firmware->data;
 
+	buf[0] = 0x01;
 	if (usb_control_msg
-	    (dev, usb_sndctrlpipe(dev, 0), 0xa0, 0x40, 0xe600, 0, "\1", 1,
+	    (dev, usb_sndctrlpipe(dev, 0), 0xa0, 0x40, 0xe600, 0, buf, 1,
 	     300) != 1) {
 		printk(KERN_ERR
 		       "Failed to initialise isight firmware loader\n");
@@ -100,8 +101,9 @@ static int isight_firmware_load(struct usb_interface *intf,
 		}
 	}
 
+	buf[0] = 0x00;
 	if (usb_control_msg
-	    (dev, usb_sndctrlpipe(dev, 0), 0xa0, 0x40, 0xe600, 0, "\0", 1,
+	    (dev, usb_sndctrlpipe(dev, 0), 0xa0, 0x40, 0xe600, 0, buf, 1,
 	     300) != 1) {
 		printk(KERN_ERR "isight firmware loading completion failed\n");
 		ret = -ENODEV;
