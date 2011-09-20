Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab1ITR51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 13:57:27 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:47204 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab1ITR5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 13:57:24 -0400
Date: Tue, 20 Sep 2011 17:50:19 +0100
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 3/26]   Uprobes: register/unregister
 probes.
Message-ID: <20110920165019.GA27959@stefanha-thinkpad.localdomain>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
 <20110920120022.25326.35868.sendpatchset@srdronam.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920120022.25326.35868.sendpatchset@srdronam.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 05:30:22PM +0530, Srikar Dronamraju wrote:
> +int register_uprobe(struct inode *inode, loff_t offset,
> +				struct uprobe_consumer *consumer)
> +{
> +	struct uprobe *uprobe;
> +	int ret = 0;
> +
> +	inode = igrab(inode);
> +	if (!inode || !consumer || consumer->next)
> +		return -EINVAL;
> +
> +	if (offset > inode->i_size)
> +		return -EINVAL;
> +
> +	mutex_lock(&inode->i_mutex);
> +	uprobe = alloc_uprobe(inode, offset);
> +	if (!uprobe)
> +		return -ENOMEM;

The error returns above don't iput(inode).  And inode->i_mutex stays
locked on this return.

> +void unregister_uprobe(struct inode *inode, loff_t offset,
> +				struct uprobe_consumer *consumer)
> +{
> +	struct uprobe *uprobe;
> +
> +	inode = igrab(inode);
> +	if (!inode || !consumer)
> +		return;
> +
> +	if (offset > inode->i_size)
> +		return;
> +
> +	uprobe = find_uprobe(inode, offset);
> +	if (!uprobe)
> +		return;
> +
> +	if (!del_consumer(uprobe, consumer)) {
> +		put_uprobe(uprobe);
> +		return;
> +	}

More returns that do not iput(inode).

Stefan
