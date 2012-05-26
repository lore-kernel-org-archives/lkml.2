Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab2EZBMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 21:12:40 -0400
Received: from nm5-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.112]:36048
	"HELO nm5-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751510Ab2EZBMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 21:12:38 -0400
X-Yahoo-Newman-Id: 228247.25076.bm@omp1017.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: SGD7oe0VM1mGZD9KHzJA.LZeGd.6c00107FiEFmChukqbpj
 TjbvXvi9.5yWuoEFcyyBgi6ZHSoHO.Pha3qVriH15DBzi0HODeMM24QxHQya
 uYfURTV2FYb_BX_VY8Sy0s1kFnCSAyKBkcL0VsadgSSKvTYxCBNuPctdbwQI
 KKVbi_wHSEDBNuFVggPvsg15Pgd2h5vZ7X2A.Ue73Se6mNzhBqDjr.nNgNYe
 kJEhLMaeXx.Evnvn56bW2.g_.GEoiZtHFWVqjEEn3J98GPv3rInmBLtLQR1U
 dBc9KKlVh72oZ.d2xgF4jlWujVsNnbj1gxp5Y8x_HGO_7A9aZI02gFBbsZ.a
 Lg3dFz8VALhwuwWb6XaeuojLx8m7OPb1Bk2ZUGu3Acc4anXG_NrL.QusxXu4
 VRT0zdQ--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FC02E07.8070703@att.net>
Date: Fri, 25 May 2012 20:12:39 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Generic Red-Black Trees (status update)
References: <4FC00C50.3000907@att.net> <m2fwanlv8u.fsf@firstfloor.org>
In-Reply-To: <m2fwanlv8u.fsf@firstfloor.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Daniel Santos <danielfsantos@att.net> writes:
>
>> For anybody that's keeping up with this, I've gone through multiple
>> iterations and tests with 9 different gcc versions and concluded that
>> the search, insert & remove cores need to be coded in rbtree.h, using
>> the traditional interface (i.e., passing struct rb_node & rb_root
>> pointers instead of pointers to your specific object types).  The reason
>> is that gcc can't handle the cool fully-generic code until 4.6.  In gcc
>> 4.5.x, optimization completely breaks expanding the inline functions
> Can you post details?
Well, I suppose part of this is my own value judgment of what is a
"clean" implementation.  By this, I mean balancing these requirements:
1.) minimal dependence on pre-processor
2.) avoiding pre-processor expanded code that will break debug
information (backtraces)
3.) optimal encapsulation of the details of your rbtree in minimal
source code (this is where you define the relationship between your
container and contained objects, their types, keys, rather or not
non-unique objects are allowed, etc.) -- preferably eliminating
duplication of these details entirely.
4.) offering a complete feature-set in a single implementation (not
multiple functions when various features are used)
5.) perfect optimization -- the generic function must be exactly as
efficient as the hand-coded version

So by those standards, the cleanest implementation I've come up with
uses a macro to define an anonymous interface struct something like this:

/* gerneric non-type-safe function */
static __always_inline void *__generic_func(void *obj);

/* macro to generate type-safe interface object (in practice, the real one
 * defines all the functions in the interface, but I'm keeping it simple for
 * brevity)
 */
#define INTERFACE_A(name, in_type, out_type)                            \
struct {                                                                \
        out_type *(*const func)(in_type *obj);                          \
} name = {                                                              \
        .func = (out_type *(*const)(in_type *obj))__generic_func;       \
}

/* usage looks like this: */
INTERFACE_A(solution_a, struct something, struct something_else);
struct something *s;
struct something_else *se;
se = solution_a.func(s);

Calling solution_a.func(s) optimizes perfectly in 4.6, while in 4.5 and
prior, the call by struct-member-function-pointer is never inlined and
nothing passed to it is every considered a compile-time constant. 
Because of the implementation of the generic functions, it bloats the
code unacceptably (3x larger).  The following alternative works prior to
4.6, but with different syntax:

/* IMO, this solution is uglier and will break backtraces. */
#define INTERFACE_B(name, in_type, out_type)                    \
static __always_inline out_type * name##_func(in_type *obj)     \
{                                                               \
        return (out_type *)__generic_func(obj);                 \
}

/* now you call solution_b_func(s) instead of solution_a.func(s) */

>> into huge bloated  monsters.  Also, while I'm re-coding it all, I'm
>> adding find_near & insert_near, for more efficient insertion & retrieval
>> when you already have a node that should be close to the one you want
>> (which is often the case when inserting many objects at once).
>>
>> So after I'm done with this, I'll start on a new header file (grbtree.h
>> probably) using the "grb_" prefix for it's functions that implements the
>> gcc 4.6.x+ fully generic & type safe interface, but using cute
>> pre-processor tricks for pre-4.6.x compatibility (basically, something
>> to consider using once gcc 4.6+ is more widely used).
> That doesn't make sense. Either it's used or it's not used,
> but if it's available it should work with all compilers.
>
> Otherwise you would end up with drivers or subsystems that
> are compiler specific.
>
> It's ok to be somewhat slower or bigger on older compilers.
You have a good point here, although I'm not sure that a 3x larger
function is an acceptable performance hit for a compiler as recent as
4.5.  Perhaps it's best to just implement it using the INTERFACE_B style
above, accept the minor loss of backtrace-ability and pre-processor
ugliness and get on with it.  There's no advantage to having two
competing syntaxes for usage.  I'll post the full details with patch
tomorrow.

Daniel

