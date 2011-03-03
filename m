Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab1CCSpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 13:45:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52336
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758451Ab1CCSpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 13:45:07 -0500
Date: Thu, 03 Mar 2011 10:45:42 -0800 (PST)
Message-Id: <20110303.104542.104052570.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, aarcange@redhat.com,
        tglx@linutronix.de, riel@redhat.com, mingo@elte.hu,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org,
        benh@kernel.crashing.org, hugh.dickins@tiscali.co.uk, mel@csn.ul.ie,
        npiggin@kernel.dk, rmk@arm.linux.org.uk, schwidefsky@de.ibm.com
Subject: Re: [RFC][PATCH 2/6] mm: Change flush_tlb_range() to take an
 mm_struct
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D6FCE5D.4030904@tilera.com>
References: <1299102027.1310.39.camel@laptop>
	<20110302.134735.260066220.davem@davemloft.net>
	<4D6FCE5D.4030904@tilera.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 3 Mar 2011 12:22:37 -0500

> I'm finding it hard to understand how the Sparc code handles icache
> coherence.  It seems that the Spitfire MMU is the interesting one, but the
> hard case seems to be when a process migrates around to various cores
> during execution (thus leaving incoherent icache lines everywhere), and the
> page is then freed and re-used for different executable code.  I'd think
> that there would have to be xcall IPIs to flush all the cpus' icaches, or
> to flush every core in the cpu_vm_mask plus do something at context switch,
> but I don't see any of that.  No doubt I'm missing something :-)

flush_dcache_page() remembers the cpu that wrote to the page (in the
page flags), and cross-calls to that specific cpu.

It is only that cpu which must flush his I-cache, since all other cpus
saw the write on the bus and updated their I-cache lines as a result.

See, in the sparc64 case, the incoherency issue is purely local to the
store.  The problem case is specifically the local I-cache not seeing
local writes, everything else is fine.  CPU I-caches see writes done
by other cpus, just not those done by the local cpu.

