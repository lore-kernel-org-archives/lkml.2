Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab0HRInV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 04:43:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53831 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab0HRInR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 04:43:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=t0PVGDfMfIfS0ZqY+436RIXGrgzGvUwAjsNxUUR+3mgfx4qSYN1TMKVWfE8bGJzlaL
         nJ1f/2XnfDbpP7dcTIK3cMY8XmoXl89JWn1QDKcOFsJB7BrG4IBDmAvZzkIpxe2rrfN/
         N+FXoKiliN4ycjWOINvr2gF9xdaRWQ/0ufIsA=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
In-Reply-To: <alpine.LNX.2.00.1008180911180.1019@pobox.suse.cz>
References: <AANLkTimnC384BMdwJtk1Rp33YnAXr66HJqPvBegOxGmC@mail.gmail.com>
	<201008180325.17816.rjw@sisk.pl>
	<AANLkTimdF_eYurw9k0rQRAzSQ-fZMKsFLupnME_ch1Ru@mail.gmail.com>
	<alpine.LNX.2.00.1008180911180.1019@pobox.suse.cz>
Date: Wed, 18 Aug 2010 09:43:16 +0100
Message-ID: <AANLkTiki82ZFntH2M6UTyB7+215=4mNmk3SsxiS=CGDH@mail.gmail.com>
Subject: Re: [REGRESSION, bisected] 2.6.36-rc1 - suspend issues
From: trapDoor <trapdoor6@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        arnd@arndb.de, osnix0@googlemail.com, andrea.gelmini@gelma.net,
        trapDoor <trapdoor6@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding Gabriel Craciunescu <osnix0@googlemail.com> and Andrea Gelmini
<andrea.gelmini@gelma.net> to CC lilst]

Hello,

On Wed, Aug 18, 2010 at 8:13 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 18 Aug 2010, trapDoor wrote:
>
>> >> Bisecting turned up the following commit. Reverting it in 2.6.36-rc1
>> >> results in a system that works.
>> >>
>> >> commit bd25f4dd6972755579d0ea50d1a5ace2e9b00d1a
>> >> Author: Arnd Bergmann <arnd@arndb.de>
>> >> Date:   Sun Jul 11 15:34:05 2010 +0200
>> >>
>> >>     HID: hiddev: use usb_find_interface, get rid of BKL
>> >>
>> >>     This removes the private hiddev_table in the usbhid
>> >>     driver and changes it to use usb_find_interface
>> >>     instead.
>> >>
>> >>     The advantage is that we can avoid the race between
>> >>     usb_register_dev and usb_open and no longer need the
>> >>     big kernel lock.
>> >>
>> >>     This doesn't introduce race condition -- the intf pointer could be
>> >>     invalidated only in hiddev_disconnect() through usb_deregister_dev(),
>> >>     but that will block on minor_rwsem and not actually remove the device
>> >>     until usb_open().
>> >> -----------------------
>> >>
>> >> Despite mentioned issues with network (occurring every time after
>> >> unsuccessful suspend > hard restart) the bisecting turned up a commit
>> >> which isn't rather related to network. But I can confirm that
>> >> reverting only this one commit in 2.6.36-rc1
>> >> [da5cabf80e2433131bf0ed8993abc0f7ea618c73] fixes the whole problem -
>> >> suspend works OK and I have no issues with my network after waking the
>> >> system up, neither after re-booting from the same or any other kernel.
>> >>
>> >> Please let me know what further details should I provide. Any logs,
>> >> hardware specifications? I've also made a brief log recording the
>> >> bisect if anyone would need it.
>> >
>> > Well, we should let the HID maintainer know about the problem (CC added).
>>
>> Thanks Rafael,
>> Before I opened this thread I only searched on
>> http://vger.kernel.org/vger-lists.html for any appropriate mailing
>> list but nothing linke linux-*hid* there. Now I've found out that
>> there is a list of all maintainers included in the kernel source. I'll
>> keep that in mind ..
>
> Yeah, MAINTAINERS file is always good to consult. Also CCing all people
> who have Signed-off-by or Acked-by the offending patch is usually a good
> idea.

