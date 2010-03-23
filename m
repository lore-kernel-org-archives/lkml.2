Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab0CWT6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 15:58:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753946Ab0CWT6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 15:58:15 -0400
Date: Tue, 23 Mar 2010 12:52:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Anton Starikov <ant.starikov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bugme-new] [Bug 15618] New: 2.6.18->2.6.32->2.6.33 huge regression
 in performance
In-Reply-To: <20100323112141.7f248f2b.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1003231242420.18017@i5.linux-foundation.org>
References: <bug-15618-10286@https.bugzilla.kernel.org/> <20100323102208.512c16cc.akpm@linux-foundation.org> <20100323173409.GA24845@elte.hu> <alpine.LFD.2.00.1003231037410.18017@i5.linux-foundation.org> <20100323180002.GA2965@elte.hu>
 <15090451-C292-44D6-B2BA-DCBCBEEF429D@gmail.com> <20100323112141.7f248f2b.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 23 Mar 2010, Andrew Morton wrote:
> 
> You should be able to simply set CONFIG_RWSEM_GENERIC_SPINLOCK=n,
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y by hand, as I mentioned earlier?

No. Doesn't work. The XADD code simply never worked on x86-64, which is 
why those three commits I pointed at are required.

Oh, and you need one more commit (at least) in addition to the three I 
already mentioned - the one that actually adds the x86-64 wrappers and 
Kconfig option:

	bafaecd x86-64: support native xadd rwsem implementation

so the minimal list of commits (on top of 2.6.33) is at least

	59c33fa x86-32: clean up rwsem inline asm statements
	5d0b723 x86: clean up rwsem type system
	bafaecd x86-64: support native xadd rwsem implementation
	1838ef1 x86-64, rwsem: 64-bit xadd rwsem implementation

and I just verified that they at least cherry-pick cleanly (in that 
order). I _think_ it would be good to also do

	0d1622d x86-64, rwsem: Avoid store forwarding hazard in __downgrade_write

but that one is a small detail, not anything fundamentally important.

			Linus
