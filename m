Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031513Ab2CVXpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 19:45:21 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39476 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab2CVXpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 19:45:16 -0400
MIME-Version: 1.0
In-Reply-To: <1332459220.16101.144.camel@sbsiddha-desk.sc.intel.com>
References: <1332459220.16101.144.camel@sbsiddha-desk.sc.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 22 Mar 2012 16:44:54 -0700
X-Google-Sender-Auth: 68p5hnL9Qc2i9jesuhMbMU6y1_c
Message-ID: <CA+55aFyf9RqAROx7t=CYUSGCDBXvv9z2c+LP1vRJjLU45_pD+Q@mail.gmail.com>
Subject: Re: [patch] x86, tlb: switch cr3 in leave_mm() only when needed
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 4:33 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
>
> Currently leave_mm() unconditionally switches the cr3 to swapper_pg_dir.
> But there is no need to change the cr3, if we already left that mm.
>
> intel_idle() for example calls leave_mm() on every deep c-state entry where
> the CPU flushes the TLB for us. Similarly flush_tlb_all() was also calling
> leave_mm() whenever the TLB is in LAZY state. Both these paths will be
> improved with this change.

Hmm. If this is reasonably common (and intel_idle() certainly is),
maybe we shouldn't even do the "test_and_clear" RMW cycle.

We could do it with a read-only bit test (no races I can see - if it's
clear, it will stay clear), so we could do this with

    if (cpumask_test_cpu(cpu, mm_cpumask(active_mm))) {
        cpumask_clear_cpu(cpu,mm_cpumask(active_mm));
        load_cr3(swapper_pg_dir);
    }

instead? And avoid touching that "mm_cpumask" (and the atomic
serializing instruction) when not necessary?

                       Linus
