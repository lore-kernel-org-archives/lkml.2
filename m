Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761585Ab2CNWJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 18:09:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:37382 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761503Ab2CNWJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 18:09:00 -0400
Date: Wed, 14 Mar 2012 23:08:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        Carsten Emde <C.Emde@osadl.org>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [REGRESSION][PATCH] mqueue: Ignore the validity of abs_timeout
 parameter when message can be performed immediately
In-Reply-To: <20120314144601.ccc50a68.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.02.1203142250500.2466@ionos>
References: <20120302164234.4938.38390934@jp.panasonic.com> <20120314144601.ccc50a68.akpm@linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2012, Andrew Morton wrote:

> On Fri, 02 Mar 2012 16:42:35 +0900
> Akira Takeuchi <takeuchi.akr@jp.panasonic.com> wrote:
> 
> > This patch fixes up the regression problem of mq_timed{send,receive} syscall.
> > 
> > When a message of mqueue can be performed immediately,
> > the validity of abs_timeout parameter should not be checked.
> > 
> > According to the manpage of mq_timedreceive:
> >     Under no circumstance shall the operation fail with a timeout
> >     if a message can be removed from the message queue immediately.
> >     The validity of the abstime parameter need not be checked
> >     if a message can be removed from the message queue immediately.

Those POSIX spec folks definitely have a seriously distorted
relationship to timers and timekeeping.

So the caller knows upfront when he needs to provide a valid timespec
and when not. So the users of mq_.... are into crystal ball
programming or what?

> > On 2.6.35+ kernel, mq_timed{send,receive} returns EINVAL incorrectly,
> > in this situation.
> > 
> > I found this problem during the OPTS testcase
> > "conformance/interfaces/mq_timedreceive/10-2":
> > 
> >     # ./10-2.test
> >     FAIL: the validity of abs_timeout is checked
> >     Test FAILED
> 
> Are you able to identify the commit which caused this regression?  I'm
> guessing
> 
> commit 9ca7d8e6834c40a99622bbe4a88aaf64313ae43c
> Author:     Carsten Emde <C.Emde@osadl.org>
> AuthorDate: Fri Apr 2 22:40:20 2010 +0200
> Commit:     Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Tue Apr 6 21:50:03 2010 +0200
> 
>     mqueue: Convert message queue timeout to use hrtimers                       

Right, because nobody imagined that the specification would be as
asinine.

I'll pick it up and add a stable tag.

Sigh,

	tglx
