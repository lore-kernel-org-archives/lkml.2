Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540Ab2JFE25 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 00:28:57 -0400
Received: from nm22.bullet.mail.bf1.yahoo.com ([98.139.212.181]:37930 "EHLO
	nm22.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751101Ab2JFE2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 00:28:53 -0400
X-Yahoo-Newman-Id: 7282.14020.bm@smtp104.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: RRiXqEkVM1krRGJEbguoyW6x1keV7C.MbPWVtedRUUCo1TX
 0Q2faFgNPdtyde4OqykViXHBJV5ntW_Wyi.MFD0Zeku9cjYSIk4kCxfxYlv4
 NSNDNh4VYhpSkSu22F97_EQs7fXpBAFAm_AonUmU1tHWPgQ4fR7b9Ay7d8zU
 k6GXHhOPxzS8Tw.K5UnIcvFQYpwunVLqpP1f5yX5Uy4KVsqTIhc9LPthzU7B
 gJWjw4geg1ghVXYsSSv3bpzUPiVTuJKjsVW0Bw0kOtCZELdot5d16NnO65y5
 6bjnAjl62qeWigsgw14WYOeuCVUMgvg4tu8LbN._9ThWbqlaK0V6hRDd3aYm
 GmMjcmlplxRw5b78tfLsrBTDJTn85qpGuvKBIvsAm9GXPe2R_eRz1I.moGLt
 HQme6BO7TVP84wJgpoQeS5IBUTQIrfLPrY5hkJYDjS9hmPWz48g--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <506FB381.4030605@att.net>
Date: Fri, 05 Oct 2012 23:28:49 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Christopher Li <sparse@chrisli.org>,
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
Subject: Re: [PATCH v2 07/10] compiler.h, bug.h: Prevent double error messages
 with BUILD_BUG{,_ON}
References: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com> <1349466169-20637-7-git-send-email-daniel.santos@pobox.com> <20121005205922.GA7362@jtriplet-mobl1>
In-Reply-To: <20121005205922.GA7362@jtriplet-mobl1>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2012 03:59 PM, Josh Triplett wrote:
> On Fri, Oct 05, 2012 at 02:42:46PM -0500, danielfsantos@att.net wrote:
>> --- a/include/linux/compiler.h
>> +++ b/include/linux/compiler.h
>> @@ -296,6 +296,11 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
>>  #endif
>>  #ifndef __compiletime_error
>>  # define __compiletime_error(message)
>> +# define __compiletime_error_fallback(condition) \
>> +	 ((void)sizeof(char[1 - 2*!!(condition)]))
>> +#endif
>> +#ifndef __compiletime_error_fallback
>> +# define __compiletime_error_fallback(condition) (void)(0)
>
> Might want to use do { } while (0) here, to force the use of a
> semicolon and avoid the use of __compiletime_error_fallback in an
> expression.
Sure!  But while we're here, we may want to consider a few other macros
in bug.h.  These two are intended to be used as an expression:

#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
#define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))

They are using a different technique to generate the compile-time error,
perhaps because the negative sized array wasn't always working past gcc
4.4? Either way, perhaps these can become

#define BUILD_BUG_ON_ZERO(e) ({BUILD_BUG_ON(e); 0;})
#define BUILD_BUG_ON_NULL(e) ({BUILD_BUG_ON(e); (void*)0;})

This would again give us our cute error message.  However, I don't know
when this style of expression began to be supported (I know it's a gcc
extension), but I'm guessing it's pre gcc 3.2 because it's used in
kernel.h.  Also:

#define BUILD_BUG_ON_NOT_POWER_OF_2(n)            \
        BUILD_BUG_ON((n) == 0 || (((n) & ((n) - 1)) != 0))

can become:

#define BUILD_BUG_ON_NOT_POWER_OF_2(n)                         \
        BUILD_BUG_ON_MSG((n) == 0 || (((n) & ((n) - 1)) != 0), \
                         #n " not a power of two")

I think the only thing that would leave unfinished is the __OPTIMIZE__ check
in the BUILD_BUG_ON definition.  This is a throw-back to the days before
BUILD_BUG_ON_NON_CONST (oops, that's still in another patch set).  Well, if
you look at version 1 of this patch set, you'll see that it has that check,
since __builtin_constant_p never returns one in an unoptimized build.
However, that's a bit more work because we will need to examine every use of
BUILD_BUG_ON and __builtin_constant_p.  I only found 2-3 last time I looked,
one of which was commented outwith the remark that it "breaks in funny
ways",
which we certainly already know about __builtin_constant_p.  Another was a
pretty complicated expression, but I'll have to look them up again.

Please let me know what you think.

Daniel
