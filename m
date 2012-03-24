Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab2CXJjn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 05:39:43 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37240 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab2CXJjm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 05:39:42 -0400
MIME-Version: 1.0
Date: Sat, 24 Mar 2012 20:39:40 +1100
X-Google-Sender-Auth: WqTbzBWYpQDQuJhKWd13lxYI41g
Message-ID: <CABqErrHS6C6RVMKChaPGACoaWoXCKf+6dS5KFrWG04+DnZO6Dw@mail.gmail.com>
Subject: [ANNOUNCE] BFS CPU scheduler version 0.420 AKA "Smoking" for linux
 kernel 3.3.0
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to announce the first stable release of the BFS CPU scheduler
for linux 3.3.0 designed for optimal interactivity, responsiveness and
throughput on commodity hardware.

The changes since BFS version 0.416 include a fairly large
architectural change just to bring the codebase in sync with 3.3, but
none of the changes should be noticeable in any way. One change that
may be user-visible is that the high resolution IRQ accounting now
appears to be on by default for x86 architectures. There is an issue
that system time accounting is wrong without this feature enabled in
BFS so this should correct that problem.

Other changes:
416-417: A number of ints were changed to bool which though unlikely
to have any performance impact, do make the code cleaner and the
compiled code does often come out different. rq_running_iso was
converted from a function to macro to avoid it being a separate
function call when compiled in with the attendant overhead.
requeue_task within the scheduler tick was moved to being done under
lock which may prevent rare races.  test_ret_isorefractory() was
optimised. set_rq_task() was not being called on tasks that were being
requeued within schedule() which could possibly have led to issues if
the task ran out of timeslice during that requeue and should have had
its deadline offset. The need_resched() check that occurs at the end
of schedule() was changed to unlikely() since it really is that. Moved
the scheduler version print function to bfs.c to avoid recompiling the
entire kernel if the version number is changed.

417-418: Fixed a problem with the accounting resync for linux 3.3.

418-419: There was a small possibility that an unnecessary resched
would occur in try_preempt if a task had changed affinity and called
try_preempt with its ->cpu still set to the old cpu it could no longer
run on, so try_preempt was reworked slightly. Reintroduced the
deadline offset based on CPU cache locality on sticky tasks in a way
that was cheaper than we currently offset the deadline.

419-420: Finally rewrote the earliest_deadline_task code. This has
long been one of the hottest code paths in the scheduler and small
changes here that made it look nice would often slow it down. I spent
quite a few hours reworking it to include less GOTOs while
disassembling the code to make sure it was actually getting smaller
with every change.  Then I wrote a scheduler specific version of
find_next_bit which could be inlined into this code and avoid another
function call in the hot path. The overall behaviour is unchanged from
previous BFS versions, but initial benchmarking confirms slight
improvements in throughput.

While interactivity is the prime concern for BFS, as part of the
regression testing, throughput benchmarks are performed with
kernbench. This is a plot of BFS 418/420 and mainline archlinux 3.3.0
kernel on a dual quad hyperthread core2 (lower is better):

http://postimage.org/image/wavusknl1/

Enjoy!
お楽しみ下さい

--
-ck
