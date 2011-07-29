Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386Ab1G2O2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 10:28:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab1G2O2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 10:28:33 -0400
Date: Fri, 29 Jul 2011 16:25:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt.fleming@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] coredump_wait: don't call complete_vfork_done()
Message-ID: <20110729142555.GC3501@redhat.com>
References: <20110727163159.GA23785@redhat.com> <20110727163311.GD23793@redhat.com> <1311944555.21232.68.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311944555.21232.68.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29, Matt Fleming wrote:
>
> On Wed, 2011-07-27 at 18:33 +0200, Oleg Nesterov wrote:
> > Now that CLONE_VFORK is killable, coredump_wait() no longer needs
> > complete_vfork_done(). zap_threads() should find and kill all tasks
> > with the same ->mm, this includes our parent if ->vfork_done is set.
> >
> > mm_release() becomes the only caller, unexport complete_vfork_done().
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> Isn't there a subtle change in user-visible behaviour regarding wait()
> with this patch?
>
> Before the patch, if a child dumps its core it will wakeup the parent
> which can read the status of the child via wait(), whereas with this
> patch applied the parent will actually be killed along with the child.

No.

Please note that if ->vfork_done != NULL, then ->real_parent shares
->mm with us, by definition of CLONE_VFORK.

In this case, with or without this patch, the parent was already
killed by zap_threads(). It can never do wait() or something else.

However. before 3/8, it was necessary to wakeup the TASK_UNINTERRUPTIBLE
parent, otherwise we deadlock. Once again, it can't do anything,
it will die immediately because of fatal_signal_pending().

After 3/8, zap_process()->signal_wake_up(1) wakes up the KILLABLE
parent, no need to do complete().

Oleg.

