Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab2HGP37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 11:29:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:52871 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab2HGP36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 11:29:58 -0400
Message-ID: <50213462.5040304@linutronix.de>
Date: Tue, 07 Aug 2012 17:29:38 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Roland McGrath <roland@hack.frob.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ptrace: fix set_task_blockstep()->update_debugctlmsr()
 logic
References: <20120803162954.GA19806@redhat.com> <5020E2E4.3090104@linutronix.de> <20120807151531.GC13476@redhat.com>
In-Reply-To: <20120807151531.GC13476@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 05:15 PM, Oleg Nesterov wrote:
> It turns out, original code is even more buggy than I thought.
>
> Ironically, "task != current" case is more difficult and so far
> I do not see how we can handle this case correctly. I'll return
> to this a bit later, currently I am working on other patches.

maybe you could remove the autodectect mode and add helper for uprobe
which disables it.

>> For uprobes we never set the bit, we only need it cleared.
>
> Yes, at least at first step, and probably we will never need more.
>
>> We get here
>> via int 3 and do_debug() already clears TIF_BLOCKSTEP
>
> No, we get here via do_int3(), TIF_BLOCKSTEP is not cleared,

Yes, Sorry. my fault.

>> because the
>> CPU clears the bit in CPU.
>
> I am not sure. The manual says:
>
> 	 If the BTF flag is set when the processor generates a debug
> 	 exception, the processor clears the BTF flag along with the
> 	 TF flag.
>
> but I am not sure "debug exception" also means "breakpoint exception".
>
>
>
> do_debug() does clear TIF_BLOCKSTEP, and "The processor cleared BTF"
> is true in this case. But it is called after single-step.

I was wrong here in regard to do_debug() since do_int3() is correct.
Anyway, I checked it on real hardware and I saw the CPU in do_int3()
with BTF set after executing int3 with TF flag set and the BTF bit.

>
> Oleg.

Sebastian
