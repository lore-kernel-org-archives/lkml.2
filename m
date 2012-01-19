Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab2ASPTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 10:19:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62302 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab2ASPTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 10:19:18 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=ehjrB24yHB0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=S1HcKYMXndRnAJsqQP8A:9 a=4R0nt4WdLxu5R0gdOF0A:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326986356.17534.131.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/2] jump labels/x86: Use etiher 5 byte or 2 byte jumps
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Date: Thu, 19 Jan 2012 10:19:16 -0500
In-Reply-To: <1326985100.17534.127.camel@gandalf.stny.rr.com>
References: <20120118195340.767928915@goodmis.org>
	 <20120118195926.797694014@goodmis.org> <20120119144141.GA547@Krystal>
	 <4F182CDE.2080603@zytor.com>
	 <1326985100.17534.127.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-19 at 09:58 -0500, Steven Rostedt wrote:
> On Thu, 2012-01-19 at 06:46 -0800, H. Peter Anvin wrote:

> > 
> > >> +
> > >> +	/* Use probe_kernel_read()? */
> > >> +	op = *(unsigned char *)ip;
> > >> +	nop = ideal_nops[NOP_ATOMIC5][0];
> > >>  
> > >>  	if (type == JUMP_LABEL_ENABLE) {
> > >> -		code.jump = 0xe9;
> > >> -		code.offset = entry->target -
> > >> -				(entry->code + JUMP_LABEL_NOP_SIZE);
> > >> -	} else
> > >> -		memcpy(&code, ideal_nops[NOP_ATOMIC5], JUMP_LABEL_NOP_SIZE);
> > >> +		if (op == 0xe9 || op == 0xeb)
> > >> +			/* Already enabled. Warn? */
> > > 
> > > This could be caused by failure to run the link-time script, or running
> > > the transform twice. A warning would indeed be welcome, as this should
> > > never happen.
> > > 
> > 
> > Warning?  No.  ERROR.  Something very bad could be happening here.  We
> > have covered this before.
> 
> Heh, not this exactly. We covered run time errors, this is build time
> errors.

Oops, this is patch 2 not 1. It is run time error.

> 
> But I agree, it should error. The mcount code errors on problems, this
> should too.

I'll have to look at this in more detail, to make sure jump labels are
consistent in their updates. It may legitimately enable them twice. If
that's the case, what should be done is to make sure the entire
instruction is what we expect it to be, otherwise BUG().

-- Steve


