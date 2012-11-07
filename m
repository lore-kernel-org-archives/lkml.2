Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab2KGP6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 10:58:47 -0500
Received: from relay3.sgi.com ([192.48.152.1]:35497 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752128Ab2KGP6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 10:58:45 -0500
Message-ID: <509A8531.9090407@sgi.com>
Date: Wed, 7 Nov 2012 09:58:41 -0600
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 2/2] procfs: /proc/sched_debug fails on very very large
 machines.
References: <1352235741-26478-1-git-send-email-nzimmer@sgi.com> <1352235741-26478-2-git-send-email-nzimmer@sgi.com> <1352235741-26478-3-git-send-email-nzimmer@sgi.com> <20121106213128.GB1762@redhat.com> <20121106232414.GA7338@gulag1.americas.sgi.com> <20121106234949.GA24258@redhat.com>
In-Reply-To: <20121106234949.GA24258@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.169]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 05:49 PM, Dave Jones wrote:
> On Tue, Nov 06, 2012 at 05:24:15PM -0600, Nathan Zimmer wrote:
>   > On Tue, Nov 06, 2012 at 04:31:28PM -0500, Dave Jones wrote:
>   > > On Tue, Nov 06, 2012 at 03:02:21PM -0600, Nathan Zimmer wrote:
>   > >  > On systems with 4096 cores attemping to read /proc/sched_debug fails.
>   > >  > We are trying to push all the data into a single kmalloc buffer.
>   > >  > The issue is on these very large machines all the data will not fit in 4mb.
>   > >  >
>   > >  > A better solution is to not us the single_open mechanism but to provide
>   > >  > our own seq_operations and treat each cpu as an individual record.
>   > >
>   > > Good timing.
>   > >
>   > > This looks like it would solve the problem I just reported here:
>   > > https://lkml.org/lkml/2012/11/6/390
>   > >
>   > > That happens even on an 8-way, so it's not just niche machines that have
>   > > this problems.
>   >
>   > Glad to help. I hadn't thought of memory tight situation but it does make sense
>   > that it helps as it can get by with 4k allocation vs grabbing successively
>   > large chucks.
>   >
>   > If you have seen similar issues with your fuzz testing let me know where and
>   > I'll take a look.
>
> I think /proc/timer_list could probably use the same treatment.
> I had traces showing that using 64k allocations too, but I think I may have
> just bricked my testbox.
>
> 	Dave
>

Yup it looks like /proc/timer_list is doing the thing with single open.

nzimmer@harp50-sys:~> cat /proc/timer_list
cat: /proc/timer_list: Cannot allocate memory
nzimmer@harp50-sys:~>

I'll see if I can squeeze that one in too.
