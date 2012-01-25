Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab2AYATj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 19:19:39 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59460 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab2AYATh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 19:19:37 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 25 Jan 2012 09:18:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Tuner <pjt@google.com>
Subject: Re: [PATCH v2] proc:  speedup /proc/stat handling
Message-Id: <20120125091818.45e00b3c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1327449683.14373.12.camel@edumazet-laptop>
References: <1327075164.12389.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<1327449683.14373.12.camel@edumazet-laptop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jan 2012 01:01:23 +0100
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> On a typical 16 cpus machine, "cat /proc/stat" gives more than 4096
> bytes, and is slow :
> 
> # strace -T -o /tmp/STRACE cat /proc/stat | wc -c
> 5826
> # grep "cpu " /tmp/STRACE
> read(0, "cpu  1949310 19 2144714 12117253"..., 32768) = 5826 <0.001504>
> 
> 
> Thats partly because show_stat() must be called twice since initial
> buffer size is too small (4096 bytes for less than 32 possible cpus)
> 
> Fix this by :
> 
> 1) Taking into account nr_irqs in the initial buffer sizing.
> 
> 2) Using ksize() to allow better filling of initial buffer.
> 
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Glauber Costa <glommer@parallels.com>
> Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Paul Tuner <pjt@google.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>


Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

BTW, what is the reason of this change ?

> -	unsigned size = 4096 * (1 + num_possible_cpus() / 32);
> +	unsigned size = 1024 + 128 * num_possible_cpus();

I think size of buffer is affected by the number of online cpus.
(Maybe 128 is enough but please add comment why 128 ?)

And
> size += 2 * nr_irqs;

If this assumption fails, the issue comes again...


-Kame

