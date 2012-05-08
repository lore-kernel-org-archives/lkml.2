Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572Ab2EHW1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:27:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:55514 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab2EHW1S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:27:18 -0400
Message-ID: <1336516020.8226.57.camel@twins>
Subject: RE: [PATCH] sched: Make nr_uninterruptible count a signed value
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Diwakar Tundlam <dtundlam@nvidia.com>
Cc: "'Ingo Molnar'" <mingo@kernel.org>,
        "'David Rientjes'" <rientjes@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Date: Wed, 09 May 2012 00:27:00 +0200
In-Reply-To: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10D@HQMAIL04.nvidia.com>
References: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10C@HQMAIL04.nvidia.com>
	 <1336514192.8226.52.camel@twins>
	 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10D@HQMAIL04.nvidia.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 15:14 -0700, Diwakar Tundlam wrote:
> Sorry to bug you when it is late for you..
> 
Nah, I'm the idiot still behind the screen after midnight, its just the
brain that's slightly slower and needs more hints.

> You're right, there is no real difference at all.
> Only cosmetic difference when you look at the output of
> cat /proc/sched_debug.

Not sure I see that.. the printf is still using %Ld (signed) so the
output shouldn't matter regardless of if the variable is unsigned long
or long.
> 
> But I suddenly realized maybe the increment/decrement of
> nr_interruptible is reversed.
> Maybe that's the source of the problem: decrement in activate task and
> increment in deactivate task !!

No that's right. nr_uninterruptible counts the number of tasks in
uninterruptible sleep, so deactivate_task puts a task to sleep, so we
need to increment the number of sleeping tasks, activate_task wakes a
task up so we need to decrement the number of sleeping tasks.

I think the problem you're having is that we don't match the cpu where
we inc and dec the counter, and that's fully on purpose since its rather
expensive -- it would require atomics.

