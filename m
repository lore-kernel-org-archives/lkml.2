Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404Ab1FHQVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 12:21:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:61754 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959Ab1FHQVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 12:21:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,339,1304319600"; 
   d="scan'208";a="9290699"
Message-ID: <4DEFA18A.2000808@linux.intel.com>
Date: Wed, 08 Jun 2011 09:21:30 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Oliver <david@rgmadvisors.com>
CC: Kyle Moffett <kyle@moffetthome.net>, Andrew Lutomirski <luto@mit.edu>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Change in functionality of futex() system call.
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>	<1307373819.3098.40.camel@edumazet-laptop>	<1307376672.2322.167.camel@twins>	<1307376989.2322.171.camel@twins>	<1307377349.3098.65.camel@edumazet-laptop>	<1307377782.2322.183.camel@twins>	<1307378564.3098.67.camel@edumazet-laptop>	<4DED1421.5000300@linux.intel.com>	<1307383898.3098.90.camel@edumazet-laptop>	<4DED976C.90009@linux.intel.com>	<4DEE3944.5020005@mit.edu>	<1307462300.3091.39.camel@edumazet-laptop>	<BANLkTinyuHUGXACJYUT241g8rzg6AzPBiA@mail.gmail.com>	<BANLkTinHEyRnnJqB=GTwBOAb6aRaHnjQLQ@mail.gmail.com>	<BANLkTi=uQmePFOJUx=bdTsnFuFa+ZaYqVw@mail.gmail.com>	<BANLkTi=vwJBgkKSY_Cq_jQS-71gH6uOPaw@mail.gmail.com> <BANLkTinL60RXZNH1QW9NdrTv10TckgWFcg@mail.gmail.com>
In-Reply-To: <BANLkTinL60RXZNH1QW9NdrTv10TckgWFcg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/08/2011 08:20 AM, David Oliver wrote:
> On Tue, Jun 7, 2011 at 5:26 PM, Kyle Moffett <kyle@moffetthome.net> wrote:
>> On Tue, Jun 7, 2011 at 15:19, Andrew Lutomirski <luto@mit.edu> wrote:
>>> On Tue, Jun 7, 2011 at 3:10 PM, David Oliver <david@rgmadvisors.com> wrote:
>>>> I have software which currently uses shared files for a one way
>>>> transfer of information, which is modeled precisely by the futex (as
>>>> contrasted to the mutex) model. In this case, the number of receivers
>>>> is undetermined, so the number of wakeups is set to maxint.
>>>>
>>>> The receivers are minimally trusted: they have read access to the
>>>> files, so they cannot accidentally affect other processes use of the
>>>> data. Requiring my files to be writeable by all clients would require
>>>> a serious increase in the amount of software needing to be trusted.
>>>
>>> What's wrong with adding a FUTEX_WAIT_NOCONSUME flag then?  Your
>>> program can use it to get exactly the semantics it wants and my
>>> program can use it or not depending on which semantics it wants.
>>>
>>> Then we can document in the man page that, on kernels newer than
>>> whichever version introduced the regression, read-only mappings of a
>>> file cannot be used to interfere with futexes on that file.
>>
>> Hmm, I would actually call it "FUTEX_POLL", since that better reflects the
>> operation being performed.
>>
>> Certainly you would want to avoid allowing FUTEX_POLL to "steal"
>> limited wakeups from FUTEX_CMP_REQUEUE or whatever, so you
>> also need a new "FUTEX_NOTIFY".  Alternatively I guess you could just
>> special-case the FUTEX_WAKE && wakeups == INTMAX combination to
>> also notify FUTEX_POLL processes.
>>
>> I almost wonder if long-term there might possibly be some decent way
>> to integrate this with eventfds to allow a thread to wait for notifications from
>> any number of memory addresses as well as other event sources.  This
>> would be a similar extension to signalfd, only for futexes.
>>
>> Cheers,
>> Kyle Moffett
>>
> 
> Having a new call is inelegant from a futex(2) user perspective, as
> the need for a change is due to the kernel implementation and/or mutex
> requirements. The futex() system call, as documented, is ideal for a
> single producer to signal multiple receivers of state updates.
> 
> If it is truly necessary to add new variants to futex() to protect
> applications that allow untrusted applications read access to their
> mutexes, I would avoid both the names suggested, as consumption of
> wakeups is not an obvious issue to users, and POLL suggests waiting
> for multiple entities as in poll(2) (which is not provided), or
> returning immediately (which is orthogonally provided by the timeout
> parameter). What is being provided from the user point of view is a
> FUTEX_WAIT per the man page, which doesn't require write access. How
> about FUTEX_WAIT_RDONLY?
> 
> Alternatively, use the current call and document that when process
> performing a FUTEX_WAIT on read-only memory are woken, they do not
> count towards the number reported as being woken.
> 
> Best, IMHO, would be to document that providing read access to mutexes
> to untrusted software is unsafe behavior, and restore read only access
> to readers of futexes.

I'm inclined to agree with this approach.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
