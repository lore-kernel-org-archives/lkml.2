Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238Ab1IUEVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 00:21:18 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36374 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab1IUEVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 00:21:17 -0400
Date: Wed, 21 Sep 2011 09:37:22 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20110921040722.GE6568@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
 <20110920120022.25326.35868.sendpatchset@srdronam.in.ibm.com>
 <20110920165019.GA27959@stefanha-thinkpad.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110920165019.GA27959@stefanha-thinkpad.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stefan Hajnoczi <stefanha@linux.vnet.ibm.com> [2011-09-20 17:50:19]:

> On Tue, Sep 20, 2011 at 05:30:22PM +0530, Srikar Dronamraju wrote:
> > +int register_uprobe(struct inode *inode, loff_t offset,
> > +				struct uprobe_consumer *consumer)
> > +{
> > +	struct uprobe *uprobe;
> > +	int ret = 0;
> > +
> > +	inode = igrab(inode);
> > +	if (!inode || !consumer || consumer->next)
> > +		return -EINVAL;
> > +
> > +	if (offset > inode->i_size)
> > +		return -EINVAL;
> > +
> > +	mutex_lock(&inode->i_mutex);
> > +	uprobe = alloc_uprobe(inode, offset);
> > +	if (!uprobe)
> > +		return -ENOMEM;
> 
> The error returns above don't iput(inode).  And inode->i_mutex stays
> locked on this return.

Yes will fix this .. by clubbing the !uprobe with the next condition.
Thanks for pointing this.

> 
> > +void unregister_uprobe(struct inode *inode, loff_t offset,
> > +				struct uprobe_consumer *consumer)
> > +{
> > +	struct uprobe *uprobe;
> > +
> > +	inode = igrab(inode);
> > +	if (!inode || !consumer)
> > +		return;
> > +
> > +	if (offset > inode->i_size)
> > +		return;
> > +
> > +	uprobe = find_uprobe(inode, offset);
> > +	if (!uprobe)
> > +		return;
> > +
> > +	if (!del_consumer(uprobe, consumer)) {
> > +		put_uprobe(uprobe);
> > +		return;
> > +	}
> 
> More returns that do not iput(inode).

Yes. will fix these too.

-- 
Thanks and Regards
Srikar
