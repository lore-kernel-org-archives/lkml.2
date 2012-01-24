Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab2AXQWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 11:22:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58609 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab2AXQWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 11:22:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Pekka Enberg <penberg@kernel.org>
Subject: Re: [RFC 1/3] /dev/low_mem_notify
Date: Tue, 24 Jan 2012 16:22:36 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc7; KDE/4.3.2; x86_64; ; )
Cc: leonid.moiseichuk@nokia.com, riel@redhat.com, minchan@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, rientjes@google.com,
        kosaki.motohiro@gmail.com, hannes@cmpxchg.org, mtosatti@redhat.com,
        akpm@linux-foundation.org, rhod@redhat.com,
        kosaki.motohiro@jp.fujitsu.com
References: <1326788038-29141-1-git-send-email-minchan@kernel.org> <84FF21A720B0874AA94B46D76DB98269045596AE@008-AM1MPN1-003.mgdnok.nokia.com> <CAOJsxLGiG_Bsp8eMtqCjFToxYAPCE4HC9XCebpZ+-G8E3gg5bw@mail.gmail.com>
In-Reply-To: <CAOJsxLGiG_Bsp8eMtqCjFToxYAPCE4HC9XCebpZ+-G8E3gg5bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201241622.36222.arnd@arndb.de>
X-Provags-ID: V02:K0:ssDhLAP5zU5THHJFgPKC62lf/Sc8a7m/4xNt140HCf4
 wLHbAUHA8js6r0uQVxPJOdG9QN0lHH8NGo+IxhtJ8mQhcSB7sE
 U67gtKhvUW4CUzsGr7ivgygCrfjqzUdnMUbWaeE2Uj6TIkje3V
 JrOfGEazGqoBYnFV9+M6ViuXvUF3ynbnhPNuT5vv0P7iwDxUr+
 rtHY9364f20v2qrbayZNqua9XPYT3k0dQoE3JpWJLk3I0s1ncQ
 oT3f8zD+OI9Eed655tJYT5d56k6J3c07x6bSIU7lpYl20T8OFs
 9XEOh6mJIWTCW/W49XYCPFrFHOf2tONDCNmgNaGKyrQMl34O2H
 2XfXCljifMSSPQQ7cSr0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 January 2012, Pekka Enberg wrote:
> >> +struct vmnotify_event {
> >> +     /* Size of the struct for ABI extensibility. */
> >> +     __u32                   size;
> >> +
> >> +     __u64                   nr_avail_pages;
> >> +
> >> +     __u64                   nr_swap_pages;
> >> +
> >> +     __u64                   nr_free_pages;
> >> +};
> >
> > Two fields here most likely session-constant, (nr_avail_pages and
> > nr_swap_pages), seems not much sense to report them in every event.  If we
> > have memory/swap hotplug user-space can use sysinfo() call.
> 
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

Please make the first member a __u64 instead of a __u32. This will
avoid incompatibility between 32 and 64 bit processes, which have
different alignment rules on x86: x86-32 would implicitly pack the
struct while x86-64 would add padding with your layout.

	Arnd
