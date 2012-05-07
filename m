Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab2EGLh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:37:57 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:54220 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab2EGLhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:37:55 -0400
X-AuditID: b753bd60-9145cba000002c51-bd-4fa7b4110f51
X-AuditID: b753bd60-9145cba000002c51-bd-4fa7b4110f51
Message-ID: <4FA7B410.1000804@hitachi.com>
Date: Mon, 07 May 2012 20:37:52 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [PATCH 6/9][RFC] kprobes: Allow probe on ftrace reserved
 text (but move it)
References: <20120502192418.024103772@goodmis.org>  <20120502193237.321234712@goodmis.org> <y0mhavyl3kg.fsf@fche.csb> <1336002032.14207.52.camel@gandalf.stny.rr.com>
In-Reply-To: <1336002032.14207.52.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/03 8:40), Steven Rostedt wrote:
> On Wed, 2012-05-02 at 16:40 -0400, Frank Ch. Eigler wrote:
>> rostedt wrote:
>>
>>> [...]  Added KPROBE_FLAG_MOVED (as suggested by Masami) that is set
>>> when the address is moved to get around an ftrace nop. [...]
>>
>> Steve, perhaps my earlier comments on this got lost during the mailing
>> list outage.
> 
> I saw it, but it didn't really specify what you wanted. Here's your
> comment:
> 
> 
>> I suspect Masami intended that this flag is later used during int3
>> processing to subtract MCOUNT_INSN_SIZE back out from the pt_regs->ip
>> during kprobe_handler() if this flag was set.
> 
> This is what I thought too, but to me it sounded like Masami could do
> the work. I was just setting up a flag to make it possible.
> 
>>
>> The gist is that a KPROBE_FLAG_MOVED being set this way accomplishes
>> very little since nothing is looking for that flag.  Instead, you
>> should patch {arch/*}/kernel/kprobe.c kprobe_handler() to subtract
>> MCOUNT_INSN_SIZE back out from pt_regs->ip if KPROBE_FLAG_MOVED was
>> set.  That way, kprobes clients need do not perceive the int3 movement.
> 
> I basically thought that Masami wanted me to add the flag, and then
> others could look for this and do the adjustment. I'm not the kprobes
> author. I was just adding a flag that Masami and others could use to do
> such updates.

Right, that was what I thought. Since the kp->addr is changed when
kprobe is set, kprobes itself don't need to adjust the pt_regs->ip.
I mean, struct kprobe itself puts a probe on the next to the mcount
entry, even if the caller tries to put a probe on the mcount entry.

This change may be unintended and caller will doubt that why the
kp->addr is automatically changed. So this KPROBE_FLAG_MOVED gives
a hint for the caller who knows the original intended probed address.

> I'm not sure if the adjustment is fine with everyone, as it may cause
> repercussions that I don't know about. 

Yeah, that's a point. if the adjustment is transparently done, there
is no problem. But it changes kp->addr when registering a probe.
If adjustment is done, following code (still) doesn't work.

---
int func(struct kprobe *kp, strcut pt_regs *regs)
{
	BUG_ON(kp->addr != regs->ip);
	/* or */
	store_probed_address(kp->addr);	/* since regs->ip depends on x86*/
}

kp->handler = func;
kp->addr = <somewhere on ftrace>
register_kprobe(kp);
---

but if adjustment is not done, at least, kprobes behavior itself
looks same. (but just be moved if probed on ftrace)

Yeah, I know systemtap people likes regs->ip to be adjusted, but
there may be someone who use raw kprobes.

> Perhaps that could be another patch (want to write it?)

Oh, so I think we need to show the new flag on debugfs for
someone who want to know why the probe has been moved. :)


By the way, there is another way to do that transparently which
we add a "real_addr" member to struct kprobes and put the real
probed address to the member (without changing kp->addr). This
will keep API compatibility.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