Thanks for the tip.

> Could you please verify whether the patch below (which is currently queued
> in my tree and I am planning to push it to Linus soon, as it fixes memory
> corruption) fixes your issue? Thanks.
>
> commit 9c9e54a8df0be48aa359744f412377cc55c3b7d2
> Author: Jiri Kosina <jkosina@suse.cz>
> Date:   Fri Aug 13 12:19:45 2010 +0200
>
>    HID: hiddev: fix memory corruption due to invalid intfdata
>
>    Commit bd25f4dd6972755579d0 ("HID: hiddev: use usb_find_interface,
>    get rid of BKL") introduced using of private intfdata in hiddev for
>    purpose of storing hiddev pointer.
>
>    This is a problem, because intf pointer is already being set to struct
>    hid_device pointer by HID core. This obviously lead to memory corruptions
>    at device disconnect time, such as
>
>    WARNING: at lib/kobject.c:595 kobject_put+0x37/0x4b()
>    kobject: '(null)' (ffff88011e9cd898): is not initialized, yet kobject_put() is being called.
>
>    Convert hiddev into accessing hiddev through struct hid_device which is
>    in intfdata already.
>
>    Reported-and-tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
>    Reported-and-tested-by: Heinz Diehl <htd@fritha.org>
>    Reported-and-tested-by: Alan Ott <alan@signal11.us>
>    Signed-off-by: Jiri Kosina <jkosina@suse.cz>
>
> diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
> index f285017..0a29c51 100644
> --- a/drivers/hid/usbhid/hiddev.c
> +++ b/drivers/hid/usbhid/hiddev.c
> @@ -266,13 +266,15 @@ static int hiddev_open(struct inode *inode, struct file *file)
>  {
>        struct hiddev_list *list;
>        struct usb_interface *intf;
> +       struct hid_device *hid;
>        struct hiddev *hiddev;
>        int res;
>
>        intf = usb_find_interface(&hiddev_driver, iminor(inode));
>        if (!intf)
>                return -ENODEV;
> -       hiddev = usb_get_intfdata(intf);
> +       hid = usb_get_intfdata(intf);
> +       hiddev = hid->hiddev;
>
>        if (!(list = kzalloc(sizeof(struct hiddev_list), GFP_KERNEL)))
>                return -ENOMEM;
> @@ -890,7 +892,6 @@ int hiddev_connect(struct hid_device *hid, unsigned int force)
>        hid->hiddev = hiddev;
>        hiddev->hid = hid;
>        hiddev->exist = 1;
> -       usb_set_intfdata(usbhid->intf, usbhid);
>        retval = usb_register_dev(usbhid->intf, &hiddev_class);
>        if (retval) {
>                err_hid("Not able to get a minor for this device.");
>
> --
> Jiri Kosina
> SUSE Labs, Novell Inc.
>

Yes. That patch fixes my problem too. Tested on top of the current
tree [2.6.36-rc1-00051-g3b89f56]. Thanks!

One little thing though. There is a message about 2 lines offset when
patching. Succeeded anyway but I've never got such messages before so
I thought it would be better to mention it:

patch -p1 <../patches/hid.git-9c9e54a8df0be48aa359744f412377cc55c3b7d2.patch
patching file drivers/hid/usbhid/hiddev.c
Hunk #2 succeeded at 890 (offset -2 lines).

I downloaded the patch from
http://git.kernel.org/?p=linux/kernel/git/jikos/hid.git;a=commitdiff;h=9c9e54a8df0be48aa359744f412377cc55c3b7d2
to make sure I had the original indentations etc. preserved (Gmail
tends to mess up with lines).

-- 
Regards
Tomasz B.
