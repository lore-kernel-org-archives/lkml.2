Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab0KJVie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 16:38:34 -0500
Received: from smtp-out.google.com ([216.239.44.51]:11150 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab0KJVid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 16:38:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=mglWuC3ru1kOFanhgobxc1fM+Xn9Ng4hZizv+kDRD0V7l4Phtk2jq5Ws7bLs1KMrCb
         +XusA1KYjG+rSXAjkZkQ==
Date: Wed, 10 Nov 2010 13:38:25 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Vasiliy Kulikov <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        =?UTF-8?Q?Andr=C3=A9_Goddard_Rosa?= <andre.goddard@gmail.com>,
        Joe Perches <joe@perches.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: vsprintf: fix invalid arg check
In-Reply-To: <20101110130834.02496b48.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1011101335410.7756@chino.kir.corp.google.com>
References: <1289421490-23950-1-git-send-email-segooon@gmail.com> <20101110130834.02496b48.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010, Andrew Morton wrote:

> > "size" is size_t.  If we want to check whether it was underflowed
> > then we should cast it to ssize_t instead of int.  When
> > sizeof(size_t) > sizeof(int) the code sees UINT_MAX as underflow,
> > but it is not.
> > 
> 
> Does this patch fix any actual observed problem?
> 
> >  Compile tested.
> > 
> 
> I guess not.
> 
> > --- a/lib/vsprintf.c
> > +++ b/lib/vsprintf.c
> > @@ -1290,7 +1290,7 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
> >  
> >  	/* Reject out-of-range values early.  Large positive sizes are
> >  	   used for unknown buffer sizes. */
> 
> Thousands of people would find that comment to be utterly mysterious. 
> I am one.
> 

vsprintf() and sprintf() pass INT_MAX for an unbounded buffer length, so 
the cast to int here in the original code is correct.  The type of 
interest is not of the passed size, but rather the return value of the 
function.   The changelog is wrong: if sizeof(size_t) > sizeof(int) then 
the return value overflows.

> > -	if (WARN_ON_ONCE((int) size < 0))
> > +	if (WARN_ON_ONCE((ssize_t) size < 0))
> >  		return 0;
> >  
> >  	str = buf;
