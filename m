Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab2KMI0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:26:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46651 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab2KMI0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:26:53 -0500
Message-ID: <50A2044B.8040002@canonical.com>
Date: Tue, 13 Nov 2012 09:26:51 +0100
From: David Henningsson <david.henningsson@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Arun Raghavan <arun.raghavan@collabora.co.uk>
Subject: Re: getnstimeofday stuck for several milliseconds?
References: <50977DF5.60703@canonical.com> <50A18C0F.9000604@us.ibm.com> <1352765720.18025.21.camel@gandalf.local.home>
In-Reply-To: <1352765720.18025.21.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 01:15 AM, Steven Rostedt wrote:
> On Mon, 2012-11-12 at 15:53 -0800, John Stultz wrote:
>
>> Cc'ing Steven to see if he can't help understand whats going on here.
>
> I don't trust the trace...

Thanks John and Steven!

I've redone the trace with the global clock and got a different stack 
trace, this time at 11 ms in total. (I don't know how much of these 11 
ms are caused from the tracing overhead?)

The result is here:

http://pastebin.se/jxxqf8pt

and most of the time it seems to be these lines repeating:

   compiz-1975    0.N.1   11us+: arch_flush_lazy_mmu_mode <-kmap_atomic_prot
   compiz-1975    0.N.1   16us : __kunmap_atomic <-drm_clflush_page
   compiz-1975    0.N.1   16us : native_flush_tlb_single <-__kunmap_atomic
   compiz-1975    0.N.1   17us : arch_flush_lazy_mmu_mode <-__kunmap_atomic
   compiz-1975    0.N..   18us : drm_clflush_page <-drm_clflush_sg
   compiz-1975    0.N..   18us : kmap_atomic <-drm_clflush_page
   compiz-1975    0.N..   19us : kmap_atomic_prot <-kmap_atomic

There are also occasionally sched* tasks going on at other CPUs. If you 
would excuse a layman's question - why can't we just schedule alsa-sink 
on another CPU, if this one is busy with doing graphics stuff?

For reference, test kernel and test case were the same this time around 
(3.7rc2, then playing a game for a few minutes).


-- 
David Henningsson, Canonical Ltd.
https://launchpad.net/~diwic
