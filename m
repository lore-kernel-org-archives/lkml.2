Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab0CRP7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 11:59:05 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52845 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab0CRP67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 11:58:59 -0400
Subject: Re: 64-syscall args on 32-bit vs syscall()
From: Steven Munroe <munroesj@linux.vnet.ibm.com>
Reply-To: munroesj@us.ibm.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ulrich Drepper <drepper@redhat.com>,
       munroesj@us.ibm.com, David Miller <davem@davemloft.net>,
       ralf@linux-mips.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel@teksavvy.com,
       torvalds@linux-foundation.org
In-Reply-To: <1268866720.2335.204.camel@pasglop>
References: <20100315134449.GB1653@linux-mips.org>
	 <4B9E4EB1.9010800@zytor.com>	<4B9E59B7.6060405@redhat.com>
	 <20100315.120004.209998642.davem@davemloft.net>
	 <4B9E8D67.8040209@zytor.com> <1268685311.2335.38.camel@pasglop>
	 <1268776570.19726.98.camel@spokane1.rchland.ibm.com>
	 <1268785874.2335.137.camel@pasglop>  <4BA06E1B.2040706@redhat.com>
	 <1268816179.2335.187.camel@pasglop>  <4BA11FD2.2090104@zytor.com>
	 <1268858134.2335.198.camel@pasglop>  <4BA1412C.6070008@zytor.com>
	 <1268866720.2335.204.camel@pasglop>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Thu, 18 Mar 2010 11:08:00 -0500
Message-Id: <1268928480.19726.123.camel@spokane1.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-18 at 09:58 +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2010-03-17 at 13:53 -0700, H. Peter Anvin wrote:
> > > Yeah, whatever, I don't mind what technique you use for the
> > versionning,
> > > ultimately, if the approach works, we can look at those details :-)
> > We
> > > -do- need the macro to strip the dummy argument though, unless we
> > use
> > > a slightly different technique which is to make the __sysno argument
> > > itself 64-bit, which works as well I believe.
> > >
> > 
> > It seems cleaner to do it that way (with a 64-bit sysno arg.) 
> 
> Right. Now if we can get Ulrich to actually put 2 and 2 together and
> admit that it actually works without breaking anything existing (at
> least for my arch but I wouldn't be surprised if that was the case for
> others), I would be even happier :-)
> 
> Steve, any chance you can cook up a glibc patch to test with ? Maybe
> making it powerpc specific for now ?
> 

Do what declare __sysno as long long? The current prototype is in
unistd.h:

#ifdef __USE_MISC
/* Invoke `system call' number SYSNO, passing it the remaining
arguments.
   This is completely system-dependent, and not often useful.

   In Unix, `syscall' sets `errno' for all errors and most calls return
-1
   for errors; in many systems you cannot pass arguments or get return
   values for all system calls (`pipe', `fork', and `getppid' typically
   among them).

   In Mach, all system calls take normal arguments and always return an
   error code (zero for success).  */
extern long int syscall (long int __sysno, ...) __THROW;

#endif	/* Use misc.  */

Changing this would be an ABI change and would have to be versioned. It
would effect any one using syscall not just SYS_fallocate.

the question is do programmers in practice include unistd.h when they
use syscall.

If the changed prototype is not in scope then the 1st parm (__sysno)
defaults to int and is passed in on r3 which gets moved to r0.

If the changed syscall prototype is in scope then then _sysno would be
passed in r3/r4 (r3 would be 0 would be passed to r0 and the actual
system number would be in r4 and passed to the kernel in r3)

which behavior do you want? which (incorrect behavior compiled into
existing codes do you want to support?

Do you want syscall.S for PPC32 to change to match the changed
prototype? It will have to be be versioned and the new prototype will
only be available in future releases of GLIBC. Existing applications
will bind to the old ABI and get the old behavior.

