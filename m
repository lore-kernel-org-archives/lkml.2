Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab2AYAMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 19:12:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab2AYAMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 19:12:22 -0500
Date: Tue, 24 Jan 2012 16:12:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Tuner <pjt@google.com>
Subject: Re: [PATCH v2] proc:  speedup /proc/stat handling
Message-Id: <20120124161221.032325d1.akpm@linux-foundation.org>
In-Reply-To: <1327449683.14373.12.camel@edumazet-laptop>
References: <1327075164.12389.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<1327449683.14373.12.camel@edumazet-laptop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
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

It is pretty bad:

akpm:/usr/src/25> time (for i in $(seq 1000); do; cat /proc/self/stat > /dev/null; done)     
(; for i in $(seq 1000); do; cat /proc/self/stat > /dev/null; done; )  0.05s user 0.94s system 29% cpu 3.367 total

(29% CPU?)

> # strace -T -o /tmp/STRACE cat /proc/stat | wc -c
> 5826
> # grep "cpu " /tmp/STRACE
> read(0, "cpu  1949310 19 2144714 12117253"..., 32768) = 5826 <0.001504>
> 

Did you measure the improvement from this patch?

> Thats partly because show_stat() must be called twice since initial
> buffer size is too small (4096 bytes for less than 32 possible cpus)
> 
> Fix this by :
> 
> 1) Taking into account nr_irqs in the initial buffer sizing.
> 
> 2) Using ksize() to allow better filling of initial buffer.

