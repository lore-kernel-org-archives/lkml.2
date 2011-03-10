Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab1CJSEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 13:04:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54617 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab1CJSEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 13:04:06 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=UwRGqXM3h7MA:10 a=IkcTkHD0fZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=U9pPZYnkAAAA:8 a=EKu6VDdQP5BItLtRNQcA:9 a=hNg_hEFNnIMEuTt5XM4A:7 a=NNm1ziERnz7BL_zWb2uZAk9eYFMA:4 a=QEXdDO2ut3YA:10 a=wIppf-e6KYyYldE5:21 a=HWEzS9xIYd7OhpEW:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/2] jump label: update for .39
From: Steven Rostedt <rostedt@goodmis.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Jason Baron <jbaron@redhat.com>, peterz@infradead.org, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
In-Reply-To: <4D790A13.4060705@caviumnetworks.com>
References: <cover.1299702291.git.jbaron@redhat.com>
	 <1299728191.15854.319.camel@gandalf.stny.rr.com>
	 <BLU0-SMTP690BB959832A97E002293396C80@phx.gbl>
	 <1299771504.15854.347.camel@gandalf.stny.rr.com>
	 <4D790A13.4060705@caviumnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Mar 2011 13:04:01 -0500
Message-ID: <1299780241.15854.393.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 09:27 -0800, David Daney wrote:
> On 03/10/2011 07:38 AM, Steven Rostedt wrote:

> >> Can you explain what would prevent gcc from aligning these 3 pointers
> >> (total of 24 bytes on 64-bit architectures) on 32-bytes ?
> 
> I can:
> 
> http://www.x86-64.org/documentation/abi.pdf Section 3.1.2:
> 
>     Aggregates and Unions

Note, we are not dealing with C or arrays, but with inline assembly, and
the linker.

+static __always_inline bool arch_static_branch(struct jump_label_key *key)
+{
+       asm goto("1:\tnop\n\t"
+               "nop\n\t"
+               ".pushsection __jump_table,  \"aw\"\n\t"
+               WORD_INSN " 1b, %l[l_yes], %0\n\t"
+               ".popsection\n\t"
+               : :  "i" (key) : : l_yes);
+       return false;
+l_yes:
+       return true;
+}


That push/pop section part creates the structure we are talking about.
It's made up of three pointers. The address of the nop, the address of
the label l_yes and the address of the key.

Now its up to the linker to decide where to place that element. Can we
guarantee that it will always be on an 8 byte boundery?
Hmm, I wonder if we could add a .ALIGN sizeof(long) before that?

Now if we have two object files where there's a list of these jump
labels, and then when the linker concatenates them we have something
like:

 .long f1-a, .long f1-b, .long f1-c
 [ the above is 24 bytes ] so
 .long [ pad 8 bytes]
 .long f2-a, .long f2-b, .long f2-c ...

Where f1 is object file 1 and f2 is object file 2. File 1 has a jump
label table that holds a total of 24 bytes, and when the linker added
the next jump label it padded it with 8 bytes into that section. The
question remains, is that OK for the linker to do that, even though we
specified in vmlinux.ld:

        /* implement dynamic printk debug */                            \
+       . = ALIGN(8);                                                   \
+       VMLINUX_SYMBOL(__start___jump_table) = .;                       \
+       *(__jump_table)                                                 \
+       VMLINUX_SYMBOL(__stop___jump_table) = .;                        \

But then again, maybe it will break on 32 bit, where the above file 1
would have a total of 12 bytes, it may pad it with 4 bytes to keep that
8 byte alignment.
  

>     Structures and unions assume the alignment of their most strictly
>     aligned component. Each member is assigned to the lowest
>     available offset with the appropriate alignment. The size of any
>     object is always a multiple of the object‘s alignment.
> 
>     An array uses the same alignment as its elements, except that a
>     local or global array variable of length at least 16 bytes or a C99
>     variable-length array variable always has alignment of at least 16
>     bytes.
> 
>     Structure and union objects can require padding to meet size and
>     alignment constraints. The contents of any padding is undefined.
> 
> I don't think it is explicitly stated, but it is also true that the size 
> is the smallest value that meets the above constraints.

Could be true, but gcc has no idea that this data is an array. It's
really up to the linker.

> 
> 
> >> Also, could
> >> you point out what would refrain the linker from aligning the start of
> >> object sections on the next 32-bytes (thus power of two) address
> >> multiple ?
> >
> 
> The rules of the ABI are quite specific.  It would be a toolchain bug if 
> this were messed up.
> 
> 
> 
> > Maybe it would be just easier to add another long ;)
> 
> Maybe we should audit all the data structures in the entire kernel and 
> add manual padding to power of 2 boundaries.

We are not worried about normal C data structures, we are worried about
data structures that are created by inline assembly and the linker. As
we did have a bug with the trace_events code. But that dealt with a
structure that was not strictly naturally word aligned. It had "int" as
well as pointers.

> 
> >
> > Seriously, it would. Then it would be 32 bytes on 64bit and 16 bytes on
> > 32bit. Then I guess we can have our guarantee without doing a large
> > change to have this indirect pointer and still waste sizeof(long) bytes
> > in having it.
> >
> > Just insert a long "Reserved" word.
> >
> 
> I disagree.  Wasting memory to work around non-existent hypothetical 
> bugs seems wrong to me.

The linker may never cause the issue. I haven't seen any problems with
things that were naturally word aligned. But then, all the places that
we do this has been naturally word aligned as well as a power of 2
(extables for example).

Thus, if we do "waste" space, I rather just add the 'Reserved' word and
which makes it a power of 2 and be done with it.

-- Steve


