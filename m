Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab0IGNgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 09:36:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40654 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab0IGNgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 09:36:00 -0400
X-Authority-Analysis: v=1.1 cv=B7Pj8GqnuGREL1Ssc7DCARZD8q26a0DDU4WStOn6m+0= c=1 sm=0 a=X7QPjtwe-8wA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=agsmbXc7YG21kWYOaiQA:9 a=rVpIYKAWiNBW_5RO5nYA:7 a=nxt2_ymwGrwfYOKw-AmceDSDQ4sA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: disabling group leader perf_event
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100906154737.GA4332@elte.hu>
References: <4C84B088.5050003@redhat.com> <1283772256.1930.303.camel@laptop>
	 <4C84D1CE.3070205@redhat.com> <1283774045.1930.341.camel@laptop>
	 <4C84D77B.6040600@redhat.com> <20100906124330.GA22314@elte.hu>
	 <4C84E265.1020402@redhat.com> <20100906125905.GA25414@elte.hu>
	 <4C850147.8010908@redhat.com>  <20100906154737.GA4332@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 07 Sep 2010 09:35:58 -0400
Message-ID: <1283866558.5133.73.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-06 at 17:47 +0200, Ingo Molnar wrote:

> > The actual language doesn't really matter.
> 
> There are 3 basic categories:
> 
>  1- Most (least abstract) specific code: a block of bytecode in the form 
>     of a simplified, executable, kernel-checked x86 machine code block - 
>     this is also the fastest form. [yes, this is actually possible.]
> 
>  2- Least specific (most abstract) code: A subset/sideset of C - as it's 
>     the most kernel-developer-trustable/debuggable form.
> 
>  3- Everything else little more than a dot on the spectrum between the
>     first two points.
> 
> I lean towards #2 - but #1 looks interesting too. #3 is distinctly 
> uninteresting as it cannot be as fast as #1 and cannot be as convenient 
> as #2.

I would lean to passing a limited assembly language to the kernel, in
ASCII. This would do the following:

1) probably the easiest to verify.

2) we could write a simple interpreter that all archs can use

3) each arch can have a simple compiler to convert the assembly to
native byte code to optimize it.


The input, output and memory heap can be expressed and the kernel can
grant or deny any of what is touched.

Now here's some of my concerns for any of this. Using the kvm tracepoint
as an example:

slot->base_gfn + ((hva - slot->userspace_addr) >> PAGE_SHIFT)


If we were given "slot" and now we need to dereference it to get
base_gfn or userspace_addr, how would the kernel know this is a valid
address that can be read? Seems to me that this may allow userspace to
trivially see parts of the kernel that was never meant to be seen.

One reason that ftrace only allows root access, is that the kernel is
best a black box for most userspace.  Letting userspace see how SELinux
is treating it, and finding addresses that SELinux is using, can give a
large arsenal to black hats that are writing tools to circumvent Linux
security.

Unless we only let this interpreter access the inputs and its own
allocated memory, it will be very difficult to verify what the
interpreter is doing. I guess one thing we could do is to have a table
of places in the kernel that we let userspace see. This table will need
strict scrutinizing to verify that it can't be used to exploit other
parts of the kernel.

-- Steve
  

