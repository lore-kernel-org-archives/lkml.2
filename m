Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab1I0Miy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 08:38:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:55582 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab1I0Mix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 08:38:53 -0400
Subject: Re: [PATCH v5 3.1.0-rc4-tip 18/26]   uprobes: slot allocation.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 27 Sep 2011 14:37:59 +0200
In-Reply-To: <20110920120335.25326.50673.sendpatchset@srdronam.in.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
	 <20110920120335.25326.50673.sendpatchset@srdronam.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317127079.15383.52.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 17:33 +0530, Srikar Dronamraju wrote:
> +static unsigned long xol_take_insn_slot(struct uprobes_xol_area *area)
> +{
> +       unsigned long slot_addr, flags;
> +       int slot_nr;
> +
> +       do {
> +               spin_lock_irqsave(&area->slot_lock, flags);
> +               slot_nr = find_first_zero_bit(area->bitmap, UINSNS_PER_PAGE);
> +               if (slot_nr < UINSNS_PER_PAGE) {
> +                       __set_bit(slot_nr, area->bitmap);
> +                       slot_addr = area->vaddr +
> +                                       (slot_nr * UPROBES_XOL_SLOT_BYTES);
> +                       atomic_inc(&area->slot_count);
> +               }
> +               spin_unlock_irqrestore(&area->slot_lock, flags);
> +               if (slot_nr >= UINSNS_PER_PAGE)
> +                       xol_wait_event(area);
> +
> +       } while (slot_nr >= UINSNS_PER_PAGE);
> +
> +       return slot_addr;
> +} 

Why isn't a find_first_bit() + set_and_test_bit() not sufficient? That
is, what do you need that lock for?
