Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab2KEIvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:51:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40805 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab2KEIvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 03:51:07 -0500
Message-ID: <50977DF5.60703@canonical.com>
Date: Mon, 05 Nov 2012 09:51:01 +0100
From: David Henningsson <david.henningsson@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: tglx@linutronix.de, johnstul@us.ibm.com
Subject: getnstimeofday stuck for several milliseconds?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi LKML,

I'm trying to make audio more useful in everyday low-latency scenarios 
such as gaming or VOIP.

While doing so, I ran the wakeup_rt tracer, to track the time from 
PulseAudio requesting wakeup (through hrtimers), to the thread actually 
running.

I'm not sure how much overhead added by the wakeup_rt tracer itself, but 
I got 9 ms on one machine and 20 ms on another, which I consider to be 
quite a lot even for a standard kernel (i e without RT or other special 
configuration).

The 9 ms example is pastebinned at [1], and here's where we get stuck 
for most of the time:

   <idle>-0       3d... 1105us : ktime_get_real <-intel_idle
   <idle>-0       3d... 1106us!: getnstimeofday <-ktime_get_real
   <idle>-0       3d... 7823us : ktime_get_real <-intel_idle

   <idle>-0       3d... 7890us : ktime_get_real <-intel_idle
   <idle>-0       3d... 7891us!: getnstimeofday <-ktime_get_real
   <idle>-0       3d... 9023us : ktime_get_real <-intel_idle

It seems to me that sometimes we get stuck for several milliseconds 
inside the getnstimeofday function - this was seen on both the 9 ms and 
the 20 ms trace. This looks like a bug to me, and as I'm not sure on how 
to best debug it further, and therefore I'm asking for help (or a bug 
fix!) here.

For reference, the 9 ms trace was from a ~2 year old laptop (core i3 
cpu) running 3.7rc2 vanilla/mainline kernel, and the 20 ms trace was 
from an ~1 year old Atom-based machine running the 3.2-ubuntu kernel. 
While tracing was enabled, I was running a libSDL game for a minute or two.

Thanks in advance for looking into this, and let me know if you need 
further information, or anything else I can do to help sorting this one out.

-- 
David Henningsson, Canonical Ltd.
https://launchpad.net/~diwic

[1] http://pastebin.se/6iMRdDfR
