Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab1AYMPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 07:15:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51254 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab1AYMPT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 07:15:19 -0500
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 4/20]  4: uprobes: Adding and
 remove a uprobe in a rb tree.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Linux-mm <linux-mm@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20101216095803.23751.41491.sendpatchset@localhost6.localdomain6>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	 <20101216095803.23751.41491.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 Jan 2011 13:15:46 +0100
Message-ID: <1295957746.28776.724.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 15:28 +0530, Srikar Dronamraju wrote:
> +/* Acquires uprobes_mutex */

Requires? afaict uprobes_mutex isn't actually used anywhere in this
patch.

Its use is added in the next patch.

> +static struct uprobe *uprobes_add(struct inode *inode,
> +                                       unsigned long offset)
> +{
> +       struct uprobe *uprobe, *cur_uprobe;
> +
> +       __iget(inode);
> +       uprobe = kzalloc(sizeof(struct uprobe), GFP_KERNEL);
> +
> +       if (!uprobe) {
> +               iput(inode);
> +               return NULL;
> +       }
> +       uprobe->inode = inode;
> +       uprobe->offset = offset;
> +
> +       /* add to uprobes_tree, sorted on inode:offset */
> +       cur_uprobe = insert_uprobe_rb_node(uprobe);
> +
> +       /* a uprobe exists for this inode:offset combination*/
> +       if (cur_uprobe) {
> +               kfree(uprobe);
> +               uprobe = cur_uprobe;
> +               iput(inode);
> +       } else
> +               init_rwsem(&uprobe->consumer_rwsem);
> +
> +       return uprobe;
> +} 
