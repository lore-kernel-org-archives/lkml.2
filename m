Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab0LTWIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 17:08:18 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36271 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758181Ab0LTWIR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 17:08:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=k1ZaxVYBdel4QH1zegCQAe/0zTWR7U75hFBCs3gq1uiSceBHv0TkXVgnKu0ZjLqm3N
         3ClV5PJ6nZg9rc8OsXPjo0IsMQ6h+yBnGifhSHU5e017JK0QuDfS0tpc1xhwpdDIS/Es
         rn98Hi+yp8WmLcjL953eLbb3b20pUFVYV5nxQ=
MIME-Version: 1.0
In-Reply-To: <201012202254.35185.arnd@arndb.de>
References: <201012201912.19051.arnd@arndb.de>
	<201012202152.38863.arnd@arndb.de>
	<0d30dc$kh41r4@orsmga001.jf.intel.com>
	<201012202254.35185.arnd@arndb.de>
Date: Tue, 21 Dec 2010 08:08:16 +1000
Message-ID: <AANLkTi=aXG+mOku=23e9ssfVx7dnQqeFJd_T1GBk=-gK@mail.gmail.com>
Subject: Re: [BISECTED] agp/intel: revert "Remove confusion of stolen entries
 not stolen memory"
From: Dave Airlie <airlied@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 7:54 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 20 December 2010 22:06:47 Chris Wilson wrote:
>> On Mon, 20 Dec 2010 21:52:38 +0100, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Monday 20 December 2010 20:52:07 Chris Wilson wrote:
>> > >
>> > > Also, which modules do you have loaded when using VESA? i.e. is the
>> > > i915.ko loaded, but in UMS mode (i915.modeset=0)?
>> >
>> > This doesn't seem to matter, as far as I can tell, i915 can be loaded
>> > or now.
>>
>> Thanks, that rules out the likely explanation that we [i915] loaded the
>> GTT with some conflicting entries. Instead it is likely the initialisation
>> of the GTT to point to the scratch page that is triggering the problem.
>> Can you try disabling it with:
>>
>> diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
>> index 356f73e..238848e 100644
>> --- a/drivers/char/agp/intel-gtt.c
>> +++ b/drivers/char/agp/intel-gtt.c
>> @@ -867,11 +867,13 @@ static int intel_fake_agp_configure(void)
>>
>>       agp_bridge->gart_bus_addr = intel_private.gma_bus_addr;
>>
>> +#if 0
>>       for (i = 0; i < intel_private.base.gtt_total_entries; i++) {
>>               intel_private.driver->write_entry(intel_private.scratch_page_dma,
>>                                                 i, 0);
>>       }
>>       readl(intel_private.gtt+i-1);   /* PCI Posting. */
>> +#endif
>>
>>       global_cache_flush();
>
> Yes, this works as well, good catch!
>
>> > I've seen the system crash once while loading i915 with
>> > modeset=1 and my revert patch applied and backed it out.
>> >
>> > After that, I could no longer even get i915 to do modesetting,
>> > the ioremap in intel_opregion_setup now fails because reserve_memtype
>> > decides that the opregion should be write-back when we ask for
>> > an uncached mapping. That's probably an unrelated problem, but
>> > I'm mentioning it anyway in case it's significant.
>>
>> I hope not. But it sounds like we're in for a turbulent ride if ioremap is
>> failing in -next.
>
> It only fails for the opregion. I feel I've done enough bisecting for today,
> but it's certainly broken in -next and the ioremap works in 2.6.37-rc6.
> Should the opregion actually be writeback cached? Maybe something is
> wrong in reserve_memtype.
>
> Loading i915 in -rc6 also crashes my system hard when modeset=1, but
> that may be a hardware problem -- the same one that used to cause occasional
> hangs with i915 KMS, forcing me to run X11 with the vesa driver.

I wonder if the ACPI table mapping stuff is in -next yet.

As a first guess.

Dave.
