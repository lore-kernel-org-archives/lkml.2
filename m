Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab0DMXqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 19:46:45 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:56050 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab0DMXqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 19:46:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tDQjm+sim2r4BT+tY0imQ5MLxp5zI/EVwL/x81XR/zAOWk6tZ8N7fWqiOUAk7g9QMa
         5EbZ47DkjkB383PgaYMC8KkPgqHeAzoKWIzL8Sv6mvFJDYV91B1RO11wPbq8h5Trc8ri
         PJT/jJogatcK6wL96goLZLwQU8nYI7vzmsydI=
MIME-Version: 1.0
In-Reply-To: <20100413182233.GR30807@buzzloop.caiaq.de>
References: <20100412162947.GQ18855@one.firstfloor.org>
	 <Pine.LNX.4.44L0.1004121252310.1702-100000@iolanthe.rowland.org>
	 <20100413182233.GR30807@buzzloop.caiaq.de>
Date: Wed, 14 Apr 2010 00:46:42 +0100
Message-ID: <k2o74fd948d1004131646k1e0e1897z7594f77a580c6b9f@mail.gmail.com>
Subject: Re: USB transfer_buffer allocations on 64bit systems
From: Pedro Ribeiro <pedrib@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Greg KH <gregkh@suse.de>, alsa-devel@alsa-project.org,
       linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 April 2010 19:22, Daniel Mack <daniel@caiaq.de> wrote:
> On Mon, Apr 12, 2010 at 12:57:16PM -0400, Alan Stern wrote:
>> On Mon, 12 Apr 2010, Andi Kleen wrote:
>> > On Mon, Apr 12, 2010 at 12:17:22PM -0400, Alan Stern wrote:
>> > > On Mon, 12 Apr 2010, Andi Kleen wrote:
>> > >
>> > > > > Well, the sound driver itself doesn't care for any of those things, just
>> > > > > like any other USB driver doesn't. The USB core itself of the host
>> > > > > controller driver should do, and as far as I can see, it does that, yes.
>> > > >
>> > > > Hmm, still things must go wrong somewhere. Perhaps need some instrumentation
>> > > > to see if all the transfer buffers really hit the PCI mapping functions.
>> > >
>> > > Such a test has already been carried out earlier in this thread:
>> > >
>> > >   http://marc.info/?l=linux-usb&m=127074587029353&w=2
>> > >   http://marc.info/?l=linux-usb&m=127076841801051&w=2
>> > >   http://marc.info/?l=linux-usb&m=127082890510415&w=2
>> >
>> > Hmm, thanks. But things must still go wrong somewhere, otherwise
>> > the GFP_DMA32 wouldn't be needed?
>>
>> Indeed, something must go wrong somewhere.  Since Daniel's patch fixed
>> the problem by changing the buffer from a streaming mapping to a
>> coherent mapping, it's logical to assume that bad DMA addresses have
>> something to do with it.  But we don't really know for certain.
>
> Some more ideas to nail this down would be to boot the machine with
> mem=4096M and mem=2048M to see whether this makes any difference. Also,
> I think it would be interesting to know whether the patch below helps.
>
> As the real reason seems entirely obfuscated, there's unfortunately need
> for some trial error approach. Pedro, as you're the only one who can
> actually reproduce the problem, do you see any chance to do that?
>
> Thanks,
> Daniel
>
>
> diff --git a/sound/usb/caiaq/audio.c b/sound/usb/caiaq/audio.c
> index 4328cad..26013be 100644
> --- a/sound/usb/caiaq/audio.c
> +++ b/sound/usb/caiaq/audio.c
> @@ -560,7 +560,7 @@ static struct urb **alloc_urbs(struct snd_usb_caiaqdev *dev, int dir, int *ret)
>                }
>
>                urbs[i]->transfer_buffer =
> -                       kmalloc(FRAMES_PER_URB * BYTES_PER_FRAME, GFP_KERNEL);
> +                       kmalloc(FRAMES_PER_URB * BYTES_PER_FRAME, GFP_KERNEL | GFP_DMA);
>                if (!urbs[i]->transfer_buffer) {
>                        log("unable to kmalloc() transfer buffer, OOM!?\n");
>                        *ret = -ENOMEM;
>
>

Good news, I can't trigger the interference with either:
- mem=2048m
- mem=4096m
- your patch

Any idea why is mem=4096m different than a regular boot since I have 4GB anyway?

Regards,
Pedro
