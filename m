Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab1AFCF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 21:05:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798Ab1AFCF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 21:05:27 -0500
Date: Wed, 5 Jan 2011 21:05:12 -0500
From: Don Zickus <dzickus@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] panic:  ratelimit panic messages
Message-ID: <20110106020512.GJ2317@redhat.com>
References: <1294198711-15492-1-git-send-email-dzickus@redhat.com>
 <1294198711-15492-2-git-send-email-dzickus@redhat.com>
 <20110105145128.3b635ae7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110105145128.3b635ae7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 02:51:28PM -0800, Andrew Morton wrote:
> On Tue,  4 Jan 2011 22:38:30 -0500
> Don Zickus <dzickus@redhat.com> wrote:
> 
> > Sometimes when things go bad, so much spew is coming on the console it is hard
> > to figure out what happened.  This patch allows you to ratelimit the panic
> > messages with the intent that the first panic message will provide the info
> > we need to figure out what happened.
> > 
> > Adds new kernel param 'panic_ratelimit=on/<integer in seconds>'
> > 
> 
> Terminological whinge: panic() is a specific kernel API which ends up
> doing a sort-of-oops thing.  So the graph is
> 
> 	panic		-> oops
> 	other-things	-> oops
> 
> Your patch doesn't affect only panics - it also affects oops, BUG(),
> etc.  So I'd suggest that this patch should do s/panic/oops/g.

Ok.  Sorry about that.

<snip>
> 
> We keep on hacking away at this and things never seem to get much
> better.  It's still the case that a large number of our oops reports
> are damaged because the important parts of the oops trace scrolled off
> the screen.
> 
> I therefore propose
> 
> 	oops_lines_delay=N,M
> 
> which will cause the kernel to pause for M milliseconds after emitting
> N lines of oops output.  Bonus marks for handling linewrap!
> 
> Start the line counter at oops_begin() or thereabouts and then do the
> delay after N lines have been emitted.  I guess that counter should
> _not_ be invalidated in oops_end(): if the oops generates 12 lines and
> then another 100 lines of random printk crap are printed, we still want
> to put a pause after the 13th line of that random crap, so we can view
> the oops.
> 
> The oops_lines_delay implemetnation should count lines from all CPUs
> and should block all CPUs during the delay.
> 
> I think this would solve the problem which you're seeing, as well as
> the much larger my-oops-scrolled-off problem?

Ok.  Forgive me for being thick.  I seem to be lost in the lower layer of
the oops code for some reason.  I understand your idea and am willing to
take a crack at implementing it, I just can't figure out what function to
stick it in.  I grep'd for oops_begin() and it seemed to be an x86-only
thing.  Is there a more generic place to put this stuff?

Cheers,
Don

> 
