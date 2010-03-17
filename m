Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab0CQKUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 06:20:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:44796 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753757Ab0CQKUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 06:20:11 -0400
Subject: Re: 64-syscall args on 32-bit vs syscall()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: Ulrich Drepper <drepper@redhat.com>, munroesj@us.ibm.com,
       "H. Peter Anvin" <hpa@zytor.com>, David Miller <davem@davemloft.net>,
       ralf@linux-mips.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel@teksavvy.com,
       torvalds@linux-foundation.org
In-Reply-To: <20100317091820.GA8149@shareable.org>
References: <20100315134449.GB1653@linux-mips.org>
	 <4B9E4EB1.9010800@zytor.com> <4B9E59B7.6060405@redhat.com>
	 <20100315.120004.209998642.davem@davemloft.net>
	 <4B9E8D67.8040209@zytor.com> <1268685311.2335.38.camel@pasglop>
	 <1268776570.19726.98.camel@spokane1.rchland.ibm.com>
	 <1268785874.2335.137.camel@pasglop> <4BA06E1B.2040706@redhat.com>
	 <1268816179.2335.187.camel@pasglop>  <20100317091820.GA8149@shareable.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 21:18:58 +1100
Message-ID: <1268821138.2335.196.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-17 at 09:18 +0000, Jamie Lokier wrote:
> Benjamin Herrenschmidt wrote:
> > Hence, apps that use the first form today because it works on x86 would
> > end up working at least on powerpc where they would have been otherwise
> > broken unless they used some arch specific #ifdef to do the second form.
> 
> I think what Ulrich is getting at is your change will break existing
> code which already does:
> 
> #ifdef __powerpc__
> 	syscall(SYS_foo, 0, my_64bit_arg);
> #else
> 	syscall(SYS_foo, my_64bit_arg);
> #endif
> 
> I don't know of any such code, but it might be out there.

No, the above "workaround" doesn't work. With the existing syscall()
definition, there is no difference between your two examples. In the
first case, you force a proper 64-bit aligment, but you are already off
by one register pair from the kernel expectation. In the second case,
gcc will imply one, which means that both your examples above will
result in my_64bit_arg in the -same- place, which is off by a register
pair from what the kernel expect.

IE. In the first case gcc will put SYS_foo in r3, 0 in r4, and
my_64bit_arg in r5 and r6. In the second case, gcc will put SYS_foo in
r3, won't care about r4, and will put the 64-bit arg in r5 and r6. Then,
glibc syscall() will shift r3 to r0, r3 to r4 etc... causing
my_64bit_arg to land in r4 and r5. But the kernel expects it in r3 and
r4.

The workaround that apps should use today is:

#if defined(__powerpc__) && WORDSIZE == 32
	syscall(SYS_foo, (u32)(my_64bit_arg >> 32), (u32)my_64bit_arg);
#else
	syscall(SYS_foo, my_64bit_arg);
#endif

And with my proposed change, both of the above will work. IE. gcc will
put the argument always in r5,r6 and the syscall() implementation will
always shift r5 to r3 and t6 to r4. 

Cheers,
Ben.


