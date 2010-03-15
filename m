Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936708Ab0COUXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 16:23:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:42382 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936679Ab0COUXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 16:23:19 -0400
Subject: Re: 64-syscall args on 32-bit vs syscall()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel@teksavvy.com, drepper@redhat.com, torvalds@linux-foundation.org,
       munroesj@linux.vnet.ibm.com
In-Reply-To: <20100314.225443.150715656.davem@davemloft.net>
References: <1268628493.2355.2.camel@pasglop>
	 <20100314.220646.190065794.davem@davemloft.net>
	 <1268630313.2335.2.camel@pasglop>
	 <20100314.225443.150715656.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 07:22:19 +1100
Message-ID: <1268684539.2335.22.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-14 at 22:54 -0700, David Miller wrote:
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Mon, 15 Mar 2010 16:18:33 +1100
> 
> > Or is there any good reason -not- to do that in glibc ?
> 
> The whole point of syscall() is to handle cases where the C library
> doesn't know about the system call yet.
> 
> I think it's therefore very much "buyer beware".
> 
> On sparc it'll never work to use the workaround you're proposing since
> we pass everything in via registers.
> 
> So arch knowledge will always need to be present in these situations.

I'm not sure I follow. We also pass via register on powerpc, but the
offset introduced by the sysno argument breaks register pair alignment
which cannot be fixed up inside syscall().

However, if I change glibc's syscall to be something like

#define syscall(sysno, args...)	__syscall(0 /* dummy */, sysno, args)

And make __syscall then do something like:

	mr	r0, r4
	mr	r3, r5
	mr	r4, r6
	mr	r5, r7
	mr	r6, r8
	.../...
	sc
	blr

Then at least all that class of syscalls will be fixed. Of course this
has to be in glibc arch code. I was merely asking if that was something
our glibc folks would consider and whether somebody could think of a
better solution :-)

Cheers
,Ben.


