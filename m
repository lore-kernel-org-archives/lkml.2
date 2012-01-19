Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab2ASKy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 05:54:26 -0500
Received: from smtp.nokia.com ([147.243.1.48]:33056 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab2ASKyW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 05:54:22 -0500
From: <leonid.moiseichuk@nokia.com>
To: <rhod@redhat.com>, <penberg@kernel.org>
CC: <riel@redhat.com>, <minchan@kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <mel@csn.ul.ie>, <rientjes@google.com>, <kosaki.motohiro@gmail.com>,
        <hannes@cmpxchg.org>, <mtosatti@redhat.com>,
        <akpm@linux-foundation.org>, <kosaki.motohiro@jp.fujitsu.com>
Subject: RE: [RFC 1/3] /dev/low_mem_notify
Thread-Topic: [RFC 1/3] /dev/low_mem_notify
Thread-Index: AQHM1PAILpEwsgBJQ0+ebltvcfq8MpYQOdkAgAB3jICAACXvgIAA9v4A///6iYCAABO3AIAAA+QAgAARAJCAAMdZAIAAg3iAgAAcKICAAAFDAIAAAtAAgAASS5A=
Date: Thu, 19 Jan 2012 10:53:29 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB9826904559D46@008-AM1MPN1-003.mgdnok.nokia.com>
References: <1326788038-29141-1-git-send-email-minchan@kernel.org>
 <1326788038-29141-2-git-send-email-minchan@kernel.org>
 <CAOJsxLHGYmVNk7D9NyhRuqQDwquDuA7LtUtp-1huSn5F-GvtAg@mail.gmail.com>
 <4F15A34F.40808@redhat.com>
 <alpine.LFD.2.02.1201172044310.15303@tux.localdomain>
 <84FF21A720B0874AA94B46D76DB98269045596AE@008-AM1MPN1-003.mgdnok.nokia.com>
 <CAOJsxLGiG_Bsp8eMtqCjFToxYAPCE4HC9XCebpZ+-G8E3gg5bw@mail.gmail.com>
 <84FF21A720B0874AA94B46D76DB98269045596EA@008-AM1MPN1-003.mgdnok.nokia.com>
 <CAOJsxLG4hMrAdsyOg6QUe71SPqEBq3eZXvRvaKFZQo8HS1vphQ@mail.gmail.com>
 <84FF21A720B0874AA94B46D76DB982690455978C@008-AM1MPN1-003.mgdnok.nokia.com>
 <4F175706.8000808@redhat.com>
 <alpine.LFD.2.02.1201190922390.3033@tux.localdomain>
 <4F17DCED.4020908@redhat.com>
 <CAOJsxLG3x_R5xq85hh5RvPoD+nhgYbHJfbLW=YMxCZockAXJqw@mail.gmail.com>
 <4F17E058.8020008@redhat.com>
In-Reply-To: <4F17E058.8020008@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.23.171]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 19 Jan 2012 10:53:31.0467 (UTC) FILETIME=[954609B0:01CCD698]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: ext Ronen Hod [mailto:rhod@redhat.com]
> Sent: 19 January, 2012 11:20
> To: Pekka Enberg
...
> >>> Isn't
> >>>
> >>> /proc/sys/vm/min_free_kbytes
> >>>
> >>> pretty much just that?
> >> Would you suggest to use min_free_kbytes as the threshold for sending
> >> low_memory_notifications to applications, and separately as a target
> >> value for the applications' memory giveaway?
> > I'm not saying that the kernel should use it directly but it seems
> > like the kind of "ideal number of free pages" threshold you're
> > suggesting. So userspace can read that value and use it as the "number
> > of free pages" threshold for VM events, no?
> 
> Yes, I like it. The rules of the game are simple and consistent all over, be it the
> alert threshold, voluntary poling by the apps, and for concurrent work by
> several applications.
> Well, as long as it provides a good indication for low_mem_pressure.

For me it doesn't look that have much sense. min_free_kbytes could be set from user-space (or auto-tuned by kernel) to keep some amount 
of memory available for GFP_ATOMIC allocations.  In case situation comes under pointed level kernel will reclaim memory from e.g. caches.

>From potential user point of view the proposed API has number of lacks which would be nice to have implemented:
1. rename this API from low_mem_pressure to something more related to notification and memory situation in system: memory_pressure, memnotify, memory_level etc. The word "low" is misleading here
2. API must use deferred timers to prevent use-time impact. Deferred timer will be triggered only in case HW event or non-deferrable timer, so if device sleeps timer might be skipped and that is what expected for user-space
3. API should be tunable for propagate changes when level is Up or Down, maybe both ways. 
4. to avoid triggering too much events probably has sense to filter according to amount of change but that is optional. If subscriber set timer to 1s the amount of events should not be very big.
5. API must provide interface to request parameters e.g. available swap or free memory just to have some base.
6. I do not understand how work with attributes performed ( ) but it has sense to use mask and fill requested attributes using mask and callback table i.e. if free pages requested - they are reported, otherwise not.
7. would have sense to backport couple of attributes from memnotify.c

I can submit couple of patches if some of proposals looks sane for everyone.
