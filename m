Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751004Ab2IFEMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 00:12:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41236 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab2IFEMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 00:12:39 -0400
MIME-Version: 1.0
In-Reply-To: <20120905173011.7a1111f0@pyramind.ukuu.org.uk>
References: <s5hd3222azc.wl%tiwai@suse.de>
	<CACVXFVP-A7M2dG9bOvAnpzR60=iTYSw=WCOEwgo9KeuioxKanQ@mail.gmail.com>
	<s5hd32122hw.wl%tiwai@suse.de>
	<CACVXFVNE1GHAQJTrQy2AYgUBfq5kv42EjJJ7J+2q3jzXG-E=MQ@mail.gmail.com>
	<s5hpq61j9qx.wl%tiwai@suse.de>
	<CACVXFVOu86J5=1DLDrpLCd-pyk1jm2HT7ks1uzCXm9nURCRo2A@mail.gmail.com>
	<20120905140304.5c5c58a4@pyramind.ukuu.org.uk>
	<CACVXFVO+OgvLoFMcDD0gcQnbzUW=SyR=wiSMyT-FtpjWW5sWdw@mail.gmail.com>
	<20120905173011.7a1111f0@pyramind.ukuu.org.uk>
Date: Thu, 6 Sep 2012 12:12:37 +0800
Message-ID: <CACVXFVMbCOov6nFqmmVu+9QYXuGc_1uwYKLcevqERZw4CRvVCA@mail.gmail.com>
Subject: Re: A workaround for request_firmware() stuck in module_init
From: Ming Lei <ming.lei@canonical.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 6, 2012 at 12:30 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Yes, deferring the load may fix the built in case, but which also
>> introduces much work on changes of current drivers. In fact,
>> there are few guys who complained the built in case.
>
> It fixes the modular case too.

Sorry, I don't see anyone explained clearly why request_firmware()
can't be called inside module_init() in module case, so maybe it is
a bit early to say it is a fix on 'bug', :-)

>
>> The current complaint is from that udev may timeout request inside probe()
>> when drivers are built as module. As pointed by Linus and Benjamin,
>> it is better to fix it in udev, and looks not good to introduce great changes
>> (such as Takashi's defer probe patch) in kernel to workaround the problem.
>
> It's not about a workaround but about doing it properly for the long term
> and doing it in one place. It's also not a "great change", its a small
> change.
>
>> Linus has said that he doesn't like to load firmware in probe(), but in some
>> situation the drivers have to load firmware in its probe():
>
> You don't want to load firmware in probe because of the locking problems
> - you can trigger a load of another device on the same bus - the defer
>   dodges that nicely

Yes, it is alike with the patches from Takashi and me.

Also it is a kind of async probe, all these drivers may convert to
async probe to fix the problem for built-in case, I guess. If it is doable,
it may be a easier approach.

>
>> In fact, it is better for drivers to load firmware just when user wants to use
>> the device, and some drivers have already changed to load firmware in
>> the open() callback.
>
> For those devices sure but they are if anything a minority as far as I
> can see.
>
>> So looks loading firmware always before probe in driver core is
>> against the above idea.
>
> I never said "always"

Sorry for misunderstanding your idea.

>
>> > firmware load off and only when the firmware had loaded would it call
>> > ->probe with dev->firmware pointing at a refcounted firmware struct.
>>
>> IMO, introduce refcount for the firmware doesn't make sense. The lifetime
>> of firmware is completely different with lifetime of driver or device:
>
> Exactly. Which is why the moment you have multiple devices you need
> refcounts. It's also why the propsoal included a
>
> dev_discard_firmware()
>
> so you an instance can drop its firmware reference if it doesn't need it
> post probe.

This kind of mechanism has been implemented already: request_firmware()
and release_firmware() will get and put a refcount.  And, the reference
count is associated with firmware name, and it should be so, IMO.

>
>>     - firmware needn't be kept in memory in the device/driver's lifetime, and
>>       should be loaded just in need, and be released after downloading
>>       it into device.
>
> You broke suspend/resume for lots of devices.

The firmware cache mechanism will keep the firmware during suspend/resume
cycle to address the problem.

>
>>    - sometimes devices may disappear, but it is better to keep the
>>      firmware in memory, for example, device may be disconnected
>>      during resume but will come back later.
>
> So the moment you have multiple instances of a device with their own
> lifetime and you have the need to pin it sometimes you need a refcount
>
>> As said above, ref/deref on probe/remove is not a good idea since
>> we needn't to keep the firmware in memory during the whole device/driver
>> lifetime.
>
> Often you do. And in the case you don't you still have to deal with
> multiple probes doing asynchronous loads of the same firmware so you want
> to do matching and refcounting. It's pretty much essential.

For drivers, I understand request_firmware()/request_firmware_nowait()
and release_firmware() are enough. If many devices share one firmware,
there is only one firmware kept in memory for their requests if one holds
the firmware, and there is a refcount for it already, :-)

So I don't see why it is difficult to use request/release_firmware() inside
drivers, :-)

> The other big value apart from making it harder for driver writers to
> screw up is that it takes some of the control and puts it in one place.
> That means you can change it later easily not in each driver.
>
> This is enabling for device drivers. With no intention of offending
> driver authors the reality is that we should have driver interfaces that
>
> - work the right way by default
> - allow driver authors to do things themselves if they need to instead
>   (ie opt out)
> - are hard to f**k up
>
> because we want it to just work.

Thanks,
--
Ming Lei
