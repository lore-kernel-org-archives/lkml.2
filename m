Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab1DKDGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 23:06:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62381 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab1DKDGO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 23:06:14 -0400
Message-ID: <4DA2709E.50902@cn.fujitsu.com>
Date: Mon, 11 Apr 2011 11:08:14 +0800
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
References: <1302077428.2225.1365.camel@twins> <20110406192119.GB2265@linux.vnet.ibm.com> <20110406201350.GA9378@linux.vnet.ibm.com> <1302123970.2207.4.camel@laptop> <4D9CDACB.9050705@linux.intel.com> <20110407003041.GD2265@linux.vnet.ibm.com> <4D9D507F.2040006@cn.fujitsu.com> <20110407154737.GF2262@linux.vnet.ibm.com> <20110407162600.GA24227@linux.vnet.ibm.com> <4D9E6438.5030206@cn.fujitsu.com> <20110408051359.GA2318@linux.vnet.ibm.com>
In-Reply-To: <20110408051359.GA2318@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-11 11:06:42,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-11 11:06:42
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2011 01:13 PM, Paul E. McKenney wrote:
> On Fri, Apr 08, 2011 at 09:26:16AM +0800, Lai Jiangshan wrote:
>> On 04/08/2011 12:26 AM, Paul E. McKenney wrote:
>>> On Thu, Apr 07, 2011 at 08:47:37AM -0700, Paul E. McKenney wrote:
>>>> On Thu, Apr 07, 2011 at 01:49:51PM +0800, Lai Jiangshan wrote:
>>>>> On 04/07/2011 08:30 AM, Paul E. McKenney wrote:
>>>>>> On Wed, Apr 06, 2011 at 02:27:39PM -0700, H. Peter Anvin wrote:
>>>>>>> On 04/06/2011 02:06 PM, Peter Zijlstra wrote:
>>>>>>>> On Wed, 2011-04-06 at 13:13 -0700, Paul E. McKenney wrote:
>>>>>>>>> And the following patch builds correctly for defconfig x86 builds,
>>>>>>>>> while allowing rcupdate.h to see the sched.h definitions as needed
>>>>>>>>> to inline rcu_read_lock() and rcu_read_unlock().
>>>>>>>>>
>>>>>>>> Looks like an entirely reasonable patch to me ;-)
>>>>>>>>
>>>>>>>
>>>>>>> Quite... a lot better than the original proposal!
>>>>>>
>>>>>> Glad you both like it!
>>>>>>
>>>>>> When I do an allyesconfig build, I do get errors during the "CHECK"
>>>>>> phase, when it is putting things into the usr/include in the build tree.
>>>>>> I believe that this is because I am exposing different header files to
>>>>>> the library-export scripts.  The following patch silences some of them,
>>>>>> but I am really out of my depth here.
>>>>>>
>>>>>> Sam, Jan, Michal, help?
>>>>>>
>>>>>> 							Thanx, Paul
>>>>>>
>>>>>> ------------------------------------------------------------------------
>>>>>>
>>>>>
>>>>> Easy to split rcupdate.h, hard to resolve the dependence problem.
>>>>>
>>>>> You can apply the next additional patch when you test:
>>>>
>>>> I am sure that you are quite correct.  ;-)
>>>>
>>>> I am moving _rcu_read_lock() and _rcu_read_unlock() into
>>>> include/linux/rcutree.h and include/linux/rcutiny.h, and I am sure that
>>>> more pain will ensue.
>>>>
>>>> One thing I don't understand...  How does is it helping to group the
>>>> task_struct RCU-related fields into a structure?  Is that generating
>>>> better code on your platform due to smaller offsets or something?
>>
>> You don't like task_rcu_struct patch? I think it can make code clearer,
>> and it can also check the code even when CONFIG_PREEMPT_RCU=n.
>>
>> For rcu_read_[un]lock(), it generates the same code, no better, no worse.
>>
>> It is just a cleanup patch, it is helpless for making rcu_read_[un]lock() inline,
>> if you don't like it, I will give up it.
> 
> I don't know that I feel strongly either way about it.  It was necessary
> with the integer-offset approach, but optional now.
> 
>>>> Also, does your patchset address the CHECK warnings?
>>>
>>> I take it back...  I applied the following patch on top of my earlier
>>> one, and a defconfig x86 build completed without error.  (Though I have
>>> not tested the results of the build.)
>>>
>>> One possible difference -- I did this work on top of a recent Linus
>>> git commit (b2a8b4b81966) rather than on top of my -rcu tree.  Also,
>>> I have not yet tried an allyesconfig build, which will no doubt locate
>>> some more problems.
>>>
>>> 							Thanx, Paul
>>>
>>
>> when defconfig or allyesconfig, CONFIG_PREEMPT=n and CONFIG_TREE_PREEMPT_RCU=n
>> when you make them "y":
>>
>> In file included from include/linux/rcupdate.h:764:0,
>>                  from include/linux/tracepoint.h:19,
>>                  from include/linux/module.h:18,
>>                  from include/linux/crypto.h:21,
>>                  from arch/x86/kernel/asm-offsets.c:8:
>> include/linux/rcutree.h:50:20: error: static declaration of ‘__rcu_read_lock’ follows non-static declaration
>> include/linux/rcupdate.h:76:13: note: previous declaration of ‘__rcu_read_lock’ was here
>> include/linux/rcutree.h:63:20: error: static declaration of ‘__rcu_read_unlock’ follows non-static declaration
>> include/linux/rcupdate.h:77:13: note: previous declaration of ‘__rcu_read_unlock’ was here
>> make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
>> make: *** [prepare0] Error 2
> 
> Yep.  I need to move the rcu_read_lock() APIs to follow the inclusion
> of rcutree.h and rcutiny.h.  Also add include of sched.h to rcutiny.h.
> The code movement does bloat the patch a bit.  But rcu_assign_pointer()
> must precede the inclusion of rcutree.h and rcutiny.h, so it is not
> possible to simply move the inclusions.  See below.
> 
> 							Thanx, Paul
> 

sched.h still contains rcupdate.h after applied this patch.
See my [PATCH 2/4] for more info.


# make lib/is_single_threaded.o
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CC      lib/is_single_threaded.o
In file included from include/linux/rcupdate.h:639:0,
                 from include/linux/rculist.h:10,
                 from include/linux/sched.h:82,
                 from lib/is_single_threaded.c:13:
include/linux/rcutree.h: In function ‘__rcu_read_lock’:
include/linux/rcutree.h:52:15: error: dereferencing pointer to incomplete type
In file included from include/linux/rcupdate.h:639:0,
                 from include/linux/rculist.h:10,
                 from include/linux/sched.h:82,
                 from lib/is_single_threaded.c:13:
include/linux/rcutree.h: In function ‘__rcu_read_unlock’:
include/linux/rcutree.h:68:5: error: dereferencing pointer to incomplete type
include/linux/rcutree.h:70:7: error: dereferencing pointer to incomplete type
include/linux/rcutree.h:71:46: error: dereferencing pointer to incomplete type
include/linux/rcutree.h:71:78: error: dereferencing pointer to incomplete type
include/linux/rcutree.h:71:6: warning: type defaults to ‘int’ in type name
make[1]: *** [lib/is_single_threaded.o] Error 1
make: *** [lib/is_single_threaded.o] Error 2
