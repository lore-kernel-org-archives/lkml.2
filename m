Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab1AQKuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 05:50:10 -0500
Received: from cantor.suse.de ([195.135.220.2]:49460 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641Ab1AQKuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 05:50:07 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: David Ahern <daahern@cisco.com>
Subject: Re: perf timechart broken
Date: Mon, 17 Jan 2011 11:50:04 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-18-desktop; KDE/4.5.3; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-perf-users@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <201101071104.37576.trenn@suse.de> <201101141800.18913.trenn@suse.de> <4D308331.6010106@cisco.com>
In-Reply-To: <4D308331.6010106@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101171150.05444.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 January 2011 18:09:05 David Ahern wrote:
> 
> On 01/14/11 10:00, Thomas Renninger wrote:
> >> http://www.mail-archive.com/linux-perf-
> > users@vger.kernel.org/msg00057.html
> > Looks slightly different, the segfault should happen in:
> > process_sample_event
> > But looks very much related, possibly it has not been made/make with 
> > DEBUG=1
> > and -O6 was added and the backtrace is not 100% correct?
> 
> perf was built with DEBUG=1; that's how I got the pretty backtrace
> versus having the arguments optimized out. The cpu=6291457 is the
> garbage causing the segfault
Then it's the same issue.

> (there are only 2 cores in the system).
> 6291457 = 0x600001. Perhaps a mask is missing?
No, the power_start and power_end event have different kernel
structures, but in builtin-timechart.c the same struct is used.
cpu is at the end.
Therefore pe->cpu_id (in power_end case) accesses uninitialized
data.

But using the cpu data from the event itself (data.cpu, the cpu on
which the event got emited) for fixing this is fine.
It's the way it was done before the bug got introduced.
As said, this won't work if the kernel code triggering the C-state
is executed on a different CPU than the CPU which is affected by
the C-state change. But such HW does not yet exist on X86 afaik and the
power_start event dies out anyway.

I resubmitted the fix for 2.6.3{6,7} stable kernels and added you
to CC.

   Thomas
