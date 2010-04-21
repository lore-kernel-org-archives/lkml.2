Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab0DUJMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 05:12:12 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:58499 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab0DUJMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 05:12:09 -0400
Message-ID: <4BCEC166.50207@dcl.info.waseda.ac.jp>
Date: Wed, 21 Apr 2010 18:12:06 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH] perf lock: Fix state machine to recognize lock sequence
References: <4BC09546.5050309@dcl.info.waseda.ac.jp> <1271407446-27180-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20100421012651.GC7120@nowhere>
In-Reply-To: <20100421012651.GC7120@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/10 10:26, Frederic Weisbecker wrote:
 > On Fri, Apr 16, 2010 at 05:44:06PM +0900, Hitoshi Mitake wrote:
 >> Hi Ingo,
 >>
 >> I'm developing the model to recognize the correct sequence of lock 
events.
 >> Previous state machine of perf lock was really broken.
 >> This patch improves it a little.
 >>
 >> This patch prepares the array of state machine represents lock 
sequence for each threads.
 >> These state machines represent one of these sequence:
 >>
 >>        1) acquire ->  acquired ->  release
 >>        2) acquire ->  contended ->  acquired ->  release
 >>        3) acquire (w/ try) ->  release
 >>        4) acquire (w/ read) ->  release
 >>
 >> The case of 4) is a little special.
 >> Double acquire of read lock is allowed, so state machine of sequence
 >> counts read lock number, and permit double acquire and release.
 >>
 >> But, things are not so simple. Something of my model is still wrong.
 >> I counted the number of lock instances with bad sequence,
 >> and ratio is like this (case of tracing whoami): bad:122, total:1956
 >
 >
 >
 > I just gave your patch a try and it's worse: almost every sequences
 > were reported bad (it wasn't working either before your patch :)
 >
 > This is not the fault of your patch though. Actually your patch seems to
 > be a nice improvement.

Thanks for your review, Frederic!

 >
 > In fact I just found two things:
 >
 > 1) We are working on tasks in pid basis. We should work on a task by 
using
 > its tid.
 > In fact we are processing the sequences of several threads in a 
process as
 > if we were dealing with a single task.
 >
 > If A and B are two threads belonging to a same process, and if we have:
 >
 > A: acquire lock 1, release lock 1
 > B: acquire lock 2, release lock 2
 >
 > ...then we are dealing with a random mess of sequences:
 >
 > AB: acquire lock 1, acquire lock 2, release lock 1, and any kind of 
random
 > things like this.


Ah, I missed tid. I'll fix this point.

 >
 > 2) I can't get lock_acquired traces. Not sure why yet...

Really? It's mystery... I'll seek the cause.

 >
 >
 >>
 >> There is another new bad thing.
 >> The size of array of state machine is equal to max depth lockdep 
defines.
 >> If perf lock record tries to record lock events of the programs with 
lots of
 >> system call like "perf bench sched messaging", the array will be 
exhausted :(
 >
 >
 >
 > Yeah, I suggest you use a list for that in fact. The max lockdep 
depth may
 > change in the future, or become variable, so we can't relay on that.

Yeah, I'll use list or hashtable.

 >
 > But that's still a cool improvement.
 >
 > I'm queuing this patch.

Thanks! But I have to fix some points based on your advice.
Should I send v2 patch or make fix on your tree?

Thanks,
	Hitoshi
