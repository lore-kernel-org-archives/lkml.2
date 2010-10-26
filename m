Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759822Ab0JZK5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:57:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759745Ab0JZK5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:57:34 -0400
Date: Tue, 26 Oct 2010 06:57:13 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Richard Kralovic <Richard.Kralovic@dcs.fmph.uniba.sk>
Cc: Milan Broz <mbroz@redhat.com>, linux-kernel@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: CFQ and dm-crypt
Message-ID: <20101026105713.GA29672@redhat.com>
References: <4CC439ED.8090400@dcs.fmph.uniba.sk>
 <4CC45BAD.2060308@redhat.com>
 <4CC553A3.5070308@dcs.fmph.uniba.sk>
 <20101025205934.GC23426@redhat.com>
 <4CC69335.4090301@dcs.fmph.uniba.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC69335.4090301@dcs.fmph.uniba.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 10:37:09AM +0200, Richard Kralovic wrote:
> On 10/25/10 22:59, Vivek Goyal wrote:
> > Richard,
> > 
> > So what problem are you facing? I know you are referring to CFQ ioprio not
> > working with dm targets but how does it impact you? So it is not about
> > overall disk performance or any slow down with dm-crypt target but just
> > about prioritizing your IO over other?
> 
> The ioprio not working is probably the biggest problem (since it is used
> quite a lot for background tasks like desktop indexing services). But
> also the overall performance is worse. I didn't do a rigorous
> benchmarking, but tried a following simple test to see the impact of my
> dm-crypt patch:
> 
> test-write:
> 
> SIZE=640
> 
> 
> KERN=`uname -r`
> ((time /bin/bash -c "dd if=/dev/zero bs=1M count=64 \
>    of=normal.tst oflag=direct") 1>$KERN-write-normal 2>&1) |
> ((time /bin/bash -c "ionice -c 3 dd if=/dev/zero bs=1M \
>    count=64 of=idle.tst oflag=direct") 1>$KERN-write-idle 2>&1)
> 
> Times for vanilla kernel (with CFQ) were 5.24s for idle and 5.38s for
> normal, times for patched kernel were 4.9s for idle and 3.13s for
> normal. A similar test for reading showed even bigger differences:
> vanilla kernel has 8.5s for idle as well as 8.5s for normal, patched
> kernel has 4.2s for idle and 2.1s for normal.
> 
> So it seems that CFQ is behaving really badly if it is not able to see
> which process is doing the IO (and sees kcryptd everywhere). As far as I
> understood, there is no point in using CFQ in that case and it is much
> better to use other scheduler in this situation.

Ok, so are you getting better results with noop and deadline?

So your bigger concerns seems to be not necessarily making ioprio and
class working but why there is a performance drop when dm-crypt starts
submitting IOs with the help of a worker thread and we lose original
context.

If you are getting better numbers say with noop, then I would think that
somehow we are idling a lot in CFQ (with dm-crypt) and it is overshadowing
the benefits of reduced seeks due to idling (if any). 

Is it possible to capture a trace with CFQ using blktrace. Say 30 second
trace for two cases. Vanilla CFQ and patched CFQ with normal case (Will
look into the case of IDLE later). I want to compare two traces and see
what changed in terms of idling.

One explanation could that your workload is sequential (dd case), and
by exposing the context to CFQ you are getting the idling right and
reducing some seeks. By submitting everything from kcryptd, I think it
practically becomes a seeky traffic (read/write intermixed) and increased
seeks reduce throughput. But if this is the case, same should be true
for noop and i do not understand why you would get better performance
with noop.

Anyway, looking at blktrace might give some idea.

Thanks
Vivek
