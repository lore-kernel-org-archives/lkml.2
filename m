Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab1DGIIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 04:08:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40189 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755393Ab1DGIIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 04:08:34 -0400
Date: Thu, 7 Apr 2011 10:08:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFT/PATCH v2 1/6] x86-64: Clean up vdso/kernel shared variables
Message-ID: <20110407080825.GF24879@elte.hu>
References: <cover.1302137785.git.luto@mit.edu>
 <c79ac2a9a1caad9865ffa3c4a05438227c59f63e.1302137785.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c79ac2a9a1caad9865ffa3c4a05438227c59f63e.1302137785.git.luto@mit.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@MIT.EDU> wrote:

> Variables that are shared between the vdso and the kernel are
> currently a bit of a mess.  They are each defined with their own
> magic, they are accessed differently in the kernel, the vsyscall page,
> and the vdso, and one of them (vsyscall_clock) doesn't even really
> exist.
> 
> This changes them all to use a common mechanism.  All of them are
> delcared in vvar.h with a fixed address (validated by the linker
> script).  In the kernel (as before), they look like ordinary
> read-write variables.  In the vsyscall page and the vdso, they are
> accessed through a new macro VVAR, which gives read-only access.
> 
> The vdso is now loaded verbatim into memory without any fixups.  As a
> side bonus, access from the vdso is faster because a level of
> indirection is removed.

Ok, that's a pretty nice consolidation and speedup.

This layout:

> +DECLARE_VVAR(0, volatile unsigned long, jiffies)
> +DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
> +DECLARE_VVAR(256, int, vgetcpu_mode)

Is spread out too much, using up several separate cachelines with nothing else 
on them. Why not pack it tightly, with natural alignment taken into 
consideration?

Thanks,

	Ingo
