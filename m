Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab1C0MBN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 08:01:13 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:43201 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab1C0MBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 08:01:12 -0400
X-ASG-Debug-ID: 1301227262-01de284cf8c4970001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D8F26F9.3000905@fusionio.com>
Date: Sun, 27 Mar 2011 14:00:57 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39
References: <4D8B4A89.80608@fusionio.com> <4D8F2455.2080205@redhat.com>
X-ASG-Orig-Subj: Re: [GIT PULL] Core block IO bits for 2.6.39
In-Reply-To: <4D8F2455.2080205@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301227262
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.59112
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-27 13:49, Avi Kivity wrote:
> On 03/24/2011 03:43 PM, Jens Axboe wrote:
>> Hi Linus,
>>
>> This is the main pull request for the block IO layer and friends for
>> 2.6.39.
>>
>> There are two major things in this tree:
>>
>> - The removal of the per-device plugging state for disks. On fast
>>    devices, it ended up hammering the queue lock quite hard. The new
>>    scheme puts the plugging state on the stack and allows an IO submitter
>>    to finish his batch of IO before pushing it to the queue. Once that
>>    push starts, we'll insert/merge with the existing queue.
>>
>>    A pointer to this plugging context is stored in the task structure. If
>>    a task ends up blocking before it has submitted it's IO (usual cause
>>    would be memory allocation of some sort), the plugged list is
>>    auto-submitted before the task goes to sleep.
> 
> This is the fourth "do something if preempted" hook (the other three are 
> kvm, cmwq, and perf).  Why not use sched notifiers for this?

It's a 'if preempted', it's 'if going to sleep'. Two issues with the
preempt notifiers for this, I did look into it:

- Not unconditionally available. Not a big problem, we could just do
  that.

- Sched out is called under the runqueue lock, and it's not safe to drop
  it.

But it's not a bad point, it would be nice if we could unify all these
use cases and provide a notifier that works for all.

-- 
Jens Axboe

