Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab1GFNwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 09:52:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57914 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab1GFNwN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 09:52:13 -0400
Subject: Re: [PATCH 1/4] perf: Add memory load/store events generic code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
In-Reply-To: <1309931621.18875.130.camel@minggr.sh.intel.com>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
	 <1309766525-14089-2-git-send-email-ming.m.lin@intel.com>
	 <1309778192.3282.27.camel@twins>  <1309866860.2381.1.camel@localhost>
	 <1309875468.3282.210.camel@twins>
	 <1309931621.18875.130.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 06 Jul 2011 15:51:42 +0200
Message-ID: <1309960302.3282.283.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-06 at 13:53 +0800, Lin Ming wrote:

> Do you mean to use the "impossible combinations" to express the inverse?

Nah, impossible would be things like having neither LOAD nor STORE set.

> MEM_STORE_DCU_MISS as: store-l2-l3-dram
> MEM_STORE_STLB_MISS as: store-itlb-dtlb
> 
> How about below code?

Right, something like that. Robert can the IBS data source data be
mapped onto this as well?

> #define PERF_MEM_LOAD                   (1ULL << 0)
> #define PERF_MEM_STORE                  (1ULL << 1)
> #define PERF_MEM_ATOMIC                 (1ULL << 2)
> #define PERF_MEM_L1                     (1ULL << 3)
> #define PERF_MEM_L2                     (1ULL << 4)
> #define PERF_MEM_L3                     (1ULL << 5)
> #define PERF_MEM_RAM                    (1ULL << 6)
> #define PERF_MEM_UNKNOWN                (1ULL << 7)
> #define PERF_MEM_IO                     (1ULL << 8)
> #define PERF_MEM_UNCACHED               (1ULL << 9)
> #define PERF_MEM_RESERVED               (1ULL << 10)
> #define PERF_MEM_LOCAL                  (1ULL << 11)
> #define PERF_MEM_REMOTE                 (1ULL << 12)
> #define PERF_MEM_SNOOP                  (1ULL << 13)
> #define PERF_MEM_MODIFIED               (1ULL << 14)
> #define PERF_MEM_EXCLUSIVE              (1ULL << 15)
> #define PERF_MEM_SHARED                 (1ULL << 16)
> #define PERF_MEM_INVALID                (1ULL << 17)

> #define PERF_MEM_ITLB                   (1ULL << 18)
> #define PERF_MEM_DTLB                   (1ULL << 19)
> #define PERF_MEM_STLB                   (1ULL << 20)

Are these TLB hit or miss?

> #define PERF_MEM_STORE_L1D_HIT  \
>         (PERF_MEM_STORE | PERF_MEM_L1)
> 
> #define PERF_MEM_STORE_L1D_MISS \
>         (PERF_MEM_STORE | PERF_MEM_L2 | PERF_MEM_L3 | PERF_MEM_RAM)
> 
> #define PERF_MEM_STORE_STLB_HIT \
>         (PERF_MEM_STORE | PERF_MEM_STLB)
>       
> #define PERF_MEM_STORE_STLB_MISS \
>         (PERF_MEM_STORE | PERF_MEM_ITLB | PERF_MEM_DTLB)

Going by the definition in table 30-22 neither of these seem correct, a
STLB_HIT was defined as DTLB|STLB whereas a STLB_MISS was missing both
(resulting in a full page-table walk I presume).

> #define PERF_MEM_STORE_ATOMIC \
>         (PERF_MEM_STORE | PERF_MEM_ATOMIC)
> 
> #define PERF_MEM_LOAD_STLB_HIT  \
>         (PERF_MEM_LOAD | PERF_MEM_STLB)
>    
> #define PERF_MEM_LOAD_STLB_MISS \
>         (PERF_MEM_LOAD | PERF_MEM_ITLB | PERF_MEM_DTLB)

idem

> #define PERF_MEM_LOAD_ATOMIC \
>         (PERF_MEM_LOAD | PERF_MEM_ATOMIC)
> 

