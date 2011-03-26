Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab1CZTaj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 15:30:39 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:26143 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753659Ab1CZTai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 15:30:38 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: zuebq10VM1nf47uEk5ZbnQUPRZiEi8kw2Mxe8WOdlYaYuIo
 9DP4lUt81ykmQEUdFkyDblFsNOKZH_IAozYhdOCbypSZf_99mJwM7NDjB0Bd
 VwRDKnIG8oVLmCwN8lNcpmvzGupVJ2tvLNrFrLiDQJ2Amuw_fJi3UliZ3wYV
 85eRL6gJ3Xh8xsO0J_kmVmER1QMnX8iOauBpl8RYC2sFFUhZ1Ut5Ilj_2iza
 pfXfVlpEyKM59.BPNRpSqf1NoX8dvN3GpFmYN73RB9bI9tlhQHIvpZclWyxA
 TkM3sePt4_UobpqFJOsOiCBAa6.NRY.yH6EuyW8DsTV2nQT39
X-Yahoo-Newman-Property: ymail-3
Date: Sat, 26 Mar 2011 14:30:33 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tj@kernel.org, npiggin@kernel.dk,
        rientjes@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] slub: Disable the lockless allocator
In-Reply-To: <alpine.DEB.2.00.1103261406420.24195@router.home>
Message-ID: <alpine.DEB.2.00.1103261428200.25375@router.home>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>  <20110324142146.GA11682@elte.hu>  <alpine.DEB.2.00.1103240940570.32226@router.home>  <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>  <20110324172653.GA28507@elte.hu> <20110324185258.GA28370@elte.hu>
  <alpine.LFD.2.00.1103242005530.31464@localhost6.localdomain6>  <20110324192247.GA5477@elte.hu>  <AANLkTinBwM9egao496WnaNLAPUxhMyJmkusmxt+ARtnV@mail.gmail.com>  <20110326112725.GA28612@elte.hu>  <20110326114736.GA8251@elte.hu> <1301161507.2979.105.camel@edumazet-laptop>
 <alpine.DEB.2.00.1103261406420.24195@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indeed I can reproduce it easily.
With a few printk's this shows that alloc_percpu() returns a wrong
address which is the cause of all of this:

logs:

Memory: 1011444k/1048564k available (11622k kernel code, 452k absent,
36668k reserved, 6270k data, 1028k init)
alloc_kmem_cache_cpus kmem_cache_node = ffff88003ffcf000
alloc_kmem_cache_cpus kmem_cache = ffff88003ffcf020

This means that the cpu_slab is not a percpu pointer.

Now the first allocation attempt:

Slab kmem_cache cpu_slab=ffff88003ffcf020 freelist=ffff88003f8020c0
BUG: unable to handle kernel paging request at ffff87ffc1fdc020
IP: [<ffffffff812c3852>] this_cpu_cmpxchg16b_emu+0x2/0x1c

Tejun: Whats going on there? I should be getting offsets into the per cpu
area and not kernel addresses.

