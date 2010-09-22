Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab0IVUn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 16:43:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35687 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab0IVUn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 16:43:26 -0400
Date: Wed, 22 Sep 2010 21:43:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Sparc
Message-ID: <20100922204323.GG19804@ZenIV.linux.org.uk>
References: <20100922.111019.200357319.davem@davemloft.net>
 <20100922183200.GC19804@ZenIV.linux.org.uk>
 <AANLkTi=DWk2_=wMqcM1jgJEuNRj_ni2OkM3osYCUg57Y@mail.gmail.com>
 <20100922185328.GD19804@ZenIV.linux.org.uk>
 <AANLkTi=pJUKRUQhpcVV8XAJF+BO1440v1Py5Opr34DR1@mail.gmail.com>
 <20100922195349.GF19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100922195349.GF19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 08:53:49PM +0100, Al Viro wrote:
> On Wed, Sep 22, 2010 at 12:08:53PM -0700, Linus Torvalds wrote:
> > On Wed, Sep 22, 2010 at 11:53 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > Um, no. ?You've *already* called get_signal_to_deliver(). ?There had been
> > > no SIGSEGV in sight. ?You happily went on to set a sigframe for e.g.
> > > SIGHUP, but ran out of stack. ?At that point you get force_sigsegv()
> > > from handle_signal(). ?_NOW_ you have a pending SIGSEGV
> > 
> > Ahh. Ok. Different case from the one I thought you were worried about.
> > And yeah, I guess that one does require us to mess with the low-level
> > asm code (although I do wonder if we could not make the whole
> > do_notify_resume + reschedule code be generic C code - it's a lot of
> > duplicated subtle asm as it is).
> 
> Worse than just that...  Note that on sparc you need to deal with
> fault_in_user_windows(), which can also trigger signals.

	Actually, I wonder why don't we do the following:
1) check wsaved first, do fault_in_user_windows() if needed (and probably do
Something Cruel(tm) if we fail copy_to_user() in there)
2) in a loop check if we need to reschedule / if we need to handle signals
3) don't bother with wsaved checks in setup_frame() variants at all -
wsaved can't grow back at that point; we also can use flush_user_windows()
instead of full synchronize_user_stack() in there.

It's definitely a separate patch, but it looks like it might be worth
doing...  Comments?
