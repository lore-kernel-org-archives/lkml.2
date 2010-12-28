Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab0L1K5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 05:57:09 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65519 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab0L1K5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 05:57:07 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.188.89]
In-Reply-To: <AANLkTimCB5g29gzWFzaFU1N8+doROTpWaXy18VU5AJyH@mail.gmail.com>
References: <1292870624-25450-1-git-send-email-felipe.contreras@nokia.com>
 <AANLkTikisHaAMZphRJVYdcokVbaZXVF9COrwkdGTDg__@mail.gmail.com>
 <AANLkTi=9AL3aWUsMeih+Gb-sMov=MgBZ1eTp8wb=q1hZ@mail.gmail.com>
 <AANLkTinX8t=3b48e2sxPU-V_G-nGm_1DyEg6B-CeqXDa@mail.gmail.com>
 <1293452486-notmuch-felipe.contreras@nokia.com> <AANLkTinz0HuhGB_WzTQbK8XkfkGALjtg928WdOUYsySf@mail.gmail.com>
 <AANLkTimCB5g29gzWFzaFU1N8+doROTpWaXy18VU5AJyH@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 28 Dec 2010 12:56:46 +0200
Message-ID: <AANLkTi=xmxkWnhuYcjtDNDHgep_2EztfGXDv+winW2Y5@mail.gmail.com>
Subject: Re: [PATCH v2] staging: tidspbridge: protect dmm_map properly
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        greg@kroah.com, omar.ramirez@ti.com, fernando.lugo@ti.com, nm@ti.com,
        ameya.palande@nokia.com, h-kanigeri2@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 12:36 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
>> You can never really tell who is using the kernel (or will be using
>> this kernel version), how and under which workload.
>
> No, but it's better to address real issues rather than hypothetical.

Right. and both patches do that. one adds locks, and one doesn't.

> However, as I sad, everybody is using proc_map() and proc_un_map()
> which take a lock, and there are no complaints.

I didn't complain about that; I didn't like you adding locks to the DMA API.

> Ok, can I get your Ack?

Frankly, I don't like the locks you are adding. But as I said, I
wouldn't resist them as long as it's temporary.

> Then why did you add that check for is_map_obj_used(), and then return
> -EBUSY? If that can happen, then it can happen when the application is
> crashing; user-space crashes while kernel-space is in the middle of a
> proc_*_dma() operation.

I still don't know how exactly you triggered the bug: is gst-dsp
multithreaded ? and one of its threads invoked proc_un_map() while
another thread called proc_begin_dma() ?

Anyhow, a thread that is calling proc_*_dma() will both increase the
reference count and decrease it back before going back to user space.
Otherwise your patch would be problematic as well - who will unlock
the mutex you take in proc_*_dma() ?

>>> Sure, but I see this as a broader effort to have finer locking, part of
>>> this should be to remove the already existing proc_lock.
>>
>> Having bad locking is not an excuse for adding more.
>
> No, but not being a permanent solution is not an excuse for not fixing
> a kernel panic right away.

Right. But we have a fix that doesn't add any additional locking... I
don't see why it can't be taken now, but as I said, I wouldn't resist
staging it for the next cycle.
