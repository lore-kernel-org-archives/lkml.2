Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab2G1NZV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 09:25:21 -0400
Received: from canardo.mork.no ([148.122.252.1]:55054 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431Ab2G1NZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 09:25:19 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Daniel Mack <zonque@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Sarbojit Ganguly <unixman.linuxboy@gmail.com>,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: Re: Kernel Oops while disconnecting USB peripheral (always)
Organization: m
References: <Pine.LNX.4.44L0.1207231044380.1633-100000@iolanthe.rowland.org>
	<500D659E.5090207@gmail.com> <87r4rwvzop.fsf@nemi.mork.no>
	<5013E074.20007@gmail.com>
Date: Sat, 28 Jul 2012 15:25:07 +0200
In-Reply-To: <5013E074.20007@gmail.com> (Daniel Mack's message of "Sat, 28 Jul
	2012 14:52:04 +0200")
Message-ID: <87mx2kvwzw.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack <zonque@gmail.com> writes:
> On 28.07.2012 14:27, Bjørn Mork wrote:
>
>> The reason is this change:
>> 
>>  0998d0631 device-core: Ensure drvdata = NULL when no driver is bound
>> 
>> 
>> It will make bugs like this suddenly 100% reproducible.  But the bugs
>> *are* in the drivers, and may have been there for a long time.  The
>> drivers have been accessing drvdata after unbinding.  They just didn't
>> crash prior to that commit.

I just realized that I might have been concluding too quickly here, as
usual.. 

The crashes referred to in this thread were not NULL pointer
dereferences, which makes it less likely that this change is the
cause. Could of course still be related somehow, but not directly.


>> But the commit is correct, and a very much needed improvement if my
>> assumptions are correct.  The drivers need fixing and this just makes it
>> evident.
>
> Hmm, interesting. Thanks for sharing this. I personally never saw this
> bug kicking in, but if I understand your findings correctly, we would
> need something like the following patch for snd-usb and the storage driver?
>
> Sarbojit, could you give this a test and see whether your kernel still
> crashes in any of the two drivers?
>
>
> Thanks,
> Daniel
>
>
>
> diff --git a/sound/usb/card.c b/sound/usb/card.c
> index d5b5c33..0e8caaa 100644
> --- a/sound/usb/card.c
> +++ b/sound/usb/card.c
> @@ -555,7 +555,7 @@ static void snd_usb_audio_disconnect(struct
> usb_device *dev,
>         struct snd_card *card;
>         struct list_head *p;
>
> -       if (chip == (void *)-1L)
> +       if (chip == (void *)-1L || chip == NULL)
>                 return;

I may be wrong, but I don't think you need this is disconnect.  The
driver will not be unbound until after disconnect returns.

But IMHO, the usage of (void *)-1L as invalid drvdata marker in that
driver should be replaced with NULL.  suspend/resume may also be unsafe
for example.


>         card = chip->card;
> @@ -610,6 +610,7 @@ static void usb_audio_disconnect(struct
> usb_interface *intf)
>  {
>         snd_usb_audio_disconnect(interface_to_usbdev(intf),
>                                  usb_get_intfdata(intf));
> +       usb_set_intfdata(intf, NULL);


This can't harm, but is not necessary given that it now will be taken
care of by the driver core.


>  }
>
>  #ifdef CONFIG_PM
> diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
> index d012fe4..36862ee 100644
> --- a/drivers/usb/storage/usb.c
> +++ b/drivers/usb/storage/usb.c
> @@ -1025,9 +1025,14 @@ void usb_stor_disconnect(struct usb_interface *intf)
>  {
>         struct us_data *us = usb_get_intfdata(intf);
>
> +       if (!us)
> +               return;
> +
>         US_DEBUGP("storage_disconnect() called\n");
>         quiesce_and_remove_host(us);
>         release_everything(us);
> +
> +       usb_set_intfdata(intf, NULL);
>  }
>  EXPORT_SYMBOL_GPL(usb_stor_disconnect);


I don't really think you need those changes for the same reasons I gave
above.

Sorry if my comment just confused the search for this bug.  bisecting it
is probably the easiest way to locate it after all.



Bjørn
