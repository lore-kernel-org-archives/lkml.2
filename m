Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab2KFRlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 12:41:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab2KFRls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 12:41:48 -0500
Message-ID: <50994BC1.1000705@redhat.com>
Date: Tue, 06 Nov 2012 09:41:21 -0800
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: uprobes && pre-filtering
References: <20121105190446.GA6188@redhat.com> <20121106090525.GB27055@linux.vnet.ibm.com> <20121106170243.GA32311@redhat.com>
In-Reply-To: <20121106170243.GA32311@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 09:02 AM, Oleg Nesterov wrote:
> On 11/06, Srikar Dronamraju wrote:
>> Another reason for having the filters in the current way was to have a
>> set of standard filters in uprobes code so that all users dont need to
>> recreate these filters.
> 
> IOW, you mean that both register_for_each_vma() and handler_chain() should
> use the same ->filter() method? Personally I do not think they should.
> 
> Because the semantics is different imo. register_for_each_vma() needs
> to know if we should modify mm and insert the breakpoint. handler_chain()
> just tries to skip ->handler() (and for no reason, imho).

I agree here - I don't see much use for filter(), and even if you have
it, the semantics are definitely different than prefilter().  You could
do all sorts of localized and temporal checks in filter() that make no
sense for a prefilter(), like check for a particular thread id, filter
every N hits, or filter only hits under calls to some foo().

[...]
>>> - Perhaps we should extend the API. We can add
>>>
>>> 	uprobe_apply(consumer, task, bool add_remove);
>>>
>>>   which adds/removes breakpoints to task->mm.
>>>
>>>   This way consumer can probe every task it wants to trace after
>>>   uprobe_register().
>>>
>>>   Its ->filter(UPROBE_FILTER_REGISTER) should simply return false. Or,
>>>   better, we can split uprobe_register() into 2 functions,
>>>   __uprobe_register() and uprobe_apply_all() which actually does
>>>   register_for_each_vma().
>>>
>>>   ***** QUESTION *****: perhaps this is all systemtap needs? ignoring
>>>   UPROBE_FILTER_MMAP.
>>>
>>> - Multiple consumers. uprobe_register/uprobe_unregister should be
>>>   modified so that register_for_each_vma() is called every time when
>>>   the new consumer comes or consumer goes away.
>>>
>>>   uprobe_apply(add_remove => false) should obviously consult other
>>>   consumers too.
>>
>>
>> So in this case, would uprobe_register() just add a consumer to a
>> new/existing uprobe. The actual probe insertion is done by the
>> uprobe_apply()/uprobe_apply_all().
> 
> Yes. Not sure we really need this, but to me this extension looks natural.
> 
> Frank, Josh, do you think it can help systemtap ?

Yes, I think this sounds closer to systemtap's model of probing.  We
already track tasks that come and go to see which are "interesting", so
we could easily call apply() at that time.  We actually watch mmaps too,
so I think we could apply() for that case as well.

We wouldn't even need filtering functions at all in this mode.  But
maybe other consumers could still use it, like perf.

However, it's not clear to me what value there is in uprobe_register, if
you always have to apply it too.  The modes are something like:

1. uprobe_register(); uprobe_apply_all();
2. uprobe_register(); uprobe_apply(); [...]

And the second could have a bunch of idle registrations waiting for the
first applicable task to come around.  So why not instead:

1. uprobe_register_all();
2. uprobe_register_task(); [...]

In this case, the second would have to allow the same consumer to be
repeated on different tasks, but it feels more natural to me.

Josh
