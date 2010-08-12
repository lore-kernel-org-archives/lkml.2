Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760037Ab0HLM6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 08:58:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45753 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab0HLM6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 08:58:01 -0400
Date: Thu, 12 Aug 2010 14:57:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Heinz Diehl <htd@fritha.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Alan Ott <alan@signal11.us>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [BUG] object: is not initialized, yet kobject_put() is being
 called
In-Reply-To: <alpine.LNX.2.00.1008121401580.2702@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1008121457060.2702@pobox.suse.cz>
References: <20100810210941.GA7938@fritha.org> <20100810223215.GA1609@arch.tripp.de> <alpine.LNX.2.00.1008121108540.2702@pobox.suse.cz> <20100812091659.GA1591@arch.tripp.de> <alpine.LNX.2.00.1008121148100.2702@pobox.suse.cz> <20100812113624.GB1591@arch.tripp.de>
 <20100812114513.GA1584@arch.tripp.de> <20100812115657.GA1611@arch.tripp.de> <alpine.LNX.2.00.1008121401580.2702@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Aug 2010, Jiri Kosina wrote:

> > > > > > > Guys, could you please send me your .config with which you are 
> > > > > > > experiencing the problem, so that I can try to reproduce it with it?
> > > > > > 
> > > > > > Attached.
> > > > > 
> > > > > So I had to add support for HW of mine (SATA_VIA, PATA_VIA, disabled the 
> > > > > radeon firmware stuff, and, most importantly, enabled UHCI, which is what 
> > > > > is on machine I am using now for testing), and disconnect-connect cycle 
> > > > > works nicely:
> > > > > 
> > > > > usb 3-2: USB disconnect, address 3
> > > > > usb 3-2: new low speed USB device using uhci_hcd and address 4
> > > > > input: mouse USB mouse with wheel as /devices/pci0000:00/0000:00:10.1/usb3/3-2/3-2:1.0/input/input6
> > > > > generic-usb 0003:05B8:3091.0004: input,hidraw0: USB HID v1.10 Mouse [mouse USB mouse with wheel] on usb-0000:00:10.1-2/input0
> > > > > input: mouse USB mouse with wheel as /devices/pci0000:00/0000:00:10.1/usb3/3-2/3-2:1.1/input/input7
> > > > > generic-usb 0003:05B8:3091.0005: input,hidraw1: USB HID v1.10 Keyboard [mouse USB mouse with wheel] on usb-0000:00:10.1-2/input1
> > > > > 
> > > > > so still no BUG from kobject refcounting, and the hidraw numbers are the 
> > > > > same. The major difference seems to be that I am using UHCI and you have 
> > > > > your HID devices connected through OHCI, is that correct?
> > > > 
> > > > Correct. And I should add that it very easy to reproduce here; just
> > > > disconnecting the usb receiver triggers the WARNING.
> > > 
> > > Disabling USB_HIDDEV in my .config solves the problem (there is no
> > > WARNING anymore when disconnecting the receiver).
> > 
> > Reverting bd25f4dd6972755579d0ea50d1a5ace2e9b00d1a with USB_HIDDEV
> > enabled also solves the problem. So there must be a bug in that patch:
> > 
> > commit bd25f4dd6972755579d0ea50d1a5ace2e9b00d1a
> > Author: Arnd Bergmann <arnd@arndb.de>
> > Date:   Sun Jul 11 15:34:05 2010 +0200
> > 
> >     HID: hiddev: use usb_find_interface, get rid of BKL
> >     
> >     This removes the private hiddev_table in the usbhid
> >     driver and changes it to use usb_find_interface
> >     instead.
> >     
> >     The advantage is that we can avoid the race between
> >     usb_register_dev and usb_open and no longer need the
> >     big kernel lock.
> >     
> >     This doesn't introduce race condition -- the intf pointer could be
> >     invalidated only in hiddev_disconnect() through usb_deregister_dev(),
> >     but that will block on minor_rwsem and not actually remove the device
> >     until usb_open().
> >     
> >     Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >     Cc: Jiri Kosina <jkosina@suse.cz>
> >     Cc: "Greg Kroah-Hartman" <gregkh@suse.de>
> >     Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> Thanks, I had my suspicion about this commit (that's why I asked to you 
> verify with CONFIG_USB_HIDDEV turned off as well).
> 
> Adding Arnd to CC and will look into it myself as well soon.
> 
> Arnd, the complete thread can be found at 
> http://lkml.org/lkml/2010/8/10/280

Could please those of you, who are able to reproduce the problem, verify 
whether the patch below (completely untested) makes everything behave 
again? Thanks.



 drivers/hid/usbhid/hiddev.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index 254a003..0dcb79a 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -266,13 +266,15 @@ static int hiddev_open(struct inode *inode, struct file *file)
 {
 	struct hiddev_list *list;
 	struct usb_interface *intf;
+	struct hid_device *hid;
 	struct hiddev *hiddev;
 	int res;
 
 	intf = usb_find_interface(&hiddev_driver, iminor(inode));
 	if (!intf)
 		return -ENODEV;
-	hiddev = usb_get_intfdata(intf);
+	hid = usb_get_intfdata(intf);
+	hiddev = hid->hiddev;
 
 	if (!(list = kzalloc(sizeof(struct hiddev_list), GFP_KERNEL)))
 		return -ENOMEM;
@@ -888,7 +890,6 @@ int hiddev_connect(struct hid_device *hid, unsigned int force)
 	hid->hiddev = hiddev;
 	hiddev->hid = hid;
 	hiddev->exist = 1;
-	usb_set_intfdata(usbhid->intf, usbhid);
 	retval = usb_register_dev(usbhid->intf, &hiddev_class);
 	if (retval) {
 		err_hid("Not able to get a minor for this device.");


-- 
Jiri Kosina
SUSE Labs, Novell Inc.
