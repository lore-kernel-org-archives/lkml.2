Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab1ITJv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 05:51:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:33741 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560Ab1ITJvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 05:51:55 -0400
Date: Tue, 20 Sep 2011 11:51:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] posix-timers: move global timer id management to
 signal_struct v4
In-Reply-To: <1316472096.2455.27.camel@edumazet-laptop>
Message-ID: <alpine.LFD.2.02.1109201121340.2723@ionos>
References: <1316468925-16754-1-git-send-email-andi@firstfloor.org>  <1316471007.2455.24.camel@edumazet-laptop>  <20110919223649.GO7761@one.firstfloor.org> <1316472096.2455.27.camel@edumazet-laptop>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1500424232-1316512312=:2723"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1500424232-1316512312=:2723
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 20 Sep 2011, Eric Dumazet wrote:

> Le mardi 20 septembre 2011 à 00:36 +0200, Andi Kleen a écrit :
> > > This means idr_pre_get() consumes 6528 bytes of spare space per process,
> > > even if only one posix timer is used.
> > 
> > And? Given the now normal bloat level in the kernel that's small
> > potatoes.

That's not really a good excuse to create more bloat without spending
a few brain cycles.

> I see. Oh yes, you work for a known hardware vendor.

LOL

Aside of that this patch already adds sizeof(idr) + sizeof(mutex) to
every signal_struct unconditionally. There is no reason to do that. We
simply can have a pointer to

struct posix_timer_idr {
	struct mutex lock;
	struct idr idr;
};

and allocate that when a process creates the first posix timer.

Thinking more about that the question arises whether the global idr is
in fact a real scalability issue. The number of posix timers actually
used is usually pretty low and I doubt that they are created/deleted
with high frequency.

If it's just about limiting the per process posix timer allocation we
can achieve the same goal with a simple per process counter which
holds the number of allocated timers.

Thanks,

	tglx
--8323328-1500424232-1316512312=:2723--
