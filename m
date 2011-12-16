Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251Ab1LPRSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 12:18:46 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57746 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab1LPRSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 12:18:39 -0500
Message-ID: <1324055915.25554.69.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] slub: prefetch next freelist pointer in slab_alloc()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, "Alex,Shi" <alex.shi@intel.com>,
        Shaohua Li <shaohua.li@intel.com>, Matt Mackall <mpm@selenic.com>
Date: Fri, 16 Dec 2011 18:18:35 +0100
In-Reply-To: <alpine.DEB.2.00.1112161030270.26651@router.home>
References: <1324049134.25554.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <alpine.DEB.2.00.1112161030270.26651@router.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 16 décembre 2011 à 10:31 -0600, Christoph Lameter a écrit :
> On Fri, 16 Dec 2011, Eric Dumazet wrote:
> 
> > Recycling a page is a problem, since freelist link chain is hot on
> > cpu(s) which freed objects, and possibly very cold on cpu currently
> > owning slab.
> 
> Good idea. How do the tcp benchmarks look after this?
> 
> Looks sane.
> 
> Acked-by: Christoph Lameter <cl@linux.com>

Thanks !

I wouldnt expect TCP being a huge win (most of cpu is consumed in tcp
stack, not really memory allocations), but still...

[I expect much better gain on an UDP load, where memory allocator costs
are higher ]

$ cat netperf.sh
for in in `seq 1 32`
do
 netperf -H 192.168.20.110 -v 0 -l -100000 -t TCP_RR &
done
wait

If cpu0 handles network interrupts, and other cpus run applications :

Before

 Performance counter stats for './netperf.sh':

      38001,927957 task-clock                #    2,344 CPUs utilized          
         3 306 138 context-switches          #    0,087 M/sec                  
                79 CPU-migrations            #    0,000 M/sec                  
             9 656 page-faults               #    0,000 M/sec                  
    83 564 329 446 cycles                    #    2,199 GHz                    
    61 350 744 867 stalled-cycles-frontend   #   73,42% frontend cycles idle   
    34 907 541 687 stalled-cycles-backend    #   41,77% backend  cycles idle   
    44 739 971 752 instructions              #    0,54  insns per cycle        
                                             #    1,37  stalled cycles per insn
     8 662 005 669 branches                  #  227,936 M/sec                  
       249 555 153 branch-misses             #    2,88% of all branches        

      16,214220448 seconds time elapsed

After :

 Performance counter stats for './netperf.sh':

      37035,347847 task-clock                #    2,374 CPUs utilized          
         3 314 540 context-switches          #    0,089 M/sec                  
               131 CPU-migrations            #    0,000 M/sec                  
             9 691 page-faults               #    0,000 M/sec                  
    81 783 678 294 cycles                    #    2,208 GHz                    
    59 595 242 695 stalled-cycles-frontend   #   72,87% frontend cycles idle   
    34 367 813 304 stalled-cycles-backend    #   42,02% backend  cycles idle   
    44 698 853 546 instructions              #    0,55  insns per cycle        
                                             #    1,33  stalled cycles per insn
     8 654 940 308 branches                  #  233,694 M/sec                  
       245 578 562 branch-misses             #    2,84% of all branches        

      15,597940419 seconds time elapsed


