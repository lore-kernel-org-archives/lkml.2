Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab2KQOjE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 09:39:04 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37282 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab2KQOjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 09:39:02 -0500
Date: Sat, 17 Nov 2012 15:39:18 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v5 8/9] compiler.h, bug.h: Prevent double error messages
 with BUILD_BUG{,_ON}
Message-ID: <20121117143918.GC16441@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel Santos <daniel.santos@pobox.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Andi Kleen <ak@linux.intel.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christopher Li <sparse@chrisli.org>,
	David Daney <david.daney@cavium.com>,
	David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>,
	linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Pavel Pisa <pisa@cmp.felk.cvut.cz>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Steven Rostedt <rostedt@goodmis.org>
References: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com>
 <1352844821-18952-8-git-send-email-daniel.santos@pobox.com>
 <20121115150804.GF4956@x1.osrc.amd.com>
 <50A5462D.4060809@att.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50A5462D.4060809@att.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 01:44:45PM -0600, Daniel Santos wrote:
> Yeah, I agree. Also, with the complexity, I think a few more comments
> can be helpful in compiler.h to clarify what these macros are for more
> specifically.

>From what I've read so far the comments are fine but if you want to be
more descriptive then sure, by all means. Just don't let them grow out
of proportion - keep them simple and succinct.

> On another note, I have a "part two" set of patches for bug.h &
> compiler*.h that does some other stuff (more cleanup & restructuring)
> and this is making me think about that more.  My thought about
> __compiletime_error_fallback is that it should be called only from
> within compiler.h (as in the following patch) and basically just be a
> private macro.  However, we still use the use the negative sized array
> trick for the unoptimized version of BUILD_BUG_ON (which may have
> limited meaning), and we also use a negative bit specifier on a bitfield
> in BUILD_BUG_ON_ZERO and BUILD_BUG_ON_NULL (which I treat some in my
> other patches as well).  But my thought is that it may be helpful to
> encapsulate these tricks into (public) macros in compiler*.h, such as
> "compiletime_assert_negarray" and "compiletime_assert_negbitfiled" and
> then have __compiletime_error_fallback expand to
> compiletime_assert_negarray when it's needed and no-op when it's not.
> 
> This doesn't have to be decided now, but it's just a thought you gave me.

I dunno. I'm thinking that maybe making them more unreadable for no
apparent reason might be simply too much. They're fine the way they are
now, if you ask me.

> And in case you're wondering about the negative bit field,
> BUILD_BUG_ON_{ZERO,NULL} can't call BUILD_BUG_ON in a complex expression
> ({ exp; exp; }) because it is evaluated outside of a function body and
> gcc doesn't like that.  Thus, the following macro would, sadly, result
> in errors:
> 
> #define BUILD_BUG_ON_ZERO(exp) ({BUILD_BUG_ON(exp); 0;})
> 
> However, it would not be an error to call an __alwaysinline function
> that uses BUILD_BUG_ON, so I still have to explore that and make sure it
> works in all scenarios (and compilers).

Ok, I see your point. Think of it this way: if unifying those macros can
only happen at the expense of readability or performance then maybe it
is not worth the trouble. If, OTOH, you can think of something slick and
pretty, then go ahead :).

HTH.

-- 
Regards/Gruss,
Boris.
