Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab2LPUQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 15:16:27 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60411 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab2LPUQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 15:16:26 -0500
Date: Sun, 16 Dec 2012 20:16:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Michel Lespinasse <walken@google.com>,
        Hugh Dickins <hughd@google.com>, J??rn Engel <joern@logfs.org>
Subject: Re: [PATCH] mm: Downgrade mmap_sem before locking or populating on
 mmap
Message-ID: <20121216201621.GG4939@ZenIV.linux.org.uk>
References: <3b624af48f4ba4affd78466b73b6afe0e2f66549.1355463438.git.luto@amacapital.net>
 <20121214072755.GR4939@ZenIV.linux.org.uk>
 <CALCETrVw9Pc1sUZBL=wtLvsnBnkW5LAO5iu-i=T2oMOdwQfjHg@mail.gmail.com>
 <20121214144927.GS4939@ZenIV.linux.org.uk>
 <CALCETrUS7baKF7cdbrqX-o2qdeo1Uk=7Z4MHcxHMA3Luh+Obdw@mail.gmail.com>
 <20121216170403.GC4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121216170403.GC4939@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 05:04:03PM +0000, Al Viro wrote:

> That's just from a couple of days of RTFS.  The locking in there is far too
> convoluted as it is; worse, it's not localized code-wise, so rechecking
> correctness is going to remain a big time-sink ;-/
> 
> Making it *more* complex doesn't look like a good idea, TBH...

... and another fun place: kvm_setup_async_pf() grabs a _passive_ reference
to current->mm (->mm_count, not ->mm_users), sticks it into work->mm and
schedules execution of async_pf_execute().  Which does use_mm() (still no
active refs acquired), grabs work->mm->mmap_sem shared and proceeds to call
get_user_pages().  What's going to happen if somebody does kill -9 to
the process that had started that?

get_user_pages() in parallel with exit_mmap() is a Bad Thing(tm) and I don't
see anything on the exit path that would've waited for that work to finish.
I might've missed something here, but...  Note that aio (another place
playing with use_mm(), also without an active ref) has an explicit hook
for mmput() to call before proceeding to exit_mmap(); I don't see anything
similar here.

Not that aio.c approach had been all that safe - get_task_mm() will refuse
to pick use_mm'ed one, but there are places open-coding it without the
check for PF_KTHREAD.  Few of them, fortunately, but...
