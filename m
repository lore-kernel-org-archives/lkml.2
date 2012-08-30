Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab2H3TPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 15:15:33 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:56057 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab2H3TPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 15:15:32 -0400
X-Originating-IP: 217.70.178.134
X-Originating-IP: 173.246.103.110
Date: Thu, 30 Aug 2012 12:15:23 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 5/5] rcu: Prevent initialization race in
 rcutorture kthreads
Message-ID: <20120830191523.GF6749@jtriplet-mobl1>
References: <20120830184448.GA31753@linux.vnet.ibm.com>
 <1346352312-31987-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352312-31987-5-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346352312-31987-5-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:45:12AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> When you do something like "t = kthread_run(...)", it is possible that
> the kthread will start running before the assignment to "t" happens.
> If the child kthread expects to find a pointer to its task_struct in "t",
> it will then be fatally disappointed.  This commit therefore switches
> such cases to kthread_create() followed by wake_up_process(), guaranteeing
> that the assignment happens before the child kthread starts running.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Seems like you should go ahead and make this change for all the threads,
not just two of them.  A simple wrapper around kthread_run, taking a
struct task_struct ** to write to, would make this much simpler.  Such a
wrapper could also return an error code directly (for use in firsterr),
write NULL to the pointer on error, and perhaps print an error message,
which would remove most of the boilerplate currently duplicated for
every thread creation.

Arguably, all of those except the error message printing would make
sense as changes to kthread_run itself, but that's another patch. :)

- Josh Triplett
