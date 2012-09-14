Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307Ab2INWup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 18:50:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33841 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760281Ab2INWul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 18:50:41 -0400
MIME-Version: 1.0
In-Reply-To: <20120719211510.GA32763@google.com>
References: <20120719211510.GA32763@google.com>
Date: Fri, 14 Sep 2012 15:50:40 -0700
Message-ID: <CAMbhsRQs+2MCXq0M-eTeezwPR=KMnBKtJny1rjiUJL-wNYctMQ@mail.gmail.com>
Subject: Re: [PATCHSET] kthread_worker: reimplement flush_kthread_work() to
 allow freeing during execution
From: Colin Cross <ccross@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        Andy Walls <awalls@md.metrocast.net>, ivtv-devel@ivtvdriver.org,
        linux-media@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 2:15 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> kthread_worker was introduced together with concurrency managed
> workqueue to serve workqueue users which need a special dedicated
> worker - e.g. RT scheduling.  This is minimal queue / flush / flush
> all iterface on top of kthread and each provided interface matches the
> workqueue counterpart so that switching isn't difficult.
>
> However, one noticeable difference was that kthread_worker doesn't
> allow a work item to be freed while being executed.  The intention was
> to keep the code simpler but it didn't really and the restriction is
> subtle and does prevent some valid use cases.
>
> This two-patch series reimplements flush_kthread_work() so that it
> uses an extra work item for flushing.  While this takes a bit more
> lines, this is easier to understand and removes the annoying
> difference.
>
> This patchset contains the following two patches.
>
>  0001-kthread_worker-reorganize-to-prepare-for-flush_kthre.patch
>  0002-kthread_worker-reimplement-flush_kthread_work-to-all.patch
>
> The first one is a prep patch which makes no functional changes.  The
> second reimplements flush_kthread_work().
>
> All current kthread_worker users are cc'd.  If no one objects, I'll
> push it through the workqueue branch.  This patchset is also available
> in the following git branch.
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-kthread_worker-flush
>
> diffstat follows.  Thanks.
>
>  include/linux/kthread.h |    8 +---
>  kernel/kthread.c        |   86 +++++++++++++++++++++++++++---------------------
>  2 files changed, 52 insertions(+), 42 deletions(-)
>
> --
> tejun

This patch set fixes a reproducible crash I'm seeing on a 3.4.10
kernel.  flush_kthread_worker (which is different from
flush_kthread_work) is initializing a kthread_work and a completion on
the stack, then queuing it and calling wait_for_completion.  Once the
completion is signaled, flush_kthread_worker exits and the stack
region used by the kthread_work may be immediately reused by another
object on the stack, but kthread_worker_fn continues accessing its
work pointer:
                work->func(work);         <- calls complete,
effectively frees work
                smp_wmb();      /* wmb worker-b0 paired with flush-b1 */
                work->done_seq = work->queue_seq;   <- overwrites a
new stack object
                smp_mb();       /* mb worker-b1 paired with flush-b0 */
                if (atomic_read(&work->flushing))
                        wake_up_all(&work->done);  <- or crashes here

These patches fix the problem by not accessing work after work->func
is called, and should be backported to stable.  They apply cleanly to
3.4.10.  Upstream commits are 9a2e03d8ed518a61154f18d83d6466628e519f94
and 46f3d976213452350f9d10b0c2780c2681f7075b.
