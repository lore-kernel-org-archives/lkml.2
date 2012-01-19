Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab2ASO6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 09:58:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58804 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab2ASO6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 09:58:22 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=ehjrB24yHB0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VD9I6ROX042A_B7HwEoA:9 a=D1Z8GgJagV8NdmtEh5AA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326985100.17534.127.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/2] jump labels/x86: Use etiher 5 byte or 2 byte jumps
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Date: Thu, 19 Jan 2012 09:58:20 -0500
In-Reply-To: <4F182CDE.2080603@zytor.com>
References: <20120118195340.767928915@goodmis.org>
	 <20120118195926.797694014@goodmis.org> <20120119144141.GA547@Krystal>
	 <4F182CDE.2080603@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-19 at 06:46 -0800, H. Peter Anvin wrote:

> >>  				   void *(*poker)(void *, const void *, size_t))
> >>  {
> >>  	union jump_code_union code;
> >> +	unsigned char nop;
> >> +	unsigned char op;
> >> +	unsigned size;
> >> +	void *ip = (void *)entry->code;
> >> +	void *ideal = (void *)ideal_nops[NOP_ATOMIC5];
> > 
> > "void *" should possibly be "unsigned char *" here to respect the nop
> > place-holder typing.
> > 
> 
> const unsigned char * please.

OK.

> 
> >> +
> >> +	/* Use probe_kernel_read()? */
> >> +	op = *(unsigned char *)ip;
> >> +	nop = ideal_nops[NOP_ATOMIC5][0];
> >>  
> >>  	if (type == JUMP_LABEL_ENABLE) {
> >> -		code.jump = 0xe9;
> >> -		code.offset = entry->target -
> >> -				(entry->code + JUMP_LABEL_NOP_SIZE);
> >> -	} else
> >> -		memcpy(&code, ideal_nops[NOP_ATOMIC5], JUMP_LABEL_NOP_SIZE);
> >> +		if (op == 0xe9 || op == 0xeb)
> >> +			/* Already enabled. Warn? */
> > 
> > This could be caused by failure to run the link-time script, or running
> > the transform twice. A warning would indeed be welcome, as this should
> > never happen.
> > 
> 
> Warning?  No.  ERROR.  Something very bad could be happening here.  We
> have covered this before.

Heh, not this exactly. We covered run time errors, this is build time
errors.

But I agree, it should error. The mcount code errors on problems, this
should too.

-- Steve


