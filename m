Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850Ab0JZIhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 04:37:17 -0400
Received: from element.ksp.sk ([158.195.16.154]:60973 "EHLO ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757551Ab0JZIhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 04:37:14 -0400
Message-ID: <4CC69335.4090301@dcs.fmph.uniba.sk>
Date: Tue, 26 Oct 2010 10:37:09 +0200
From: Richard Kralovic <Richard.Kralovic@dcs.fmph.uniba.sk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100917 Icedove/3.0.8
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Milan Broz <mbroz@redhat.com>, linux-kernel@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: CFQ and dm-crypt
References: <4CC439ED.8090400@dcs.fmph.uniba.sk> <4CC45BAD.2060308@redhat.com> <4CC553A3.5070308@dcs.fmph.uniba.sk> <20101025205934.GC23426@redhat.com>
In-Reply-To: <20101025205934.GC23426@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/10 22:59, Vivek Goyal wrote:
> Richard,
> 
> So what problem are you facing? I know you are referring to CFQ ioprio not
> working with dm targets but how does it impact you? So it is not about
> overall disk performance or any slow down with dm-crypt target but just
> about prioritizing your IO over other?

The ioprio not working is probably the biggest problem (since it is used
quite a lot for background tasks like desktop indexing services). But
also the overall performance is worse. I didn't do a rigorous
benchmarking, but tried a following simple test to see the impact of my
dm-crypt patch:

test-write:

SIZE=640


KERN=`uname -r`
((time /bin/bash -c "dd if=/dev/zero bs=1M count=64 \
   of=normal.tst oflag=direct") 1>$KERN-write-normal 2>&1) |
((time /bin/bash -c "ionice -c 3 dd if=/dev/zero bs=1M \
   count=64 of=idle.tst oflag=direct") 1>$KERN-write-idle 2>&1)

Times for vanilla kernel (with CFQ) were 5.24s for idle and 5.38s for
normal, times for patched kernel were 4.9s for idle and 3.13s for
normal. A similar test for reading showed even bigger differences:
vanilla kernel has 8.5s for idle as well as 8.5s for normal, patched
kernel has 4.2s for idle and 2.1s for normal.

So it seems that CFQ is behaving really badly if it is not able to see
which process is doing the IO (and sees kcryptd everywhere). As far as I
understood, there is no point in using CFQ in that case and it is much
better to use other scheduler in this situation.


	Richard
