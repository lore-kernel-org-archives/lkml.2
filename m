Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760106Ab1EOP4b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 11:56:31 -0400
Received: from vps.jankratochvil.net ([46.28.109.124]:56961 "EHLO
	host1.jankratochvil.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756656Ab1EOP4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 11:56:30 -0400
Date: Sun, 15 May 2011 17:56:02 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: oleg@redhat.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: PTRACE_SEIZE should not stop  [Re: [PATCH 02/11] ptrace: implement
 PTRACE_SEIZE]
Message-ID: <20110515155602.GD31855@host1.jankratochvil.net>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304869745-1073-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 May 2011 17:48:56 +0200, Tejun Heo wrote:
> The usage is the same with PTRACE_ATTACH but it takes PTRACE_SEIZE_*
> flags in @data.

> After PTRACE_SEIZE, tracee will trap.

PTRACE_SEIZE does not need to stop, there is that new PTRACE_INTERRUPT for it.
This is not an improvement.

It was already addressed by me before so I will give more reasons:
	https://lkml.org/lkml/2011/3/1/309

GDB already has mode `set observer on' (in this case we are interested in its
part `set may-interrupt off') - see: $ info '(gdb)Observer Mode'
	# If you want to [...] observe program behavior without any chance of
	# disruption by GDB
This is an increasingly requested feature as one of the ways of monitoring.

There are also requests to handle applications using 10000+ threads, which
currently have problems with GDB.  One can imagine a needless
waitpid+PTRACE_CONT is not a help.

There could be a new PTRACE_SEIZE_INTERRUPT option in @data so that
applications does not have to use two syscalls (PTRACE_SEIZE
+ PTRACE_INTERRUPT) if the applications really want to perform some operations
on the tracee requiring having it stopped after the attachment.  (Personally
I do not think this single vs. double syscall difference is worth the new
flag.)


> Which trap will happen isn't fixed.  If other trap conditions exist (signal
> delivery or group stop), they might be taken; otherwise, a trap with
> exit_code SIGTRAP | (PTRACE_EVENT_INTERRUPT << 8) is taken.

What if PTRACE_INTERRUPT is called by tracer only after the tracee has stopped
on a signal delivery?  It should be ignored in such case - as the first signal
will not be PTRACE_EVENT_INTERRUPT.  (Sorry if you have stated it somewhere.)


Thanks,
Jan
