Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161470Ab2COUmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:42:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60884 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161383Ab2COUmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:42:39 -0400
Date: Thu, 15 Mar 2012 20:42:35 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [patch 0/5] seqlock consolidation
Message-ID: <20120315204235.GF8943@ZenIV.linux.org.uk>
References: <20120314170736.617746873@linutronix.de>
 <20120315122112.GB8943@ZenIV.linux.org.uk>
 <alpine.LFD.2.02.1203151322020.2466@ionos>
 <20120315174305.GD8943@ZenIV.linux.org.uk>
 <alpine.LFD.2.02.1203151854110.2466@ionos>
 <20120315183940.GE8943@ZenIV.linux.org.uk>
 <alpine.LFD.2.02.1203152013030.2466@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1203152013030.2466@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 08:17:12PM +0100, Thomas Gleixner wrote:
> > +			hits += replace_path(&fs->root, old_root, new_root);
> > +			hits += replace_path(&fs->pwd, old_root, new_root);
> 
> Wouldn't it be simpler to just do: 
> 
> +			count += replace_path(&fs->root, old_root, new_root);
> +			count += replace_path(&fs->pwd, old_root, new_root);
> 
> > +			write_seqcount_end(&fs->seq);
> > +			while (hits--) {
> >  				count++;
> 
> Instead of that loop ?

This loop also contains path_get_longterm() and we need to do it before
dropping fs->lock.  We are holding a reference to new_root, all right,
but once it's place into ->fs->{root,pwd} of another task and ->fs->lock
is dropped, there's nothing to stop that task of doing chdir() and dropping
its reference.  Which could outweight the single reference we are holding
pretty soon...
