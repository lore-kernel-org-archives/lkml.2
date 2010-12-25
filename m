Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab0LYHuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 02:50:39 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:37367 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750865Ab0LYHui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 02:50:38 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+gwEAOMT6gSGUUjvnbcKweD/Rm8zXXLFWKkqPBfQ
	zkKR25o73ylN2P
Subject: Re: [PATCH] sched: Buggy comparison in check_preempt_tick
From: Mike Galbraith <efault@gmx.de>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Ranjit Manomohan <ranjitm@google.com>
In-Reply-To: <1293236813-31550-1-git-send-email-venki@google.com>
References: <1293236813-31550-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 25 Dec 2010 08:50:18 +0100
Message-ID: <1293263418.6896.54.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-24 at 16:26 -0800, Venkatesh Pallipadi wrote:
> A preempt comparison line in check_preempt_tick has two bugs.
> * It compares signed and unsigned quantities, which breaks when signed
>   quantity happens to be negative

Oops, that's a bug.

> * It compares runtime and vruntime, which breaks when there are niced tasks

This imho isn't.

vruntimes advance at different rates for differently weighted tasks, so
they're already weighted, as is ideal_runtime.

For wakeup preemption we use wakeup_gran() as the weighted ruler to
limit spread.  This test just uses a different weighted ruler for the
same purpose at tick time, one already computed.

If you're a heavily niced task, you were very likely booted before you
got this far.  If you haven't run for considerable wall time, you won't
get further, you keep on running.  You only get booted if giving you a
full wall slice will spread vruntimes too much, for which you'll pay if
you keep running, and leftmost will pay now if we don't boot you.

	-Mike

