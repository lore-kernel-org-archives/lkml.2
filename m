Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab0CVKUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 06:20:37 -0400
Received: from www.tglx.de ([62.245.132.106]:49823 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922Ab0CVKUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 06:20:35 -0400
Date: Mon, 22 Mar 2010 11:19:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       Ian Campbell <ian.campbell@citrix.com>, Ingo Molnar <mingo@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, x86@kernel.org,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       lguest@ozlabs.org, Paul Mundt <lethal@linux-sh.org>,
       linux-sh@vger.kernel.org
Subject: Re: [PATCH 01/10] irq: move some interrupt arch_* functions into
 struct irq_chip.
In-Reply-To: <1269221770-9667-2-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.LFD.2.00.1003220950570.3147@localhost.localdomain>
References: <1269221770-9667-1-git-send-email-yinghai@kernel.org> <1269221770-9667-2-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Mar 2010, Yinghai Lu wrote:

> From: Ian Campbell <ian.campbell@citrix.com>
> 
> Move arch_init_copy_chip_data and arch_free_chip_data into function
> pointers in struct irq_chip since they operate on irq_desc->chip_data.

Not sure about that. These functions are solely used by x86 and there
is really no need to generalize them. The problem you try to solve is
x86/xen specific and can be solved by x86_platform_ops as well w/o
adding extra function pointers to irq_chip.

> arch_init_chip_data cannot be moved into struct irq_chip because
> irq_desc->chip is not known at the time the irq_desc is setup. Instead
> rename arch_init_chip_data to arch_init_irq_desc for PowerPC, the
> only other user, whose usage better matches the new name.
> 
> To replace the x86 arch_init_chip_data functionality
> irq_to_desc_alloc_node now takes a pointer to a function to allocate
> the chip data. This is necessary to ensure the allocation happens
> under the correct locking at the core level. On PowerPC and SH

Err, that argument is totally bogus. The calling convention of
irq_to_desc_alloc_node and arch_init_chip_data/arch_init_irq_desc is
still the same. It does not explain why the heck we need that function
pointer at all.

AFAICT the function pointer to irq_to_desc_alloc_node is completely
pointless. It just solves a Xen/x86 specific problem which can be
solved by using x86_platform_ops and keeps the churn x86 internal.

> architectures (the other users of irq_to_desc_alloc_node) pass in NULL
> which retains existing chip_data behaviour.
 
> I've retained the chip_data behaviour for uv_irq although it isn't
> clear to me if these interrupt types support migration or how closely
> related to the APIC modes they really are. If it weren't for this the
> x86_{init,copy,free}_chip_data functions could be static to
> io_apic.c.
> 
> I've tested by booting on an 64 bit x86 system with sparse IRQ enabled
> and 32 bit without, but it's not clear to me what actions I need to
> take to actually exercise some of these code paths.
> 
> -v4: yinghai add irq_to_desc_alloc_node_x...

Aside of the general objection against this, please use descriptive
function names and do not distinguish functions by adding random
characters which tell us absolutely nothing about the purpose.

Thanks,

	tglx
