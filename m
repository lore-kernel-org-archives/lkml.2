Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab1KWQ1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 11:27:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:56796 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab1KWQ13 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:27:29 -0500
Message-ID: <1322065625.14799.82.camel@twins>
Subject: Re: [PATCH v7 3.2-rc2 3/30] uprobes: register/unregister probes.
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
Date: Wed, 23 Nov 2011 17:27:05 +0100
In-Reply-To: <20111118110713.10512.9461.sendpatchset@srdronam.in.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
	 <20111118110713.10512.9461.sendpatchset@srdronam.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 16:37 +0530, Srikar Dronamraju wrote:
> +void unregister_uprobe(struct inode *inode, loff_t offset,
> +                               struct uprobe_consumer *consumer)
> +{
> +       struct uprobe *uprobe = NULL;
> +
> +       inode = igrab(inode);
> +       if (!inode || !consumer)
> +               goto unreg_out;

Why do you take a reference on the inode here? Surely inode is already
made stable by whoever calls us?

> +       uprobe = find_uprobe(inode, offset);
> +       if (!uprobe)
> +               goto unreg_out;
> +
> +       mutex_lock(uprobes_hash(inode));
> +       if (!del_consumer(uprobe, consumer)) {
> +               mutex_unlock(uprobes_hash(inode));
> +               goto unreg_out;
> +       }
> +
> +       if (!uprobe->consumers)
> +               __unregister_uprobe(inode, offset, uprobe);
> +
> +       mutex_unlock(uprobes_hash(inode));
> +
> +unreg_out:
> +       if (uprobe)
> +               put_uprobe(uprobe);
> +       if (inode)
> +               iput(inode);
> +} 
