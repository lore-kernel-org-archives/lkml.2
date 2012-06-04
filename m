Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab2FDG4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 02:56:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59493 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2FDG4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 02:56:39 -0400
Date: Mon, 4 Jun 2012 07:56:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question about do_mmap changes
Message-ID: <20120604065638.GW30000@ZenIV.linux.org.uk>
References: <4FCC47C9.8050904@lwfinger.net>
 <20120604062604.GV30000@ZenIV.linux.org.uk>
 <4FCC57AD.3000803@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FCC57AD.3000803@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 01:37:33AM -0500, Larry Finger wrote:

> Oh, shit. I was hoping for an easy conversion of this code to work
> with 3.5 so that I could use VB while testing 3.5. Clearly, the
> fixes will not be quick.
> 
> As you have likely gathered, I am not a VB developer. Is it OK if I
> pass your comments on to the real developers and let them do the
> work?

Sure.  BTW, if they are doing that munmap() *not* to current->mm, they
are in for serious analysis (and very likely - fixing unpleasant races)
in earlier versions as well; these races hadn't appeared just now.

Note that aio (another place that used to do such munmap()) had been
racy all way back to original merge.  Moreover, access of task->mm
becomes really interesting when it's another task - note that execve(2)
changes the sucker, so you are risking up_write() done to mm->mmap_sem
that gets freed under you or up_write() on a _different_ mm_struct
->mmap_sem.  And then there's the fact that exit_mm() is done without
->mmap_sem (it's done when no active users should've been left, after
all), so munmap() done on it will do nasty things.  So will munmap()
racing with do_coredump() (again, no ->mmap_sem there - all threads
are already not running in userland by that point, so the kernel
just goes ahead and assumes that nobody will touch that mm_struct).

Conversion to vm_mmap()/vm_munmap() was done, in a large part, to simplify
the analysis and to make damn sure we are doing that to current->mm.
There are users of do_munmap() outside of mm/* (ipc/shm.c), but they
are also working on current->mm and the code in question is really
a misplaced piece of mm/* to start with.

_IF_ this is done not to current->mm, these guys are in for a world of
hurt, probably going all way back.
