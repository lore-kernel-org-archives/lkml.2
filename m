Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759702Ab2IFT6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 15:58:23 -0400
Received: from [216.32.181.184] ([216.32.181.184]:25571 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759593Ab2IFT6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 15:58:22 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(zzbb2dI98dI9371I103dK1432Izz1202hzz8275bh8275dhz2dh668h839h944hd25hf0ah11b5h121eh1220h1155h)
X-WSS-ID: 0M9Y22N-02-12X-02
X-M-MSG: 
Date: Thu, 6 Sep 2012 21:56:45 +0200
From: Robert Richter <robert.richter@amd.com>
To: David Ahern <dsahern@gmail.com>
CC: <acme@ghostprotocols.net>, <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 08/11] perf tool: precise mode requires exclude_guest
Message-ID: <20120906195645.GD8285@erda.amd.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
 <1342826756-64663-9-git-send-email-dsahern@gmail.com>
 <20120906190238.GA29278@erda.amd.com>
 <5048F6BF.70106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5048F6BF.70106@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.09.12 13:17:19, David Ahern wrote:
> On 9/6/12 1:02 PM, Robert Richter wrote:
> > just found your patch...

I tested the patch and it runs ok with my kernel patch that checks
syscall attributes for ibs. perf tools falls back and clears
exclude_guest/_host bits in attr. It also should work if the kernel
ignores those bits (without my patch).

Acked-by: Robert Richter <robert.richter@amd.com>

> > To summarize how I think it should work:
> >
> >   -e cycles:p ..... Enable exclude_guest bit. If the syscall fails,
> >                     fall back by disabling the guest bit and send
> >                     syscall again
> 
> I think the fallback scenarios are getting out of hand -- too many and 
> too many combinations. For this case (:p only) I proposed setting 
> exclude_guest. It should not fail if the pebs/ibs is supported. If so, 
> give the user a helpful message. e.g., https://lkml.org/lkml/2012/7/20/440
> 
> 
> >
> >   -e cycles:pGH ... Do not enable exclude_guest/_host. Do not fall back
> >                     on syscall errors.
> 
> In this case give the user a message that the requested combination is 
> invalid. I have a patch similar to the one above for this.

Yes, but cases where only guest or host-only mode is supported are
rare.

> 
> >
> > Same for the case the p modifier is not set.
> >
> > So we have the following:
> >
> >   G           ... set exclude_host bit, clear exclude_guest
> >   H           ... set exclude_guest bit, clear exclude_host
> >   GH          ... clear both exclude_guest/_host
> >   <no G or H> ... default (set exclude_host bit, clear exclude_guest),
> >                   but fall back on syscall errors to clear both
> >                   exclude_guest/_host
> 
> you lost me on the last one. If the user specifies no attributes on the 
> events then exclude_host/exclude_guest is controlled by the 
> perf_host/perf_guest variables - see event_attr_init().

As you said above, falling back by disabling flags becomes unhandy.
Current implementation falls back without (?) notice even if the user
explicitly demanded G or H. Falling back should only be the case if no
G/H modifiers are given. This is what I meant here.

> > The modifier parser should be correctly implemented and should work
> > with ibs. Will test this patch.
> 
> Thanks!

Sorry far being late a bit with all this.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

