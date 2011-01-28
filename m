Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab1A1HD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 02:03:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360Ab1A1HD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 02:03:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Tejun Heo <tj@kernel.org>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 2/4] ptrace: remove the extra wake_up_process() from
 ptrace_detach()
In-Reply-To: Tejun Heo's message of  Thursday, 27 January 2011 14:34:12 +0100 <20110127133412.GC24925@htj.dyndns.org>
References: <1293016398-18001-1-git-send-email-tj@kernel.org>
	<1293016398-18001-3-git-send-email-tj@kernel.org>
	<20110117221340.E6A4F180996@magilla.sf.frob.com>
	<20110127133412.GC24925@htj.dyndns.org>
X-Shopping-List: (1) Porous warriors
   (2) Insistent protein reservations
   (3) Hot pink conical balls
Message-Id: <20110128070252.709F8183C1A@magilla.sf.frob.com>
Date: Thu, 27 Jan 2011 23:02:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Jan 17, 2011 at 02:13:40PM -0800, Roland McGrath wrote:
> > Of course I agree that the current code is wrong here.  But I'm still not
> > at all clear on what practical compatibility problems it introduces.  This
> > change is OK if and only if we are really making the only area clean and
> > well-defined in the same release cycle.
> 
> I don't follow what you meant by the above sentence.  Can you please
> clarify a bit?

I think I meant to write "the whole area" rather than "the only area".
The point I meant to make is that removing this (wrong) wake-up entirely
should only be done when we are also thoroughly cleaning up and verifying
everything about the behavior of stopping/resuming in ptrace.  When we get
to a clear statement of what all the rules are and we really believe that
the new code matches those rules, then fine.  When we are still in the
quagmire, no change is better than an incremental change whose subtle
ramifications we can't clearly articulate.

> It's slightly more serious than that.  Calling wake_up_process()
> unconditionally can cause a quite serious failure.  It wakes up a
> process in any state and there are code paths which aren't prepared to
> be woken up unless certain conditions are met.  

I understand that.  But I don't recall having seen anyone cite an actual
scenario in the real world where it does something problematic.

> A safer choice can be changing it to wake up only tasks in interruptible
> sleep.

For ptrace-related purposes, wake_up_state(child, TASK_TRACED|TASK_STOPPED)
ought to cover anything that it is doing now that anything could reasonably
be relying on.

> I have very difficult time imagining what real user visible
> implication it would have in negative and noticeable manner, so while
> I do agree that we should proceed carefully, I think it would be
> better to take the chance and remove the erratic behavior.  We have
> release cycles and testing at multiple layers after all.  If we find
> out that it breaks something in serious manner, we can always revert.

"Difficult time imagining" and ptrace subtleties unfortunately often go
together.  I want to be sure we are doing something right, rather than just
being thoroughly unsure that we aren't doing something wrong.


Thanks,
Roland
