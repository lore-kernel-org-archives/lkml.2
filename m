Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab2HMRDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 13:03:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63958 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab2HMRDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 13:03:08 -0400
Date: Mon, 13 Aug 2012 10:03:03 -0700
From: Tejun Heo <tj@kernel.org>
To: JoonSoo Kim <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] workqueue: change value of lcpu in
 queue_delayed_work_on()
Message-ID: <20120813170303.GF9180@google.com>
References: <1344874672-6257-1-git-send-email-js1304@gmail.com>
 <1344874672-6257-2-git-send-email-js1304@gmail.com>
 <20120813163219.GA9180@google.com>
 <CAAmzW4NfPAVQnmD0vG71Ahz_=gmV7CQBNABpnEHFU7YBsYJOyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAmzW4NfPAVQnmD0vG71Ahz_=gmV7CQBNABpnEHFU7YBsYJOyQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 14, 2012 at 01:54:22AM +0900, JoonSoo Kim wrote:
> wq = WQ_NON_REENTRANT.
> queue_delayed_work_on(CPU B) is invoked in CPU A, so lcpu = CPU A, cpu = CPU B.
> 
> In this case, we call add_time_on(CPU B), then delayed_work_timer_fn()
> is invoked on CPU B.
> delayed_work_timer_fn() calls __queue_work(), then following
> comparisons return true!
> 
>                 gcwq = get_gcwq(cpu);
>                 if (wq->flags & WQ_NON_REENTRANT &&
>                     (last_gcwq = get_work_gcwq(work)) && last_gcwq != gcwq) {
> 
> I thinks that if we assign cpu to lcpu, above comparisons return
> false, so save some overheads.
> Is there any missing part?

Nope, that sound correct to me.

> And, do u mean  @cpu is WORK_CPU_UNBOUND?

@cpu could be WORK_CPU_UNBOUND at that point.  The timer will be added
to local CPU but @work->data would be pointing to WORK_CPU_UNBOUND,
again triggering the condition.  Given that @cpu being
WORK_CPU_UNBOUND is far more common than an actual CPU number, the
patch would actually increase spurious nrt lookups.  The right thing
to do is probably setting cpu to raw_smp_processor_id() beforehand.

Thanks.

-- 
tejun
