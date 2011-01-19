Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab1ASWNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:13:31 -0500
Received: from mail.openrapids.net ([64.15.138.104]:40733 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753690Ab1ASWNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:13:30 -0500
Date: Wed, 19 Jan 2011 17:13:27 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Miller <davem@davemloft.net>
Cc: rostedt@goodmis.org, richm@oldelvet.org.uk, 609371@bugs.debian.org,
        ben@decadent.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
	Unknown relocation: 36
Message-ID: <20110119221327.GA23544@Krystal>
References: <20110118.223247.241909079.davem@davemloft.net> <20110118.232045.58440904.davem@davemloft.net> <20110119153326.GC11022@Krystal> <20110119.134047.232915743.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119.134047.232915743.davem@davemloft.net>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:51:45 up 57 days,  2:54,  4 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller (davem@davemloft.net) wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Date: Wed, 19 Jan 2011 10:33:26 -0500
> 
> > I'm still unsure that __long_long_aligned is needed over __long_aligned though.
> > AFAIK, the only requirement we have for, e.g. tracepoints, is to align on the
> > pointer size (sizeof(long)), so RCU pointer updates are performed atomically.
> > Aligning on the pointer size also allows the architecture to efficiently read
> > the field content. What does aligning on sizeof(long long) bring to us ? Is it
> > that you are concerned about the fact that the "aligned" type attribute, when
> > applied to a structure, is only used as a lower-bound by the compiler ? In that
> > case, we might want to consider using "packed" too:
> 
> My concern is that if there is ever a u64 or similarly "long long"
> typed member in these tracing structures, it will not be aligned
> sufficiently to avoid unaligned access traps on 32-bit systems.

Hrm, I'd like to see what kind of ill-conceived 32-bit architecture would
generate a unaligned access for a 32-bit aligned u64. Do you have examples in
mind ? By definition, the memory accesses should be at most 32-bit, no ? AFAIK,
gcc treats u64 as two distinct reads on all 32-bit architectures.

> If your suggestion defines the lowest possible alignment and GCC will
> do the right thing and "up-align" the structure if necessary, then
> fine.

Well, I must admit that my assumption is that aligning on the "long" size should
be the only alignment required, both on 32-bit and 64-bit. But I'm curious to
see if there are indeed architectures that break this assumption.

Ideally, I'd like to avoid letting gcc up-align a structure, because it is then
hard to know for sure what the alignment value of the section should be (in the
linker script, we can safely choose 32, but it's more a "safe choice" than
anything else). Moreover, I'm not convinced that gcc will choose to up-align the
structure with the exact same alignment values for both the type declaration and
the variable definition (I'm deeply distrusting gcc to do the right thing here).

> If you add "packed" it is going to screw everything up and we'll
> essentially be back to square one.
> 
> On RISC like sparc64, "packed" causes even 16-bit words to be read and
> written a byte at a time.
> 
> Never use "packed" under any circumstances unless absolutely
> unavoidable.

gcc on my sparc64 box (32-bit userland) disagrees with you here ;) Using
gcc (Debian 4.3.3-14) 4.3.3, here is a demonstration that, indeed, "packed"
generates aweful code, but that "packed, aligned(4 or 8)" generates pretty
decent code:

compiling for sparc32:

struct test {
        unsigned long a;
        unsigned long b;
};

Storing to test "a" field in a main() that returns 0, with -O0:

000104f0 <main>:
   104f0:       9d e3 bf 90     save  %sp, -112, %sp
   104f4:       03 00 00 81     sethi  %hi(0x20400), %g1
   104f8:       84 10 63 9c     or  %g1, 0x39c, %g2     ! 2079c <blah>
   104fc:       82 10 20 2a     mov  0x2a, %g1
   10500:       c2 20 80 00     st  %g1, [ %g2 ]
   10504:       82 10 20 00     clr  %g1
   10508:       b0 10 00 01     mov  %g1, %i0
   1050c:       81 e8 00 00     restore 
   10510:       81 c3 e0 08     retl 
   10514:       01 00 00 00     nop 

__attribute__((packed))

000104f0 <main>:
   104f0:       9d e3 bf 90     save  %sp, -112, %sp
   104f4:       03 00 00 81     sethi  %hi(0x20400), %g1
   104f8:       84 10 63 dc     or  %g1, 0x3dc, %g2     ! 207dc <blah>
   104fc:       c2 08 80 00     ldub  [ %g2 ], %g1
   10500:       82 08 60 00     and  %g1, 0, %g1
   10504:       c2 28 80 00     stb  %g1, [ %g2 ]
   10508:       c2 08 a0 01     ldub  [ %g2 + 1 ], %g1
   1050c:       82 08 60 00     and  %g1, 0, %g1
   10510:       c2 28 a0 01     stb  %g1, [ %g2 + 1 ]
   10514:       c2 08 a0 02     ldub  [ %g2 + 2 ], %g1
   10518:       82 08 60 00     and  %g1, 0, %g1
   1051c:       c2 28 a0 02     stb  %g1, [ %g2 + 2 ]
   10520:       c2 08 a0 03     ldub  [ %g2 + 3 ], %g1
   10524:       82 08 60 00     and  %g1, 0, %g1
   10528:       82 10 60 2a     or  %g1, 0x2a, %g1
   1052c:       c2 28 a0 03     stb  %g1, [ %g2 + 3 ]
   10530:       82 10 20 00     clr  %g1
   10534:       b0 10 00 01     mov  %g1, %i0
   10538:       81 e8 00 00     restore 
   1053c:       81 c3 e0 08     retl 
   10540:       01 00 00 00     nop 

__attribute__((packed, aligned(4)))

000104f0 <main>:
   104f0:       9d e3 bf 90     save  %sp, -112, %sp
   104f4:       03 00 00 81     sethi  %hi(0x20400), %g1
   104f8:       84 10 63 9c     or  %g1, 0x39c, %g2     ! 2079c <blah>
   104fc:       82 10 20 2a     mov  0x2a, %g1
   10500:       c2 20 80 00     st  %g1, [ %g2 ]
   10504:       82 10 20 00     clr  %g1
   10508:       b0 10 00 01     mov  %g1, %i0
   1050c:       81 e8 00 00     restore 
   10510:       81 c3 e0 08     retl 
   10514:       01 00 00 00     nop 

__attribute__((packed, aligned(8)))

000104f0 <main>:
   104f0:       9d e3 bf 90     save  %sp, -112, %sp
   104f4:       03 00 00 81     sethi  %hi(0x20400), %g1
   104f8:       84 10 63 a0     or  %g1, 0x3a0, %g2     ! 207a0 <blah>
   104fc:       82 10 20 2a     mov  0x2a, %g1
   10500:       c2 20 80 00     st  %g1, [ %g2 ]
   10504:       82 10 20 00     clr  %g1
   10508:       b0 10 00 01     mov  %g1, %i0
   1050c:       81 e8 00 00     restore 
   10510:       81 c3 e0 08     retl 
   10514:       01 00 00 00     nop 

Now about :

struct test {
        unsigned long long a;
        unsigned long long b;
};

__attribute__((packed, aligned(8)))
(and without attribute)

000104f0 <main>:
   104f0:       9d e3 bf 90     save  %sp, -112, %sp
   104f4:       03 00 00 81     sethi  %hi(0x20400), %g1
   104f8:       82 10 63 a0     or  %g1, 0x3a0, %g1     ! 207a0 <blah>
   104fc:       84 10 20 00     clr  %g2
   10500:       86 10 20 2a     mov  0x2a, %g3
   10504:       c4 38 40 00     std  %g2, [ %g1 ]
   10508:       82 10 20 00     clr  %g1
   1050c:       b0 10 00 01     mov  %g1, %i0
   10510:       81 e8 00 00     restore 
   10514:       81 c3 e0 08     retl 
   10518:       01 00 00 00     nop 
   1051c:       00 00 00 00     illtrap  0

__attribute__((packed, aligned(4)))

000104f0 <main>:
   104f0:       9d e3 bf 90     save  %sp, -112, %sp
   104f4:       03 00 00 81     sethi  %hi(0x20400), %g1
   104f8:       84 10 63 9c     or  %g1, 0x39c, %g2     ! 2079c <blah>
   104fc:       82 10 20 2a     mov  0x2a, %g1
   10500:       c2 20 a0 04     st  %g1, [ %g2 + 4 ]
   10504:       c0 20 80 00     clr  [ %g2 ]
   10508:       82 10 20 00     clr  %g1
   1050c:       b0 10 00 01     mov  %g1, %i0
   10510:       81 e8 00 00     restore 
   10514:       81 c3 e0 08     retl 
   10518:       01 00 00 00     nop 
   1051c:       00 00 00 00     illtrap  0

So the packed, aligned(__alignof__(long)) options does not look that bad.

Mathieu



-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
