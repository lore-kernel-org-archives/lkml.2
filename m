Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031380Ab2COA2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 20:28:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:37902 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031226Ab2COA2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 20:28:43 -0400
Date: Thu, 15 Mar 2012 01:28:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        Carsten Emde <C.Emde@osadl.org>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [REGRESSION][PATCH] mqueue: Ignore the validity of abs_timeout
 parameter when message can be performed immediately
In-Reply-To: <alpine.LFD.2.02.1203142250500.2466@ionos>
Message-ID: <alpine.LFD.2.02.1203150056361.2466@ionos>
References: <20120302164234.4938.38390934@jp.panasonic.com> <20120314144601.ccc50a68.akpm@linux-foundation.org> <alpine.LFD.2.02.1203142250500.2466@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2012, Thomas Gleixner wrote:
> On Wed, 14 Mar 2012, Andrew Morton wrote:
> 
> > On Fri, 02 Mar 2012 16:42:35 +0900
> > Akira Takeuchi <takeuchi.akr@jp.panasonic.com> wrote:
> > 
> > > This patch fixes up the regression problem of mq_timed{send,receive} syscall.
> > > 
> > > When a message of mqueue can be performed immediately,
> > > the validity of abs_timeout parameter should not be checked.
> > > 
> > > According to the manpage of mq_timedreceive:
> > >     Under no circumstance shall the operation fail with a timeout
> > >     if a message can be removed from the message queue immediately.
> > >     The validity of the abstime parameter need not be checked
> > >     if a message can be removed from the message queue immediately.
> 
> Those POSIX spec folks definitely have a seriously distorted
> relationship to timers and timekeeping.
> 
> So the caller knows upfront when he needs to provide a valid timespec
> and when not. So the users of mq_.... are into crystal ball
> programming or what?

Thinking more about it. The manpage according to

  git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git

does not mention that insanity at all.

So what the patch is referring to is the POSIX spec:

   http://pubs.opengroup.org/onlinepubs/009604499/functions/mq_timedsend.html
   http://pubs.opengroup.org/onlinepubs/009604499/functions/mq_timedreceive.html

Aside of my previous ranting about the insanity of that, the following
is actually open for interpretation:

 "The validity of the abstime parameter need not be checked if a
  message can be removed from the message queue immediately."

It's not necessary to check the validity of the abstime parameter, but
the spec does not forbid it either.

So for the sake of sanity we rather fix that test case and keep the
code as is. There haven't been regression reports from real world
applications within 2 years, so there is no point to add more
convolution to the mqueue code just to satisfy a random interpretation
of the spec by a test suite.

Again, there is no point to interpret it as "avoid the check" simply
because user space cannot know whether there is room to queue or
whether there is a message waiting. So requiring a valid timespec is
always the Right Thing to do.

Thanks,

	tglx
