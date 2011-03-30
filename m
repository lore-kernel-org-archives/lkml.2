Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab1C3FX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 01:23:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59370 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab1C3FX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 01:23:28 -0400
Message-ID: <4D92BECA.50802@cn.fujitsu.com>
Date: Wed, 30 Mar 2011 13:25:30 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: paulmck@linux.vnet.ibm.com, Jan Beulich <JBeulich@novell.com>,
        Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
References: <4D8FF8AD.5080607@cn.fujitsu.com> <4D8FF9BC.7050609@cn.fujitsu.com> <4D90647902000078000389CB@vpn.id2.novell.com> <4D924BAF.1020906@linux.intel.com> <20110329213130.GK2261@linux.vnet.ibm.com> <4D924FEE.8040804@linux.intel.com> <20110329214704.GM2261@linux.vnet.ibm.com> <4D9256AF.5000308@linux.intel.com> <20110330004725.GO2261@linux.vnet.ibm.com>
In-Reply-To: <20110330004725.GO2261@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-30 13:21:53,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-30 13:21:55,
	Serialize complete at 2011-03-30 13:21:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2011 08:47 AM, Paul E. McKenney wrote:
> On Tue, Mar 29, 2011 at 03:01:19PM -0700, H. Peter Anvin wrote:
>> On 03/29/2011 02:47 PM, Paul E. McKenney wrote:
>>> On Tue, Mar 29, 2011 at 02:32:30PM -0700, H. Peter Anvin wrote:
>>>> On 03/29/2011 02:31 PM, Paul E. McKenney wrote:
>>>>>>
>>>>>> I have to say that if we have to use hardcoded offsets in C then we have
>>>>>> bigger problems.
>>>>>
>>>>> In this case, the offsets are mechanically generated from the structure
>>>>> definitions.
>>>>>
>>>>> Or am I missing your point?
>>>>
>>>> Yes.  The point is if we have to pull out these kinds of hacks in *C*
>>>> code, we are doing it wrong.  Not just a little wrong, but completely
>>>> and totally bonkers wrong.
>>>
>>> OK, maybe we are doing it wrong.
>>>
>>> But in that case, how do you suggest restructuring include/linux/sched.h
>>> so that struct task_struct can be safely included everywhere
>>> rcu_read_lock() and friends are invoked?  Or, on the other hand,
>>> what should we be doing so that we don't need to include task_struct
>>> everywhere?
>>
>> Lai's text doesn't give any hint as to the specific nature of the
>> conflict, which makes it hard to come up with a better alternative
>> without having to rediscover the problem from first principles.
>> However, a somewhat logical assumption is that the problem is that
>> struct task_struct includes struct rcu_head, in which case the easiest
>> thing to do is almost certainly to move the definition of struct
>> rcu_head to its own header file, <linux/rcuhead.h>, and include that in
>> <linux/sched.h>, which should make it possible to include
>> <linux/sched.h> in <linux/rcupdate.h>.
> 
> I believe that there are other circular dependencies -- there certainly
> were a few years back -- but I will defer to Lai.
> 
> 							Thanx, Paul
> 

Yes, there are other circular dependencies, <linux/sched.h> includes
many files which include or indirectly include <linux/rcupdate.h>
for struct rcu_head or RCU apis. There are too many to be split all.

Even we just create a <linux/task_struct_def.h>, it also needs to include
many files which have included or indirectly included <linux/rcupdate.h>
for struct rcu_head already. It is still not a easy work to split them,
it still requires many subsystem maintainers to participate in.

RCU is one of the most import subsystem,
I think it is worth to do such "wrong" way.

Thanks,
Lai

P.S.

Circular dependencies is one of the original sins of C language.
If it is a good change for lots of linux hackers participating in
to split all un-split kernel headers, I'd like to do so too.
