Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140Ab2EaTZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 15:25:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20130 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933116Ab2EaTZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 15:25:04 -0400
X-Authority-Analysis: v=2.0 cv=PqgRnnw3 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=6I2XFdsDAPIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=vAlqWlI16SXUnGFgg20A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338492300.13348.384.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 4/5] x86: Allow nesting of the debug stack IDT setting
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Dave Jones <davej@redhat.com>, Andi Kleen <ak@linux.intel.com>
Date: Thu, 31 May 2012 15:25:00 -0400
In-Reply-To: <4FC7BF59.3070906@zytor.com>
References: <20120531012829.160060586@goodmis.org>
	 <20120531020441.500105258@goodmis.org> <4FC7BF59.3070906@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 11:58 -0700, H. Peter Anvin wrote:

> What you have here is a nesting counter, which is good, but I have
> some objections to the implementation.
> 
> The name "debug_idt_zero" doesn't convey a counter in any way, shape
> or form; perhaps debug_stack_users or something like that.

Well, it is 'debug_idt_SET_zero' which is what it is doing, regardless
of counter (see below). But perhaps we should change it to:

debug_idt_get()
debug_idt_put()

?

> 
> Since this is percpu, there is no reason to use the atomic operations
> (globally locked!), and since it is on the local CPU there is no need
> to manifest a pointer; we can instead use this_cpu_inc/dec_return:
> 
> static DEFINE_PER_CPU(u32, debug_stack_use_ctr);
> 
> void debug_stack_set_zero(void)
> {
> 	if (this_cpu_inc_return(debug_stack_use_ctr) == 1)

If an NMI comes in here, it will not update the IDT and will corrupt the
stack. The load_idt() must happen for all calls. There's only two static
IDT tables. It's either one or the other. Thus, if it loads it twice, it
will just set it to the same value. The counter is to know when to set
it back.

-- Steve

> 	 	load_idt((const struct desc_ptr *)&nmi_idt_descr);
> }
> 
> void debug_stack_reset(void)
> {
> 	if (this_cpu_dec_return(debug_stack_use_ctr) == 0)
> 		load_idt((const struct desc_ptr *)&idt_descr);
> }
> 
> 	-hpa
> 


