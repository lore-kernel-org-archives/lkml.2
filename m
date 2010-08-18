Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343Ab0HRHNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 03:13:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:42230 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab0HRHNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 03:13:42 -0400
Date: Wed, 18 Aug 2010 09:13:40 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: trapDoor <trapdoor6@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        arnd@arndb.de, trapDoor <trapdoor6@googlemail.com>
Subject: Re: [REGRESSION, bisected] 2.6.36-rc1 - suspend issues
In-Reply-To: <AANLkTimdF_eYurw9k0rQRAzSQ-fZMKsFLupnME_ch1Ru@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1008180911180.1019@pobox.suse.cz>
References: <AANLkTimnC384BMdwJtk1Rp33YnAXr66HJqPvBegOxGmC@mail.gmail.com> <201008180325.17816.rjw@sisk.pl> <AANLkTimdF_eYurw9k0rQRAzSQ-fZMKsFLupnME_ch1Ru@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Aug 2010, trapDoor wrote:

> >> Bisecting turned up the following commit. Reverting it in 2.6.36-rc1
> >> results in a system that works.
> >>
> >> commit bd25f4dd6972755579d0ea50d1a5ace2e9b00d1a
> >> Author: Arnd Bergmann <arnd@arndb.de>
> >> Date:   Sun Jul 11 15:34:05 2010 +0200
> >>
> >>     HID: hiddev: use usb_find_interface, get rid of BKL
> >>
> >>     This removes the private hiddev_table in the usbhid
> >>     driver and changes it to use usb_find_interface
> >>     instead.
> >>
> >>     The advantage is that we can avoid the race between
> >>     usb_register_dev and usb_open and no longer need the
> >>     big kernel lock.
> >>
> >>     This doesn't introduce race condition -- the intf pointer could be
> >>     invalidated only in hiddev_disconnect() through usb_deregister_dev(),
> >>     but that will block on minor_rwsem and not actually remove the device
> >>     until usb_open().
> >> -----------------------
> >>
> >> Despite mentioned issues with network (occurring every time after
> >> unsuccessful suspend > hard restart) the bisecting turned up a commit
> >> which isn't rather related to network. But I can confirm that
> >> reverting only this one commit in 2.6.36-rc1
> >> [da5cabf80e2433131bf0ed8993abc0f7ea618c73] fixes the whole problem -
> >> suspend works OK and I have no issues with my network after waking the
> >> system up, neither after re-booting from the same or any other kernel.
> >>
> >> Please let me know what further details should I provide. Any logs,
> >> hardware specifications? I've also made a brief log recording the
> >> bisect if anyone would need it.
> >
> > Well, we should let the HID maintainer know about the problem (CC added).
> 
> Thanks Rafael,
> Before I opened this thread I only searched on
> http://vger.kernel.org/vger-lists.html for any appropriate mailing
> list but nothing linke linux-*hid* there. Now I've found out that
> there is a list of all maintainers included in the kernel source. I'll
> keep that in mind ..

Yeah, MAINTAINERS file is always good to consult. Also CCing all people 
who have Signed-off-by or Acked-by the offending patch is usually a good 
idea.

Could you please verify whether the patch below (which is currently queued 
in my tree and I am planning to push it to Linus soon, as it fixes memory 
corruption) fixes your issue? Thanks.

commit 9c9e54a8df0be48aa359744f412377cc55c3b7d2
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Fri Aug 13 12:19:45 2010 +0200

    HID: hiddev: fix memory corruption due to invalid intfdata
    
    Commit bd25f4dd6972755579d0 ("HID: hiddev: use usb_find_interface,
    get rid of BKL") introduced using of private intfdata in hiddev for
    purpose of storing hiddev pointer.
    
    This is a problem, because intf pointer is already being set to struct
    hid_device pointer by HID core. This obviously lead to memory corruptions
    at device disconnect time, such as
    
    WARNING: at lib/kobject.c:595 kobject_put+0x37/0x4b()
    kobject: '(null)' (ffff88011e9cd898): is not initialized, yet kobject_put() is being called.
    
    Convert hiddev into accessing hiddev through struct hid_device which is
    in intfdata already.
    
    Reported-and-tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
    Reported-and-tested-by: Heinz Diehl <htd@fritha.org>
    Reported-and-tested-by: Alan Ott <alan@signal11.us>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index f285017..0a29c51 100644
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
@@ -890,7 +892,6 @@ int hiddev_connect(struct hid_device *hid, unsigned int force)
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
