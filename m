Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab2LESzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 13:55:06 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:48910 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab2LESzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 13:55:04 -0500
Message-ID: <50BF982D.7090704@linux.vnet.ibm.com>
Date: Thu, 06 Dec 2012 00:23:33 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        oleg@redhat.com, sbw@mit.edu, amit.kucheria@linaro.org,
        rostedt@goodmis.org, rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 01/10] CPU hotplug: Provide APIs for "light" atomic
 readers to prevent CPU offline
References: <20121205184041.3750.64945.stgit@srivatsabhat.in.ibm.com> <20121205184258.3750.31879.stgit@srivatsabhat.in.ibm.com> <50BF96DF.3000500@linux.vnet.ibm.com> <50BF979A.50304@linux.vnet.ibm.com>
In-Reply-To: <50BF979A.50304@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120518-2000-0000-0000-00000A249A14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaying what Tejun wrote:

Hello, Oleg.

> Replaying what Oleg wrote:
> 
> Hi,
> 
> Sorry I don't understand the context and I can't find this thread
> anywhere, so I am not sure I understand...
> 

Weird, lkml cc is missing.  Srivatsa?

[Now fixed. This thread has lkml CC]

>> Replaying what Tejun wrote:
>> So, we basically need percpu_rwlock.  We already have percpu_rwsem.
> 
> Yes, and with -mm patches it becomes reader-friendly. In particular
> see http://marc.info/?l=linux-mm-commits&m=135240650828875
> 
>> Oleg, it seems
>> CPU hotplug needs big-reader rwlock, ideas on how to proceed?
>>
> 
> I am going to convert get_online_cpus() to use percpu_down_read(),
> this looks simple.
> 
> We already discussed this with Paul, see
> 
> 	http://marc.info/?l=linux-kernel&m=135248463226031
> 
> and the whole thread.
> 
> In short, all we need is percpu_down_write_recursive_readers() and
> afaics the only complication is lockdep, we need down_read_no_lockdep()
> which (like __up_read) doesn't do rwsem_acquire_read().
> 

So, it's a different thing.  There are two mechanism protecting
against cpu hotplug - get_online_cpus() and preempt_disable().  The
former can be used by ones which can sleep and need to protect against
the whole up/down process (DOWN_PREPARE and so on).  The latter
protects the last step and can be used when the caller can't sleep.
Replacing get_online_cpus() w/ percpu_rwsem is great but this thread
is about replacing preempt_disable with something finer grained and
less heavy on the writer side - IOW, percpu_rwlock as opposed to
percpu_rwsem, so, I think the end result would be that CPU hotplug
will be protected by percpu_rwsem for the whole part and by
percpu_rwlock for the last commit stage.

The problem seems that we don't have percpu_rwlock yet.  It shouldn't
be too difficult to implement, right?

Thanks.

-- tejun 

