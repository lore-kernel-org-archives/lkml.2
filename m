Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab2JEVDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 17:03:14 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:38872 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab2JEVDI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 17:03:08 -0400
X-Originating-IP: 217.70.178.138
X-Originating-IP: 173.246.103.110
Date: Fri, 5 Oct 2012 14:02:59 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Borislav Petkov <bp@alien8.de>, danielfsantos@att.net,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
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
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Santos <daniel.santos@pobox.com>
Subject: Re: [PATCH v2 09/10] bug.h: Add BUILD_BUG_ON_MSG &
 BUILD_BUG_INTERNAL{,2}
Message-ID: <20121005210258.GB7362@jtriplet-mobl1>
References: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
 <1349466169-20637-9-git-send-email-daniel.santos@pobox.com>
 <20121005205858.GB28452@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121005205858.GB28452@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 10:58:58PM +0200, Borislav Petkov wrote:
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

Also, you don't need both the BUILD_BUG_INTERNAL and CONCAT/UNIQUIFY
macros.  My original implementation just used the BUILD_BUG_INTERNAL
family of macros; if you'd rather rename them, by all means do so, but I
don't think you need two separate families of multiply-indirect macros.

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

Because without that, you end up writing multiple prototypes for the
same function (__build_bug_on_failed) with different error attributes,
and GCC will ignore all but the last error attribute it sees, even with
a scoped prototype.

- Josh Triplett
