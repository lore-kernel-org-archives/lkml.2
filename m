Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930Ab2AMWnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 17:43:45 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:23355
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759396Ab2AMWnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 17:43:41 -0500
X-SpamScore: -10
X-BigFish: VS-10(zz1432N98dK4015Lzz1202hzzz2dhc1ahc1bh87h2a8h668h839h8e2h8e3h944hbe9k61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.36.179.113;KIP:(null);UIP:(null);IPV:NLI;H:kedge4.utk.tennessee.edu;RD:kedge4.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 13 Jan 2012 17:43:33 -0500
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: <linux-kernel@vger.kernel.org>
CC: <mingo@elte.hu>, <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: perf_event hard locks 3.1.x
In-Reply-To: <alpine.DEB.2.00.1112161804280.8779@cl320.eecs.utk.edu>
Message-ID: <alpine.DEB.2.00.1201131735480.11102@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1112161804280.8779@cl320.eecs.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 16 Dec 2011, Vince Weaver wrote:

> I had a PAPI user report that perf_event usage (such as running
> the PAPI tests) would cause hard lockups on his 3.1.x kernel
> (from ARCH linux).
> 
> After some tedious bisection of the .config file, I found that the issue
> happens when 
>   CONFIG_SLUB=y
>   CONFIG_SLUB_DEBUG=y
> is enabled.  Having a kernel with that enabled and stressing the 
> perf_event subsystem will eventually cause lockups or hard crashes.

I spent a lot of time trying to track this down, though the problem does 
not appear with stock 3.2.

The problem is still there with 3.1.9, but since that might be the last 
3.1.x kernel it might not matter anymore.

Summary of what I found:
  you need to have CONFIG_SLUB=y
  you can cause the crash by running the PAPI ctests 1-3 times
    (the program that causes the crash is different each time, so 
     no good workaround.  Probably a race condition).

I reverse-bisected the fix between 3.1 and  3.2 (that is to say, I 
bisected to find when the kernels stopped crashing) to this commit:

   commit a33caeb118198286309859f014c0662f3ed54ed4
   lockdep, kmemcheck: Annotate ->lock in lockdep_init_map()

but that fix is already in 3.1.9 and doesn't seem to fix things.

It might also be the next commit 

   commit ddf6e0e50723b62ac76ed18eb53e9417c6eefba7
   ftrace: Fix hash record accounting bug

as the panics in that report look similar to what I see before the 
machine quickly and massively dies, but when I apply this on top of 
3.1.9 it doesn't avoid the crash.

I suspect maybe I was chasing two separate problems, which is why the 
bisect didn't give the proper results.

In any case, I'm abandoning the search for now unless anyone has some 
other ideas I could try.

Thanks,

Vince

