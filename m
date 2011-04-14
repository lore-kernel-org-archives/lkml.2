Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432Ab1DNT4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 15:56:31 -0400
Received: from col0-omc3-s2.col0.hotmail.com ([65.55.34.140]:65469 "EHLO
	col0-omc3-s2.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755381Ab1DNT4a convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 15:56:30 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Apr 2011 15:56:30 EDT
Message-ID: <COL101-W165ED5CB17434202CE273DE2AD0@phx.gbl>
X-Originating-IP: [71.105.174.211]
From: James McMechan <james_mcmechan@hotmail.com>
To: <richard@nod.at>, <mikpe@it.uu.se>
CC: <linux-kernel@vger.kernel.org>,
        uml devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: RE: [uml-devel] gcc-4.6.0 generates no code for sub_preempt_count()
Date: Thu, 14 Apr 2011 19:50:13 +0000
Importance: Normal
In-Reply-To: <201104141552.42213.richard@nod.at>
References: <201104132150.05623.richard@nod.at>,<19878.42746.60978.537126@pilspetsen.it.uu.se>,<201104141552.42213.richard@nod.at>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 14 Apr 2011 19:50:14.0427 (UTC) FILETIME=[2C11C6B0:01CBFADD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Am Donnerstag 14 April 2011, 09:49:14 schrieb Mikael Pettersson:
> > Richard Weinberger writes:
> > > Hi,
> > >
> > > I'm facing a very strange issue with gcc-4.6.0 and UML.
> > > Within __local_bh_enable() gcc generates no code for
> > > sub_preempt_count().
> > >
> > > See:
> > > http://userweb.kernel.org/~rw/uml-gcc460/__local_bh_enable-gcc460.txt
> > > vs.
> > > http://userweb.kernel.org/~rw/uml-gcc460/__local_bh_enable-gcc431.txt
> > >
> > > Interestingly it generates code for add_preempt_count().
> > > I can reproduce this on x86 and x86_64.
> > >
> > > The problem has to do with UML's current_thread_info() function.
> > > When I replace it with arch/x86's (unportable) variant gcc generates
> > > code.
> > >
> > > Any ideas whether this is a gcc or a kernel issue?

It looks like a gcc error with one of the optimization passes

> > Please provide a standalone test case.
>
> There you go!
> http://userweb.kernel.org/~rw/uml-gcc460/testcase.c

Replacing inline with __attribute__((noinline)) makes it produce code again

without requiring asm("esp")/asm("rsp") tricks and the code appears to be working

I think gcc is assuming only low bits in the address of stack vars and thought they

were all masked out :( with this change my test version of gcc-4.6.0 works for x86/amd64

I have not yet gotten 4.6.0 to install yet so I was testing with xgcc from the failed build


--- testcase.orig       2011-04-14 08:34:24.000000000 -0700

+++ testcase.c  2011-04-14 12:17:44.000000000 -0700

@@ -31,7 +31,7 @@

 }

 #else

 /* UML */

-static inline struct thread_info *current_thread_info(void)

+static __attribute__((noinline)) struct thread_info *current_thread_info(void)

 {

   struct thread_info *ti;

   unsigned long mask = THREAD_SIZE - 1;>

> Thanks,
> //richard

 		 	   		  