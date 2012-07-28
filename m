Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab2G1MwM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 08:52:12 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51301 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab2G1MwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 08:52:10 -0400
Message-ID: <5013E074.20007@gmail.com>
Date: Sat, 28 Jul 2012 14:52:04 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Sarbojit Ganguly <unixman.linuxboy@gmail.com>,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: Re: Kernel Oops while disconnecting USB peripheral (always)
References: <Pine.LNX.4.44L0.1207231044380.1633-100000@iolanthe.rowland.org> <500D659E.5090207@gmail.com> <87r4rwvzop.fsf@nemi.mork.no>
In-Reply-To: <87r4rwvzop.fsf@nemi.mork.no>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.07.2012 14:27, Bjørn Mork wrote:
> Daniel Mack <zonque@gmail.com> writes:
>> On 23.07.2012 16:47, Alan Stern wrote:
>>> On Mon, 23 Jul 2012, Sarbojit Ganguly wrote:
>>>> That is why I provided two stacks,
>>>>
>>>> 1st one is when I tried to remove the USB hub (which connects a webcam
>>>> + microphone)
>>>> 2nd one is when I tried to remove an USB powered external HDD.
>>>>
>>>> Just to make sure whether the problem is with USB sound or the USB subsystem.
>>>
>>> Do you stop all the programs that are using the USB devices before 
>>> unplugging the hub?  Do you unmount the USB HDD first?
>>>
>>> The first crash shows a problem in the snd-usb-audio driver.
>>>
>>> The second crash shows a problem in the VFS layer or in ext3, not in 
>>> the USB stack.
>>
>> I dare to doubt there are two severe bugs of that kind that are 100%
>> reproducible. I haven't had a  hotplug crash in any of the two drivers
>> for a long time, and I use both of them extensively.
> 
> Actually, based on the recent usb_wwan experience, I'd say that two such
> bugs isn't as unlikely as it may seem at first.  Even three if we add
> the now fixed usb_wwan (or six, if we count the three drivers affected
> by the usb_wwan bug).  There are probably even more.
> 
> The reason is this change:
> 
>  0998d0631 device-core: Ensure drvdata = NULL when no driver is bound
> 
> 
> It will make bugs like this suddenly 100% reproducible.  But the bugs
> *are* in the drivers, and may have been there for a long time.  The
> drivers have been accessing drvdata after unbinding.  They just didn't
> crash prior to that commit.
> 
> But the commit is correct, and a very much needed improvement if my
> assumptions are correct.  The drivers need fixing and this just makes it
> evident.

Hmm, interesting. Thanks for sharing this. I personally never saw this
bug kicking in, but if I understand your findings correctly, we would
need something like the following patch for snd-usb and the storage driver?

Sarbojit, could you give this a test and see whether your kernel still
crashes in any of the two drivers?


Thanks,
Daniel



diff --git a/sound/usb/card.c b/sound/usb/card.c
index d5b5c33..0e8caaa 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -555,7 +555,7 @@ static void snd_usb_audio_disconnect(struct
usb_device *dev,
        struct snd_card *card;
        struct list_head *p;

-       if (chip == (void *)-1L)
+       if (chip == (void *)-1L || chip == NULL)
                return;

        card = chip->card;
@@ -610,6 +610,7 @@ static void usb_audio_disconnect(struct
usb_interface *intf)
 {
        snd_usb_audio_disconnect(interface_to_usbdev(intf),
                                 usb_get_intfdata(intf));
+       usb_set_intfdata(intf, NULL);
 }

 #ifdef CONFIG_PM
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index d012fe4..36862ee 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -1025,9 +1025,14 @@ void usb_stor_disconnect(struct usb_interface *intf)
 {
        struct us_data *us = usb_get_intfdata(intf);

+       if (!us)
+               return;
+
        US_DEBUGP("storage_disconnect() called\n");
        quiesce_and_remove_host(us);
        release_everything(us);
+
+       usb_set_intfdata(intf, NULL);
 }
 EXPORT_SYMBOL_GPL(usb_stor_disconnect);


