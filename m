Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab2LMRgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 12:36:25 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35153 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab2LMRgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 12:36:23 -0500
Date: Thu, 13 Dec 2012 18:36:17 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf changes for v3.8
Message-ID: <20121213173617.GB19444@gmail.com>
References: <50C94ECD.6020504@gmail.com>
 <CA+55aFzmsEbKCg=Qp0LGxQb-D+ZfBAELEa4HyUkuxkj6Z0-agA@mail.gmail.com>
 <50C95A21.1010101@gmail.com>
 <20121213073056.GA13156@gmail.com>
 <50C9E692.9070506@gmail.com>
 <CA+55aFzmDooC3tYzvP1YGv9g4ej1hBUQBPV6R+ukrfxuEELBaQ@mail.gmail.com>
 <50CA0134.2090608@gmail.com>
 <CA+55aFyZ2kAQPmZSv_sfHDAR1gusOxO22TRX-kqSim-cZrMscw@mail.gmail.com>
 <CA+55aFwSYyoLmdDJ5xsdwcWLThYQ7oieoeWDV2g+wV3CJk4vtg@mail.gmail.com>
 <50CA10C8.3020509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CA10C8.3020509@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 12/13/12 10:02 AM, Linus Torvalds wrote:
> 
> From your response to Ingo I take it you looked into other cases.
> I'll summarize here to make sure we are on the same page:
> 
> 1. guest only profiling from the host
> perf {record|top} -e cycles:G
> 
> 2. host only profiling
> perf {record|top} -e cycles:H
> 
> These are 4 existing use cases that toggle exclude_guest and do work
> today for those who care. Not the lack of precise attribute on the
> commands. These are the existing use cases that break by inverting
> the logic in the kernel.
> 
> The problem child is perf record -e cycles:ppG. [...]

The #1 problem child in this particular case, the one you should 
care about most is:

	perf record -e cycles:pp

As 99% of the people won't be doing any host or guest side 
profiling, they just want to do profiling.

The above G/H variants are the 1%.

So make sure the default works fine, that old binaries don't 
stop working - and then you can automatically (by default) 
exclude guest profiling if PEBS is enabled, and only ever reject 
profiling in the very specific case of:

	perf record -e cycles:ppG

where the user asks for something we don't support (yet).

So please stop thinking exclusively with a virtualization hat 
on, first think with a generic kernel developer hat on. Once all 
those cases work, make the virtualization case do the right 
thing as well.

We can fix all these cases properly and automatically, users 
don't need to specify flags they don't care about, old binaries 
will work and no VMs will crash.

Ok? So now we need a patch that does all that - otherwise we'll 
have to revert the one that added the regression.

Thanks,

	Ingo
