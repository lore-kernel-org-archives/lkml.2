Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab1GZSdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:33:44 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45229 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab1GZSdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:33:39 -0400
Date: Tue, 26 Jul 2011 20:33:25 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
Message-ID: <20110726183325.GE32536@aftab>
References: <1311340547-7861-1-git-send-email-bp@amd64.org>
 <20110724111350.GD21120@elte.hu>
 <20110724134046.GA10583@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110724134046.GA10583@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 09:40:46AM -0400, Borislav Petkov wrote:
> > also, the PAGE_ALIGN() complication here looks unnecessary - can the
> > vdso 'addr' ever be not 4K aligned above?
> 
> Yeah, it can. I did some trace_printk runs and 'addr' wasn't 4K aligned
> in some cases. I think this is because of the stack randomization we do
> and we use mm->start_stack to get the vdso base address. Unfortunately,
> I can't find those traces anymore but will do some again tomorrow.

Better late than never :).

So yes, mm->start_stack comes in unaligned from setup_arg_pages() and we
use it to generate the vdso VA because the vdso is below the stack:

7fff761f9000-7fff7621a000 rw-p 00000000 00:00 0                          [stack]
7fff763ec000-7fff763ed000 r-xp 00000000 00:00 0                          [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]

here's a trace_printk excerpt from vdso_addr() (gets inlined into
arch_setup_additional_pages()):

           <...>-2516  [006]   624.364274: arch_setup_additional_pages: mm->start_stack: 0x7fff7621942a, len: 4096
           <...>-2516  [006]   624.364278: arch_setup_additional_pages: randomized: 0x7fff763eb42a
           <...>-2516  [006]   624.364279: arch_setup_additional_pages: final addr: 0x7fff763eb42a

Then, both arch_get_unmapped_area{,_topdown} page-align it.

For our case, we PAGE_ALIGN it before randomizing it so that we can
control the [14:12] setting.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
