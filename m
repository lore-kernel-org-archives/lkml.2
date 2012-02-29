Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030642Ab2B2S5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 13:57:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030443Ab2B2S5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 13:57:54 -0500
Date: Wed, 29 Feb 2012 19:50:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Roland McGrath <roland@redhat.com>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Questions about ptrace on a dying process
Message-ID: <20120229185056.GA11757@redhat.com>
References: <4F4E6915.1010209@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4E6915.1010209@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29, Tim Bird wrote:
>
> ptrace maintainers (and interested parties)...
>
> I'm working on a crash handler for Linux, which uses ptrace to retrieve information
> about a process during it's coredump.  Specifically, from within a core handler
> program (started within do_coredump() as a user_mode_helper), I would like to make
> ptrace calls against the dying process.

Which calls? just curious.

> My problem is that the process state is not entering into TASK_TRACED, when
> I do an PTRACE_ATTACH against it.

Yes, it can never do ptrace_stop() in do_coredump() paths.

Perhaps you can use PTRACE_O_TRACEEXIT. PTRACE_EVENT_EXIT will be reported
after the coredumping. I think the core handler should close the pipe first,
otherwise the dumping tracee will wait for the handler forever.

However. You need PTRACE_SEIZE, not PTRACE_ATTACH. And this can only work
with the recent patch from Denys which allows to pass PTRACE_O_TRACEEXIT
with PTRACE_SEIZE (currently in -mm tree).

Just in case, it could have other threads sleeping in TASK_UNINTERRUPTIBLE
until do_coredump() completes. But these threads have already passed
ptrace_event(PTRACE_EVENT_EXIT).

Oleg.

