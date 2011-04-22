Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab1DVHRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 03:17:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65173 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab1DVHRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 03:17:30 -0400
Message-ID: <4DB12C1E.8050200@cn.fujitsu.com>
Date: Fri, 22 Apr 2011 15:19:58 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
References: <4D9CDACB.9050705@linux.intel.com> <20110407003041.GD2265@linux.vnet.ibm.com> <4D9D507F.2040006@cn.fujitsu.com> <20110407154737.GF2262@linux.vnet.ibm.com> <20110407162600.GA24227@linux.vnet.ibm.com> <4D9E6438.5030206@cn.fujitsu.com> <20110408051359.GA2318@linux.vnet.ibm.com> <4DA2709E.50902@cn.fujitsu.com> <20110411051241.GB18415@linux.vnet.ibm.com> <4DA2BC4E.4010000@cn.fujitsu.com> <20110411210223.GB2226@linux.vnet.ibm.com>
In-Reply-To: <20110411210223.GB2226@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-22 15:17:58,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-22 15:17:59,
	Serialize complete at 2011-04-22 15:17:59
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2011 05:02 AM, Paul E. McKenney wrote:
> On Mon, Apr 11, 2011 at 04:31:10PM +0800, Lai Jiangshan wrote:
>> On 04/11/2011 01:12 PM, Paul E. McKenney wrote:
>>
>>> -static inline struct task_struct *next_thread(const struct task_struct *p)
>>> -{
>>> -	return list_entry_rcu(p->thread_group.next,
>>> -			      struct task_struct, thread_group);
>>> -}
>>> +/* Avoid #include hell for inlining rcu_read_lock(). */
>>> +#define next_thread(p) \
>>> +	list_entry_rcu((p)->thread_group.next, struct task_struct, thread_group)
>>>  
>>
>>
>> It is strange for me.
>> The user of the API "next_thread(p)" must has two headers included, sched.h and rculist.h
>>
>> I know this is a very popular pattern of user space code, is it OK for kernel?
>> I think a file(even a header file) uses API(Marco), it should includes the the corresponding
>> headers, it reduces surprises(example, the name of "next_thread()" has no "rcu",
>> it is not expected that rcuxxxx.h is required).
>>
>> I admit the work will become very much simpler if this pattern is allowed.
> 
> The guy who maintains much of sched.h suggested it.  ;-)
> 
> 							Thanx, Paul
> 
>> man fcntl:
>>        #include <unistd.h>
>>        #include <fcntl.h>
>>
>>        int fcntl(int fd, int cmd, ... /* arg */ );
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Hi, Paul

What is the solution you prefer to?

I insist on the solution which split rcupdate.h into 2 parts,
the first part is rcupdate_defs.h which only contains:
1) struct rcu_head
2) MACRO rcu_dereference*
3) MACRO rcu_access_pointer rcu_access_index rcu_assign_pointer RCU_INIT_POINTER
4) rcu_*_lock_held() which is required by 2)

All of these is required by sched.h, it is all about 450 lines of code.

It does not just separate struct rcu_head out only, because rcu_dereference*()
and APIs in rculist.h are required by in sched.h or headers included by sched.h.

Any suggestion?

Thanks,
Lai
