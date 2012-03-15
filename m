Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760390Ab2COWI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 18:08:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:43010 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab2COWIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 18:08:25 -0400
Date: Thu, 15 Mar 2012 23:08:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [patch 0/5] seqlock consolidation
In-Reply-To: <20120315204235.GF8943@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.02.1203152307460.2466@ionos>
References: <20120314170736.617746873@linutronix.de> <20120315122112.GB8943@ZenIV.linux.org.uk> <alpine.LFD.2.02.1203151322020.2466@ionos> <20120315174305.GD8943@ZenIV.linux.org.uk> <alpine.LFD.2.02.1203151854110.2466@ionos> <20120315183940.GE8943@ZenIV.linux.org.uk>
 <alpine.LFD.2.02.1203152013030.2466@ionos> <20120315204235.GF8943@ZenIV.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Mar 2012, Al Viro wrote:

> On Thu, Mar 15, 2012 at 08:17:12PM +0100, Thomas Gleixner wrote:
> > > +			hits += replace_path(&fs->root, old_root, new_root);
> > > +			hits += replace_path(&fs->pwd, old_root, new_root);
> > 
> > Wouldn't it be simpler to just do: 
> > 
> > +			count += replace_path(&fs->root, old_root, new_root);
> > +			count += replace_path(&fs->pwd, old_root, new_root);
> > 
> > > +			write_seqcount_end(&fs->seq);
> > > +			while (hits--) {
> > >  				count++;
> > 
> > Instead of that loop ?
> 
> This loop also contains path_get_longterm() and we need to do it before
> dropping fs->lock.  We are holding a reference to new_root, all right,
> but once it's place into ->fs->{root,pwd} of another task and ->fs->lock
> is dropped, there's nothing to stop that task of doing chdir() and dropping
> its reference.  Which could outweight the single reference we are holding
> pretty soon...

Oops, sorry I missed that path_get_longterm() in the loop due to the
+/- forrest around it.

