Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab2KUO0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 09:26:04 -0500
Received: from smtp.nokia.com ([147.243.128.25]:48853 "EHLO mgw-da03.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384Ab2KUO0B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 09:26:01 -0500
From: <leonid.moiseichuk@nokia.com>
To: <kirill@shutemov.name>, <rientjes@google.com>
CC: <glommer@parallels.com>, <anton.vorontsov@linaro.org>,
        <penberg@kernel.org>, <mgorman@suse.de>, <kosaki.motohiro@gmail.com>,
        <minchan@kernel.org>, <b.zolnierkie@samsung.com>,
        <john.stultz@linaro.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linaro-kernel@lists.linaro.org>,
        <patches@linaro.org>, <kernel-team@android.com>,
        <linux-man@vger.kernel.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <mhocko@suse.cz>, <hannes@cmpxchg.org>, <tj@kernel.org>
Subject: RE: [RFC v3 0/3] vmpressure_fd: Linux VM pressure notifications
Thread-Topic: [RFC v3 0/3] vmpressure_fd: Linux VM pressure notifications
Thread-Index: AQHNvNajVAwxa4W29kaKh6XYDR71zpfeOmsAgAAB2ACAAAQ9AIAMBlsAgAAMv2eAADn4AIAACneAgAALWQCAANJLAIAAy5CAgACwRQCAABMJAIAADG2AgAQw74CAAdbngIABA1UAgAAU6GA=
Date: Wed, 21 Nov 2012 11:32:43 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB982690469CC00@008-AM1MPN1-002.mgdnok.nokia.com>
References: <20121115073420.GA19036@lizard.sbx05977.paloaca.wayport.net>
 <alpine.DEB.2.00.1211142351420.4410@chino.kir.corp.google.com>
 <20121115085224.GA4635@lizard>
 <alpine.DEB.2.00.1211151303510.27188@chino.kir.corp.google.com>
 <50A60873.3000607@parallels.com>
 <alpine.DEB.2.00.1211161157390.2788@chino.kir.corp.google.com>
 <50A6AC48.6080102@parallels.com>
 <alpine.DEB.2.00.1211161349420.17853@chino.kir.corp.google.com>
 <50AA3ABF.4090803@parallels.com>
 <alpine.DEB.2.00.1211200950120.4200@chino.kir.corp.google.com>
 <20121121093056.GA31882@shutemov.name>
In-Reply-To: <20121121093056.GA31882@shutemov.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-version: 3.3.8.1
x-tituslabs-classifications-30: TLPropertyRoot=Nokia;Confidentiality=Nokia
 Internal Use Only;Project=None;
x-tituslabs-classificationhash-30: VgNFIFU9Hx+/nZJb9Kg7IqbQaTB01pYvlfczhoKjdi5ZneV8m7WL0RqcskKq273oFFVbp422poiaQKmewK6sRvzp6tEaPBmSXpqOn87QrZraLNfMxPAISx+mffQNGbLNclMYovdPaHi2YGVB5mHgI+zCjdRXVbm6VFeCiEpR7yJFZ9NVSFN8NDbl3qwdZ61ArHOwYowz5dgHMgZ/jN918odmb48UcnNNyXl3TyOolxs5NYuG+vYOiqhMZ+Y+S2v46z3f+M1N+3vlgN/gAEtOVg==
x-headerinfofordlp: None
x-originating-ip: [172.21.82.153]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 21 Nov 2012 11:32:44.0360 (UTC) FILETIME=[EC864480:01CDC7DB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: ext Kirill A. Shutemov [mailto:kirill@shutemov.name] 
Sent: 21 November, 2012 11:31
...

BTW, there's interface for OOM notification in memcg. See oom_control.
I guess other pressure levels can also fit to the interface.

---
Hi,

I have tracking this conversation very little, but as person somehow related to this round of development and requestor of memcg notification mechanism in past (Kirill implemented that) I have to point there are reasons not to use memcg. The situation in latest kernels could be different but practically in past the following troubles were observed with memcg:
1. by default memcg is turned off on Android (at least on 4.1 I see it)
2. you need to produce memory partitioning, and that maybe non-trivial task in general case when apps/use cases are not so limited
3. memcg takes into account cached memory. Yes, you can play with MADV_DONTNEED  as it was mentioned  but in generic case that is insane
4. memcg need be extended in a way you need to track some other kinds of memory
5. in case of situation in some partition changed fast (e.g. process moved to another partition) it may cause pages trashing and device lock. The in-kernel lock was fixed in May 2012, but even pages trashing knock out device number of seconds (even minutes).

Thus, I would prefer to avoid memcg even it is powerful feature.

Memory notifications are quite irrelevant to partitioning and cgroups. The use-case is related to user-space handling low memory. Meaning the functionality should be accurate with specific granularity (e.g. 1 MB) and time (0.25s is OK) but better to have it as simple and battery-friendly. I prefer to have pseudo-device-based  text API because it is easy to debug and investigate. It would be nice if it will be possible to use simple scripting to point what kind of memory on which levels need to be tracked but private/shared dirty is #1 and memcg cannot handle it.

There are two use-cases related to this notification feature:

1. direct usage -> reaction to coming low memory situation and do something ahead of time. E.g. system calibrated to 80% dirty memory border, and if we crossed it we can compensate device slowness by flushing application caches, closing background images even notify user but without killing apps by any OOM killer and corruption unsaved data.

2. permission to do some heavy actions. If memory level is low enough for some application use case (e.g. 50 MB available) application can start heavy use-case, otherwise - do something to prevent potential problems. 

So, seems to me, the levels depends from application memory usage e.g. calculator does not need memory information but browser and image gallery needs. Thus, tracking daemons in user-space looks as overhead, and such construction we used in n900 (ke-recv -> dbus -> apps) is quite fragile and slow.
 
These bits [1] was developed initially for n9 to replace memcg notifications with great support of kernel community about a year ago. Unfortunately for n9 I was a bit late and code was integrated to another product's kernel (say M), but at last Summer project M was forced to die due to moving product line to W. Practically arm device produced signals ON/OFF which fit well into space/time requirements, so I have what I need. Even it is quite primitive code but I prefer do not over-engineering complexity without necessity.

Best Wishes,
Leonid

PS: but seems code related to vmpressure_fd solves some other problem so you can ignore my speech. 

[1] http://maemo.gitorious.org/maemo-tools/libmemnotify/blobs/master/src/kernel/memnotify.c
