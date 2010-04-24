Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab0DXGfE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 02:35:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:45203 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab0DXGfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 02:35:00 -0400
Message-ID: <4BD290CC.4080601@kernel.org>
Date: Sat, 24 Apr 2010 08:33:48 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
CC: Oleg Nesterov <oleg@redhat.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
       Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 7/9] PM: Add suspend blocking work.
References: <1271984938-13920-1-git-send-email-arve@android.com>	 <1271984938-13920-2-git-send-email-arve@android.com>	 <1271984938-13920-3-git-send-email-arve@android.com>	 <1271984938-13920-4-git-send-email-arve@android.com>	 <1271984938-13920-5-git-send-email-arve@android.com>	 <1271984938-13920-6-git-send-email-arve@android.com>	 <1271984938-13920-7-git-send-email-arve@android.com>	 <1271984938-13920-8-git-send-email-arve@android.com>	 <4BD1576E.5070401@kernel.org> <20100423122032.GA23544@redhat.com> <y2ud6200be21004231549q8e52c9c0z441d82b5a15e177d@mail.gmail.com>
In-Reply-To: <y2ud6200be21004231549q8e52c9c0z441d82b5a15e177d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 24 Apr 2010 06:33:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 04/24/2010 12:49 AM, Arve Hjønnevåg wrote:
> I want the suspend blocker active when the work is pending or running.
> I did not see a way to do this on top of the workqueue api without
> adding additional locking.

Well, then add additional locking.  suspend_blocker is far away from
being a hot path and there's nothing wrong with additional locking as
long as everything is wrapped inside proper APIs.  Adding stuff to the
core code for things as specific as this is much worse.

> If the work is both queued and starts running on another workqueue
> between "get_wq_data(work) == cwq" and "!work_pending(work)", then
> suspend_unblock will be called when it shouldn't. It should work fine
> if I change to it check pending first though, since it cannot move
> back to the current workqueue without locking cwq->lock first.

The code is more fundamentally broken.  Once work->func has started
executing, the work pointer can't be dereferenced as work callback is
allowed to free or re-purpose the work data structure and in the same
manner you can't check for pending status after execution has
completed.

> Or are you talking about the race when the callback is running on
> multiple (cpu) workqueues at the same time. In that case the suspend
> blocker is released when the callback returns from the last workqueue
> is was queued on, not when all the callbacks have returned. On that
> note, is it ever safe to use flush_work and cancel_work_sync for work
> queues on anything other than a single single threaded workqueue?

flush_work() is guaranteed only to flush from the last queued cpu but
cancel_work_sync() will guarantee that no cpu is executing or holding
onto the work.  So, yeah, as long as the limitations of flush_work()
is understood, it's safe.

Going back to the original subject, just add simplistic outside
locking in suspend_blocker_work API (or whatever other name you
prefer).  That will be much cleaner and safer.  Let's think about
moving them into workqueue implementation proper after the number of
the API users grows to hundreds.

Thanks.

-- 
tejun
