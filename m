Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab1KPUwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 15:52:55 -0500
Received: from slb-smtpout-01.boeing.com ([130.76.64.48]:49090 "EHLO
	slb-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab1KPUwx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 15:52:53 -0500
From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
To: Paul Mackerras <paulus@samba.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "B04825@freescale.com" <B04825@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "scottwood@freescale.com" <scottwood@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Date: Wed, 16 Nov 2011 14:52:28 -0600
Subject: Re: [RFC PATCH 0/2] powerpc: CPU cache op cleanup
Thread-Topic: [RFC PATCH 0/2] powerpc: CPU cache op cleanup
Thread-Index: Acykoacu0S9ZOiIKQvSuQsPugsfw9w==
Message-ID: <CBC1AF48-B8D4-42B6-8E50-5ACA84F03022@boeing.com>
References: <1320986410.21206.48.camel@pasglop>
 <1321324332-22964-1-git-send-email-Kyle.D.Moffett@boeing.com>
 <1321396146.3170.11.camel@pasglop>
 <022078B9-CD41-4D24-B44A-F85256A69D0A@boeing.com>
 <20111116044032.GA26476@bloggs.ozlabs.ibm.com>
In-Reply-To: <20111116044032.GA26476@bloggs.ozlabs.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
x-tm-as-product-ver: SMEX-10.0.0.1412-6.800.1017-18522.007
x-tm-as-result: No--64.118600-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 15, 2011, at 23:40, Paul Mackerras wrote:
> On Tue, Nov 15, 2011 at 04:45:18PM -0600, Moffett, Kyle D wrote:
>> 
>> I guess that's doable, although I have to admit that idea almost gives
>> me more of a headache than trying to fix up the 32-bit ASM.
>> 
>> One thing that bothers me in particular is that both 32/64 versions of
>> __copy_tofrom_user() are dramatically overcomplicated for what they
>> ought to be doing.
>> 
>> It would seem that if we get a page fault during an unaligned copy, we
>> ought to just give up and fall back to a simple byte-by-byte copy loop
>> from wherever we left off.  That would eliminate 90% of the ugly
>> special cases without actually hurting performance, right?
> 
> That's basically what we do, IIRC, and most of the complexity comes
> from working out where we were up to.  We could probably use a simpler
> approximation that means we might copy some bytes twice.  In fact the
> greatest simplification would probably be to implement range entries
> in the exception table so we can just have one entry for all the loads
> and stores instead of an entry for each individual load and store.

Well, I spent some time tinkering with the GCC inline-assembly option,
which was probably a waste, but I figured I would post my code here for
other people to chuckle at.  :-D

Here's a basic, relatively easily extended "copy u8" macro that sets up
the exception table using "asm goto":

#define try_copy_u8(DST, SRC, LOAD_FAULT, STORE_FAULT) do {	\
	unsigned long try_copy_tmp__ = (try_copy_tmp__);	\
	asm goto (						\
		"1:	lbz %[tmp], %[src]\n"			\
		"2:	stb %[tmp], %[dst]\n"			\
		"	.pushsection __ex_table, \"a\"\n"	\
		"	.align 2\n"				\
		"	.long 1b, %l["#LOAD_FAULT"]\n"		\
		"	.long 2b, %l["#STORE_FAULT"]\n"		\
		"	.popsection\n"				\
		: /* No outputs allowed for "asm goto" */	\
		: [dst] "m"(*(__user u8 *)(DST)),		\
		  [src] "m"(*(const __user u8 *)(SRC)),		\
		  [tmp] "r"(try_copy_tmp__)			\
		: "memory"					\
		: LOAD_FAULT, STORE_FAULT			\
	);							\
} while(0)

If I put that into a function and compile it, the assembly and the
exception table look perfectly OK, even under register pressure.
With a few macros like that it looks like it should be possible to
write the copy function directly in C and get optimal results.

The only other variants you need would be "try_copy_ulong" and
"try_copy_4ulong"/"try_copy_8ulong" for 32/64-bit.

Unfortunately, as I mentioned before, GCC 4.4 and older don't have
"asm goto" support :-(.

Perhaps I could put __copy_tofrom_user() into its own file and make
the assembled 32/64 output files be ".shipped"?

On the other hand, perhaps this is overly complicated :-D.

I'll poke at it more tomorrow.


>> For a page-fault during a cacheline-aligned copy, we should be able to
>> handle the exception and retry from the last cacheline without much
>> logic, again with good performance.
>> 
>> With that said, I'm curious about the origin of the PPC32 ASM.  In
>> particular, it looks like it was generated by GCC at some point in the
>> distant past, and I'm wondering if there's a good way to rewrite that
>> file in C and trick GCC into generating the relevant exception tables
>> for it?
> 
> Why do you think it was generated by gcc?  I wrote the original
> version, but I think it got extended and macro-ized by others.

Ah, sorry,  when I first looked at it the large collection of numeric
labels and the very sparing comments made it look autogenerated.

Although, given how much of a pain in the neck it is maybe you would
rather people not think you wrote it at all. ;-)

Cheers,
Kyle Moffett

--
Curious about my work on the Debian powerpcspe port?
I'm keeping a blog here: http://pureperl.blogspot.com/

