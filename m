Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242Ab0HUElM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 00:41:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49439 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab0HUElK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 00:41:10 -0400
Message-ID: <4C6F58DE.1010503@zytor.com>
Date: Fri, 20 Aug 2010 21:41:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Mark Stanovich <mrktimber@gmail.com>
CC: torvalds@linux-foundation.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.35.3
References: <AANLkTi=wyG13QOU3EQwaO3qBxY=aR=ftiP4s7YpemrPp@mail.gmail.com>	<4C6F4BBB.5040207@zytor.com> <AANLkTi=sKH95tLee+H03ah=8dF6LV9hpw+1esGSZuHRS@mail.gmail.com>
In-Reply-To: <AANLkTi=sKH95tLee+H03ah=8dF6LV9hpw+1esGSZuHRS@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050905020507050005010804"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050905020507050005010804
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

OK, I think we can consider this root-caused (it's unclear if it's our
bug or gcc's, but adding "volatile" to the pointer solves the problem.)

Greg, do you want to take the listed upstream patches (thus bringing the
code closer to mainline) or do you want to take the one-liner patch from
the bugzilla?  [Attached for reference?]

	-hpa



On 08/20/2010 09:06 PM, Mark Stanovich wrote:
> On Fri, Aug 20, 2010 at 11:44 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 08/20/2010 08:40 PM, Mark Stanovich wrote:
>>> After updating to the 2.6.35.3 stable release, my machine was rebooting
>>> automatically during the first few seconds of boot.
>>>
>>> I bisected to the first bad commit of
>>>
>>> commit 568132624386f53e87575195d868db
>>> 9afb2e9316
>>> Author: H. Peter Anvin <hpa@zytor.com <mailto:hpa@zytor.com>>
>>> Date:   Tue Jul 27 17:01:49 2010 -0700
>>>
>>>     x86: Add memory modify constraints to xchg() and cmpxchg()
>>>
>>>     commit 113fc5a6e8c2288619ff7e8187a6f556b7e0d372 upstream.
>>>
>>>     xchg() and cmpxchg() modify their memory operands, not merely read
>>>     them.  For some versions of gcc the "memory" clobber has apparently
>>>     dealt with the situation, but not for all.
>>>
>>> I noticed that the latest version pulled from Linus's git tree did not
>>> have the problem.  After looking at the changes to
>>> arch/x86/include/asm/cmpxchg_32.h, I cherry-picked two patches from
>>> Linus's tree that seemed to make a difference, namely:
>>>
>>> 69309a05907546fb686b251d4ab041c26afe1e1d
>>> 4532b305e8f0c238dd73048068ff8a6dd1380291
>>>
>>> Applying these patches solved the rebooting problem on 2.6.35.3
>>>
>>> I believe the same problem also happens for the latest stable version of
>>> 2.6.34, but did not verify the fix worked for the 2.6.34 stable releases.
>>>
>>> I don't know if this is helpful, but I thought I would let you know in
>>> case someone else is having the same problem.
>>>
>>> If you need any further information, just let me know.
>>>
>>
>> Yes, as a matter of fact, we have been trying to root-cause this
>> problem; please see:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=16612
>>
>> If you could try the one-liner in there and see if it solves your
>> problem, it would be great.
> 
> The patch for __set_64bit on top of 2.6.35.3 solves the rebooting problem!
> 
>>
>>        -hpa
>>
>> P.S. What version of gcc do you use?
> 
> gcc (Gentoo 4.4.3-r2 p1.2) 4.4.3
> 
> Thanks,
> Mark
> 


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


--------------050905020507050005010804
Content-Type: text/x-patch;
 name="volatilize.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="volatilize.patch"

diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index c1cf59d..e022d0c 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -66,7 +66,7 @@ struct __xchg_dummy {
  * of the instruction set reference 24319102.pdf. We need
  * the reader side to see the coherent 64bit value.
  */
-static inline void __set_64bit(unsigned long long *ptr,
+static inline void __set_64bit(volatile unsigned long long *ptr,
 			       unsigned int low, unsigned int high)
 {
 	asm volatile("\n1:\t"

--------------050905020507050005010804--
