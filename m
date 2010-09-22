Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab0IVSrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 14:47:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104Ab0IVSro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 14:47:44 -0400
MIME-Version: 1.0
In-Reply-To: <20100922183200.GC19804@ZenIV.linux.org.uk>
References: <20100922.111019.200357319.davem@davemloft.net> <20100922183200.GC19804@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Sep 2010 11:46:27 -0700
Message-ID: <AANLkTi=DWk2_=wMqcM1jgJEuNRj_ni2OkM3osYCUg57Y@mail.gmail.com>
Subject: Re: [GIT] Sparc
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 11:32 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> That has unpleasant results - for starters, delivery of SIGSEGV upon
> failure to set sigframe up is delayed unpredictably; we will take it
> only when we trap again.

I think this whole argument is a total red herring.

It's a bug in next_signal() if we allow this to happen. We need to
enqueue those synchronous signals first, and NO AMOUNT OF SIGNAL
QUEUEING will ever change that.

The fact is, even if you queue up all the signals at once, you need to
queue up the synchronous ones first. Otherwise their instruction
pointer information etc will simply be bogus. It's that simple. Your
argument about queuing up one, two, or more signals is bogus, for the
simple reason that it doesn't matter: whether you queue or not is
irrelevant, since the "innermost" one in the queue always has to be
the SIGSEGV.

Whether we queue other signals on top of that (and they get executed
first, since it's a stack) doesn't matter. That's a timing issue, and
the program acts as if those asynchronous signals happened before the
trap. But that's fine. All that matters is that the actual synchronous
signal has the register contents of the time of the synchronous trap,
ie it gets enqueued first.

It's why we have that "if (x & SYNCHRONOUS_MASK)" in next_signal().
It's not pretty, it's not perfect, but it's required.

                  Linus
