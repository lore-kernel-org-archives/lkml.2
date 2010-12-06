Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab0LFPkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:40:32 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57870 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab0LFPkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:40:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=TMF17Ta+bQ116HASRCq21YgDJZ1asQBoMZOSrrRCNIFsao8yt1LJfLznQAwSTVCQM2
         E4i2216Nw28POhBMcAA2igl3d5eDwGQsG9WPkNB6QMW2vEWwRC4IXgZi2nxGHZY02cLV
         ODmz9vP7HzwK1idiQGzRZM6CyJTDOBE+Zx9dg=
Date: Mon, 6 Dec 2010 10:40:26 -0500 (EST)
From: "Bjoern B. Brandenburg" <bbb.lst@gmail.com>
X-X-Sender: bbb@jupiter-cs.cs.unc.edu
To: Mike Galbraith <efault@gmx.de>
cc: Yong Zhang <yong.zhang0@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Andrea Bastoni <bastoni@sprg.uniroma2.it>,
        "James H. Anderson" <anderson@cs.unc.edu>,
        linux-kernel@vger.kernel.org
Subject: Re: Scheduler bug related to rq->skip_clock_update?
In-Reply-To: <1291613607.9457.5.camel@marge.simson.net>
Message-ID: <alpine.LNX.2.00.1012061031170.8927@jupiter-cs.cs.unc.edu>
References: <alpine.LNX.2.00.1011202315290.8927@jupiter-cs.cs.unc.edu> <1290359641.4816.69.camel@maggy.simson.net> <alpine.LNX.2.00.1011212327250.8927@jupiter-cs.cs.unc.edu> <1290442781.16393.22.camel@maggy.simson.net> <alpine.LNX.2.00.1011221310430.8927@jupiter-cs.cs.unc.edu>
 <20101205052819.GA2878@zhy> <1291613607.9457.5.camel@marge.simson.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Dec 2010, Mike Galbraith wrote:

> On Sun, 2010-12-05 at 13:28 +0800, Yong Zhang wrote:
>
> > when we init idle task, we doesn't mark it on_rq.
> > My test show the concern is smoothed by below patch.
>
> Close :)
>
> The skip_clock_update flag should only be set if rq->curr is on_rq,
> because it it _that_ clock update during dequeue, and subsequent
> microscopic vruntime update it causes that we're trying to avoid.
>
> I think the below fixes it up properly.
>
> Sched: fix skip_clock_update optimization

Mike, Yong,

thanks for looking into this. On the x86_64 host, I'm now see seeing
delays of less than 0.1ms, which seems fine. On the ARM host, I'm seeing
delays of up to ~2.5ms. However, this only happens on CPU0, which makes me
think that it is probably just a byproduct of interrupts.

bbb@district10:~$ egrep 'cpu#|skip' /proc/sched_debug
cpu#0
  .skip_clock_count              : 98494
  .skip_clock_recent_max         : 2543000
  .skip_clock_max                : 9876875
cpu#1
  .skip_clock_count              : 61084
  .skip_clock_recent_max         : 861750
  .skip_clock_max                : 1382875
cpu#2
  .skip_clock_count              : 60846
  .skip_clock_recent_max         : 193375
  .skip_clock_max                : 2236500
cpu#3
  .skip_clock_count              : 60270
  .skip_clock_recent_max         : 318750
  .skip_clock_max                : 1679000
bbb@district10:~$ cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3
 33:         29          0          0          0         GIC  timer
 35:         49          0          0          0         GIC  isp1760-hcd:usb1
 36:        145          0          0          0         GIC  uart-pl011
 39:         10          0          0          0         GIC  kmi-pl050
 40:        116          0          0          0         GIC  kmi-pl050
 41:     215789          0          0          0         GIC  eth0
 46:          0          0          0          0         GIC  mmci-pl18x (cmd)
 47:          0          0          0          0         GIC  mmci-pl18x (pio)
IPI:     102721     103079      94532     111227
LOC:     115129     114840     114166     115122
Err:          0

So the latest patch seems to solve the issue.

Tested-by: Bjoern B. Brandenburg <bbb.lst@gmail.com>

Btw, I think this patch is a good candidate for the .36-stable tree since
it fixes a major regression.

Thanks,
Bjoern
