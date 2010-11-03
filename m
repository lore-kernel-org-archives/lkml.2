Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab0KCMro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 08:47:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754709Ab0KCMrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 08:47:42 -0400
Date: Wed, 3 Nov 2010 05:48:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v2.6.36-rc7] init: don't call flush_scheduled_work()
 from do_initcalls()
Message-Id: <20101103054804.c88601d5.akpm@linux-foundation.org>
In-Reply-To: <4CD14089.7050709@kernel.org>
References: <4CB86F94.7080702@kernel.org>
	<20101021171203.37d0d6d6.akpm@linux-foundation.org>
	<4CC14ADA.9080706@kernel.org>
	<20101022110925.ea1263f8.akpm@linux-foundation.org>
	<4CD14089.7050709@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Nov 2010 11:59:21 +0100 Tejun Heo <tj@kernel.org> wrote:

> Hello, Andrew.
> 
> On 10/22/2010 08:09 PM, Andrew Morton wrote:
> > mm..  I think we'd be OK to merge it.  Any such code is pretty badly
> > buggy and is probably also crashable with a well-timed rmmod.
> > 
> > It'll also be code which few people ever use, so any runtime checks
> > won't get us very good coverage.
> > 
> > Still, if it's not too hard to implement an "are there any scheduled
> > works which live in initmem" check then I guess that would be the
> > prudent approach.  A quite gross way of implementing that might be
> > something like
> 
> I've been trying to implement proper check code but there is a
> problem.  It's possible to check all pending works to see whether the
> work struct itself or the work function is in initmem and warn about
> them.
> 
> The problem is with currently running works.  As work_struct isn't
> accessible once it starts executing, struct worker would need to cache
> it for later reference.  Worker already remembers the work_struct
> pointer itself and its cwq and adding one more field to remember the
> currently running work function is easy.  However, it's only useful
> during the unlikely buggy case during init.  Given that if anything is
> still depending on initmem, it will blow up pretty reliably, I don't
> think it's worthwhile to add additional tracking just for this.

yes, if it goes bang, we'll hear it.  And we'll be able to work out why
it went bang pretty easily.  Although I assume that a backtrace which
leads into a just-unloaded module won't be able to display that
module's symbols.

>  So, I
> think I'll just go ahead and drop the flush call and deal with the
> unlikely fallouts if there's any.

OK by me.
