Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964818Ab2JEVEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 17:04:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12885 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275Ab2JEVEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 17:04:11 -0400
X-Authority-Analysis: v=2.0 cv=fb8vOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=l-C6q13x6_kA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=Xw4KYig8ptAA:10 a=HZJGGiqLAAAA:8 a=ybZZDoGAAAAA:8 a=cyPSiuf_e5D8SoU7SMMA:9 a=QEXdDO2ut3YA:10 a=HeoGohOdMD0A:10 a=qIVjreYYsbEA:10 a=Rwk2WqX-Gi0r00DO:21 a=E1mVqvkDOLoY0GGT:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349471048.6755.77.camel@gandalf.local.home>
Subject: Re: [PATCH v2 09/10] bug.h: Add BUILD_BUG_ON_MSG &
 BUILD_BUG_INTERNAL{,2}
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: danielfsantos@att.net, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Daniel Santos <daniel.santos@pobox.com>
Date: Fri, 05 Oct 2012 17:04:08 -0400
In-Reply-To: <20121005205858.GB28452@liondog.tnic>
References: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
	 <1349466169-20637-9-git-send-email-daniel.santos@pobox.com>
	 <20121005205858.GB28452@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-05 at 22:58 +0200, Borislav Petkov wrote:
> On Fri, Oct 05, 2012 at 02:42:48PM -0500, danielfsantos@att.net wrote:
> > Add BUILD_BUG_ON_MSG which behaves like BUILD_BUG_ON (with optimizations
> > turned enabled), except that it allows you to specify the error message
> > you want emitted as the third parameter.  Under the hood, this relies on
> > BUILD_BUG_INTERNAL{,2}, which does the actual work and is pretty-much
> > identical to BUILD_BUG_ON.
> > 
> > Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
> > ---
> >  include/linux/bug.h |   26 ++++++++++++++++++++++++++
> >  1 files changed, 26 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/bug.h b/include/linux/bug.h
> > index 1b43ea2..91bd9d5 100644
> > --- a/include/linux/bug.h
> > +++ b/include/linux/bug.h
> > @@ -16,6 +16,7 @@ struct pt_regs;
> >  #define BUILD_BUG_ON_NOT_POWER_OF_2(n)
> >  #define BUILD_BUG_ON_ZERO(e) (0)
> >  #define BUILD_BUG_ON_NULL(e) ((void*)0)
> > +#define BUILD_BUG_ON_MSG(cond, msg) (0)
> >  #define BUILD_BUG_ON(condition) (0)
> >  #define BUILD_BUG() (0)
> >  #else /* __CHECKER__ */
> > @@ -38,6 +39,31 @@ struct pt_regs;
> >   */
> >  #define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
> >  
> > +#define _CONCAT1(a, b) a##b
> > +#define CONCAT(a, b) _CONCAT1(a, b)
> 
> Let's call the indirection _CONCAT without the "1".

You're stricter than I ;-)

> 
> > +#define UNIQUIFY(prefix) CONCAT(prefix, __LINE__)
> > +
> > +#define BUILD_BUG_INTERNAL2(condition, msg, fn)			\
> > +	do {							\
> > +		extern void fn (void) __compiletime_error(msg);	\
> > +		__compiletime_error_fallback(condition);	\
> > +		if (condition)					\
> > +			fn();					\
> > +	} while (0)
> > +
> > +#define BUILD_BUG_INTERNAL(condition, msg, fn) \
> > +	BUILD_BUG_INTERNAL2(condition, msg, fn)
> 
> Ditto. BUILD_BUG_INTERNAL2 should be __BUILD_BUG_INTERNAL and the one
> calling it _BUILD_BUG_INTERNAL (with one underscore).

I thought about commenting about the '2' too, but figured it's only used
internally by BUILD_BUG_INTERNAL and was really not too concerned about
such a trivial thing. It could have been 42 for all I care ;-)

> 
> > +
> > +/**
> > + * BUILD_BUG_ON_MSG - break compile if a condition is true & emit supplied
> > + * 		      error message.
> > + * @condition: the condition which the compiler should know is false.
> > + *
> > + * See BUILD_BUG_ON for description.
> > + */
> > +#define BUILD_BUG_ON_MSG(cond, msg) \
> > +	BUILD_BUG_INTERNAL(cond, msg, UNIQUIFY(__build_bug_on_failed_))
> 
> Btw, why are we adding the line at all? It is issued by gcc anyway:
> 
> cc -Wall    macros.c   -o macros
> macros.c: In function ‘main’:
> macros.c:22:1: error: ‘__build_bug_on_failed_22’ undeclared (first use in this function)
> 	^^^^
> 
> It is in front of the filename here.
> 
> macros.c:22:1: note: each undeclared identifier is reported only once for each function it appears in
> make: *** [macros] Error 1

I was thinking that the number was added as a safety measure that the
line number would be shown for all versions of the compiler. I'm not
sure it is.

-- Steve


