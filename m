Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab2LNVgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 16:36:37 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:32829 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab2LNVgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 16:36:36 -0500
Message-ID: <50CB9BE1.5070906@linaro.org>
Date: Fri, 14 Dec 2012 13:36:33 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Feng Tang <feng.tang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        alek.du@intel.com
Subject: Re: [PATCH 1/3] timekeeping: Add persistent_clock_exist flag
References: <1355364328-19550-1-git-send-email-feng.tang@intel.com> <50CA7EE4.3000306@linaro.org> <20121214013725.GA11276@feng-snb> <50CA8837.5010800@linaro.org> <20121214023826.GA31613@obsidianresearch.com>
In-Reply-To: <20121214023826.GA31613@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 06:38 PM, Jason Gunthorpe wrote:
> On Thu, Dec 13, 2012 at 06:00:23PM -0800, John Stultz wrote:
>
>> So per Jason's related patch, he's made the point that the
>> persistent_clock and RTC class functionality are basically exclusive
>> (well, in his case, he said this with respect to updating the RTC,
>> not reading it - I don't mean to put words in his mouth - Please do
>> correct me here Jason. :).  In other words, we probably should avoid
>> configurations where both the rtc hctosys and persistent_clock
>> interfaces are both active.
> I only studied update_persistent_clock, read_persistent_clock is
> very much different.
>
> Looking at it, I don't think that update_persistent_clock is in any
> way related to read_persistent_clock..  update_persistent_clock is
> *only* called by NTP, and its *only* purpose is to update the RTC with
> NTP synchronized time. In many configurations it will never even be
> called.
>
> I think update_persistent_clock is badly named, it should be called
> platform_save_ntp_time_to_rtc(), keep it divorced from
> read_presistent_clock :)
Fair enough.  I think you've done a decent job convincing me that for 
the update path converting everything to using the RTC class exclusively 
is the better approach. That way we avoid the duplication on the write 
at least.

The read side, I suspect we can't eliminate the duplication, but we can 
likely configure it out for most cases.

>> make the HCTOSYS option be dependent on !HAS_PERSISTENT_CLOCK. This
>> way we avoid having configs where there are conflicting paths that
>> we chose from.
> On ARM the read_presistent_clock is used to access a true monotonic
> counter that is divorced from the system RTC - look at
> arch/arm/plat-omap/counter_32k.c for instance.
Yea, the 32k counter in that case is an interesting one (and a good 
example of wanting both a read_persistent_clock and a rtc). It doesn't 
exactly implement what read_persistent_clock() intends, but gets away 
with it, since on the suspend/resume we only take a delta from the 
read_persistent_clock(), we don't actually care if its accurate time 
wise.  It works well enough for suspend/resume and is nicely more 
accurate then the RTC.

Although this does cause duplication on the initialization side, where 
we probably set the time initially to the wrong time using the 32k 
counter, and then follow up with the HCTOSYS_DEVICE to get the correct 
time (and there's the extra overhead of the RTC suspend/resume path 
calculating and calling timekeeping_inject_sleeptime, but since 
read_persistent_clock is there, we throw that less accurate data out).


> This seems like a great use of that hardware resource, and no doubt
> those mach's also have a class RTC driver available talking to
> different hardware.
>
> For mach's without that functionality ARM returns a fixed 0 value
> from read_persistent_clock, persumably the kernel detects this and
> falls back to using class rtc functions?
>
> Maybe Feng would be better off adjusting read_persistent_clock to
> return ENODEV in such cases??
Although he wants to avoid even doing any read/calculation in the RTC 
suspend/resume path if read_persistent_clock is there. So probably some 
sort of a flag interface will be needed in that case.

> So, I think you have to keep your test as a run time test. To support
> the single image ARM boot you can't make the distinction with kconfig.
So yea, I agree there are some cases where both are necessary, but I 
also think that in *most* cases we can optimize out the choice at 
compile time, which is even better then having even the improved runtime 
conditional checking.

thanks
-john

