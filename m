Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab1EDVrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 17:47:13 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42705 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab1EDVrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 17:47:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=J6cBc/R02T3EjzgP3Zke4OpdjX2XDNpcZBxioWBm1c3mtkH/caQLFz4w67mGNa/42U
         IncsHK4oLovIb+MeEu5y5DET5ORTzLaOBamxqYsnRD9XV/GBiaTs1xigC5HNIxq7CWJJ
         2xGa/L3k+OHe8Vu0LSAWfJ25P9jPyOlveuEos=
Message-ID: <4DC1C95B.4040706@gmail.com>
Date: Wed, 04 May 2011 16:47:07 -0500
From: Dave Kleikamp <dkleikamp@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110429 Lightning/1.0b2 OracleBeehiveExtension/1.0.0.2-OracleInternal ObetStats/UAFCAFCATUAFLAF_1301673577011-962016341 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: idle issues running sembench on 128 cpus
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,
I've been looking at performance running sembench on a 128-cpu system 
and I'm running into some issues in the idle loop.

Initially, I was seeing a lot of contention on the clockevents_lock in 
clockevents_notify(). Assuming it is only protecting clockevents_chain, 
and not the handlers themselves, I changed this to an rwlock (with 
thoughts of using rcu if successful).

This didn't help, but exposed an underlying problem with high contention 
on tick_broadcast_lock in tick_broadcast_oneshot_control(). I think with 
this many cpus, tick_handle_oneshot_broadcast() is holding that lock a 
long time, causing the idle cpus to spin on the lock.

I am able to avoid this problem with either kernel parameter, 
"idle=mwait" or "processor.max_cstate=1". Similarly, defining 
CONFIG_INTEL_IDLE=y and using the kernel parameter 
intel_idle.max_cstate=1 exposes a different spinlock, pm_qos_lock, but I 
found this patch which fixes that contention:
https://lists.linux-foundation.org/pipermail/linux-pm/2011-February/030266.html
https://patchwork.kernel.org/patch/550721/

Of course, we'd like to find a way to reduce the spinlock contention and 
not resort to prohibiting the cpus from entering C3 state at all. I 
don't see a simple fix, and want to know if you've seen anything like 
this before and given it any thought.

I also don't know if it makes sense to be able to tune the cpuidle 
governors to add more resistance to enter the C3 state, or even being 
able to switch to a performance governor at runtime, similar to cpufreq.

I'd like to hear your thoughts before I dive any deeper into this.

Thanks,
Shaggy
