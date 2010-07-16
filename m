Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966108Ab0GPT14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 15:27:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966044Ab0GPT1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 15:27:55 -0400
Message-ID: <4C40B277.9030408@redhat.com>
Date: Fri, 16 Jul 2010 22:26:47 +0300
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
References: <20100714154923.947138065@efficios.com>	<20100714155804.252253097@efficios.com>	<4C405078.20707@redhat.com>	<20100716144927.GA22516@Krystal>	<4C408D0C.5050709@redhat.com>	<20100716165855.GA3836@Krystal>	<4C409CBA.1050709@redhat.com>	<4C409F62.6030303@zytor.com>	<4C40A1BD.4040507@redhat.com>	<4C40A227.6000207@zytor.com>	<4C40A4E8.5090605@redhat.com> <AANLkTinc_of_KYCFt9-8GZYGFLyqQLlgNttPe-YvZn-1@mail.gmail.com>
In-Reply-To: <AANLkTinc_of_KYCFt9-8GZYGFLyqQLlgNttPe-YvZn-1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2010 09:37 PM, Linus Torvalds wrote:
> On Fri, Jul 16, 2010 at 11:28 AM, Avi Kivity<avi@redhat.com>  wrote:
>    
>> Use kmalloc and percpu pointers, it's not that onerous.
>>      
> What people don't seem to understand is that WE SHOULD NOT MAKE NMI
> FORCE US TO DO "STRANGE" CODE IN CODE-PATHS THAT HAVE NOTHING
> WHAT-SO-EVER TO DO WITH NMI.
>
> I'm shouting, because this point seems to have been continually
> missed. It was missed in the original patches, and it's been missed in
> the discussions.
>
> Non-NMI code should simply never have to even _think_ about NMI's. Why
> should it? It should just do whatever comes "natural" within its own
> context.
>
>    

But we're not talking about non-NMI code.  The 8k referred to in the 
original patch are buffers used by NMI stack recording.  Module code 
vmalloc_sync_all() is only need by code that is executed during NMI, 
hence must be NMI aware.

> This is why I've been pushing for the "let's just fix NMI" approach.
> Not adding random hacks to other code sequences that have nothing
> what-so-ever to do with NMI.
>    

"fixing NMI" will result in code that is understandable by maybe three 
people after long and hard thinking.  NMI can happen in too many 
semi-defined contexts, so there will be plenty of edge cases.  I'm not 
sure we can ever trust such trickery.

> So don't add NMI code to the page fault code. Not to the debug code,
> or to the module loading code. Don't say "use special allocations
> because the NMI code may care about these particular data structures".
> Because that way lies crap and unmaintainability.
>    

If NMI code can call random hooks and access random data, yes.  But I 
don't think we're at that point yet.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

