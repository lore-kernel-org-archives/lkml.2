Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab2G1NaZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 09:30:25 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44550 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab2G1NaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 09:30:23 -0400
Message-ID: <5013E96A.5050202@gmail.com>
Date: Sat, 28 Jul 2012 15:30:18 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Sarbojit Ganguly <unixman.linuxboy@gmail.com>,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: Re: Kernel Oops while disconnecting USB peripheral (always)
References: <Pine.LNX.4.44L0.1207231044380.1633-100000@iolanthe.rowland.org> <500D659E.5090207@gmail.com> <87r4rwvzop.fsf@nemi.mork.no> <5013E074.20007@gmail.com> <87mx2kvwzw.fsf@nemi.mork.no>
In-Reply-To: <87mx2kvwzw.fsf@nemi.mork.no>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.07.2012 15:25, Bjørn Mork wrote:
> Daniel Mack <zonque@gmail.com> writes:
>> On 28.07.2012 14:27, Bjørn Mork wrote:
>>
>>> The reason is this change:
>>>
>>>  0998d0631 device-core: Ensure drvdata = NULL when no driver is bound
>>>
>>>
>>> It will make bugs like this suddenly 100% reproducible.  But the bugs
>>> *are* in the drivers, and may have been there for a long time.  The
>>> drivers have been accessing drvdata after unbinding.  They just didn't
>>> crash prior to that commit.
> 
> I just realized that I might have been concluding too quickly here, as
> usual.. 
> 
> The crashes referred to in this thread were not NULL pointer
> dereferences, which makes it less likely that this change is the
> cause. Could of course still be related somehow, but not directly.
> 
> 
>>> But the commit is correct, and a very much needed improvement if my
>>> assumptions are correct.  The drivers need fixing and this just makes it
>>> evident.
>>
>> Hmm, interesting. Thanks for sharing this. I personally never saw this
>> bug kicking in, but if I understand your findings correctly, we would
>> need something like the following patch for snd-usb and the storage driver?
>>
>> Sarbojit, could you give this a test and see whether your kernel still
>> crashes in any of the two drivers?
>>
>>
>> Thanks,
>> Daniel
>>
>>
>>
>> diff --git a/sound/usb/card.c b/sound/usb/card.c
>> index d5b5c33..0e8caaa 100644
>> --- a/sound/usb/card.c
>> +++ b/sound/usb/card.c
>> @@ -555,7 +555,7 @@ static void snd_usb_audio_disconnect(struct
>> usb_device *dev,
>>         struct snd_card *card;
>>         struct list_head *p;
>>
>> -       if (chip == (void *)-1L)
>> +       if (chip == (void *)-1L || chip == NULL)
>>                 return;
> 
> I may be wrong, but I don't think you need this is disconnect.  The
> driver will not be unbound until after disconnect returns.

I thought so too, yes. Still, as I don't fully understand the call trace
that is involved across all the driver layers, I thought it might we
worth a try if that fixes it.

> But IMHO, the usage of (void *)-1L as invalid drvdata marker in that
> driver should be replaced with NULL.  suspend/resume may also be unsafe
> for example.

Could be, but Sarbojit reported crashes on disconnect, not on suspend.

> I don't really think you need those changes for the same reasons I gave
> above.
> 
> Sorry if my comment just confused the search for this bug.  bisecting it
> is probably the easiest way to locate it after all.

Yes, definitely.


Thanks, anyway,
Daniel

