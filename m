Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab0L2Jqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 04:46:47 -0500
Received: from mail-iy0-f194.google.com ([209.85.210.194]:37416 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab0L2Jqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 04:46:46 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.188.89]
In-Reply-To: <AANLkTimMe97QECEJ+T6Eh7SFKqOi8xo08ZB+S+8Yzuww@mail.gmail.com>
References: <1292870624-25450-1-git-send-email-felipe.contreras@nokia.com>
 <AANLkTikisHaAMZphRJVYdcokVbaZXVF9COrwkdGTDg__@mail.gmail.com>
 <AANLkTi=9AL3aWUsMeih+Gb-sMov=MgBZ1eTp8wb=q1hZ@mail.gmail.com>
 <AANLkTinX8t=3b48e2sxPU-V_G-nGm_1DyEg6B-CeqXDa@mail.gmail.com>
 <1293452486-notmuch-felipe.contreras@nokia.com> <AANLkTinz0HuhGB_WzTQbK8XkfkGALjtg928WdOUYsySf@mail.gmail.com>
 <AANLkTimCB5g29gzWFzaFU1N8+doROTpWaXy18VU5AJyH@mail.gmail.com>
 <AANLkTi=xmxkWnhuYcjtDNDHgep_2EztfGXDv+winW2Y5@mail.gmail.com>
 <AANLkTiksjHKjKQ+mWE=Zf0+967_E46V3+RURcMC-s5cD@mail.gmail.com>
 <AANLkTi=ZY09yJ=pK4ejqOZjh7YjJp1UemRdMgMfpsz2f@mail.gmail.com>
 <AANLkTinZ0Uwp8jbmsSwm6ut75A06CxrkESTRJT-GoPkP@mail.gmail.com>
 <AANLkTi=wBG9AXvDva-_uNjGbRphrb356gZ6ChMJjP8aL@mail.gmail.com> <AANLkTimMe97QECEJ+T6Eh7SFKqOi8xo08ZB+S+8Yzuww@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 29 Dec 2010 11:46:25 +0200
Message-ID: <AANLkTi=s03AA5wJaUzp7KkQDBcBVceSn4QvwH8CyRRyO@mail.gmail.com>
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

On Wed, Dec 29, 2010 at 11:39 AM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> On Tue, Dec 28, 2010 at 2:37 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>> On Tue, Dec 28, 2010 at 2:24 PM, Felipe Contreras
>> <felipe.contreras@gmail.com> wrote:
>>> user-space crashed, not kernel-space; the code would continue to run
>>> and eventually release the lock.
>>
>> So you'll have to be more specific about the scenario you are describing.
>>
>> If there's a user thread that is still running the proc_*_dma()
>> function, and we agree that this thread keeps running until completion
>> and then returns to user space, what's the problem ?
>
> The problem is if the user-space process crashes exactly in the middle
> of it, *before* completing. With locks there's no problem, as
> proc_un_map() would wait for the lock in my patch. In your patch it
> would not wait, just return -EBUSY.

We have two threads.

One called proc_un_map(), and one called proc_begin_dma().

The first crashed, but the second didn't. it still holds the bridge
device open. When it will exit, and release the device, then
drv_remove_all_resources() will be called, and all the map_obj's will
be cleaned.

>
>> If that user thread will crash, drv_remove_all_resources() will clean
>> up all map_obj's.
>
> Not if a proc_*_dma() is still running.

It will be called after it will return, and its thread will exit (or crash).
