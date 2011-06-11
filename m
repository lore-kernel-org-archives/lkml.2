Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab1FKXZB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 19:25:01 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42319 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab1FKXY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 19:24:59 -0400
Date: Sat, 11 Jun 2011 16:24:16 -0700 (PDT)
Message-Id: <20110611.162416.414198854514319441.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: netdev@vger.kernel.org, andi@firstfloor.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, mingo@elte.hu, tj@kernel.org,
        cl@linux-foundation.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next-2.6] snmp: reduce percpu needs by 50%
From: David Miller <davem@davemloft.net>
In-Reply-To: <1307771151.2872.72.camel@edumazet-laptop>
References: <1307602166.3980.92.camel@edumazet-laptop>
	<20110608.235113.2177191884416780789.davem@davemloft.net>
	<1307771151.2872.72.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 11 Jun 2011 16:24:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sat, 11 Jun 2011 07:45:51 +0200

> SNMP mibs use two percpu arrays, one used in BH context, another in USER
> context. With increasing number of cpus in machines, and fact that ipv6
> uses per network device ipstats_mib, this is consuming a lot of memory
> if many network devices are registered.
> 
> commit be281e554e2a (ipv6: reduce per device ICMP mib sizes) shrinked
> percpu needs for ipv6, but we can reduce memory use a bit more.
> 
> With recent percpu infrastructure (irqsafe_cpu_inc() ...), we no longer
> need this BH/USER separation since we can update counters in a single
> x86 instruction, regardless of the BH/USER context.
> 
> Other arches than x86 might need to disable irq in their
> irqsafe_cpu_inc() implementation : If this happens to be a problem, we
> can make SNMP_ARRAY_SZ arch dependent, but a previous poll
> ( https://lkml.org/lkml/2011/3/17/174 ) to arch maintainers did not
> raise strong opposition.
> 
> Only on 32bit arches, we need to disable BH for 64bit counters updates
> done from USER context (currently used for IP MIB)
> 
> This also reduces vmlinux size :
> 
> 1) x86_64 build
> $ size vmlinux.before vmlinux.after
>    text	   data	    bss	    dec	    hex	filename
> 7853650	1293772	1896448	11043870	 a8841e	vmlinux.before
> 7850578	1293772	1896448	11040798	 a8781e	vmlinux.after
> 
> 2) i386  build
> $ size vmlinux.before vmlinux.afterpatch 
>    text	   data	    bss	    dec	    hex	filename
> 6039335	 635076	3670016	10344427	 9dd7eb	vmlinux.before
> 6037342	 635076	3670016	10342434	 9dd022	vmlinux.afterpatch
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Looks good to me, applied, thanks Eric.
