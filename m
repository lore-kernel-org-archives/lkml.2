Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab2CFRcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 12:32:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:46128 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab2CFRca convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 12:32:30 -0500
Message-ID: <1331055135.11248.325.camel@twins>
Subject: Re: [PATCH -tip v5 2/5] perf: set correct value to
 perf_event_header.misc for BTS
From: Peter Zijlstra <peterz@infradead.org>
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Date: Tue, 06 Mar 2012 18:32:15 +0100
In-Reply-To: <4F432E0B.5090608@hitachi.com>
References: <20120130044242.2384.23076.stgit@linux3>
	  <20120130044303.2384.63515.stgit@linux3> <1327916138.2446.187.camel@twins>
	 <4F432E0B.5090608@hitachi.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-21 at 14:39 +0900, Akihiro Nagai wrote:
> (2012/01/30 18:35), Peter Zijlstra wrote:
> > On Mon, 2012-01-30 at 13:43 +0900, Akihiro Nagai wrote:
> >> @@ -330,6 +342,14 @@ int intel_pmu_drain_bts_buffer(void)
> >>                  return 1;
> >>
> >>          for (; at<  top; at++) {
> >> +               /*
> >> +                * To resolve user space symbols and DSOs correctly, set
> >> +                * PERF_RECORD_MISC_USER if from_addr or to_addr is user space.
> >> +                */
> >> +               if (!kernel_ip(data.ip) || !kernel_ip(data.addr)) {
> >> +                       header.misc&= ~PERF_RECORD_MISC_CPUMODE_MASK;
> >> +                       header.misc |= PERF_RECORD_MISC_USER;
> >> +               }
> >>                  data.ip         = at->from;
> >>                  data.addr       = at->to;
> >
> > Why not key off of the from? If its a jump from userspace its a user
> > event, its a jump from kernel space its a kernel event?
> 
> Of course, originally, perf does that. 

I don't think it does.

> And, in those cases,
> BTS records the both addresses of kernel and user in one
> perf_sample on branches from kernel to user. 

Sorry, I don't get this.

> Current perf sets PERF_RECORD_MISC_KERNEL to all BTS events,

It doesn't, it does something far more stupid.. it sets the state to
wherever we were when the BTS overflow interrupt happens. If that was in
kernel space, we mark all of them as in-kernel, if that was in
user-space we mark all of then in-user.

>  and
> perf-script doesn't resolve symbols and DSOs about the
> user-space address, because it is a kernel event. 

Well, that's a perf-script problem, not something you should change the
kernel for.

So how about something like this?

---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c
b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index d6bd49f..81e788c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -333,6 +333,13 @@ int intel_pmu_drain_bts_buffer(void)
 		data.ip		= at->from;
 		data.addr	= at->to;
 
+		/* XXX doesn't do virt muck properly */
+		header.misc &= ~PERF_RECORD_MISC_CPUMODE_MASK;
+		if (kernel_ip(at->from))
+			header.misc |= PERF_RECORD_MISC_KERNEL;
+		else
+			header.misc |= PERF_RECORD_MISC_USER;
+
 		perf_output_sample(&handle, &header, &data, event);
 	}
 

