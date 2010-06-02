Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab0FBB5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 21:57:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755685Ab0FBB5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 21:57:49 -0400
Date: Tue, 1 Jun 2010 18:57:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
       davem@davemloft.net, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       viro@zeniv.linux.org.uk, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-mm@kvack.org
Subject: Re: [PATCH] fs: run emergency remount on dedicated workqueue
Message-Id: <20100601185700.32ed2a0c.akpm@linux-foundation.org>
In-Reply-To: <AANLkTikhC_cVbuTjSSaOffEH5dpCU-S-JBpcXNk8N2QC@mail.gmail.com>
References: <25328.1274886067@redhat.com>
	<4BFE4203.5010803@kernel.org>
	<20100601164603.39dfedf7.akpm@linux-foundation.org>
	<AANLkTikhC_cVbuTjSSaOffEH5dpCU-S-JBpcXNk8N2QC@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 09:02:40 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:

> ...
>
> > Another possibility might be to change lru_add_drain_all() to use IPI
> > interrupts rather than schedule_on_each_cpu(). __That would greatly
> > speed up lru_add_drain_all(). __I don't recall why we did it that way
> > and I don't immediately see a reason not to. __A few things in core mm
> > would need to be changed from spin_lock_irq() to spin_lock_irqsave().
> >
> > But I do have vague memories that there was a reason for it.
> >
> > <It's a huge PITA locating the commit which initially added
> > lru_add_drain_all()>
> >
> > <ten minutes later>
> >
> > : tree 05d7615894131a368fc4943f641b11acdd2ae694
> > : parent e236a166b2bc437769a9b8b5d19186a3761bde48
> > : author Nick Piggin <npiggin@suse.de> Thu, 19 Jan 2006 09:42:27 -0800
> > : committer Linus Torvalds <torvalds@g5.osdl.org> Thu, 19 Jan 2006 11:20:17 -0800
> > :
> > : [PATCH] mm: migration page refcounting fix
> > :
> > : Migration code currently does not take a reference to target page
> > : properly, so between unlocking the pte and trying to take a new
> > : reference to the page with isolate_lru_page, anything could happen to
> > : it.
> > :
> > : Fix this by holding the pte lock until we get a chance to elevate the
> > : refcount.
> > :
> > : Other small cleanups while we're here.
> >
> > It didn't tell us.
> >
> > <looks in the linux-mm archives>
> >
> > Nope, no rationale is provided there either.
> 
> Maybe this thread?
> 
> http://lkml.org/lkml/2008/10/23/226

Close.  There's some talk there of using smp_call_function() (actually
on_each_cpu()) within lru_add_drain_all(), but nobody seems to have
tried it.

