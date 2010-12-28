Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab0L1MMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 07:12:45 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34487 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab0L1MMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 07:12:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ZZsfG5O8myGNUXUwHCgRqU4Be9tdNXV+uBqBuhWuBLqxooWjK8leB8SdUkzId8ROrd
         HNBYXxYgcwZQ+niXnRjAT6pE9KoOYnGZutcbhd+g0A5ITE97c7ANA94lWK4FM5LlGh2K
         O1zEcverlpLJD327lj1Pznm8/dz5rnz9AHt+8=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=xmxkWnhuYcjtDNDHgep_2EztfGXDv+winW2Y5@mail.gmail.com>
References: <1292870624-25450-1-git-send-email-felipe.contreras@nokia.com>
	<AANLkTikisHaAMZphRJVYdcokVbaZXVF9COrwkdGTDg__@mail.gmail.com>
	<AANLkTi=9AL3aWUsMeih+Gb-sMov=MgBZ1eTp8wb=q1hZ@mail.gmail.com>
	<AANLkTinX8t=3b48e2sxPU-V_G-nGm_1DyEg6B-CeqXDa@mail.gmail.com>
	<1293452486-notmuch-felipe.contreras@nokia.com>
	<AANLkTinz0HuhGB_WzTQbK8XkfkGALjtg928WdOUYsySf@mail.gmail.com>
	<AANLkTimCB5g29gzWFzaFU1N8+doROTpWaXy18VU5AJyH@mail.gmail.com>
	<AANLkTi=xmxkWnhuYcjtDNDHgep_2EztfGXDv+winW2Y5@mail.gmail.com>
Date: Tue, 28 Dec 2010 14:12:41 +0200
Message-ID: <AANLkTiksjHKjKQ+mWE=Zf0+967_E46V3+RURcMC-s5cD@mail.gmail.com>
Subject: Re: [PATCH v2] staging: tidspbridge: protect dmm_map properly
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        greg@kroah.com, omar.ramirez@ti.com, fernando.lugo@ti.com, nm@ti.com,
        ameya.palande@nokia.com, h-kanigeri2@ti.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 12:56 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Tue, Dec 28, 2010 at 12:36 PM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>>> You can never really tell who is using the kernel (or will be using
>>> this kernel version), how and under which workload.
>>
>> No, but it's better to address real issues rather than hypothetical.
>
> Right. and both patches do that. one adds locks, and one doesn't.
>
>> However, as I sad, everybody is using proc_map() and proc_un_map()
>> which take a lock, and there are no complaints.
>
> I didn't complain about that; I didn't like you adding locks to the DMA API.
>
>> Ok, can I get your Ack?
>
> Frankly, I don't like the locks you are adding. But as I said, I
> wouldn't resist them as long as it's temporary.
>
>> Then why did you add that check for is_map_obj_used(), and then return
>> -EBUSY? If that can happen, then it can happen when the application is
>> crashing; user-space crashes while kernel-space is in the middle of a
>> proc_*_dma() operation.
>
> I still don't know how exactly you triggered the bug: is gst-dsp
> multithreaded ? and one of its threads invoked proc_un_map() while
> another thread called proc_begin_dma() ?

I haven't investigated why that happens, but kernel-space should not
panic regardless of what user-space does.

> Anyhow, a thread that is calling proc_*_dma() will both increase the
> reference count and decrease it back before going back to user space.
> Otherwise your patch would be problematic as well - who will unlock
> the mutex you take in proc_*_dma() ?

I'm saying that user-space might crash *before* proc_*_dma() finishes,
before the reference count has been decreased.

In my patch there would be no issue because proc_un_map() would wait
until proc_*_dma() has released the lock.

>>>> Sure, but I see this as a broader effort to have finer locking, part of
>>>> this should be to remove the already existing proc_lock.
>>>
>>> Having bad locking is not an excuse for adding more.
>>
>> No, but not being a permanent solution is not an excuse for not fixing
>> a kernel panic right away.
>
> Right. But we have a fix that doesn't add any additional locking... I
> don't see why it can't be taken now, but as I said, I wouldn't resist
> staging it for the next cycle.

Because:
 1) Your patch changes 114 lines, mine 18
 2) It hasn't been reviewed, nor tested by other people
 3) At least I see a potential issue
 4) 2.6.37 is imminent

IMO one patch has chances going into 2.6.37, the other one doesn't. I
don't see the problem of pushing my patch to 2.6.37, and once your
patch has been properly reviewed, and tested, put it for the 2.6.38
merge window. Anyway, it's looking more and more that this patch would
not be ack'ed in time, so I guess we would have to wait to see what
other people (Omar?) say, which would probably be 2.6.38 timeline.

Cheers.

-- 
Felipe Contreras
