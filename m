Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab0HRIqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 04:46:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36985 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158Ab0HRIqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 04:46:36 -0400
Date: Wed, 18 Aug 2010 10:46:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: trapDoor <trapdoor6@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        arnd@arndb.de, osnix0@googlemail.com, andrea.gelmini@gelma.net,
        trapDoor <trapdoor6@googlemail.com>
Subject: Re: [REGRESSION, bisected] 2.6.36-rc1 - suspend issues
In-Reply-To: <AANLkTiki82ZFntH2M6UTyB7+215=4mNmk3SsxiS=CGDH@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1008181045110.1019@pobox.suse.cz>
References: <AANLkTimnC384BMdwJtk1Rp33YnAXr66HJqPvBegOxGmC@mail.gmail.com> <201008180325.17816.rjw@sisk.pl> <AANLkTimdF_eYurw9k0rQRAzSQ-fZMKsFLupnME_ch1Ru@mail.gmail.com> <alpine.LNX.2.00.1008180911180.1019@pobox.suse.cz>
 <AANLkTiki82ZFntH2M6UTyB7+215=4mNmk3SsxiS=CGDH@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Aug 2010, trapDoor wrote:

> > Could you please verify whether the patch below (which is currently queued
> > in my tree and I am planning to push it to Linus soon, as it fixes memory
> > corruption) fixes your issue? Thanks.
> >
> > commit 9c9e54a8df0be48aa359744f412377cc55c3b7d2
> > Author: Jiri Kosina <jkosina@suse.cz>
> > Date:   Fri Aug 13 12:19:45 2010 +0200
> >
> >    HID: hiddev: fix memory corruption due to invalid intfdata
> >
> >    Commit bd25f4dd6972755579d0 ("HID: hiddev: use usb_find_interface,
> >    get rid of BKL") introduced using of private intfdata in hiddev for
> >    purpose of storing hiddev pointer.
> >
> >    This is a problem, because intf pointer is already being set to struct
> >    hid_device pointer by HID core. This obviously lead to memory corruptions
> >    at device disconnect time, such as
> >
> >    WARNING: at lib/kobject.c:595 kobject_put+0x37/0x4b()
> >    kobject: '(null)' (ffff88011e9cd898): is not initialized, yet kobject_put() is being called.
> >
> >    Convert hiddev into accessing hiddev through struct hid_device which is
> >    in intfdata already.
> >
> >    Reported-and-tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> >    Reported-and-tested-by: Heinz Diehl <htd@fritha.org>
> >    Reported-and-tested-by: Alan Ott <alan@signal11.us>
> >    Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> >
> > diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
> > index f285017..0a29c51 100644
> > --- a/drivers/hid/usbhid/hiddev.c
> > +++ b/drivers/hid/usbhid/hiddev.c
> > @@ -266,13 +266,15 @@ static int hiddev_open(struct inode *inode, struct file *file)
> >  {
> >        struct hiddev_list *list;
> >        struct usb_interface *intf;
> > +       struct hid_device *hid;
> >        struct hiddev *hiddev;
> >        int res;
> >
> >        intf = usb_find_interface(&hiddev_driver, iminor(inode));
> >        if (!intf)
> >                return -ENODEV;
> > -       hiddev = usb_get_intfdata(intf);
> > +       hid = usb_get_intfdata(intf);
> > +       hiddev = hid->hiddev;
> >
> >        if (!(list = kzalloc(sizeof(struct hiddev_list), GFP_KERNEL)))
> >                return -ENOMEM;
> > @@ -890,7 +892,6 @@ int hiddev_connect(struct hid_device *hid, unsigned int force)
> >        hid->hiddev = hiddev;
> >        hiddev->hid = hid;
> >        hiddev->exist = 1;
> > -       usb_set_intfdata(usbhid->intf, usbhid);
> >        retval = usb_register_dev(usbhid->intf, &hiddev_class);
> >        if (retval) {
> >                err_hid("Not able to get a minor for this device.");
> >
> 
> Yes. That patch fixes my problem too. Tested on top of the current
> tree [2.6.36-rc1-00051-g3b89f56]. Thanks!

Thanks a lot for prompt testing.

> One little thing though. There is a message about 2 lines offset when
> patching. Succeeded anyway but I've never got such messages before so
> I thought it would be better to mention it:
> 
> patch -p1 <../patches/hid.git-9c9e54a8df0be48aa359744f412377cc55c3b7d2.patch
> patching file drivers/hid/usbhid/hiddev.c
> Hunk #2 succeeded at 890 (offset -2 lines).
> 
> I downloaded the patch from
> http://git.kernel.org/?p=linux/kernel/git/jikos/hid.git;a=commitdiff;h=9c9e54a8df0be48aa359744f412377cc55c3b7d2
> to make sure I had the original indentations etc. preserved (Gmail
> tends to mess up with lines).

Yeah, that's fine. It just means that the patch has been generated on a 
slightly different version of the file, which makes the line numbers be 
off a bit, but patch, git and friends can cope with this easily.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
