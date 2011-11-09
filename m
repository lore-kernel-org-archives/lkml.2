Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab1KITw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 14:52:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:34946 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab1KITwZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 14:52:25 -0500
Subject: Re: Linus GIT - INFO: possible circular locking dependency detected
From: Peter Zijlstra <peterz@infradead.org>
To: Luis Henriques <henrix@camandro.org>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        stable@vger.kernel.org
Date: Wed, 09 Nov 2011 20:52:12 +0100
In-Reply-To: <20111109191155.GB2490@hades>
References: <CAHFgRy8S0xLfhZxTUOEH5A0PL_Fb79-0-gmbQ=9h2D-xMqt1hA@mail.gmail.com>
	 <20111103204930.GA3599@hades> <20111105093146.GA14338@albatros>
	 <20111108155716.33c04ce1.akpm@linux-foundation.org>
	 <20111109001723.GA26225@kroah.com> <20111109004013.GA30562@kroah.com>
	 <20111109191155.GB2490@hades>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320868332.19727.19.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 19:11 +0000, Luis Henriques wrote:
> [   12.948038] -> #0 (&sig->cred_guard_mutex){+.+.+.}:
> [   12.948038]        [<ffffffff8108ff9f>] __lock_acquire+0x17bf/0x2020
> [   12.948038]        [<ffffffff81092e4f>] lock_acquire+0xaf/0x1f0
> [   12.948038]        [<ffffffff8135b2a5>] __mutex_lock_common+0x65/0x4d0
> [   12.948038]        [<ffffffff8135b76b>] mutex_lock_killable_nested+0x1b/0x20
> [   12.948038]        [<ffffffff811b301e>] lock_trace+0x2e/0x80
> [   12.948038]        [<ffffffff811b73ab>] proc_readfd_common+0x5b/0x4b0
> [   12.948038]        [<ffffffff811b7835>] proc_readfd+0x15/0x20
> [   12.948038]        [<ffffffff8115f8f0>] vfs_readdir+0xb0/0xd0
> [   12.948038]        [<ffffffff8115fa09>] sys_getdents+0x89/0x100
> [   12.948038]        [<ffffffff8135e8c2>] system_call_fastpath+0x16/0x1b
> 
> sb->s_type->i_mutex_key is shown as being acquired in the execve path,
> which seems to be wrong -- it was acquired in the vfs_readdir (on the 2nd
> trace).
> 
> This means that the initial analysis from Vasiliy is incorrect, as he
> assumed the execve path.  Or Am I interpreting this log incorrectly?
> (Probably I am...). 

->#0 shows where sig->cred_guard_mutex was taken, as it was the first
lock there is no nesting yet and therefore the ->i_mutex_key#6 thing
should not be associated with this stacktrace.

->#1 shows where ->i_mutex_key#6 was taken while holding
->cred_guard_mutex (but doesn't explicitly show where that was taken).

Mostly ->#0 information is useless in lockdep reports and can be safely
ignored.
