Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab0LVNKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:10:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48159 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000Ab0LVNKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:10:37 -0500
Date: Wed, 22 Dec 2010 14:09:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Len Brown <lenb@kernel.org>,
        Jack Steiner <steiner@sgi.com>, Lori Gilbertson <loriann@sgi.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: Early kernel messages are overflowing the static log buffer
Message-ID: <20101222130946.GC13412@elte.hu>
References: <4D06B317.2090608@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D06B317.2090608@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> So it seems we need to reduce the number of messages.

Absolutely!

> The voluminous message sources before buffer reallocation are:
> 
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000008f000
> (usable)                                              ...
> [    0.000000] EFI: mem00: type=3, attr=0xf,
> range=[0x0000000000000000-0x0000000000001000) (0MB)
> [    ...
> [    0.000000] modified physical RAM map:
> [    0.000000]  modified: 0000000000000000 - 0000000000001000
> (usable)                         ...
> [    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
> ...
> [    0.000000] Bootmem setup node 0 0000000000000000-0000000800000000
> [    0.000000]   NODE_DATA [000000000000e100 - 00000000000420ff]
> [    0.000000]   bootmap [0000000000100000 -  00000000001fffff] pages 100
> ...
> [    0.000000] early_node_map[137] active PFN ranges
> [    0.000000]     0: 0x00000000 -> 0x00000001
> ...
> [    0.000000] On node 1 totalpages: 8388608
> [    0.000000]   Normal zone: 114688 pages used for memmap
> [    0.000000]   Normal zone: 8273920 pages, LIFO batch:31
> ...
> [    0.000000] ACPI: X2APIC (apic_id[0x00] uid[0x00] enabled)
> ...
> [    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000006000
> ...
> [    0.000000] pcpu-alloc: [000] 0000 0001 0002 0003 0004 0005 0006 0007 1024 1025 1026 1027 1028 1029 1030 1031
> 
> What I'm asking is which of these would be most acceptable to
> either remove or replace with some sort of message reduction?

The pcpu alloc messages look entirely superfluous and zappable - make them 
KERN_DEBUG perhaps (and Cc: Tejun)?

> Note that a lot of the messages are completely redundant.  Like
> the Bootmem setup generally has exactly the same information
> (spread over 15 lines), for each of the 128 Nodes.

Yeah.

> One patch that I still have was David's "reduce srat verbosity in
> the kernel log" that was rejected by you as too complex.  This
> would have resulted in about a 16:1 reduction in SRAT: messages,
> without loss of an information.  Before I start another doomed patch,
> I'd like to find out the guidelines.  Remember, no one really looks
> at these messages unless the system panics, usually during startup.
> So the information here may be key to diagnosing the problem.

Mind resending that patch again? Maybe we can find a simpler solution. I almost 
never NAK patches permanently - there can always be reasons i missed, or better 
implementations.

We dont want to lose physical memory layout information - it's useful in many other 
types of post mortem analysis and we dont want to force people to reboot into some 
debug kernel just to be able to report essential bits.

Thanks,

	Ingo
