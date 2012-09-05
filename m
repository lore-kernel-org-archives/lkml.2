Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab2IELcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 07:32:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37152 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab2IELcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 07:32:33 -0400
MIME-Version: 1.0
In-Reply-To: <s5hpq61j9qx.wl%tiwai@suse.de>
References: <s5hd3222azc.wl%tiwai@suse.de>
	<CACVXFVP-A7M2dG9bOvAnpzR60=iTYSw=WCOEwgo9KeuioxKanQ@mail.gmail.com>
	<s5hd32122hw.wl%tiwai@suse.de>
	<CACVXFVNE1GHAQJTrQy2AYgUBfq5kv42EjJJ7J+2q3jzXG-E=MQ@mail.gmail.com>
	<s5hpq61j9qx.wl%tiwai@suse.de>
Date: Wed, 5 Sep 2012 19:32:31 +0800
Message-ID: <CACVXFVOu86J5=1DLDrpLCd-pyk1jm2HT7ks1uzCXm9nURCRo2A@mail.gmail.com>
Subject: Re: A workaround for request_firmware() stuck in module_init
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 1:53 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 5 Sep 2012 09:15:34 +0800,
> Ming Lei wrote:
>>
>> On Wed, Sep 5, 2012 at 12:10 AM, Takashi Iwai <tiwai@suse.de> wrote:
>> > At Tue, 4 Sep 2012 23:52:15 +0800,
>> > Ming Lei wrote:
>> >>
>> >> On Tue, Sep 4, 2012 at 9:06 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> >> > Hi,
>> >> >
>> >> > as I've got recently a few bug reports regarding the stuck with
>> >> > request_firmware() in module_init of some sound drivers, I started
>> >> > looking at the issue.  Strangely, the problem doesn't happen on
>> >> > openSUSE 12.2 although it has the same udev version with libkmod as
>> >> > Fedora.  So I installed Fedora 17, and indeed I could see a problem
>> >> > there.
>> >>
>> >> It should be a bug in udev, as discussed in the below link:
>> >>
>> >>           http://marc.info/?t=134552745100002&r=1&w=2
>> >
>> > Yeah, if udev has a fix, I'm fine.  I'll proactively ignore these bug
>> > reports.  But did it really happen...?
>>
>> Linus has expressed that it should be fixed by udev, maybe we can
>> wait some time to see if it will happen, :-)
>
> Kay, what is the status?
>
>> There are more than 300 request_firmware called in probe(), even
>> adding 2 line code in these drivers will involve much workload, since
>> you need to find the matched probe()  for one request_firmware and
>> sometimes it is not easy.
>
> Well, this depends on from which perspective you look at the issue.
> See below.
>
>> >> > Obviously a solution would be to rewrite the driver code to use
>> >> > request_firmware_nowait() instead.  But it'd need a lot of code
>> >> > shuffling, and most of such drivers are old stuff I don't want to do a
>> >> > serious surgery.
>> >> >
>> >> > So I tried an easier workaround by using the deferred probing.
>> >> > An experimental patch is below.  As you can see, from the driver side,
>> >> > it's simple: just add two lines at the head of each probe function.
>> >>
>> >> In fact, the defer probe should only be applied in situations which
>> >> driver is built in kernel and request_firmware is called in .probe().
>> >
>> > Is it?  I thought the deferred probe is basically not for this problem
>> > but rather for the dependency problem with other modules.  That's the
>> > reason it's triggered only upon the successful binding.
>>
>> Sorry, could you explain the dependency in a bit detail?
>
> When a device has some implicit dependency on another hardware
> component (e.g. SDHCI depends on I2C GPIO controller, as in comment in
> drivers/base/dd.c), the driver needs to wait until another one gets
> ready.  -EPROBE_DEFER was introduced for such a purpose.
>
> So, using this mechanism for the firmware issue is a kind of abuse.
>
>> >From your patch, I understand you just convert the caller of
>> request_firmware from module_init into deferred_probe_work_func(),
>> so the udev problem is avoided, isn't it?
>
> Yes, that was a hack.  The idea is just offloading the probe, and the
> deferred probe is an existing simple way for that.
>
>> Looks making all .probe() run non-module_init context is still a solution, :-)
>
> Sounds interesting.
>
>> > And IMO, the deferred probe for the built-in kernel is also silly.
>> > Did anyone really make it working for built-in kernel driver and
>> > external firmware files?  (For the resume, it's of course a different
>>
>> Yes, my original patch does work for the built-in situations.
>>
>> > issue.  And I guess it's been solved by your fw cache patch, right?)
>> >
>> >> > Do you think this kind of hack is OK?  If not, any better (IOW easier)
>> >> > solution?
>> >>
>> >> Looks your solution is a bit complicated, and I have wrote a similar
>> >> patch to address the problem, but Linus thought that it may hide the
>> >> problem of drivers.
>> >>
>> >>         http://marc.info/?t=134278790800004&r=1&w=2
>> >>
>> >> IMO, driver core needn't to be changed, and the defer probe can be
>> >> supported just by changes in request_firmware() and its caller.
>> >
>> > Ideally, yes.  But it won't work in some drivers like sound drivers,
>> > that have its own device number counting changed at each probe call.
>> > For such drivers, the deferred probe check must be done before
>> > entering the normal probe procedure, and returning -EPROBE_DEFER would
>> > be too late (or need more complex fallbacks).
>>
>> Simply, you can put the firmware loading at the start of probe to
>> avoid the specific
>> sound problem, :-)
>
> Well, I can't buy it.  Changing the call order can be often more
> problematic.  Anyway...

More or less, these sound drivers may not support probe deferral well.
So the similar problem may be triggered if these device/drivers want
to apply probe deferral to solve some resource dependency problem.

>
>
> IMO, the primary question is whether we still regard the
> request_firmware() call in module_init as a driver bug.  Or, looking
> at the usage numbers, we should accept it as a de facto standard use
> case?

IMO, if the driver is built as module, request_firmware should be
allowed to be called in module_init context since user space is
already ready for handling firmware request. Also some devices
can't work without firmware downloading, and some device can
only be allowed to download firmware one time,  so it is reasonable
to call request_firmware() in .probe().

The current problem is that udev thinks it is not good and may timeout
the request, and looks no reasonable explanation about that.

If the driver is built in kernel, the request_firmware in .probe() may
prolong kernel init, and it might be a problem. But looks it is not a
big deal since most of drivers are built as module.

>
> If we still see it as a bug, the only right way is to fix the drivers,
> not the core.  That's why I suggested to put some fix to each driver.
> In that way, it shows obvious that the driver is a kind of buggy but
> fixed in a very lazy way (the function name should have been more
> obvious one like i_may_call_request_firmware_so_call_me_later()).
> The difference is that this fixes the bug, not hiding the problem.
>
> OTOH, if we see it no longer as a bug, we should rather improve the
> handling in the kernel core.  (Or, more radically, we can consider a
> sort of async probing as default :)

Agree, :-)

> In anyway, fixing the core side is justified only if we agree that
> request_firmware() in module_init is a valid use case.
>
> So, before starting the work, we actually need a consensus.

Yes.

Thanks,
--
Ming Lei
