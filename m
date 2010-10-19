Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab0JSXkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 19:40:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42816 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435Ab0JSXkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 19:40:32 -0400
Message-ID: <4CBE2C1B.6070500@zytor.com>
Date: Tue, 19 Oct 2010 16:39:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        LKML <linux-kernel@vger.kernel.org>, eric.dumazet@gmail.com,
        kaneshige.kenji@jp.fujitsu.com, David Miller <davem@davemloft.net>,
        izumi.taku@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
References: <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org>    <20100908112529.GA25931@elte.hu> <1287395077.29097.1543.camel@twins>    <1287398936.29097.1548.camel@twins> <4CBD79CF.2060706@jp.fujitsu.com>    <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6>    <20101019132236.GA19197@Krystal>    <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6>    <1287496495.16971.372.camel@gandalf.stny.rr.com>    <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6>    <20101019142820.GA14520@Krystal>    <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6>    <1287521757.16971.397.camel@gandalf.stny.rr.com>    <alpine.LFD.2.00.1010192302000.6815@localhost6.localdomain6>    <1287523439.16971.433.camel@gandalf.stny.rr.com>    <4CBE122B.9020807@zytor.com>    <1287527005.16971.527.camel@gandalf.stny.rr.com> <364b3c9b09b8b02f6804634a2fc927b4.squirrel@programming.kicks-ass.net>
In-Reply-To: <364b3c9b09b8b02f6804634a2fc927b4.squirrel@programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 03:27 PM, Peter Zijlstra wrote:
> 
> Due to not actually having a sane key type the above is not easy to
> implement, but I tried:
> 
> #define _SWITCH_POINT(x)\
> ({                                                              \
>         __label__ jl_enabled;                                   \
>         bool ret = true;                                        \
>         JUMP_LABEL(x, jl_enabled);                              \
>         ret = false;                                            \
> jl_enabled:                                                     \
>         ret;            })
> 
> #define SWITCH_POINT(x) unlikely(_SWITCH_POINT(x))
> 
> #define COND_STMT(key, stmt)                                    \
> do {                                                            \
>         if (SWITCH_POINT(key)) {                                \
>                 stmt;                                           \
>         }                                                       \
> } while (0)
> 
> 
> and that's still generating these double jumps.
> 

I just experimented with it, and the ({...}) construct doesn't work,
because it looks like a merged flow of control to gcc.

Replacing the ({ ... }) with an inline does indeed remove the double
jumps.

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index b67cb18..2ff829d 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -61,12 +61,22 @@ static inline int jump_label_text_reserved(void
*start, void *end)

 #endif

+static __always_inline __pure bool _SWITCH_POINT(void *x)
+{
+       asm goto("# SWITCH_POINT %0\n\t"
+                ".byte 0x66,0x66,0x66,0x66,0x90\n"
+                "1:"
+                : : "i" (x) : : jl_enabled);
+       return false;
+jl_enabled:
+       return true;
+}
+
+#define SWITCH_POINT(x)        unlikely(_SWITCH_POINT(x))
+
 #define COND_STMT(key, stmt)                                   \
 do {                                                           \
-       __label__ jl_enabled;                                   \
-       JUMP_LABEL(key, jl_enabled);                            \
-       if (0) {                                                \
-jl_enabled:                                                    \
+       if (SWITCH_POINT(key)) {                                \
                stmt;                                           \
        }                                                       \
 } while (0)


The key here seems to be to not use the JUMP_LABEL macro as implemented;
I have utterly failed to make JUMP_LABEL() do the right thing.


	-hpa
