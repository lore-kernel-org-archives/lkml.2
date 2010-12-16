Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab0LPGd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 01:33:56 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:39491 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab0LPGdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 01:33:54 -0500
From: Miles Bader <miles@gnu.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        Pekka Enbeerg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: x86: A fast way to check capabilities of the current cpu
References: <alpine.DEB.2.00.1012151404070.21102@router.home>
	<20101215125626.25f7d648.akpm@linux-foundation.org>
	<4D092D15.7030700@zytor.com>
	<AANLkTimhdmWGhxW9qnFWYxiVDManH4XG4RqTLJb_Fdbk@mail.gmail.com>
	<4D093580.9000303@zytor.com>
System-Type: x86_64-unknown-linux-gnu
Blat: Foop
Date: Thu, 16 Dec 2010 15:25:25 +0900
In-Reply-To: <4D093580.9000303@zytor.com> (H. Peter Anvin's message of "Wed,
	15 Dec 2010 13:39:12 -0800")
Message-ID: <buowrnakze2.fsf@dhlpc061.dev.necel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:
>> In this case it this_cpu_*_test_bit() return an int, but they act as a
>> bool and are used in if()s; where is the catch?
>
> If they aren't, and are stored in a variable for whatever reason, then
> the || form will generate additional instructions to booleanize the
> value for no good reason.

It doesn't actually have to "booleanize" the value if it's used in a
boolean context though (and, AFAICT, usually won't).

My vague impression is that when used in a boolean context, gcc will
often generate the same or "equivalent" code for both variants -- but
sometimes a||b seems to generate better code; e.g.:

   static inline int test1a (int a, int b) { return a ? 1 : b; }
   int test1b (int a, int b) { if (test1a (a,b)) return a+b; else return 37; }

   static inline int test2a (int a, int b) { return a || b; }
   int test2b (int a, int b) { if (test2a (a,b)) return a+b; else return 37; }

=>

test1b:
	testl	%edi, %edi
	jne	.L2
	movl	$37, %eax
	testl	%esi, %esi
	jne	.L2
	rep
	ret
.L2:
	leal	(%rsi,%rdi), %eax
	ret

test2b:
	leal	(%rsi,%rdi), %edx
	movl	$37, %eax
	orl	%edi, %esi
	cmovne	%edx, %eax
	ret

	.ident	"GCC: (Debian 4.5.1-8) 4.5.1"


-Miles

-- 
Is it true that nothing can be known?  If so how do we know this?  -Woody Allen
