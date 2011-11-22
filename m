Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab1KVHsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 02:48:41 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39011 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab1KVHsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 02:48:39 -0500
Message-ID: <1321948113.27077.24.camel@edumazet-laptop>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Christian Kujau <lists@nerdbynature.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Date: Tue, 22 Nov 2011 08:48:33 +0100
In-Reply-To: <alpine.DEB.2.00.1111212105330.19606@router.home>
References: <20111121131531.GA1679@x4.trippels.de>
	  <1321884966.10470.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	  <20111121153621.GA1678@x4.trippels.de>
	  <1321890510.10470.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	  <20111121161036.GA1679@x4.trippels.de>
	 <1321894353.10470.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	  <1321895706.10470.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	  <20111121173556.GA1673@x4.trippels.de>
	  <1321900743.10470.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	  <20111121185215.GA1673@x4.trippels.de>
	 <20111121195113.GA1678@x4.trippels.de> <1321907275.13860.12.camel@pasglop>
	 <alpine.DEB.2.01.1111211617220.8000@trent.utfs.org>
	 <alpine.DEB.2.00.1111212105330.19606@router.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 21 novembre 2011 à 21:18 -0600, Christoph Lameter a écrit :

> Hmmm... That means that c->page points to page not frozen. Per cpu
> partial pages are frozen until they are reused or until the partial list
> is flushed.
> 
> Does this ever happen on x86 or only on other platforms? In put_cpu_partial() the
> this_cpu_cmpxchg really needs really to be irq safe. this_cpu_cmpxchg is
> only preempt safe.
> 
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c	2011-11-21 21:15:41.575673204 -0600
> +++ linux-2.6/mm/slub.c	2011-11-21 21:16:33.442336849 -0600
> @@ -1969,7 +1969,7 @@
>  		page->pobjects = pobjects;
>  		page->next = oldpage;
> 
> -	} while (this_cpu_cmpxchg(s->cpu_slab->partial, oldpage, page) != oldpage);
> +	} while (irqsafe_cpu_cmpxchg(s->cpu_slab->partial, oldpage, page) != oldpage);
>  	stat(s, CPU_PARTIAL_FREE);
>  	return pobjects;
>  }
> 

For x86, I wonder if our !X86_FEATURE_CX16 support is correct on SMP
machines.

this_cpu_cmpxchg16b_emu() claims to be IRQ safe, but may be buggy...

Could we have somewhere a NMI handler calling kmalloc() ?

Please Markus send us :

cat /proc/cpuinfo



