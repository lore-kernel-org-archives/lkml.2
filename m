Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab2LNVWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 16:22:55 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56635 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237Ab2LNVWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 16:22:53 -0500
Message-ID: <50CB98AA.5090600@linaro.org>
Date: Fri, 14 Dec 2012 13:22:50 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Feng Tang <feng.tang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        alek.du@intel.com
Subject: Re: [PATCH 1/3] timekeeping: Add persistent_clock_exist flag
References: <1355364328-19550-1-git-send-email-feng.tang@intel.com> <50CA7EE4.3000306@linaro.org> <20121214013725.GA11276@feng-snb> <50CA8837.5010800@linaro.org> <20121214023826.GA31613@obsidianresearch.com> <20121214031330.GC11276@feng-snb> <20121214041024.GA1040@obsidianresearch.com>
In-Reply-To: <20121214041024.GA1040@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 08:10 PM, Jason Gunthorpe wrote:
>
> Ah, I see, there is some duplication here, my earlier comments about
> update_persistent_clock are not quite right, some places like PCs
> stick a RTC driver and then continue to access the same hardware
> directly outside the rtc driver context! That seems ugly :|
>
> I see the PC CMOS rtc driver does not implement the set_mmss
> operation, instead running that code through update_persistent_clock..
> That seems like a cleanup waiting to happen.
>
> Regarding your problem - IMHO, it would be fantastic if the class RTC
> driver could be used instead of read_persistent_clock on PC.
>
> John mentioned that read_persistent_clock had a requirement to work
> with IRQs off - that seems like it would be easy to incorporate into
> class rtc - for hardware that supports it (and PC is not the only RTC
> HW that can do this) Is that the only reason it still exists on pc?
>
> I have to feel the long term direction should be to remove
> *_persistent_clock in favor of class RTC?
So yes, I'd love to see a cleanup here.

Although from a timekeeping perspective, the read_persistent_clock() 
interface is actually *much* preferred over the rtc HCTOSYS device.

Since read_persistent_clock() has the requirement that its safe to call 
with IRQs disabled, we can use it in the timekeeping suspend/resume 
code, which allows for better time accuracy.

That said, many systems don't have a persistent clock that they can 
access with irqs off, and so the timekeeping_inject_sleeptime code was 
added to work with the rtc class drivers,  but it is more prone to problems.

That's why I've been suggesting we add a HAS_PERSISTENT_CLOCK and make 
the HCTOSYS_DEVICE depend on !HAS_PERSISTENT_CLOCK.  As it avoids these 
weird cases we're we have possibly duplicated code paths.

But there is the risk that some architectures may require both for some 
system configs (ie: read_persistent_clock works on all but one SoC, 
which has an rtc over a usb bus or something).  Although its not clear 
yet that this is a situation that actually exists.  (And we could work 
around it with something like HAS_EXCLUSIVE_PERSISTENT_CLOCK or something).

While we're suggesting cleanups, the RTC Kconfig choices probably need a 
cleanup too, as  the list of all possible drivers can be confusing, when 
usually each architecture has only a few that they exclusively support 
(I know there are exceptions to this).  It makes it hard to even figure 
out for a specific rtc driver what architecture one should look for in 
order to test with (I usually have to look at the commit log, and then 
try to associate email address with arch maintainers). A good number of 
drivers are fine, and already depend on the SoC platform support being 
there, but I suspect we could narrow a number of the drivers down to one 
or two arches or even platforms that acutally make use of it.

thanks
-john
