Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762769Ab2FVXSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:18:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10341 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab2FVXSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:18:46 -0400
X-Authority-Analysis: v=2.0 cv=bpjO9Tmi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=5sIdsdMLa0Prqo9Z8MAA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340407123.27036.265.camel@gandalf.stny.rr.com>
Subject: Re: [GIT PULL] perf fixes
From: Steven Rostedt <rostedt@goodmis.org>
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Date: Fri, 22 Jun 2012 19:18:43 -0400
In-Reply-To: <86448d73-2e19-416f-8104-ce72aa5d76eb@email.android.com>
References: <20120622133650.GA24136@gmail.com>
	 <CA+55aFySaZ4huXgPM0yGPezAhnE9zT81tucC9WnDs5Ps+7+hGA@mail.gmail.com>
	 <20120622183827.GA8014@virgo.local>
	 <CA+55aFzpNtLSQvcOOut--2UkkMyqSb9e0_VO3JAxvZRTv7YT1g@mail.gmail.com>
	 <20120622190632.GB8014@virgo.local>
	 <1340394896.27036.258.camel@gandalf.stny.rr.com>
	 <86448d73-2e19-416f-8104-ce72aa5d76eb@email.android.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 22:08 +0200, Hagen Paul Pfeifer wrote:
> Rephrase "do not help": it helps for the framepointer aspect, no
> doubt. So mfentry is superior in that aspect. But it still generates a
> function call.

It generates a function call that at boot up is converted to a 5 byte
nop. The output ends up being:

00000000000008c3 <schedule>:
 8c3:   0f 1f 44 00 00          nop
 8c8:   65 48 8b 04 25 00 00    mov    %gs:0x0,%rax
 8cf:   00 00 
                        8cd: R_X86_64_32S       current_task
 8d1:   57                      push   %rdi
 8d2:   48 8b 10                mov    (%rax),%rdx
 8d5:   48 85 d2                test   %rdx,%rdx
 8d8:   74 45                   je     91f <schedule+0x5c>
 8da:   48 83 b8 60 06 00 00    cmpq   $0x0,0x660(%rax)
 8e1:   00 
 8e2:   75 3b                   jne    91f <schedule+0x5c>

>  Which in turn affects code generation.

How so? It's not a C function call (like the -finstrument-functions
produces). It's an assembly function call. The only differences between
having ftrace enabled and ftrace disabled with -mfentry is that you get
a 5 byte nop at the start of each traceable function. Sure, it might put
a little pressure on the icache, but from the benchmarks I've run, the
impact has all been within the noise.

I've been told that it doesn't even hurt the pipeline. But I've Cc'd hpa
and Arjan for their comments. How much impact does a 5 byte nop at the
start of each function really have on the normal operations of the
kernel?

>  That was the second concern of Linus, regarding mcount.

Again, the only difference is those 5 bytes. There's no other code
generation difference that I know of.

-- Steve



