Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab1ASPKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 10:10:08 -0500
Received: from mail.openrapids.net ([64.15.138.104]:36878 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753957Ab1ASPKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 10:10:06 -0500
Date: Wed, 19 Jan 2011 10:10:04 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Miller <davem@davemloft.net>
Cc: rostedt@goodmis.org, richm@oldelvet.org.uk, 609371@bugs.debian.org,
        ben@decadent.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
	Unknown relocation: 36
Message-ID: <20110119151004.GA11022@Krystal>
References: <20110118201323.GA14930@Krystal> <1295382144.12215.123.camel@gandalf.stny.rr.com> <20110119050844.GA8776@Krystal> <20110118.211639.68142725.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110118.211639.68142725.davem@davemloft.net>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:05:27 up 56 days, 20:08,  5 users,  load average: 0.02, 0.08,
	0.07
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller (davem@davemloft.net) wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Date: Wed, 19 Jan 2011 00:08:45 -0500
> 
> > The following works fine for me now. Comments are welcome.
> 
> Thanks for doing this work Mathieu.
> 
> > - No aligned() type attribute nor variable attribute. I get a crash on x86_64
> >   (NULL pointer exception when executing __trace_add_event_call, the 5th call).
> >   __alignof__(struct ftrace_event_call) is worth 8.
> 
> This is really bizarre.  Does it only happen on x86_64?

Sadly, my ppc32 test machine is currently broken, so I could not check on other
than x86 archs.

> I'm wondering if GCC does something bizarre like work with different
> default alignments based upon the section or something like that.
> 
> If so, maybe adding the section attribute to the array definition will
> "fix" things?

Well, I thought about it in my sleep, and it looks like gcc is within its rights
to align these statically declared structures on a larger alignment: gcc has no
clue that we're going to do tricks with the linker to access the structures as
an array, so aligning on a larger alignment *should* be fine for the compiler,
but we suffer because we're doing something non-standard.

> 
> > On 32-bit architectures, we really want a aligned(4), and on 64-bit
> > architectures, aligned(8). Represent this by creating:
> > 
> > #define __long_aligned __attribute__((__aligned__(__alignof__(long))))
> 
> Do any of these datastructures have, or will have, "u64" or "long
> long" types in them?  If so, then we will need to use "8"
> unconditionally or "__alignof__(long long)".

If my memory serves me correctly, I think "long long" is aligned on 4 bytes on
ppc32, but on 8 bytes on x86_32 (yeah, that's weird). How about we create a
#define __long_long_aligned __attribute__((__aligned__(__alignof__(long long))))

?

Thanks,

Mathieu

> 
> I'll see if I can work out why using no align directive explodes
> on x86-64.

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
