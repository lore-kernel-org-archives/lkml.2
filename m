Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934029Ab2EWThQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:37:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43216 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933930Ab2EWThL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:37:11 -0400
Date: Wed, 23 May 2012 20:37:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>
Subject: Re: linux-next: Tree for May 23 (uml)
Message-ID: <20120523193707.GO11775@ZenIV.linux.org.uk>
References: <20120523170740.ae058d8d5468d471eb948c39@canb.auug.org.au>
 <4FBD090E.5020901@xenotime.net>
 <20120523181917.GN11775@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120523181917.GN11775@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 07:19:17PM +0100, Al Viro wrote:

> Grr...  That's a conflict between uml gaining TIF_NOTIFY_RESUME (needed
> prereq to task_work_add() series) and patch in said series doing away
> with explicit calls of key_replace_session_keyring().  Fixup is to remove
> those two lines in arch/um/process.c, same as done on other architectures
> by "keys: kill the dummy key_replace_session_keyring()" (commit c1cb001).
> 
> Not an issue for mainline merge, since task_work_add patchset goes later,
> but I think I'll have to cherry-pick that series into signal.git.  And
> probably reorder it a bit, moving the calls into tracehook_notify_resume()
> first, with "kill the dummy..." commit removing just that single call.

Hmm...  Two solutions, take your pick:

1)
	I think the minimal solution is this: I add the "move
key_replace_session_keyring() into tracehook_notify_resume()" into signal.git
for-next, which yields one conflict with next/akpm.  With conflict resolution
being "take tracehook_notify_resume() from next/akpm".  I've put that
into for-next-variant1

2)
	Cherry-picked these guys into signal.git, along with the rest
of signal prereqs for them.  Merge with next/akpm-base yields a couple
of trivial conflicts in kernel/fork.c (with
	sched, mm: Rework sched_{fork,exec} node assignment
removing INIT_LIST_HEAD right next to the place where we add one; conflict
resolution being just keep the one Oleg adds and remove the one Peter removes)
and in kernel/irq/manage.c (with
	genirq: Be more informative on irq type mismatch
changing a couple of printks in there; conflict resolution: just remove
exit_irq_thread() in merged variant).  That's for-next-variant2.  With that
variant we get 5 more duplicates with next/akpm, obviously.

Stephen, which way would you prefer it handled?
