Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336Ab1FGTdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 15:33:55 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:51758 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758314Ab1FGTdw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:33:52 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=uQmePFOJUx=bdTsnFuFa+ZaYqVw@mail.gmail.com>
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>
	<1307373819.3098.40.camel@edumazet-laptop>
	<1307376672.2322.167.camel@twins>
	<1307376989.2322.171.camel@twins>
	<1307377349.3098.65.camel@edumazet-laptop>
	<1307377782.2322.183.camel@twins>
	<1307378564.3098.67.camel@edumazet-laptop>
	<4DED1421.5000300@linux.intel.com>
	<1307383898.3098.90.camel@edumazet-laptop>
	<4DED976C.90009@linux.intel.com>
	<4DEE3944.5020005@mit.edu>
	<1307462300.3091.39.camel@edumazet-laptop>
	<BANLkTinyuHUGXACJYUT241g8rzg6AzPBiA@mail.gmail.com>
	<BANLkTinHEyRnnJqB=GTwBOAb6aRaHnjQLQ@mail.gmail.com>
	<BANLkTi=uQmePFOJUx=bdTsnFuFa+ZaYqVw@mail.gmail.com>
Date: Tue, 7 Jun 2011 14:33:50 -0500
Message-ID: <BANLkTi=KZcosEZ9_WEjQw7fZRwzBeR67yA@mail.gmail.com>
Subject: Re: Change in functionality of futex() system call.
From: David Oliver <david@rgmadvisors.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 2:19 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Tue, Jun 7, 2011 at 3:10 PM, David Oliver <david@rgmadvisors.com> wrote:
>> On Tue, Jun 7, 2011 at 1:43 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>>> On Tue, Jun 7, 2011 at 11:58 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>>> Le mardi 07 juin 2011 à 10:44 -0400, Andy Lutomirski a écrit :
>>>>> On 06/06/2011 11:13 PM, Darren Hart wrote:
>>>>> >
>>>>> >
>>>>> > On 06/06/2011 11:11 AM, Eric Dumazet wrote:
>>>>> >> Le lundi 06 juin 2011 à 10:53 -0700, Darren Hart a écrit :
>>>>> >>>
>>>>> >>
>>>>> >>> If I understand the problem correctly, RO private mapping really doesn't
>>>>> >>> make any sense and we should probably explicitly not support it, while
>>>>> >>> special casing the RO shared mapping in support of David's scenario.
>>>>> >>>
>>>>> >>
>>>>> >> We supported them in 2.6.18 kernels, apparently. This might sounds
>>>>> >> stupid but who knows ?
>>>>> >
>>>>> >
>>>>> > I guess this is actually the key point we need to agree on to provide a
>>>>> > solution. This particular case "worked" in 2.6.18 kernels, but that
>>>>> > doesn't necessarily mean it was supported, or even intentional.
>>>>> >
>>>>> > It sounds to me that we agree that we should support RO shared mappings.
>>>>> > The question remains about whether we should introduce deliberate
>>>>> > support of RO private mappings, and if so, if the forced COW approach is
>>>>> > appropriate or not.
>>>>> >
>>>>>
>>>>> I disagree.
>>>>>
>>>>> FUTEX_WAIT has side-effects.  Specifically, it eats one wakeup sent by
>>>>> FUTEX_WAKE.  So if something uses futexes on a file mapping, then a
>>>>> process with only read access could (if the semantics were changed) DoS
>>>>> the other processes by spawning a bunch of threads and FUTEX_WAITing
>>>>> from each of them.
>>>>>
>>>>> If there were a FUTEX_WAIT_NOCONSUME that did not consume a wakeup and
>>>>> worked on RO mappings, I would drop my objection.
>>>>
>>>> If a group of cooperating processes uses a memory segment to exchange
>>>> critical information, do you really think this memory segment will be
>>>> readable by other unrelated processes on the machine ?
>>>
>>> Depends on the design.
>>>
>>> I have some software I'm working on that uses shared files and could
>>> easily use futexes.
>>>
>> I have software which currently uses shared files for a one way
>> transfer of information, which is modeled precisely by the futex (as
>> contrasted to the mutex) model. In this case, the number of receivers
>> is undetermined, so the number of wakeups is set to maxint.
>>
>> The receivers are minimally trusted: they have read access to the
>> files, so they cannot accidentally affect other processes use of the
>> data. Requiring my files to be writeable by all clients would require
>> a serious increase in the amount of software needing to be trusted.
>
> What's wrong with adding a FUTEX_WAIT_NOCONSUME flag then?  Your
> program can use it to get exactly the semantics it wants and my
> program can use it or not depending on which semantics it wants.
>
1. I would prefer not to require my programs have to check for kernel
version (code named "working", "regressed", and "altered") to decide
which parameters need to be sent to the futex call.
2. Doing FUTEX_WAIT_NOCONSUME would change the semantics of
futex_wake() between the "working" and "altered" kernels, as it would
no longer return the number of processes woken.

It seems that FUTEX_WAIT_NOCONSUME would be rather like a
non-consuming read on a pipe.

> Then we can document in the man page that, on kernels newer than
> whichever version introduced the regression, read-only mappings of a
> file cannot be used to interfere with futexes on that file.
>
> --Andy
>

-- 
Cheers!

David.


---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

