Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab0D1Pke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:40:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245Ab0D1Pkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:40:33 -0400
Message-ID: <4BD856BC.1000600@redhat.com>
Date: Wed, 28 Apr 2010 11:39:40 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: ananth@in.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Dave Anderson <anderson@redhat.com>
Subject: Re: [PATCH -tip 2/2] [BUGFIX] kprobes/x86: Fix removed int3	checking
 order
References: <20100427223312.2322.60512.stgit@localhost6.localdomain6> <20100427223348.2322.9112.stgit@localhost6.localdomain6> <20100428030004.GA5541@in.ibm.com>
In-Reply-To: <20100428030004.GA5541@in.ibm.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ananth N Mavinakayanahalli wrote:
> On Tue, Apr 27, 2010 at 06:33:49PM -0400, Masami Hiramatsu wrote:
>> Fix kprobe/x86 to check removed int3 when failing to get kprobe
>> from hlist. Since we have a time window between checking int3
>> exists on probed address and getting kprobe on that address,
>> we can have following senario.
>> -------
>> CPU1                     CPU2
>> hit int3
>> check int3 exists
>>                          remove int3
>>                          remove kprobe from hlist
>> get kprobe from hlist
>> no kprobe->OOPS!
>> -------
> 
> Do you have a testcase for this issue?

I heard this issue was found by systemtap team on stable kernel(means
no jump optimization). Their testsuites caused an oops (but not 100%
reproducible) with "pr10854" testcase, which registers over 5000
probes at once and removes it soon.

>> This patch moves int3 checking if there is no kprobe on that
>> address for fixing this problem as follows;
>> ------
>> CPU1                     CPU2
>> hit int3
>>                          remove int3
>>                          remove kprobe from hlist
>> get kprobe from hlist
>> no kprobe->check int3 exists
>>          ->rollback&retry
>> ------
> 
> You may also want to fix up the comment on top of kprobe_handler() about
> the interrupt gate as its only true for x86_32 and not x86_64, right?

Hmm, I couldn't find it, could you tell me more details?
(and maybe, it's another issue)

what I could find is int3 handler is registered as interrupt gate
on both of x86-32/64.

void __init trap_init(void)
{
...
        /* int3 can be called from all */
        set_system_intr_gate_ist(3, &int3, DEBUG_STACK);


> 
>> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> Cc: Dave Anderson <anderson@redhat.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
> 
> Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
