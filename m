Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768865Ab2KOTor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 14:44:47 -0500
Received: from nm8.access.bullet.mail.sp2.yahoo.com ([98.139.44.135]:47414
	"EHLO nm8.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1768750Ab2KOTop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 14:44:45 -0500
X-Yahoo-Newman-Id: 206298.80871.bm@smtp103.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: b2wWjw8VM1mnmoBu.PBGz4_IKSer014tZOaPaCTOUnMGpUa
 uZ2d5b5yLGEmNO.Vy846FwI.UXv7Mtj8nWYuIO_6q1BkwsESEG4PlVPLDVFO
 pDZjI7FmL_bq6ywlr2jlUgWEunFFdgOwutr9H_j0hFAXCP_MP2Sku_00CkS2
 m99SP1ETMApcR4Kq4wZQKq37QCki.DupEs4nJFiAFm70ElY7hz1XNQX71EV4
 OY0BUh3Bvcy.769OyQSIo5pnE3QpQQ0NyttRoETcJOT95_sgRXmp6C_.l.mu
 tvBvB0cd6l7WKB1rw9gbaOipSB4QmA5bRqFCk6XL84Cz47ZZnowKLFeMlH25
 OABywbg_lGqwifgxjGALrT3t.qLsGLSD8CL3QLFu09zlsazExAnd4LzHWZLB
 rIe4GnO64q9xcjlrSc3b0uTS9.lQbFpO6ZUM2OEQMHccN7W4FmQ--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <50A5462D.4060809@att.net>
Date: Thu, 15 Nov 2012 13:44:45 -0600
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
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
References: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com> <1352844821-18952-8-git-send-email-daniel.santos@pobox.com> <20121115150804.GF4956@x1.osrc.amd.com>
In-Reply-To: <20121115150804.GF4956@x1.osrc.amd.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/15/2012 09:08 AM, Borislav Petkov wrote:
> On Tue, Nov 13, 2012 at 04:13:40PM -0600, danielfsantos@att.net wrote:
>> Prior to the introduction of __attribute__((error("msg"))) in gcc 4.3,
>> creating compile-time errors required a little trickery.
>> BUILD_BUG{,_ON} uses this attribute when available to generate
>> compile-time errors, but also uses the negative-sized array trick for
>> older compilers, resulting in two error messages in some cases.  The
>> reason it's "some" cases is that as of gcc 4.4, the negative-sized array
>> will not create an error in some situations, like inline functions.
>>
>> This patch replaces the negative-sized array code with the new
>> __compiletime_error_fallback() macro which expands to the same thing
>> unless the the error attribute is available, in which case it expands to
>> do{}while(0), resulting in exactly one compile-time error on all
>> versions of gcc.
>>
>> Note that we are not changing the negative-sized array code for the
>> unoptimized version of BUILD_BUG_ON, since it has the potential to catch
>> problems that would be disabled in later versions of gcc were
>> __compiletime_error_fallback used.  The reason is that that an
>> unoptimized build can't always remove calls to an error-attributed
>> function call (like we are using) that should effectively become dead
>> code if it were optimized.  However, using a negative-sized array with a
>> similar value will not result in an false-positive (error). The only
>> caveat being that it will also fail to catch valid conditions, which we
>> should be expecting in an unoptimized build anyway.
>>
>> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
>> ---
>>  include/linux/bug.h      |    2 +-
>>  include/linux/compiler.h |    5 +++++
>>  2 files changed, 6 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/bug.h b/include/linux/bug.h
>> index dd4f506..125e744 100644
>> --- a/include/linux/bug.h
>> +++ b/include/linux/bug.h
>> @@ -66,7 +66,7 @@ struct pt_regs;
>>  			__compiletime_error("BUILD_BUG_ON failed");	\
>>  		if (__cond)						\
>>  			__build_bug_on_failed();			\
>> -		((void)sizeof(char[1 - 2*!!(__cond)]));			\
>> +		__compiletime_error_fallback(__cond);			\
> We're passing an already evaluated __cond here which gets doubly-negated
> again in __compiletime_error_fallback. If __compiletime_error_fallback
> is going to be called only from BUILD_BUG_ON, then its definition should
> be:
>
> 	do { ((void)sizeof(char[1 - 2 * (condition)])); } while (0)
>
> i.e., without the !!.
Yeah, I agree. Also, with the complexity, I think a few more comments
can be helpful in compiler.h to clarify what these macros are for more
specifically.

On another note, I have a "part two" set of patches for bug.h &
compiler*.h that does some other stuff (more cleanup & restructuring)
and this is making me think about that more.  My thought about
__compiletime_error_fallback is that it should be called only from
within compiler.h (as in the following patch) and basically just be a
private macro.  However, we still use the use the negative sized array
trick for the unoptimized version of BUILD_BUG_ON (which may have
limited meaning), and we also use a negative bit specifier on a bitfield
in BUILD_BUG_ON_ZERO and BUILD_BUG_ON_NULL (which I treat some in my
other patches as well).  But my thought is that it may be helpful to
encapsulate these tricks into (public) macros in compiler*.h, such as
"compiletime_assert_negarray" and "compiletime_assert_negbitfiled" and
then have __compiletime_error_fallback expand to
compiletime_assert_negarray when it's needed and no-op when it's not.

This doesn't have to be decided now, but it's just a thought you gave me.

And in case you're wondering about the negative bit field,
BUILD_BUG_ON_{ZERO,NULL} can't call BUILD_BUG_ON in a complex expression
({ exp; exp; }) because it is evaluated outside of a function body and
gcc doesn't like that.  Thus, the following macro would, sadly, result
in errors:

#define BUILD_BUG_ON_ZERO(exp) ({BUILD_BUG_ON(exp); 0;})

However, it would not be an error to call an __alwaysinline function
that uses BUILD_BUG_ON, so I still have to explore that and make sure it
works in all scenarios (and compilers).

But back to *this* patch, I'll make that change now.

Thanks!
Daniel
