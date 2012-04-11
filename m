Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761296Ab2DKVMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 17:12:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32694 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab2DKVL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 17:11:59 -0400
X-Authority-Analysis: v=2.0 cv=P4S4d18u c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=qp4yekXCDa0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=JfrnYn6hAAAA:8 a=pGLkceISAAAA:8 a=Ct8BtjlUBusx088obRIA:9 a=PUjeQqilurYA:10 a=3Rfx1nUSh_UA:10 a=MSl-tDqOz04A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334178715.23924.308.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 12/16] rtmutex: turn the plist into an rb-tree.
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Date: Wed, 11 Apr 2012 17:11:55 -0400
In-Reply-To: <1333696481-3433-13-git-send-email-juri.lelli@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-13-git-send-email-juri.lelli@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> Turn the pi-chains from plist to rb-tree, in the rt_mutex code,
> and provide a proper comparison function for -deadline and
> -priority tasks.

I have to ask. Why not just add a rbtree with a plist? That is, add all
deadline tasks to the rbtree and all others to the plist. As plist has a
O(1) operation, and rbtree does not. We are making all RT tasks suffer
the overhead of the rbtree.

As deadline tasks always win, the two may stay agnostic from each other.
Check first the rbtree, if it is empty, then check the plist.

This will become more predominant with the -rt tree as it converts most
the locks in the kernel to pi mutexes.

-- Steve

> 
> This is done mainly because:
>  - classical prio field of the plist is just an int, which might
>    not be enough for representing a deadline;
>  - manipulating such a list would become O(nr_deadline_tasks),
>    which might be to much, as the number of -deadline task increases.
> 
> Therefore, an rb-tree is used, and tasks are queued in it according
> to the following logic:
>  - among two -priority (i.e., SCHED_BATCH/OTHER/RR/FIFO) tasks, the
>    one with the higher (lower, actually!) prio wins;
>  - among a -priority and a -deadline task, the latter always wins;
>  - among two -deadline tasks, the one with the earliest deadline
>    wins.
> 
> Queueing and dequeueing functions are changed accordingly, for both
> the list of a task's pi-waiters and the list of tasks blocked on
> a pi-lock.
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Dario Faggioli <raistlin@linux.it>
> Signed-off-by: Juri Lelli <juri.lelli@gmail.com>


