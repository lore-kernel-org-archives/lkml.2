Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab1KWSYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 13:24:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:58469 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab1KWSYT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 13:24:19 -0500
Message-ID: <1322072637.14799.92.camel@twins>
Subject: Re: [PATCH v7 3.2-rc2 1/30] uprobes: Auxillary routines to insert,
 find, delete uprobes
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
Date: Wed, 23 Nov 2011 19:23:57 +0100
In-Reply-To: <20111118110647.10512.51752.sendpatchset@srdronam.in.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
	 <20111118110647.10512.51752.sendpatchset@srdronam.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 16:36 +0530, Srikar Dronamraju wrote:
> +static struct uprobe *alloc_uprobe(struct inode *inode, loff_t offset)
> +{
> +       struct uprobe *uprobe, *cur_uprobe;
> +
> +       uprobe = kzalloc(sizeof(struct uprobe), GFP_KERNEL);
> +       if (!uprobe)
> +               return NULL;
> +
> +       uprobe->inode = igrab(inode);
> +       uprobe->offset = offset;
> +
> +       /* add to uprobes_tree, sorted on inode:offset */
> +       cur_uprobe = insert_uprobe(uprobe);
> +
> +       /* a uprobe exists for this inode:offset combination */
> +       if (cur_uprobe) {
> +               kfree(uprobe);
> +               uprobe = cur_uprobe;
> +               iput(inode);
> +       }
> +       return uprobe;
> +} 

A function called alloc that actually publishes the object is weird.
Usually those things are separated. Alloc does the memory allocation and
sometimes initialization like things, but it never publishes the thing.

This leads to slightly weird code later on. Its not wrong, just weird
and makes reading this stuff slightly more challenging than needed.


