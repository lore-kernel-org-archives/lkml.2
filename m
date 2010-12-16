Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab0LPTpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 14:45:25 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:62584 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab0LPTpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 14:45:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QDG+RUq0WCZ7NzND4KRDxfsNjdFzaANbz9qLPcShOFYFvFJ2LInsskdKnDHRNTkkl3
         aPSc5/ezr1Fb8na6S2/7EJgTjsDGbbUgq3iTmtlsNfKm/BiD1vLymlPWkrwaEOf0pNjF
         dY78vQBpOx/54PhN7UJQLZnNLIfeSr/XVEaSI=
Message-ID: <4D0A6B03.6080603@am.sony.com>
Date: Thu, 16 Dec 2010 11:39:47 -0800
From: Frank Rowand <frank.rowand@gmail.com>
Reply-To: frank.rowand@am.sony.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: frank.rowand@am.sony.com
CC: frank.rowand@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/5] Reduce runqueue lock contention -v2
References: <20101216145602.899838254@chello.nl> <4D0A649B.9080505@am.sony.com> <4D0A6A40.2040907@am.sony.com>
In-Reply-To: <4D0A6A40.2040907@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/10 11:36, Frank Rowand wrote:
> 
> 
> patch 1 of 2

The email that explains the context for this does not seem to have gotten
through to the list.  Here is the email that this patch should have been
a reply to:

On 12/16/10 06:56, Peter Zijlstra wrote:
> Hi, here a new posting of my scary patch(es) ;-)
> 
> These actually survive a sembench run (and everything else I threw at it).
> The discussion between Mike and Frank over the task_running() check made me
> realize what was wrong with the previous one.
> 
> As it turns out, what was needed (p->oncpu) was something Thomas wanted me
> to do for an entirely different reason (see patch #2).
> 
> Frank's patch, while encouraging me to poke at it again, has a number of
> very fundamental problems with it, the most serious one being that it
> completely wrecks the wake-up load-balancing.

And also as Peter pointed out when I posted the patch (thank you Peter),
I did not properly handle the return value for try_to_wake_up() - a rather
fatal flaw.

By coincidence, I was about to post a new version of my scary patch when
this email arrived.  I'll post my patches as a reply to this email, then
read through Peter's.


Frank's patch, Version 2

Changes from Version 1:
  - Ensure return value of try_to_wake_up() is correct, even when queueing
    wake up on a different cpu.
  - rq->lock contention reduction not as good as first version

patch 1

  The core changes.  All the scary lock related stuff.

  select_task_rq() uses the smp_processor_id() of the old task_cpu(p) instead
  of the waking smp_processor_id().

patch 2

  select_task_rq() uses the smp_processor_id() of the waking smp_processor_id()
  
Limitations
  x86 only

Tests
  - tested on 2 cpu x86_64
  - very simplistic workload
  - results:
     rq->lock contention count reduced by ~ 75%
     rq->lock contention wait time reduced by ~ 70%
     test duration reduction is in the noise
     rq->lock contention improvement is slightly better with just patch 1
       applied, but the difference is in the noise

Todo
  - handle cpu being offlined


-Frank
