Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab0DWMYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 08:24:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451Ab0DWMYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 08:24:07 -0400
Date: Fri, 23 Apr 2010 14:20:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
       Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 7/9] PM: Add suspend blocking work.
Message-ID: <20100423122032.GA23544@redhat.com>
References: <1271984938-13920-1-git-send-email-arve@android.com> <1271984938-13920-2-git-send-email-arve@android.com> <1271984938-13920-3-git-send-email-arve@android.com> <1271984938-13920-4-git-send-email-arve@android.com> <1271984938-13920-5-git-send-email-arve@android.com> <1271984938-13920-6-git-send-email-arve@android.com> <1271984938-13920-7-git-send-email-arve@android.com> <1271984938-13920-8-git-send-email-arve@android.com> <4BD1576E.5070401@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BD1576E.5070401@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23, Tejun Heo wrote:
>
> On 04/23/2010 03:08 AM, Arve Hjønnevåg wrote:
> > Allow work to be queued that will block suspend while it is pending
> > or executing. To get the same functionality in the calling code often
> > requires a separate suspend_blocker for pending and executing work, or
> > additional state and locking.
>
> Hmm... I think this can be implemented as pure wrapper around
> workqueue instead of injecting a flag and code into workqueue core.
> Adding @fn field to suspend_blocking_work struct and using a custom
> work function to call it and then invoke suspend_unblock() should be
> enough, right?  Oh, dedicated queue functions will be needed too.  I
> don't think it's wise to meddle with workqueue core code for this.

Completely agreed. The patch adds very "strange" hacks into workqueue
code to solve the very specific problems.


Besides, the patch doesn't look right. suspend_unblock() can be called
twice if you use cancel_work(). Perhaps this is not a problem, I dunno.
WORK_STRUCT_SUSPEND_BLOCKING needs to ensure that cpu_workqueue_struct
has a proper alignment. The unblock code in run_workqueue() is racy,
it can unblock after the work was queued on another CPU, cwq->lock can't
help.

Oleg.

