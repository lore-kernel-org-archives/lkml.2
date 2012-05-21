Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab2EUPgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:36:32 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64166 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab2EUPga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:36:30 -0400
MIME-Version: 1.0
In-Reply-To: <20120521145904.GA7068@gmail.com>
References: <20120518102640.GB31517@dhcp-26-207.brq.redhat.com>
 <20120521082240.GA31407@gmail.com> <20120521093648.GC28930@dhcp-26-207.brq.redhat.com>
 <20120521124025.GC17065@gmail.com> <20120521144812.GD28930@dhcp-26-207.brq.redhat.com>
 <20120521145904.GA7068@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 May 2012 08:36:09 -0700
X-Google-Sender-Auth: sOxXnCgju0zDpuLEA7k3VB6rxHY
Message-ID: <CA+55aFxJxfx+OfDiATCCPojVAPew_Hy+2=jx9g4=2_WRvixBFw@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86: x2apic/cluster: Make use of lowest priority
 delivery mode
To: Ingo Molnar <mingo@kernel.org>
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 7:59 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> For example we don't execute tasks for 100 usecs on one CPU,
> then jump to another CPU and execute 100 usecs there, then to
> yet another CPU to create an 'absolutely balanced use of CPU
> resources'. Why? Because the cache-misses would be killing us.

That is likely generally not true within a single socket, though.

Interrupt handlers will basically never hit in the L1 anyway (*maybe*
it happens if the CPU is totally idle, but quite frankly, I doubt it).
Even the L2 is likely not large enough to have much cache across irqs,
unless it's one of the big Core 2 L2's that are largely shared per
socket anyway.

So it may well make perfect sense to allow a mask of CPU's for
interrupt delivery, but just make sure that the mask all points to
CPU's on the same socket. That would give the hardware some leeway in
choosing the actual core - it's very possible that hardware could
avoid cores that are running with irq's disabled (possibly improving
latecy) or even more likely - avoid cores that are in deeper
powersaving modes.

Avoiding waking up CPU's that are in C6 would not only help latency,
it would help power use. I don't know how well the irq handling
actually works on a hw level, but that's exactly the kind of thing I
would expect HW to do well (and sw would do badly, because the
latencies for things like CPU power states are low enough that trying
to do SW irq balancing at that level is entirely and completely
idiotic).

So I do think that we should aim for *allowing* hardware to do these
kinds of choices for us. Limiting irq delivery to a particular core is
very limiting for very little gain (almost no cache benefits), but
limiting it to a particular socket could certainly be a valid thing.
You might want to limit it to a particular socket anyway, just because
the hardware itself may well be closer to one socket (coming off the
PCIe lanes of that particular socket) than anything else.

                          Linus
