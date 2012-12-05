Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab2LESeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 13:34:13 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:49649 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab2LESeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 13:34:11 -0500
Message-ID: <50BF9349.6010205@linux.vnet.ibm.com>
Date: Thu, 06 Dec 2012 00:02:41 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>, tglx@linutronix.de, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org,
        vincent.guittot@linaro.org, sbw@mit.edu, amit.kucheria@linaro.org,
        rostedt@goodmis.org, rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v2 01/10] CPU hotplug: Provide APIs for "light" atomic
 readers to prevent CPU offline
References: <20121205131038.17383.55472.stgit@srivatsabhat.in.ibm.com> <20121205131136.17383.23318.stgit@srivatsabhat.in.ibm.com> <20121205142316.GI3885@mtj.dyndns.org> <20121205164640.GA7382@redhat.com> <20121205165356.GL3885@mtj.dyndns.org>
In-Reply-To: <20121205165356.GL3885@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120518-9574-0000-0000-000005A09E7B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2012 10:23 PM, Tejun Heo wrote:
> Hello, Oleg.
> 
> On Wed, Dec 05, 2012 at 05:46:40PM +0100, Oleg Nesterov wrote:
>> Sorry I don't understand the context and I can't find this thread
>> anywhere, so I am not sure I understand...
> 
> Weird, lkml cc is missing.  Srivatsa?
> 

Argh! I forgot to CC mailing lists :-(
Sorry about that! I'll repost the patchset (and I'll probably even
try to post the comments that you and Oleg have already given, for
the benefit of other readers).

Regards,
Srivatsa S. Bhat

>> On 12/05, Tejun Heo wrote:
>>>
>>> So, we basically need percpu_rwlock.  We already have percpu_rwsem.
>>
>> Yes, and with -mm patches it becomes reader-friendly. In particular
>> see http://marc.info/?l=linux-mm-commits&m=135240650828875
>>
>>> Oleg, it seems
>>> CPU hotplug needs big-reader rwlock, ideas on how to proceed?
>>
>> I am going to convert get_online_cpus() to use percpu_down_read(),
>> this looks simple.
>>
>> We already discussed this with Paul, see
>>
>> 	http://marc.info/?l=linux-kernel&m=135248463226031
>>
>> and the whole thread.
>>
>> In short, all we need is percpu_down_write_recursive_readers() and
>> afaics the only complication is lockdep, we need down_read_no_lockdep()
>> which (like __up_read) doesn't do rwsem_acquire_read().
> 
> So, it's a different thing.  There are two mechanism protecting
> against cpu hotplug - get_online_cpus() and preempt_disable().  The
> former can be used by ones which can sleep and need to protect against
> the whole up/down process (DOWN_PREPARE and so on).  The latter
> protects the last step and can be used when the caller can't sleep.
> Replacing get_online_cpus() w/ percpu_rwsem is great but this thread
> is about replacing preempt_disable with something finer grained and
> less heavy on the writer side - IOW, percpu_rwlock as opposed to
> percpu_rwsem, so, I think the end result would be that CPU hotplug
> will be protected by percpu_rwsem for the whole part and by
> percpu_rwlock for the last commit stage.
> 
> The problem seems that we don't have percpu_rwlock yet.  It shouldn't
> be too difficult to implement, right?
> 
> Thanks.
> 

