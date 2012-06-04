Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab2FDH15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 03:27:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50478 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab2FDH14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 03:27:56 -0400
Date: Mon, 4 Jun 2012 08:27:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question about do_mmap changes
Message-ID: <20120604072755.GY30000@ZenIV.linux.org.uk>
References: <4FCC47C9.8050904@lwfinger.net>
 <20120604062604.GV30000@ZenIV.linux.org.uk>
 <4FCC57AD.3000803@lwfinger.net>
 <20120604065638.GW30000@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120604065638.GW30000@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 07:56:38AM +0100, Al Viro wrote:
> _IF_ this is done not to current->mm, these guys are in for a world of
> hurt, probably going all way back.

	BTW, rtR0MemObjLinuxDoMmap() would really better be done with
pTask == current; it calls do_mmap(), which acts on current->mm and
nowhere in the function does it look at pTask at all.  The caller
has locked pTask->mm->mmap_sem.  And do_mmap() obviously assumes that
current->mm->mmap_sem is held by caller.

	Looking at the callers (both of that an munmap()), it appears
that they get task from
static struct task_struct *rtR0ProcessToLinuxTask(RTR0PROCESS R0Process)
{
    /** @todo fix rtR0ProcessToLinuxTask!! */
    return R0Process == RTR0ProcHandleSelf() ? current : NULL;
}

So it's probably OK, until they follow up on that todo.  BTW, quite a few
callers of that sucker are followed by Assert(pTask != NULL)...

Most of do_munmap() callers are easily converted to vm_munmap(); the only
exception is cleanup after failure in rtR0MemObjNativeMapUser().  May
or may not be convertable to vm_munmap(); depends on whether they really
need ->mmap_sem held over the entire sequence *and* on whether there's
a better solution.  They seem to be trying to shove an array of pages
into VMA they'd just created and lock them there; I might be misreading
and missing details, though - that code is really as pleasant to read
as using warm stale beer to deal with industrial-strength hangover.  The
kind when you end up spitting out a fly or two, if not a cigarette butt...
I'm not up to that right now - it's half past three in the morning here
and I'll have to get up four hours from now ;-/
