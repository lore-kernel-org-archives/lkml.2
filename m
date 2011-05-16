Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab1EPRj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 13:39:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52315 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab1EPRj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 13:39:58 -0400
Date: Mon, 16 May 2011 19:39:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Steve Munroe <sjmunroe@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
        libc-alpha@sourceware.org, linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH 4/5] Add a sysconf syscall
Message-ID: <20110516173956.GE25898@one.firstfloor.org>
References: <1305329059-2017-1-git-send-email-andi@firstfloor.org> <1305329059-2017-5-git-send-email-andi@firstfloor.org> <BANLkTikP==HkDSG1oKcfSKAhrWOXRqGF5w@mail.gmail.com> <20110516160114.GA25898@one.firstfloor.org> <OF30360F87.5C6D6DCF-ON86257892.005D7E68-86257892.005E0059@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF30360F87.5C6D6DCF-ON86257892.005D7E68-86257892.005E0059@us.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 12:06:40PM -0500, Steve Munroe wrote:
d  Seems like the Aux Vector would do job. Simple, in memory, LIBC already



It's difficult to update the aux vector dynamically after the program has
started.  Applications in theory could reuse it for something else, so it 
wouldn't be safe to poke in there (and quite complex too)

One of the main motivations for the new call was _SC_NPROCESSORS_ONLN,
which can change dynamically.

So if we put that into the aux vector the program would only ever know about
the CPUs online at startup time. Not good.

> fills in some sysconf values from the auxv and has infrastructure for that.
> And the perform conscious hacker can access the auxv directly if they want.

rlimits are not static and the they don't map to clone semantics (see all the
other mails on this) Various values are based on rlimits.

vsyscalls would work for the online CPUs, but not for a lot of other things.

I suppose if this was just to solve the online cpu case it may be a suitable 
solution, but I tried to be a bit more general.

Here's a handy reference table:

                            vdso            aux            syscall
constant values               x               x                x         
rlimit based values           -*              -                x 
runtime values like cpus      x               -                x
portable to all archs         -               x                x
performance                  best            best            good enough
coding complexity            high            low               low


* unless you break clone and add a writable page to each program and be complex

So you can see the aux vector is not doing very well overall.
The vdso is somewhat better, but only if you sacrify the rlimits
and accept high complexity.

The syscall is imho still the sweet spot overall. It's excellent 
everywhere, except it doesn't have the best performance. But it seems
good enough.

-Andi
