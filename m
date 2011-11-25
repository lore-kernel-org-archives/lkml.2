Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab1KYOyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 09:54:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:55389 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843Ab1KYOyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 09:54:03 -0500
Subject: Re: [PATCH v7 3.2-rc2 9/30] uprobes: Background page replacement.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>
In-Reply-To: <20111118110823.10512.74338.sendpatchset@srdronam.in.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
	 <20111118110823.10512.74338.sendpatchset@srdronam.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Nov 2011 15:54:46 +0100
Message-ID: <1322232886.2535.7.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 16:38 +0530, Srikar Dronamraju wrote:
> +static int read_opcode(struct mm_struct *mm, unsigned long vaddr,
> +                                               uprobe_opcode_t *opcode)
> +{
> +       struct page *page;
> +       void *vaddr_new;
> +       int ret;
> +
> +       ret = get_user_pages(NULL, mm, vaddr, 1, 0, 0, &page, NULL);
> +       if (ret <= 0)
> +               return ret;
> +
> +       lock_page(page);
> +       vaddr_new = kmap_atomic(page);
> +       vaddr &= ~PAGE_MASK;

BUG_ON(vaddr + uprobe_opcode_sz >= PAGE_SIZE);

> +       memcpy(opcode, vaddr_new + vaddr, uprobe_opcode_sz);
> +       kunmap_atomic(vaddr_new);
> +       unlock_page(page);
> +       put_page(page);         /* we did a get_user_pages in the beginning */
> +       return 0;
> +} 

