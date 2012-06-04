Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab2FDUEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 16:04:08 -0400
Received: from nm5.access.bullet.mail.mud.yahoo.com ([66.94.237.206]:36726
	"HELO nm5.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752760Ab2FDUED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 16:04:03 -0400
X-Yahoo-Newman-Id: 165240.12371.bm@smtp115.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: YLhpPd4VM1n0lmx3iddvdLZqAByiib4i7dTl9oSN_sxAKWt
 armTIlEteU0aBHWmg70DoOFTkaNkYNX5mBWIf7vnVvl.scEVcaXL1but78Y_
 PyoAS02ScY4AHvXd.TfRsPGEDGT2_H4MKOsBpY.msOGrIqqUMFOsIjrXEHxw
 LzFgkr9s3f4l.P7LFfv23_df1d5zNJolv3Inb8rJ5aX7wR482wFhjJK_Z2W.
 amSXGC.E.as_TDZe5Qx4cxoEMab6GEOvT3RZOHErMVBp9G5aXSSDm0sQiUco
 FZXCs8iovxK6nfboBqIVJ6PnbUunHJGdPVeRen3.xshJgrCGPCFeSvlsCJIc
 UKCUgQE6h.naYJMesjSnRbI240LuieX5V2R7dsvgseQxQFVS7ofwntJqQYd8
 5p_Dl4FiYijkP1OXaTnEGoeYQOOmniDw-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FCD14B2.2080906@att.net>
Date: Mon, 04 Jun 2012 15:04:02 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux/bug.h: make BUILD_BUG_ON generate compile-time
 error
References: <4FCC9D7F.7070404@att.net> <4FCCC703.2070609@windriver.com>
In-Reply-To: <4FCCC703.2070609@windriver.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 09:32 AM, Paul Gortmaker wrote:
> On 12-06-04 07:35 AM, Daniel Santos wrote:
>> This is pretty straight-forward. __compiletime_error is defined in
>> compiler-gcc4.h with appropriate version checks, so shouldn't break on
>> older compilers. This makes the difference between getting an error at
>> link-time and getting one at compile time. Example:
> It is such a rarity for it to be triggered, that I wonder if it
> really matters whether it happens at compile time, or you wait
> the extra minute for link time.  Regardless, you've got your
> commit log written here, and not in the patch (which was attached
> and not inline; preventing comment) and you've not got any
> Signed-off line. 
I apologize for the quality of patch issues.  I've just read about "git
--signoff" and I'll do that next time.  As far as the patch being
attached instead of inline, I haven't gotten my mailer client to not
screw them up yet (I'm using Thunderbird, and apparently I need to
install an external editor add-on or switch to another mail client).

As for the rarity, it's fairly common for me right now since I'm working
on stuff that depends upon compile-time constants and
__builtin_constant_p tests, since I have so many of them, it can be
tricky to track down which one in particular fails.  Since gcc added
this feature specifically for these types of checks, I thought it
appropriate that it should be used here.
>> /home/daniel/proj/kernel/grbtest/grbtest2.c:83:2: error: call to
>> ‘__build_bug_on_failed’ declared with attribute error: BUILD_BUG_ON
>> failed: !__builtin_constant_p(count)
> Also the string "BUILD_BUG_ON failed" is in itself misleading, as if
> the macro itself has issues, vs. say using the word "triggered" or 
> "tripped" vs. "failed".  You also don't want to put the whole
> meaningless paths in commit logs normally (the /home/me/mydir part).
ok, good point, I guess I'm thinking along the lines of a assertions
"failing".  So maybe "BUILD_BUG_ON triggered by: " #condition?
>
>> The above points me directly to where I called BUILD_BUG_ON. Note that
>> I'm moving __build_bug_on_failed out of the global scope, just so it can
>> be re-declared with different attributes each time.
> It wasn't clear to me why you'd want to re-declare things with
> different attributes ever.
Sorry for not clarifying this. If I have two lines like this:

BUILD_BUG_ON(!__builtin_constant_p(count));
BUILD_BUG_ON(size < 1024);

Each will declare extern void __build_bug_on_failed(void), but with
different attributes.  The first will be delcared with
__attribute__((error("BUILD_BUG_ON failed:
!__builtin_constant_p(count)"))) and the second with
__attribute__((error("BUILD_BUG_ON failed: size < 1024"))).  The
advantage is that the error output will tell you exactly what triggered
the failure, which can be especially important if you have a macro that
expands to more than one BUILD_BUG_ON check on the same line.

But I guess the really sad part that both of us have missed is that
BUILD_BUG() already uses this attribute, except via a different macro --
which means that now, in compiler-gcc4.h, we have two macros that both
expand to __attribute__(((error(msg))), except that __linktime_error
uses "__error__", where __compiletime_error uses "error".  Also, this
feature was introduced in 4.3.0 and I was not able to find any bug
reports indicating that it had problems, so that would mean the compiler
version check for __linktime_error (4.3.x) is correct and
__compiletime_error (4.4.x) is 1 minor revision late.

Then again, perhaps these macros exist to be turned off by __CHECKER__.

Daniel




