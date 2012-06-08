Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762293Ab2FHRgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 13:36:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13916 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761315Ab2FHRgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 13:36:16 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=szWgSEt-72UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=zzfQi_QIN5kw_pGKZdIA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339176975.13377.56.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/3] x86: Remove cmpxchg from i386 NMI nesting code
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 08 Jun 2012 13:36:15 -0400
In-Reply-To: <4FD23626.4020802@zytor.com>
References: <20120608135200.371649691@goodmis.org>
	  <20120608135603.699156773@goodmis.org> <4FD223E1.1090707@zytor.com>
	 <1339173716.13377.50.camel@gandalf.stny.rr.com>
	 <4FD23626.4020802@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 10:28 -0700, H. Peter Anvin wrote:
> On 06/08/2012 09:41 AM, Steven Rostedt wrote:
>  
> >>  
> >>  #define nmi_nesting_postprocess()                                      \
> >>         do {                                                            \
> >> -               if (cmpxchg(&__get_cpu_var(nmi_state),                  \
> >> -                   NMI_EXECUTING, NMI_NOT_RUNNING) != NMI_EXECUTING)   \
> >> +               if (!local_dec_and_test(&__get_cpu_var(nmi_state)))     \
> > 
> > Now this is where I think the patch helps. I'm almost certain that
> > local_dec_and_test is faster than a cmpxchg by many cycles. Especially
> > on i386.
> > 
> 
> On i386 it's infinite, but again, I don't think the code will ever be
> exercised on i386.  I'm much more concerned about performance on current
> processors.

I'm not worried about non i386 here. Some context missing from the patch
is that this code is surrounded by:

#ifdef CONFIG_X86_32

[...]

#else

The '#else' part does something completely different, as this work is
done in the assembly handler on x86_64.

And yes, this code is executed on i386 (well when I boot my x86_64 into
an i386 kernel it does).


> 
> But yes, local_dec_and_test should at least not be more expensive.  Even
> better, use this_cpu_dec_return().

Oh! That would make this much better! I'll update the patch set.

Thanks!

-- Steve




