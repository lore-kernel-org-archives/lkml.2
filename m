Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab1DNLuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 07:50:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45915 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab1DNLuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 07:50:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=i+PX9WIV9S+5792Uzq9rbiOWItC16W8YGcAL0In+0yEKfxrhtQK+m+3szVKcxDtBDH
         f+jRBqnaj1055S88Wl9a5CEYRq+GWb5jewBl927CzTGywDOP1W6GEQVW1KK3LpH/TBUp
         Li/q7b3XwUJnpDmSzpxipyKSxzk+0NmTW6rZ4=
Subject: Re: 2.6.38 sbrk regression
From: raz ben yehuda <raziebe@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, riel@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20110413172127.GB5734@random.random>
References: <1302692638.15225.14.camel@raz.scalemp.com>
	 <20110413125146.GR29444@random.random>
	 <1302703579.17536.1.camel@raz.scalemp.com>
	 <20110413172127.GB5734@random.random>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 14:49:14 +0300
Message-ID: <1302781754.5098.13.camel@raz.scalemp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Andrea
Me again. I managed to ftrace ( function graph ) the two kernels. I used
2.6.37 and 2.6.39-rc3. The bellow is example for sys_brk calls traces
from each kernel. As you can see, there is no "single smoking gun"
here. 

The vm functions durations increased as a whole.
I repeated the tests from sha1 4e9f64c42d0ba5eb0c78569435ada4c224332ce4
compared to sha1 152c9ccb75548c027fa3103efa4fa4e19a345449  and it is
consistent. ~13% performance decrease.

Can you see any relation to thp that might causes this degradation ?

thank you
raz

2.6.39-rc3

 0)       .       |  sys_brk() {
 0)   0.205 us    |    down_write();
 0)   0.256 us    |    find_vma();
 0)               |    do_brk() {
 0)   0.549 us    |      cap_file_mmap();
 0)               |      get_unmapped_area() {
 0)   0.130 us    |        arch_get_unmapped_area_topdown();
 0)   1.112 us    |      }
 0)               |      cap_vm_enough_memory() {
 0)   0.163 us    |        __vm_enough_memory();
 0)   1.408 us    |      }
 0)               |      vma_merge() {
 0)   0.313 us    |        vma_adjust();
 0)   2.315 us    |      }
 0)   9.692 us    |    }
 0)   0.168 us    |    up_write();
 0) + 14.473 us   |  }

2.6.37
 0)               |  sys_brk() {
 0)   0.261 us    |    down_write();
 0)   0.416 us    |    find_vma();
 0)               |    do_brk() {
 0)   0.411 us    |      cap_file_mmap();
 0)               |      get_unmapped_area() {
 0)   0.443 us    |        arch_get_unmapped_area_topdown();
 0)   0.982 us    |      }
 0)               |      cap_vm_enough_memory() {
 0)   0.481 us    |        __vm_enough_memory();
 0)   1.145 us    |      }
 0)               |      vma_merge() {
 0)   0.459 us    |        vma_adjust();
 0)   1.004 us    |      }
 0)   5.423 us    |    }
 0)   0.273 us    |    up_write();
 0)   8.020 us    |  }




On Wed, 2011-04-13 at 19:21 +0200, Andrea Arcangeli wrote:
> On Wed, Apr 13, 2011 at 05:06:19PM +0300, raz ben yehuda wrote:
> > ok, managed to build 38-rc3 ( keep forgetting make mrproper ).
> > problem is still there:
> 
> Oops I thought it was typo on your prev email so I didn't answer
> assuming you would test 39-rc like I suggested in my prev email, I
> really meant 2.6.39-rc3.
> 
> The fix I refer to is d527caf22e48480b102c7c6ee5b9ba12170148f7 and
> it's included in >= 2.6.39-rc1. 38-rc3 has THP but not this
> changeset. We tried to push it for 38 final but it was a bit late so
> it got merged immediately in 39-rc1 to stay on the safe side (it's
> only a performance issue and the other longstanding irq/sched latency
> issues in compaction that got fixed in 39-rc1 where actually more
> relevant than the compaction-kswapd removal).


