Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab0KKUiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 15:38:10 -0500
Received: from smtp-out.google.com ([216.239.44.51]:44248 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab0KKUiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 15:38:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Fqk6gyxfqrWI2jNJMRoTR7zkpxuRyTpo+fAqdlUhMUeXx3N8XH+k7dkYUA1KEBqj1Y
         rOy/anhDPbLGVm3gjnxA==
Date: Thu, 11 Nov 2010 12:38:01 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vasiliy Kulikov <segooon@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, kernel-janitors@vger.kernel.org,
        =?UTF-8?Q?Andr=C3=A9_Goddard_Rosa?= <andre.goddard@gmail.com>,
        Joe Perches <joe@perches.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: vsprintf: fix invalid arg check
In-Reply-To: <20101111083408.GA3471@albatros>
Message-ID: <alpine.DEB.2.00.1011111224161.25829@chino.kir.corp.google.com>
References: <1289421490-23950-1-git-send-email-segooon@gmail.com> <20101110130834.02496b48.akpm@linux-foundation.org> <alpine.DEB.2.00.1011101335410.7756@chino.kir.corp.google.com> <20101111083408.GA3471@albatros>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010, Vasiliy Kulikov wrote:

> > > > "size" is size_t.  If we want to check whether it was underflowed
> > > > then we should cast it to ssize_t instead of int.  When
> > > > sizeof(size_t) > sizeof(int) the code sees UINT_MAX as underflow,
> > > > but it is not.
> > > > 
> > > 
> > > Does this patch fix any actual observed problem?
> 
> I don't think so, this fix is more theoretical than practical.
> However, maybe there is some crazy driver that fills array of 2GB with
> s*printf().
> 

All sizes passed to vsprintf() greater than INT_MAX are invalid; that's 
what the original code is testing, warning, and handling correctly.

> > > >  Compile tested.
> > > > 
> > > 
> > > I guess not.
> 
> What do you mean here? 
> 
> $ make lib/vsprintf.o
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CC      lib/vsprintf.o
> 
> Compiled without warnings.
> 

Andrew was commenting that this was the only additional information you 
provided instead of showing a working example.

> > > >  	/* Reject out-of-range values early.  Large positive sizes are
> > > >  	   used for unknown buffer sizes. */
> > > 
> > > Thousands of people would find that comment to be utterly mysterious. 
> > > I am one.
> > > 
> [...]
> > The changelog is wrong: if sizeof(size_t) > sizeof(int) then the return value overflows.
> 
> This comparison is intended for size_t _underflow_, e.g. in such (buggy)
> code:
> 
> len = snprintf(buf, sizeof(buf), "%s", string);
> len += snprintf(buf + len, sizeof(buf) - len, "%s", string2);
> 

That's buggy because len may be greater than sizeof(buf).  snprintf() 
returns the number of characters that would have been generated if it 
wasn't truncated so that we can test that value upon return.

> If the first snprintf() returns len that is greater than sizeof(buf),
> then sizeof(buf)-len is negative; casted to (unsigned!) size_t it
> becomes some big value. buf+len points to somewhere after the real buf.
> 

Right, that's the behavior of snprintf(), but that doesn't mean the passed 
size can be anything larger than INT_MAX.

> To detect this situation we check whether size is negative (as signed).
> But it should be checked as integer of the same size.
> 
> > vsprintf() and sprintf() pass INT_MAX for an unbounded buffer length
> 
> OK, this should be changed to LONG_MAX.
> 

No, it shouldn't, these functions return int.  INT_MAX is the largest 
value we can handle successfully and that's why it is the special case for 
sprintf() and vsprintf().

The code as it stands is correct not because of the type of the size but 
rather the type of the return value.
