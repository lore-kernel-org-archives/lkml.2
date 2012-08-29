Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab2H2LmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 07:42:04 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:41345 "HELO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752677Ab2H2LmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 07:42:00 -0400
Message-ID: <503DFFF4.4060909@mellanox.com>
Date: Wed, 29 Aug 2012 14:41:40 +0300
From: Haggai Eran <haggaie@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Shachar Raindel <raindel@mellanox.com>
Subject: Re: [patch v3.6] mm, slab: lock the correct nodelist after reenabling
 irqs
References: <503CA1A2.90104@mellanox.com> <alpine.DEB.2.00.1208281947100.24229@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1208281947100.24229@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.0.13.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/08/2012 05:57, David Rientjes wrote:
> On Tue, 28 Aug 2012, Haggai Eran wrote:
>
>> Hi,
>>
>> I believe I have encountered a bug in kernel 3.6-rc3. It starts with the
>> assertion in mm/slab.c:2629 failing, and then the system hangs. I can
>> reproduce this bug by running a large compilation (compiling the kernel
>> for instance).
>>
>> Here's what I see in netconsole:
>>> ------------[ cut here ]------------
>>> kernel BUG at mm/slab.c:2629!
>>> invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
>> I'm attaching netconsole logs I got with kernel 3.6-rc1, which contain a
>> little more details after the crash, but for some reason netconsole
>> didn't capture the full stack trace of the assertion. I caught a glimpse
>> at the console and I saw RIP was at cache_alloc_refill.
>>
> It only gets called from cache_alloc_refill().
>
> Looks like a problem in 072bb0aa5e0 ("mm: sl[au]b: add knowledge of 
> PFMEMALLOC reserve pages").  cache_grow() can reenable irqs which allows 
> this to be scheduled on a different cpu, possibly with a different node.  
> So it turns out that we lock the wrong node's list_lock because we don't 
> check the new node id when irqs are disabled again.
>
> I doubt you can reliably reproduce this, but the following should fix the 
> issue.
Your patch did solve the issue. Thanks!
