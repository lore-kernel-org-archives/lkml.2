Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab2JaFec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 01:34:32 -0400
Received: from nm1.access.bullet.mail.sp2.yahoo.com ([98.139.44.128]:32605
	"EHLO nm1.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751858Ab2JaFe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 01:34:28 -0400
X-Yahoo-Newman-Id: 133205.65212.bm@smtp109.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: cp6ZTScVM1ncP4Pg1imsuXyxdSirQm6kKFoDC0Md8Qyfajv
 uJuN3rhJwroWECjLeiqXxe1RDDvZDB45NcE2dph8bF8mwml_mMvHozaCOkmq
 B42DmRbgCc7wR9rwINvrb0zlyiSbHr0K0EP5pS9mlKneuKWFwAcafrq1rmIT
 EuWvSNDcJnmtR.59dtm_5I0zRPphYO6u8C2ur.2I9m6Ew1K4c.J_QfCLF5SF
 ts72xCVE5XbLkw916U3Qp5tek9dClMMYFi8dSHwjjPDUtLezYcolycRwh9Ws
 8xIAELydVyjni8yADk9xQFrOyseFzLLPrxVHjjD9_8XlblO_zvcJE1VCgNFl
 wC2SwpSalQdcJVvP0YwwzTq48Y8GygiM2LSBD0xEfVc0bfMmDPqk3GBRd20d
 _p9vwgOjmo_zkPqfg33cb9COtyVGntFT7fsqqOcsrTcMyF_qcuOdEVvBWWwj
 v.gBrwBs3bKlG7HX2guAS2NpBSQ--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <5090B875.7030902@att.net>
Date: Wed, 31 Oct 2012 00:34:45 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Daniel Santos <daniel.santos@pobox.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
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
        Steven Rostedt <rostedt@goodmis.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v4 6/9] compiler.h, bug.h: Prevent double error messages
 with BUILD_BUG{,_ON}
References: <1351457648-7453-1-git-send-email-daniel.santos@pobox.com> <1351457835-7553-6-git-send-email-daniel.santos@pobox.com> <20121030161933.GD28499@liondog.tnic>
In-Reply-To: <20121030161933.GD28499@liondog.tnic>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2012 11:19 AM, Borislav Petkov wrote:
> On Sun, Oct 28, 2012 at 03:57:12PM -0500, danielfsantos@att.net wrote:
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
>> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
>> ---
>>  include/linux/bug.h      |    4 ++--
>>  include/linux/compiler.h |    7 +++++++
>>  2 files changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/bug.h b/include/linux/bug.h
>> index 03259d7..da03dc1 100644
>> --- a/include/linux/bug.h
>> +++ b/include/linux/bug.h
>> @@ -57,13 +57,13 @@ struct pt_regs;
>>   * track down.
>>   */
>>  #ifndef __OPTIMIZE__
>> -#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
>> +#define BUILD_BUG_ON(condition) __compiletime_error_fallback(condition)
>>  #else
>>  #define BUILD_BUG_ON(condition)						\
>>  	do {								\
>>  		extern void __build_bug_on_failed(void)			\
>>  			__compiletime_error("BUILD_BUG_ON failed");	\
>> -		((void)sizeof(char[1 - 2*!!(condition)]));		\
>> +		__compiletime_error_fallback(condition);		\
>>  		if (condition)						\
>>  			__build_bug_on_failed();			\
> If we're defining a fallback, shouldn't it come second? I.e.:
>
> 		if (condition)
> 			__build_bug_on_failed();
> 		__compiletime_error_fallback(condition);
>
> Also, the error message from __build_bug_on_failed is much more
> informative:
>
> arch/x86/kernel/cpu/amd.c: In function ‘early_init_amd’:
> arch/x86/kernel/cpu/amd.c:486:2: error: call to ‘__build_bug_on_failed’ declared with attribute error: BUILD_BUG_ON failed
> make[1]: *** [arch/x86/kernel/cpu/amd.o] Error 1
> make[1]: *** Waiting for unfinished jobs....
> make: *** [arch/x86/kernel/cpu/] Error 2
>
> than
>
> arch/x86/kernel/cpu/amd.c: In function ‘early_init_amd’:
> arch/x86/kernel/cpu/amd.c:486:2: error: size of unnamed array is negative
> make[1]: *** [arch/x86/kernel/cpu/amd.o] Error 1
> make[1]: *** Waiting for unfinished jobs....
> make: *** [arch/x86/kernel/cpu/] Error 2
Yes, the __build_bug_on_failed message is much more informative.  This
will only increase with these patches.  For example, the line

BUILD_BUG_ON(sizeof(*c) != 4);

emits this error:

arch/x86/kernel/cpu/amd.c: In function ‘early_init_amd’:
arch/x86/kernel/cpu/amd.c:486:2: error: call to
‘__build_bug_on_failed_486’ declared with attribute error: BUILD_BUG_ON
failed: sizeof(*c) != 4
make[1]: *** [arch/x86/kernel/cpu/amd.o] Error 1
make: *** [arch/x86/kernel/cpu/amd.o] Error 2

It's true that there is some redundancy in there as well as the
gibberish line number embedded in the function name, but the end of the
line spits out the exact statement that failed.

But as far as rather the fallback is first or the __compiletime_error
function is a matter of asthetics, since it's really an either/or
situation.  Either the __build_bug_on_failedxxx function will be
declared with __attribute__((error(message))) and the fallback will
expand to a no-op, or the fallback will produce code that (presumably
always?) breaks the build.  For insurance, a link-time error will occur
if the fallback code fails to break the build.

Realistically, a single macro could be defined in compiler*.h that
encapsulates the entirety of this mechanism and only exposes a "black
box" macro, that will simply expand to something that breaks the build
in the most appropriate fashion based upon the version of gcc.  In
essence, the new BUILD_BUG_ON_MSG macro attempts to fill that roll.
>
> Finally, you need to do:
>
> 	bool __cond = !!(condition);
>
> and use __cond so that condition doesn't get evaluated multiple times
> (possibly with side effects).
>
> Thanks.
Big problem!  Very good catch, thank you!  All good programmers know not
use expressions that can have side effects in an assert-type macro, but
this it should certainly be as dummy proof as possible.  That will force
others to get a really *really* good dummy if they want to break it!

Thank you for this! I suppose another justification for having a single
"black box" macro that does this in one place and addresses all of these
tricky issues.

I guess I'll fix it up (and address the emails on the other patches) and
do a v5 then for the whole set? (is that the right way to resubmit with
these corrections?)

Thanks
Daniel
