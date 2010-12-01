Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab0LABuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:50:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753513Ab0LABub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:50:31 -0500
Date: Tue, 30 Nov 2010 17:49:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nelson Elhage <nelhage@ksplice.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm_release: Do a set_fs(USER_DS) before handling
 clear_child_tid.
Message-Id: <20101130174947.5ccc3778.akpm@linux-foundation.org>
In-Reply-To: <20101201005909.GC18995@ksplice.com>
References: <1291083556-5894-1-git-send-email-nelhage@ksplice.com>
	<20101130160950.96153286.akpm@linux-foundation.org>
	<20101201005909.GC18995@ksplice.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010 19:59:09 -0500 Nelson Elhage <nelhage@ksplice.com> wrote:

> On Tue, Nov 30, 2010 at 04:09:50PM -0800, Andrew Morton wrote:
> > On Mon, 29 Nov 2010 21:19:16 -0500
> > Nelson Elhage <nelhage@ksplice.com> wrote:
> > 
> > > +			 * exited while inside set_fs(KERNEL_DS) for
> > > +			 * some reason (e.g. on a BUG()).
> > >  			 */
> > > +			set_fs(USER_DS);
> > >  			put_user(0, tsk->clear_child_tid);
> > >  			sys_futex(tsk->clear_child_tid, FUTEX_WAKE,
> > >  					1, NULL, NULL, 0);
> > 
> > Confused.  The user can only exploit the wrong addr_limit if control
> > returns to userspace for the user's code to execute.  But that won't be
> > happening, because this thread will unconditionally exit.
> 
> The user can exploit the wrong addr_limit on the very next line, with the
> put_user() there. clear_child_tid is not checked in any way before this
> point. Writing a single zero might not seem like much, but it's enough for
> privilege escalation (e.g. overwrite the top half of a function pointer to point
> to userspace).

Ah, OK.  Doh.

> I have a PoC code that uses this bug, along with CVE-2010-3849, to write a zero
> to an arbitrary kernel address, so I've tested that this is not theoretical.
> 
> That's also why I put the set_fs() hidden inside mm_release, since that's the
> only place where (to my knowledge) it matters.
> 
> On re-reading, I didn't mention clear_child_tid anywhere in the commit message,
> which was an error on my part, and explains the confusion. Sorry about that, and
> I hope this clears that up.
> 
> Let me know if this makes more sense, and I'll send a revised patch.

I do think it would be better to fix up the addr_limit somewhere within
the oops code rather than in the regular code.  Presumably just before
calling do_exit().  Isn't that the logical place?  Plus it fixes up any
other such problems, whether they be there now or in the future.

Although that involves altering every arch, each in multiple places. 
ick.  Maybe at the start of do_exit()?



