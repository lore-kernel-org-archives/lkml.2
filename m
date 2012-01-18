Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab2ARJn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:43:58 -0500
Received: from smtp.nokia.com ([147.243.1.48]:49352 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757104Ab2ARJn4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:43:56 -0500
From: <leonid.moiseichuk@nokia.com>
To: <penberg@kernel.org>
CC: <riel@redhat.com>, <minchan@kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <mel@csn.ul.ie>, <rientjes@google.com>, <kosaki.motohiro@gmail.com>,
        <hannes@cmpxchg.org>, <mtosatti@redhat.com>,
        <akpm@linux-foundation.org>, <rhod@redhat.com>,
        <kosaki.motohiro@jp.fujitsu.com>
Subject: RE: [RFC 1/3] /dev/low_mem_notify
Thread-Topic: [RFC 1/3] /dev/low_mem_notify
Thread-Index: AQHM1PAILpEwsgBJQ0+ebltvcfq8MpYQOdkAgAB3jICAACXvgIAA9v4A///6iYCAABO3AA==
Date: Wed, 18 Jan 2012 09:41:41 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB98269045596EA@008-AM1MPN1-003.mgdnok.nokia.com>
References: <1326788038-29141-1-git-send-email-minchan@kernel.org>
	<1326788038-29141-2-git-send-email-minchan@kernel.org>
	<CAOJsxLHGYmVNk7D9NyhRuqQDwquDuA7LtUtp-1huSn5F-GvtAg@mail.gmail.com>
	<4F15A34F.40808@redhat.com>
	<alpine.LFD.2.02.1201172044310.15303@tux.localdomain>
	<84FF21A720B0874AA94B46D76DB98269045596AE@008-AM1MPN1-003.mgdnok.nokia.com>
 <CAOJsxLGiG_Bsp8eMtqCjFToxYAPCE4HC9XCebpZ+-G8E3gg5bw@mail.gmail.com>
In-Reply-To: <CAOJsxLGiG_Bsp8eMtqCjFToxYAPCE4HC9XCebpZ+-G8E3gg5bw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.23.171]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 18 Jan 2012 09:41:42.0588 (UTC) FILETIME=[629187C0:01CCD5C5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: penberg@gmail.com [mailto:penberg@gmail.com] On Behalf Of ext
> Pekka Enberg
> Sent: 18 January, 2012 11:16
...
> > Would be possible to not use percents for thesholds? Accounting in pages
> even
> > not so difficult to user-space.
> 
> How does that work with memory hotplug?

Not worse than %%. For example you had 10% free memory threshold for 512 MB RAM meaning 51.2 MB in absolute number.
Then hotplug turned off 256 MB, you for sure must update threshold for %% because these 10% for 25.6 MB most likely will be not suitable for different operating mode.
Using pages makes calculations must simpler.

> 
> On Wed, Jan 18, 2012 at 11:06 AM,  <leonid.moiseichuk@nokia.com> wrote:
> > Also, looking on vmnotify_match I understand that events propagated to
> > user-space only in case threshold trigger change state from 0 to 1 but not
> > back, 1-> 0 is very useful event as well
(*)

> >
> > Would be possible to use for threshold pointed value(s) e.g. according to
> > enum zone_state_item, because kinds of memory to track could be
> different?
> > E.g. to tracking paging activity NR_ACTIVE_ANON and NR_ACTIVE_FILE
> could be
> > interesting, not only free.
> 
> I don't think there's anything in the ABI that would prevent that.

If this statement also related my question (*)  I have to point need to track attributes history, otherwise user-space will be constantly kicked with updates.

> I actually changed the ABI to look like this:
> 
> struct vmnotify_event {
>         /*
>          * Size of the struct for ABI extensibility.
>          */
>         __u32                   size;
> 
>         __u64                   attrs;
> 
>         __u64                   attr_values[];
> };
> 
> So userspace can decide which fields to include in notifications.

Good. But how you can provide current status of attributes to user-space? Need to have read() call support to deliver all supported attr_values[] on demand.

> >> +
> >> +#ifdef CONFIG_SWAP
> >> +     si_swapinfo(&si);
> >> +     event.nr_swap_pages     = si.totalswap;
> >> +#endif
> >> +
> >
> > Why not to use global_page_state() directly? si_meminfo() and especial
> > si_swapinfo are quite expensive call.
> 
> Sure, we can do that. Feel free to send a patch :-).

When I see code because from emails it is quite difficult to understand. 
For short-term I need to focus on integration "memnotify" version internally which is kind of work for me already and provides all required interfaces n9 needs.
 
Btw, when API starts to work with pointed thresholds logically it is not anymore low_mem_notify, you need to invent some other name. 

> No idea what happens. The sampling code is just a proof of concept thing and
> I expect it to be buggy as hell. :-)
> 
> 			Pekka
