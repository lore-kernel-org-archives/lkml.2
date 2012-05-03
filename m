Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab2ECUDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 16:03:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57504 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab2ECUDI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 16:03:08 -0400
Message-ID: <1336075373.6509.9.camel@twins>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kay Sievers <kay@vrfy.org>, Greg Kroah-Hartmann <greg@kroah.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Date: Thu, 03 May 2012 22:02:53 +0200
In-Reply-To: <CA+55aFxhQ3SQrZJ6KGDu0xQ6sWSDxrS1C-V_fBcgCYmSqAKSWQ@mail.gmail.com>
References: <1336004953.4240.9.camel@mop> <1336074483.6509.3.camel@twins>
	 <CA+55aFxhQ3SQrZJ6KGDu0xQ6sWSDxrS1C-V_fBcgCYmSqAKSWQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 12:56 -0700, Linus Torvalds wrote:
> On Thu, May 3, 2012 at 12:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, 2012-05-03 at 02:29 +0200, Kay Sievers wrote:
> >> + * This is printk(). It can be called from any context. We want it to work.
> >
> > This is not true..
> 
> Well, it is very very nearly true, and people should basically expect it to be.
> 
> There are exceptions, but they are ridiculously specific
>  - no NMI context

With the new record design you could actually make the thing lockless
and allow writing to it from NMI context. IIRC vsnprintf() doesn't do
any allocations/locks.

>  - we've had trouble with the percpu runqueue lock (due to the stupid wakeup)

Yep :-(

>  - for similar reasons, we've had trouble with printk called from
> within some terminal locks.
> 
> But basically, it damn well should be considered a hard rule that you
> can printk from pretty much anything. The few cases where that is not
> true are big problems, and should be considered to be real problems,
> not "oh, you can't printk from here".

Thing is, with bonkers stuff like usb-console and kms/drm that's a _lot_
of code running under the logbuf/console locks.
