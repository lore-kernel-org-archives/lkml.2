Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229Ab0L2Jv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 04:51:57 -0500
Received: from mail-iw0-f194.google.com ([209.85.214.194]:50924 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab0L2Jvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 04:51:55 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.188.89]
In-Reply-To: <AANLkTin3A__2OU+N-tQYJ_xOMz7-GXwia1yw10nzpU3V@mail.gmail.com>
References: <1292870624-25450-1-git-send-email-felipe.contreras@nokia.com>
 <AANLkTikisHaAMZphRJVYdcokVbaZXVF9COrwkdGTDg__@mail.gmail.com>
 <AANLkTi=9AL3aWUsMeih+Gb-sMov=MgBZ1eTp8wb=q1hZ@mail.gmail.com>
 <AANLkTinX8t=3b48e2sxPU-V_G-nGm_1DyEg6B-CeqXDa@mail.gmail.com>
 <1293452486-notmuch-felipe.contreras@nokia.com> <AANLkTinz0HuhGB_WzTQbK8XkfkGALjtg928WdOUYsySf@mail.gmail.com>
 <AANLkTimCB5g29gzWFzaFU1N8+doROTpWaXy18VU5AJyH@mail.gmail.com>
 <AANLkTi=xmxkWnhuYcjtDNDHgep_2EztfGXDv+winW2Y5@mail.gmail.com>
 <AANLkTiksjHKjKQ+mWE=Zf0+967_E46V3+RURcMC-s5cD@mail.gmail.com>
 <AANLkTi=X=Av0SaqphXUfiXMNX_tD8OF1CWes34keZ8O1@mail.gmail.com> <AANLkTin3A__2OU+N-tQYJ_xOMz7-GXwia1yw10nzpU3V@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 29 Dec 2010 11:51:34 +0200
Message-ID: <AANLkTim6kkxV8Bts=CNQqWmCgT+NUi4YoxZYPGCX7ttD@mail.gmail.com>
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

On Wed, Dec 29, 2010 at 11:42 AM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> On Tue, Dec 28, 2010 at 4:48 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>> On Tue, Dec 28, 2010 at 2:12 PM, Felipe Contreras
>> <felipe.contreras@gmail.com> wrote:
>>> On Tue, Dec 28, 2010 at 12:56 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>>>> I still don't know how exactly you triggered the bug: is gst-dsp
>>>> multithreaded ? and one of its threads invoked proc_un_map() while
>>>> another thread called proc_begin_dma() ?
>>>
>>> I haven't investigated why that happens
>>
>> Btw, I still think you should look into this.
>>
>> The kernel panic will be solved, but you may still have a race there
>> that can lead to data corruption: if proc_un_map will be fast enough,
>> it will acquire the proc_lock mutex before proc_begin_dma(), and then
>> you will miss a cache operation.
>
> Aquiring the lock is the first thing done; if proc_un_map() aquires
> the lock first, it's because it was run first

Not true.

Again, we have two threads:

T1 - called proc_begin_dma()

T2 - called proc_un_map()

Let's say T1 called proc_begin_dma() first, but it still didn't
acquire the lock.

At this point the scheduler let T2 run. It calls proc_un_map() and
acquire the lock, and free all map_obj's.

Then the scheduler let T1 continue to execute, but it can't find any
map_obj, and the required cache operation is not performed.

Of course the kernel has nothing to do with this, and don't care really.

That's why I said it's a user space race - you need to make sure T2
will not call proc_un_map() before T1 (or any other thread you have)
completed executing all DMA operations (that you care about).

>, and thus a problem for
> user-space. If user-space wants the cache operation, it must run
> proc_begin_dma() first, there's nothing kernel-space can do to fix
> that.
>
> --
> Felipe Contreras
>
