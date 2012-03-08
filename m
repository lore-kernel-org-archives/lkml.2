Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab2CHNJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 08:09:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47642 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab2CHNJK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 08:09:10 -0500
Message-ID: <1331212113.11248.392.camel@twins>
Subject: Re: [RFC PATCH 5/5 single-thread-version] implement per-domain
 single-thread state machine call_srcu()
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org
Date: Thu, 08 Mar 2012 14:08:33 +0100
In-Reply-To: <4F56DBDA.1020608@cn.fujitsu.com>
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
	 <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
	 <1331027858-7648-4-git-send-email-laijs@cn.fujitsu.com>
	 <4F56DBDA.1020608@cn.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-07 at 11:54 +0800, Lai Jiangshan wrote:
> This patch is on the top of the 4 previous patches(1/6, 2/6, 3/6, 4/6).
> 
> o       state machine is light way and single-threaded, it is preemptible when checking.
> 
> o       state machine is a work_struct. So, there is no thread occupied
>         by SRCU when the srcu is not actived(no callback). And it does
>         not sleep(avoid to occupy a thread when sleep).
> 
> o       state machine is the only thread can flip/check/write(*) the srcu_struct,
>         so we don't need any mutex.
>         (write(*): except ->per_cpu_ref, ->running, ->batch_queue)
> 
> o       synchronize_srcu() is always call call_srcu().
>         synchronize_srcu_expedited() is also.
>         It is OK for mb()-based srcu are extremely fast.
> 
> o       In current kernel, we can expect that there are only 1 callback per gp.
>         so callback is probably called in the same CPU when it is queued.
> 
> The trip of a callback:
>         1) ->batch_queue when call_srcu()
> 
>         2) ->batch_check0 when try to do check_zero
> 
>         3) ->batch_check1 after finish its first check_zero and the flip
> 
>         4) ->batch_done after finish its second check_zero
> 
> The current requirement of the callbacks:
>         The callback will be called inside process context.
>         The callback should be fast without any sleeping path.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com> 

Aside from the nit on srcu_advance_batches() this seems like a nice
implementation. Thanks!

I didn't fully verify the srcu state machine, but it looks about
right :-)

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
