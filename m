Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab0L1KhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 05:37:00 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46549 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab0L1Kg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 05:36:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DwR84kFKhoQXyFA+6IXf0ZIoGf4ke+/4gVCwe7wHT9ScUKljKBV9eN6wyE3eHsBTYt
         yEYSK8+HrQby0PVn7pEVBhkes0e8PSs/o305lul9QM9HzlPeKhOQ8MNQSDi0AfGarbwU
         7y7+K3KTglcNj43485oOmAX8vRWR8N70EYlgs=
MIME-Version: 1.0
In-Reply-To: <AANLkTinz0HuhGB_WzTQbK8XkfkGALjtg928WdOUYsySf@mail.gmail.com>
References: <1292870624-25450-1-git-send-email-felipe.contreras@nokia.com>
	<AANLkTikisHaAMZphRJVYdcokVbaZXVF9COrwkdGTDg__@mail.gmail.com>
	<AANLkTi=9AL3aWUsMeih+Gb-sMov=MgBZ1eTp8wb=q1hZ@mail.gmail.com>
	<AANLkTinX8t=3b48e2sxPU-V_G-nGm_1DyEg6B-CeqXDa@mail.gmail.com>
	<1293452486-notmuch-felipe.contreras@nokia.com>
	<AANLkTinz0HuhGB_WzTQbK8XkfkGALjtg928WdOUYsySf@mail.gmail.com>
Date: Tue, 28 Dec 2010 12:36:56 +0200
Message-ID: <AANLkTimCB5g29gzWFzaFU1N8+doROTpWaXy18VU5AJyH@mail.gmail.com>
Subject: Re: [PATCH v2] staging: tidspbridge: protect dmm_map properly
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        greg@kroah.com, omar.ramirez@ti.com, fernando.lugo@ti.com, nm@ti.com,
        ameya.palande@nokia.com, h-kanigeri2@ti.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 8:33 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Mon, Dec 27, 2010 at 3:55 PM, Felipe Contreras
> <felipe.contreras@nokia.com> wrote:
>> So, effectively, serializing the proc_begin_dma() and proc_end_dma()
>> would not affect anyone negatively for the time being.
>
> You can never really tell who is using the kernel (or will be using
> this kernel version), how and under which workload.

No, but it's better to address real issues rather than hypothetical.

However, as I sad, everybody is using proc_map() and proc_un_map()
which take a lock, and there are no complaints. This patch would make
proc_begin_dma() and proc_end_dma() as slow as the map operations, so
even these hypothetical users would not get affected negatively.

>> For the long-term goal I agree with that approach, however, first, I
>> think my patch should be applied, since it's fixing a problem using an
>> already existing and actively excersised mechanism. In fact, I think
>> this should be pushed to 2.6.37 as:
>>
>>  1) prevents a kernel panic
>>  2) the issue is reproducible and clearly identified
>>  3) the patch is small and obvious
>
> Both patches are (IMHO). But frankly I don't mind your patch will be
> applied now as long as it doesn't stay. I can rebase my patch against
> it after it is applied, and send separately.

Ok, can I get your Ack? I guess Omar would be able to push it to Greg,
and perhaps it would make .37.

>> This approach looks cleaner, however, we need a flag in
>> remove_mapping_information() in order to force the removal, otherwise
>> there will be memory leaks. Imagine a process crashes, and
>> remove_mapping_information() returns -EBUSY.
>
> Can't happen; both proc_*_dma() operations decrease the reference
> count before exiting, so it's not up to the application.

Then why did you add that check for is_map_obj_used(), and then return
-EBUSY? If that can happen, then it can happen when the application is
crashing; user-space crashes while kernel-space is in the middle of a
proc_*_dma() operation.

>> Sure, but I see this as a broader effort to have finer locking, part of
>> this should be to remove the already existing proc_lock.
>
> Having bad locking is not an excuse for adding more.

No, but not being a permanent solution is not an excuse for not fixing
a kernel panic right away.

> Anyway, as I said, I don't really mind your patch will be applied as
> long as it is a temporary workaround.

Can you Ack?

-- 
Felipe Contreras
