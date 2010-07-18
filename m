Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab0GRJZW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 05:25:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652Ab0GRJZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 05:25:18 -0400
Message-ID: <4C42C81B.20301@redhat.com>
Date: Sun, 18 Jul 2010 12:23:39 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 2/2] x86 NMI-safe INT3 and Page Fault
References: <20100714154923.947138065@efficios.com>	<20100714155804.252253097@efficios.com>	<4C405078.20707@redhat.com>	<20100716144927.GA22516@Krystal>	<4C408D0C.5050709@redhat.com>	<20100716165855.GA3836@Krystal>	<4C409CBA.1050709@redhat.com>	<4C409F62.6030303@zytor.com>	<4C40A1BD.4040507@redhat.com>	<4C40A227.6000207@zytor.com>	<4C40A4E8.5090605@redhat.com>	<AANLkTinc_of_KYCFt9-8GZYGFLyqQLlgNttPe-YvZn-1@mail.gmail.com>	<4C40B277.9030408@redhat.com> <AANLkTimfZb22E7c_ftyc5WfKsGvJKKq-J3Vq8Y6FNvhT@mail.gmail.com>
In-Reply-To: <AANLkTimfZb22E7c_ftyc5WfKsGvJKKq-J3Vq8Y6FNvhT@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2010 12:39 AM, Linus Torvalds wrote:
> On Fri, Jul 16, 2010 at 12:26 PM, Avi Kivity<avi@redhat.com>  wrote:
>    
>> On 07/16/2010 09:37 PM, Linus Torvalds wrote:
>>      
>>> Non-NMI code should simply never have to even _think_ about NMI's. Why
>>> should it? It should just do whatever comes "natural" within its own
>>> context.
>>>        
>> But we're not talking about non-NMI code.
>>      
> Yes, we are. We're talking about breakpoints (look at the subject
> line), and you are very much talking about things like that _idiotic_
> vmalloc_sync_all() by module loading code etc etc.
>    

Well, I'd put it in the nmi handler registration code, but you're 
right.  A user placing breakpoints can't even tell whether the 
breakpoint will be hit by NMI code, especially data breakpoints.

> Every _single_ "solution" I have seen - apart from my suggestion - has
> been about making code "special" because some other code might run in
> an NMI. Module init sequences having to do idiotic things just because
> they have data structures that might get accessed by NMI.
>
> And the thing is, if we just do NMI's correctly, and allow nesting,
> ALL THOSE PROBLEMS GO AWAY. And there is no reason what-so-ever to do
> stupid things elsewhere.
>
> In other words, why the hell are you arguing? Help Mathieu write the
> low-level NMI handler right, and remove that idiotic
> "vmalloc_sync_all()" that is fundamentally broken and should not
> exist. Rather than talk about adding more of that kind of crap.
>    

Well, at least we'll get a good test case for kvm's nmi blocking 
emulation (it's tricky since if we fault on an iret sometimes nmis get 
unblocked even though the instruction did not complete).

-- 
error compiling committee.c: too many arguments to function

