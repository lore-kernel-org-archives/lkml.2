Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab1HaMgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 08:36:11 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:41037 "EHLO
	ozymandias.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755169Ab1HaMgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 08:36:08 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 31 Aug 2011 06:36:01 -0600
From: emunson@mgebm.net
To: Anton Blanchard <anton@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, <imunsie@au1.ibm.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] perf sort: Improve symbol sort output by separating
 unresolved samples by type
In-Reply-To: <20110831115145.4f598ab2@kryten>
References: <20110831115145.4f598ab2@kryten>
Message-ID: <76545ffbdeb3d0bbddb22479f6d49a89@mgebm.net>
User-Agent: Roundcube Webmail/0.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On Wed, 31 Aug 2011 11:51:45 +1000, Anton Blanchard wrote:
> I took a profile that suggested 60% of total CPU time was in the
> hypervisor:
>
> # perf report --sort symbol
> ...
>     60.20%  [H] 0x33d43c
>      4.43%  [k] ._spin_lock_irqsave
>      1.07%  [k] ._spin_lock
>
> Using perf stat to get the user/kernel/hypervisor breakdown 
> contradicted
> this.
>
> The problem is we merge all unresolved samples into the one unknown
> bucket. If add a comparison by sample type to sort__sym_cmp we get 
> the
> real picture:
>
> # perf report --sort symbol
> ...
>     57.11%  [.] 0x80fbf63c
>      4.43%  [k] ._spin_lock_irqsave
>      1.07%  [k] ._spin_lock
>      0.65%  [H] 0x33d43c
>
> So it was almost all userspace, not hypervisor as the initial profile
> suggested.
>
> I found another issue while adding this. Symbol sorting sometimes 
> shows
> multiple entries for the unknown bucket:
>
> # perf report --sort symbol
> ...
>     16.65%  [.] 0x6cd3a8
>      7.25%  [.] 0x422460
>      5.37%  [.] yylex
>      4.79%  [.] malloc
>      4.78%  [.] _int_malloc
>      4.03%  [.] _int_free
>      3.95%  [.] hash_source_code_string
>      2.82%  [.] 0x532908
>      2.64%  [.] 0x36b538
>      0.94%  [H] 0x8000000000e132a4
>      0.82%  [H] 0x800000000000e8b0
>
> This happens because we aren't consistent with our sorting. On
> one hand we check to see if both symbols match and for two unresolved
> samples sym is NULL so we match:
>
>         if (left->ms.sym == right->ms.sym)
>                 return 0;
>
> On the other hand we use sample IP for unresolved samples when
> comparing against a symbol:
>
>        ip_l = left->ms.sym ? left->ms.sym->start : left->ip;
>        ip_r = right->ms.sym ? right->ms.sym->start : right->ip;
>
> This means unresolved samples end up spread across the rbtree and we
> can't merge them all.
>
> If we use cmp_null all unresolved samples will end up in the one 
> bucket
> and the output makes more sense:
>
> # perf report --sort symbol
> ...
>     39.12%  [.] 0x36b538
>      5.37%  [.] yylex
>      4.79%  [.] malloc
>      4.78%  [.] _int_malloc
>      4.03%  [.] _int_free
>      3.95%  [.] hash_source_code_string
>      2.26%  [H] 0x800000000000e8b0
>
> Signed-off-by: Anton Blanchard <anton@samba.org>


 Acked-by: Eric B Munson <emunson@mgebm.net>

