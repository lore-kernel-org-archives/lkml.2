Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab0GRSF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 14:05:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756827Ab0GRSFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 14:05:24 -0400
Message-ID: <4C434223.8030202@redhat.com>
Date: Sun, 18 Jul 2010 21:04:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
References: <20100714154923.947138065@efficios.com>	<20100714155804.049012415@efficios.com>	<AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>	<20100714170617.GB4955@Krystal>	<AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>	<20100714203940.GC22096@Krystal>	<AANLkTinM0eFnreNB5l_6f20oSGBchqAtYPb57tM01kUB@mail.gmail.com>	<20100714222115.GA30122@Krystal>	<AANLkTikLG4xVYfvuMtbuzsqcnzo1ut4dFAm6piqy2Lh7@mail.gmail.com>	<AANLkTin21xBD-BFY4ZX2BPRFnT5-LkgGugvWsvTEP4Mr@mail.gmail.com>	<4C42DF9A.5090908@redhat.com> <AANLkTin1noI6IUfuQsbAgVVzj2rSOhm-Cx3WpsMBgdJ6@mail.gmail.com>
In-Reply-To: <AANLkTin1noI6IUfuQsbAgVVzj2rSOhm-Cx3WpsMBgdJ6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2010 08:36 PM, Linus Torvalds wrote:
> On Sun, Jul 18, 2010 at 4:03 AM, Avi Kivity<avi@redhat.com>  wrote:
>    
>> By trading off some memory, we don't need this trickery.  We can allocate
>> two nmi stacks, so the code becomes:
>>      
> I really don't think you need even that. See earlier in the discussion
> about how we could just test %rsp itself. Which makes all the %rip
> testing totally unnecessary, because we don't even need any flags,and
> we have no races because %rsp is atomically changed with taking the
> exception.
>
> Lookie here, the %rsp comparison really isn't that hard:
>
>    nmi:
>        pushq %rax
>        pushq %rdx
>        movq %rsp,%rdx          # current stack top
>        movq 40(%rsp),%rax   # old stack top
>        xor %rax,%rdx              # same 8kB aligned area?
>        shrq $13,%rdx             # ignore low 13 bits
>        je it_is_a_nested_nmi   # looks nested..
>
>    

...

> doesn't that look pretty simple?
>
>    

Too simple - an MCE will switch to its own stack, failing the test.  Now 
that we have correctable MCEs, that's not a good idea.

So the plain everyday sequence

   NMI
   #PF
   MCE (uncompleted)
   NMI

will fail.

Plus, even in the non-nested case, you have to copy the stack frame, or 
the nested NMI will corrupt it.  With stack switching, the nested NMI is 
allocated its own frame.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

