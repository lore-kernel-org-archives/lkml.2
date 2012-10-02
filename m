Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab2JBQEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:04:08 -0400
Received: from nm31-vm5.bullet.mail.bf1.yahoo.com ([72.30.239.13]:30775 "HELO
	nm31-vm5.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754790Ab2JBQEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:04:05 -0400
X-Yahoo-Newman-Id: 351170.89232.bm@smtp112.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 0d.U26AVM1me1.1xjcN5_4tupG03Gbqen9PZLtEurxZqh7P
 aKPEqF5miPu3w7POwec_TtINgJFoO_JUST5bQWcn82LLcYyYBlvw7pessNr2
 tmg9lVuiWE3nUpzPV3IaEnrpP77zG1egN2sMBpaqCsvvhoKmADfGQ3TG_glJ
 1f8GRd.ClAjFu12igk73_SdhQrkS6_sa.d7mTEh5U8sTgVzkjZ6slDVCRNRY
 w5wt5pnxTVkCwst3DFYZETGAi8KS9w7KOaIaQdd4lge5mrbFbW_BdUGnG22t
 .EzHUp6nAJ5joebe7GDEK_ER8KLr77FgT5Xp3mZ8V2EqMSEGZlQlXHpeFWS6
 sLfgYNWSCL7CgbVRweI.rLT7r2H4LSjscXAM2VVp7vcO_zcfAkbbkefHwmRt
 1iilCh62kVBbjOLv8.3O.McrX8rPZLub3cTaIXdnmPTmQrscJAQ--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <506B1076.8050100@att.net>
Date: Tue, 02 Oct 2012 11:04:06 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Daniel Santos <daniel.santos@pobox.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 10/10] bug.h: Add gcc 4.2+ versions of BUILD_BUG_ON_*
 macros
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com> <1348874411-28288-11-git-send-email-daniel.santos@pobox.com> <CANN689EoTUakd89D4sAXLFHJ=JzFPaTpisMHFi4Yf_gQ58qngA@mail.gmail.com>
In-Reply-To: <CANN689EoTUakd89D4sAXLFHJ=JzFPaTpisMHFi4Yf_gQ58qngA@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2012 07:55 PM, Michel Lespinasse wrote:
> On Fri, Sep 28, 2012 at 4:20 PM, Daniel Santos <daniel.santos@pobox.com> wrote:
>> BUILD_BUG_ON42(arg)
>> BUILD_BUG_ON_CONST42(arg)
>>
>> Prior to gcc 4.2, the optimizer was unable to determine that many
>> constant values stored in structs were indeed compile-time constants and
>> optimize them out.  Sometimes, it will find an intergral value to be a
>> compile-time constant, but fail to perform a bit-wise AND at
>> compile-time.  These two macros provide a mechanism to perform these
>> build-time checks, but not break on older compilers where we already
>> know they can't be checked at compile time.
>>
>> For specific details, consult the doc comments for BUILD_BUG_ON_CONST.
>> These macros are used in the generic rbtree code.
>
> I think the names are quite confusing. BUILD_BUG_ON_NON_CONST42 sounds
> like it's checking if 42 is a constant.
>
> The name probably shouldn't mention what compiler versions support
> this check, but instead it should hint as to when you should use this
> instead of BUILD_BUG_ON_CONST ? Maybe BUILD_BUG_ON_CONST_DEREF or
> something (I'm pretty bad with names too :)
I completely agree about the naming, but I'm also stumped. I choose
version 4.2 after writing a test program & group of scripts and sifting
through the results of 220k tests of __builtin_constant_p()!  In gcc
4.2, there are still some tests that will fail, but I went with 4.2 as
the "good version" mostly because:

a. the broken tests didn't affect my generic red-black tree
implementation, and
b. broken cases in 4.2 were the slim minority.

For instance calling __builtin_constant_p() on a dereferenced pointer in
4.2 always fails, while dereferencing a global static array (of
primitives) returns 1 in pretty much every case that it should
(excepting global non-static const, which also fails in 4.7 and perhaps
the compiler figures that somewhere else, const can be cast away and the
data modified anyway?).

Maybe it would be better in the long term to create multiple macros for
testing various constructs.  Verbosity does really start to increase
here, but I suppose we can work out some type of nomenclature to control
that while still being clear about what the macro does (not that I have
any ideas at the moment).

BUILD_BUG_ON_NON_CONST_PTR_DEREF     - gcc 4.4
BUILD_BUG_ON_NON_CONST_ARRAY_DEREF   - gcc 4.2
BUILD_BUG_ON_NON_CONST_STRUCT_MEMBER - gcc 4.2 (unless it's a pointer or
you use -O1)
etc.

To make it any more clear, I suppose I will have to clean up my test
results and share them again (an 82k spreadsheet uncompressed).  Let me
know if you want to see it.  So it's really for a sort of
full-disclosure that I use the suffix "42" and not something more
specific to what it should test.

Alternately, we can just call it something like
BUILD_BUG_ON_NON_CONST_MODERN and bump the version up gcc 4.4, which is
just as functional as 4.7.

Daniel





