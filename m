Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933837Ab1CXTF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:05:58 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:23548 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933826Ab1CXTFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:05:55 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: L3n3ONAVM1k7uhjLc53s0UW90D8rNnEtQ5ycsbQogz6Rmjs
 x91LKewA.JxKHlCXVZ8dAoSkhgS_q5EROKGpbNhy.r3O.hMlIX9anIr3VhYN
 LNNAb2bEjjKxGBzp9ZGIejfcHwCWlmPlHIBj8uuX_A9pX7u4aOBLb2jsWPnd
 ubpeV05yx.rA6kJtvOG3sLB5pzf8BNwmBl4RoauOR7Ats7XuNoS7L37yuiwz
 PJls442hl_JE4agw8enGcCWqQ8W0Is89MkotD7M4kYPGdcCPgqSpIBWK92y3
 20HcR1xmWVqMXnMDJlGKWU8fzUnfj5j8aMeILEw.g2z8k9PcG
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 24 Mar 2011 14:05:51 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
In-Reply-To: <AANLkTi=66Q-8=AV3Y0K28jZbT3ddCHy9azWedoCC4Nrn@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1103241404490.5576@router.home>
References: <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com> <20110324172653.GA28507@elte.hu> <alpine.DEB.2.00.1103241242450.32226@router.home> <AANLkTimMcP-GikCCndQppNBsS7y=4beesZ4PaD6yh5y5@mail.gmail.com> <alpine.DEB.2.00.1103241300420.32226@router.home>
 <AANLkTi=KZQd-GrXaq4472V3XnEGYqnCheYcgrdPFE0LJ@mail.gmail.com> <alpine.DEB.2.00.1103241312280.32226@router.home> <1300990853.3747.189.camel@edumazet-laptop> <alpine.DEB.2.00.1103241346060.32226@router.home> <AANLkTik3rkNvLG-rgiWxKaPc-v9sZQq96ok0CXfAU+r_@mail.gmail.com>
 <20110324185903.GA30510@elte.hu> <AANLkTi=66Q-8=AV3Y0K28jZbT3ddCHy9azWedoCC4Nrn@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011, Pekka Enberg wrote:

> It hanged here which is pretty much expected on this box if
> kmem_cache_init() oopses. I'm now trying to see if I'm able to find
> the config option that breaks things. CONFIG_PREEMPT_NONE is a
> suspect:
>
> penberg@tiger:~/linux$ grep PREEMPT ../config-ingo
> # CONFIG_PREEMPT_RCU is not set
> CONFIG_PREEMPT_NONE=y
> # CONFIG_PREEMPT_VOLUNTARY is not set
> # CONFIG_PREEMPT is not set

The following patch should ensure that all percpu data is touched
before any emulation functions are called:

---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-03-24 14:03:10.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-03-24 14:04:08.000000000 -0500
@@ -1604,7 +1604,7 @@ static inline void note_cmpxchg_failure(

 void init_kmem_cache_cpus(struct kmem_cache *s)
 {
-#if defined(CONFIG_CMPXCHG_LOCAL) && defined(CONFIG_PREEMPT)
+#ifdef CONFIG_CMPXCHG_LOCAL
 	int cpu;

 	for_each_possible_cpu(cpu)
