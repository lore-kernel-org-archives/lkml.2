Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639Ab2DEAlD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 20:41:03 -0400
Received: from uhura.skim.hs-owl.de ([193.174.118.81]:51022 "EHLO
	uhura.skim.hs-owl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab2DEAk7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 20:40:59 -0400
Message-ID: <4F7CE650.8020207@googlemail.com>
Date: Thu, 5 Apr 2012 02:24:48 +0200
From: Jan Seiffert <kaffeemonster@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120327 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Richard Henderson <rth@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Matt Evans <matt@ozlabs.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, <linux-arch@vger.kernel.org>,
        <linux-alpha@vger.kernel.org>
Subject: Re: [PATCH V1 1/1] NET: add a bpf jit for Alpha
References: <4F75CA89.4010709@googlemail.com> <4F7A033D.4040901@googlemail.com> <4F7C5A65.7090504@redhat.com>
In-Reply-To: <4F7C5A65.7090504@redhat.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Skim-SendBy: exchange.hs-owl.de on Thu, 05 Apr 2012 02:40:52 +0200
X-Skim-SendBy: exchange.hs-owl.de on Thu, 05 Apr 2012 02:40:53 +0200
X-SA-Exim-Connect-IP: 193.174.118.178
X-SA-Exim-Mail-From: kaffeemonster@googlemail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Henderson schrieb:

Thanks for the review Mr.Henderson. I'm so grateful you taken some of your
valuable time for this.

> On 04/02/2012 03:51 PM, Jan Seiffert wrote:
[snip]
> You will never need NEGLI or SEXTLI, as both results can be had with LDA.
> 

Removed

>> +static void load_complex_constant(u32 *image, struct codegen_context *ctx,
>> +				  unsigned int i, int K, int r)
>> +
>> +{
>> +	if (K == 0) {
>> +		ALPHA_CLR(r);
>> +		return;
>> +	}
>> +	if (optimize_size == 0 || constant_needs(K) < 2 ||
>> +	    i > (0x7fff/sizeof(struct sock_filter))) {
>> +		add_constant(image, ctx, K, r_zero, r);
>> +	} else {
>> +		/* load the constant from the filter program */
>> +		ALPHA_LDL(r_sf, (i * sizeof(struct sock_filter)) +
>> +			  offsetof(struct sock_filter, k), r);
> 
> Worst case for constant loading is 3.  That's the same as the delay for
> loading from memory.  Unless you're very concerned about translated size
> of the filter,

I'm unsure. The problem goes like this:
Since constant loading can take so much instructions, the code tends to
get big. This is bad for jump ranges, the icache and pinned kernel mem.
I would not mind about it (it's a RISC, it is meant to be that way), if
the constants weren't right there. We get the original filter program
(which contains the constants) passed as second parameter, on a silver
platter (i was even thinking about moving the second parameter 32k
forward to get the full imm16 range, on the other hand if struct
sock_filter is 8 byte on Alpha, then +32k is good enough for
MAX_BPF_INSN == 4096).

Essentially this is two questions, one for the Alpha µ-arch gurus and 
one for the kernel (net-)devs.
µ-Arch Gurus: How bad are mem accesses in contrast to icache for example.
Kernel devs: how important is memory consumption/how much "faster"
the jitted code has to be?

> I'd drop this condition and make your compiler run faster.
> 
> 
>> +	if (optimize_size == 0 || constant_needs(K) < 2 ||
>> +	    i > (0x7fff/sizeof(struct sock_filter))) {
>> +		add_constant(image, ctx, K, r_A, r_t);
>> +		ALPHA_SEXTL(r_t, r_t);
> 
> OTOH, this test should be simply is_imm8 and use ADDLI,
> else is_imm8(-K) use SUBLI, else load_constant ADDL.
> 

add_constant takes care of that, only the entry condition is so
complicated because of the optimize_size case.

[snip - ugly and optimization]
> 
> Really?

yes, i was typing as fast as i was thinking: "hmmm, a constant can
look like this or like that or like this...". The optimizations where an
"afterthought", i first broke the operations out into a helper and simply
made it work. Because i knew there are some shenanigans you can do with
zapnot i revisited it at the end. I will now grab a brown paper bag.

>  This ought to be as simple as
> 
>   mask = 0;
>   for (j = 0; j < 4; j++) {
>     int b = (K >> i*8) & 0xff;
>     if (b == 0xff)
>       mask |= 1 << i;
>     else if (b != 0)
>       mask = -1;
>   }
>   if (mask != -1) {
>     ALPHA_ZAPNOTI(r_A, mask, r_t);
>     return;
>   }
> 

Works like a charm, only had to change i for j. Thanks!

[snip - or 0xffffffff]
> 
> Really?  Think about what you're doing here.  LDA(r_A, -1)
> 

changed

[snip]
>> +		if (off == 0)
>> +			ALPHA_ZEXTW(r, r);
>> +		else
>> +			ALPHA_EXTWLI(r, off, r);
> 
> No point in the off==0 special case.
> 

I was thinking maybe the zapnot^wzextw is faster, because it does not
have to do the shift and it should be the common case.
But if extw is good enough, thus removed.

>> +static void emit_call(u32 *image, struct codegen_context *ctx,
>> +		      void *func, int r)
>> +{
>> +	ptrdiff_t disp = (char *)func - (char *)&image[ctx->idx + 1];
>> +	if (disp >= -2147483648 && disp <= 2147483647) {
>> +		if (is_imm_jdisp(disp)) {
>> +			ALPHA_BSR(r, disp);
>> +			return;
>> +		}
> 
> Is this known to be calling another BPF function, and not back into C?
> Otherwise you've got an error in PV handling for the calling convention.
> 

It is known to either call special bpf helper or __divlu (the kernel
version). The special helper are responsible for setting pv right when
they have to call to C again (which is deemed as the exceptional case).

That was my idea, so i don't have to set pv again after every call,
which would bloat up every filter program.

But i don't know if the helper do the "pv and call and gp"-dance right :(

[snip - div 0 test]
> 
> Re-order these to clear r_ret before the cjmp and you don't need
> the branch-around branch.
> 

Can't do.
When building the program we are searching for a ret 0 case.
As long as no case is found (or is never found), we have to build one.

Besides, i know it's dirty, r_ret and r_A share the same register.
I was squeezing on the register usage so i may use the register as
storage for the 16 bpf mem[] slots like powerpc, i mean Alpha has
31 like powerpc. But in the end i was to stupid to achieve this.
At least this hack saves a mov at the end.

>> +		case BPF_S_ALU_LSH_X: /* A <<= X; */
>> +			ctx->seen |= SEEN_XREG;
>> +			ALPHA_SLL(r_A, r_X, r_A);
>> +			ALPHA_ZEXTL(r_A, r_A);
> 
> So... are you attempting to have canonical zero-extended values,
> or canonical sign-extended values?  Because at the moment you have
> a mix of both.
> 

I know, and i don't know what i want.

> Either drop the canonicalization and consider high-32 bits as
> garbage (and then explicitly extend whereever necessary) or pick
> one and stick with it.  Of course, the sign-extending of addl etc
> will force you to choose sign-extend not zero-extend as canonical.
> 

The problem is the bpf cpu is inherently unsigned. It does all loads
zero extended, only has logical shifts, does all compares unsigned.
Which sounds like i have to zero extend like crazy. (i took the 
Powerpc code as example, it does most things unsigned and on 32 Bit,
but has similar "add is sign extending" things, so i thought it can't
be that bad, otherwise it would have the same Bugs).

I was hoping to let the sign run it's course/sign extend and only
cut at the right point, and i figured that was a point to cut, i should
prop. sign extend.

But if that is not feasible, i could also sprinkle everything with zero
extends.

>> +		case BPF_S_ALU_RSH_X: /* A >>= X; */
>> +			ctx->seen |= SEEN_XREG;
>> +			ALPHA_SRL(r_A, r_X, r_A);
>> +			ALPHA_ZEXTL(r_A, r_A);
>> +			break;
> 
> Like here.  You must zero-extend first to avoid shifting in
> garbage.  Afterward you can reason that the value is already
> zero-extended.
> 

Oh, thanks!
Yes, the shift operations are only logical shifts, so it has to be properly
zero extended.

[snip - bpf_flush_icache]
> 
> imb() is all that is needed.
> 

Thanks! I guess i will stick to the flush_icache_range, which is defined to
an imb()/smp_imb(), so should do the right thing(TM).

[snip - comment about pases]
> 
> I should think you could do this in exactly one pass, given that there's
> absolutely no need for ultra-long branches.

The first pass is called with image == NULL, so all calls have a very long
displacement + we have to make other worst case/wrong assumptions because
addrs is not properly filled and the exit points are unknown.
The second pass with image == NULL will settle some jumps, because addrs is
now mostly properly populated _and_ the exit points are set.
This is done to get a real good estimate when allocating mem, so not to much
is allocated (saw a thread on lkml where Eric was talking with Ingo about
module_realloc, so the memusage is of concern, it is pinned kernel memory
for the user space).
The other passes are only to make things really slick with image != NULL,
and stop if there is no change.
If i knew some kind of base address where module_alloc will allocate, i
could feed that in early...

> If you're going to scan the
> body for SEEN_MEM etc, you might as well look for your A and X initialization
> at the same time and clean up that hack in the prologue.
> 

I was working on a patch for that, but it was more complicated, esp. it may
cost some RAM and/or CPU time just to remove one/two instructions, so i left
it out for the moment till i revisit it.

>> +++ b/arch/alpha/net/bpf_jit_helper.S
> 
> It would be helpful to use '$' prefixes here for local variables.
> 

???
Sorry, i don't understand what you mean. What variables? Or do you mean
register? It uses the same register as the compiler. So to not confuse
things i made the names from the compiler usable in asm. You can change one
define and the compiler and the helper will use another reg.

> 
> r~
> 

Greetings
	Jan

-- 
Anyone can build a fast processor. The trick is to build a fast system.
(Seymour Cray)
