Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab1I0NPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 09:15:00 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:52373 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab1I0NPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 09:15:00 -0400
Date: Tue, 27 Sep 2011 18:29:00 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 4/26]   uprobes: Define hooks for
 mmap/munmap.
Message-ID: <20110927125900.GC3685@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
 <20110920120040.25326.63549.sendpatchset@srdronam.in.ibm.com>
 <1317045191.1763.22.camel@twins>
 <20110926154414.GB13535@linux.vnet.ibm.com>
 <1317123681.15383.37.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1317123681.15383.37.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-09-27 13:41:21]:

> On Mon, 2011-09-26 at 21:14 +0530, Srikar Dronamraju wrote:
> > > Why not something like:
> > > 
> > > 
> > > +static struct uprobe *__find_uprobe(struct inode * inode, loff_t offset,
> > >                                       bool inode_only)
> > > +{
> > >         struct uprobe u = { .inode = inode, .offset = inode_only ? 0 : offset };
> > > +       struct rb_node *n = uprobes_tree.rb_node;
> > > +       struct uprobe *uprobe;
> > >       struct uprobe *ret = NULL;
> > > +       int match;
> > > +
> > > +       while (n) {
> > > +               uprobe = rb_entry(n, struct uprobe, rb_node);
> > > +               match = match_uprobe(&u, uprobe);
> > > +               if (!match) {
> > >                       if (!inode_only)
> > >                              atomic_inc(&uprobe->ref);
> > > +                       return uprobe;
> > > +               }
> > >               if (inode_only && uprobe->inode == inode)
> > >                       ret = uprobe;
> > > +               if (match < 0)
> > > +                       n = n->rb_left;
> > > +               else
> > > +                       n = n->rb_right;
> > > +
> > > +       }
> > >         return ret;
> > > +}
> > > 
> > 
> > I am not comfortable with this change.
> > find_uprobe() was suppose to return back a uprobe if and only if
> > the inode and offset match,
> 
> And it will, because find_uprobe() will never expose that third
> argument.
> 
> >  However with your approach, we end up
> > returning a uprobe that isnt matching and one that isnt refcounted.
> > Moreover if even if we have a matching uprobe, we end up sending a
> > unrefcounted uprobe back. 
> 
> Because the matching isn't the important part, you want to return the
> leftmost node matching the specified inode. Also, in that case you
> explicitly don't want the ref, since the first thing you do on the
> call-site is drop the ref if there was a match. You don't care about
> inode:0 in particular, you want a place to start iterating all of
> inode:*.
> 

The case of we taking a ref and dropping it would arise if and only if
there is a matching uprobe i.e inode: and 0 offset. I dont think that
would be the common case.

If you arent comfortable passing the rb_node as the third argument, then
we could pass the reference to uprobe itself. But that would mean we do
a redundant dereference everytime.

-- 
Thanks and Regards
Srikar
