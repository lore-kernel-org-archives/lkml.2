Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab1ETRlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 13:41:12 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:60924 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab1ETRlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 13:41:11 -0400
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, davej@redhat.com, kees.cook@canonical.com,
        davem@davemloft.net, eranian@google.com, torvalds@linux-foundation.org,
        adobriyan@gmail.com, penberg@kernel.org
In-Reply-To: <20110520131108.GA17699@elte.hu>
References: <1305292059.1949.0.camel@dan> <1305293345.1949.22.camel@dan>
	 <20110516153527.GC21107@elte.hu> <1305852966.3005.19.camel@dan>
	 <20110520120750.GJ14745@elte.hu> <1305896093.3005.24.camel@dan>
	 <20110520131108.GA17699@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 13:41:01 -0400
Message-ID: <1305913261.20623.12.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 15:11 +0200, Ingo Molnar wrote:

> We need to allocate the IDT dynamically: just kmalloc() it, update idt_descr 
> and do a load_idt(). Double check places that modify idt_descr or use 
> idt_table.
> 
> Note, you could do this as a side effect of a nice performance optimization: 
> would you be interested in allocating it in the percpu area, using 
> percpu_alloc()? That way the IDT is distributed between CPUs - this has 
> scalability advantages on NUMA systems and maybe even on SMP.
> 

Any suggestions on when this allocation should take place?  I'm hesitant
to touch anything in arch/x86/kernel/head_32.S, where the IDT is setup
and lidt idt_descr is called (on x86-32 anyway).  That means at some
point I'd have to copy the table into a region allocated with
alloc_percpu() and set up a new descriptor.  Seems like this should
happen before IRQ is enabled, but I'm not sure about the best place.

Also, I'd still welcome suggestions on generating entropy so early in
the boot process as to randomize the location at which the kernel is
decompressed.

On a related note, would there be obstacles to marking the IDT as
read-only?

Thanks,
Dan

