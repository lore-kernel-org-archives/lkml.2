Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab2DQITk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 04:19:40 -0400
Received: from ocelot.phlegethon.org ([81.29.64.94]:54476 "EHLO
	mail.phlegethon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab2DQITg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 04:19:36 -0400
Date: Tue, 17 Apr 2012 09:19:28 +0100
From: Tim Deegan <tim@xen.org>
To: Sheng Yang <sheng@yasker.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Jan Beulich <JBeulich@suse.com>, Konrad Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, xen-devel <xen-devel@lists.xen.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH] xen: always set the sched clock as unstable
Message-ID: <20120417081928.GA29964@ocelot.phlegethon.org>
References: <1334341255-11153-1-git-send-email-david.vrabel@citrix.com> <4F8C1F6D020000780007E11A@nat28.tlf.novell.com> <4F8C33E0.2080007@citrix.com> <049b7b93-fb37-4962-b272-d786e1dcfacb@default> <20120416170827.GE13111@ocelot.phlegethon.org> <3e05ae0e-afe4-4ed7-b839-39a343cc0d06@default> <20120416181744.GF13111@ocelot.phlegethon.org> <CA+2rt41pCFV1haMAHo63rY9kx88VgiV419pf8Y=u2cXrdmGOBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CA+2rt41pCFV1haMAHo63rY9kx88VgiV419pf8Y=u2cXrdmGOBA@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 16:01 -0700 on 16 Apr (1334592096), Sheng Yang wrote:
> So I think there are maybe *two* bugs in this issue, one caused time
> jump(detail below), the other in the kernel triggered by the first bug
> sometime, thus result in migration fail.
> 
> I've spent some time to identify the timestamp jump issue, and finally
> found it's due to Invarient TSC (CPUID Leaf 0x80000007 EDX:8, also
> called non-stop TSC). The present of the feature would enable a
> parameter in the kernel named: sched_clock_stable. Seems this
> parameter is unable to work with Xen's pvclock. If
> sched_clock_stable() is set, value returned by xen_clocksource_read()
> would be returned as sched_clock_cpu() directly(rather than calculated
> through sched_clock_local()), but CMIIW the value returned by
> xen_clocksource_read() is based on host(vcpu) uptime rather than this
> VM's uptime, then result in the timestamp jump.

OK - that seems like a kernel bug.  Linux should not be modifying how it
treats the PV clocksource based on the 'Invariant TSC' bit.
(Conversely, the patch to pretend the TSC is not invariant just because
the PV clocksource is present also seems wrong, and the earlier patch
that just enforces sched_clock_stable=0 would be better.)

> I've compiled a kernel, force sched_clock_stable=0, then it solved the
> timestamp jump issue as expected. Luckily, seems it also solved the
> call trace and guest hang issue as well.
> 
> I've posted a patch to mask the CPUID leaf 0x80000007 in Xen.

Well, as Dan says, if Xen is emulating RDTSC to provide a 'stable' TSC, 
we shouldn't _also_ tell the guest that it's not stable. :)  

OTOH, grepping for CONSTANT_TSC, NONSTOP_TSC, and TSC_RELIABLE, I don't
see anywhere even in xen-unstable where these bits are ever hidden from
the guest.  I think it would be reasonable to mask this from PV guests
at least for tsc_mode == 2, and on older Xens.

Tim.
