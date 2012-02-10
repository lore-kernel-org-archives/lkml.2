Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522Ab2BJDRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 22:17:44 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:59894 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab2BJDRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 22:17:43 -0500
Date: Thu, 9 Feb 2012 19:19:30 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Stephane Eranian <eranian@google.com>
Cc: Anton Blanchard <anton@samba.org>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, gleb@redhat.com,
        wcohen@redhat.com, vince@deater.net, asharma@fb.com,
        andi@firstfloor.org, paulus@samba.org, emunson@mgebm.net,
        imunsie@au1.ibm.com, benh@kernel.crashing.org
Subject: Re: [PATCH] perf_events: fix broken intr throttling (v3)
Message-ID: <20120210031930.GA28023@us.ibm.com>
References: <20120126160319.GA5655@quad>
 <20120208223250.282861cb@kryten>
 <CABPqkBRbvs3rHoCw9najObgUvfSCziVrR-U-UARWN3+St2=v8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRbvs3rHoCw9najObgUvfSCziVrR-U-UARWN3+St2=v8A@mail.gmail.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021003-2398-0000-0000-00000418E142
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian [eranian@google.com] wrote:
| On Wed, Feb 8, 2012 at 12:32 PM, Anton Blanchard <anton@samba.org> wrote:
| >
| > Hi,
| >
| > On Thu, 26 Jan 2012 17:03:19 +0100
| > Stephane Eranian <eranian@google.com> wrote:
| >
| >> This patch fixes the throttling mechanism. It was broken
| >> in 3.2.0. Events were not being unthrottled. The unthrottling
| >> mechanism required that events be checked at each timer tick.
| >
| > This patch breaks perf on POWER. I haven't had a chance to work out why
| > yet, but will investigate tomorrow.
| >
| Did you apply the subsequent patch I posted yesterday:
| 
| https://lkml.org/lkml/2012/2/7/185

I applied both patches to the powerpc.git tree - following hunk already
exists in the powerpc tree (and even Jan 27 mainline) so I skipped this
hunk.

--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -988,6 +988,9 @@ static void x86_pmu_start(struct perf_event *event, int flags)
        struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
        int idx = event->hw.idx;

+       if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
+               return;
+
        if (WARN_ON_ONCE(idx == -1))
                return;

I tried this on Power7 system with a simple 'nooploop' program that loops
in while(1) for 10 seconds.

Results before the patches were applied:

	# /tmp/perf record -e cycles,cycles /tmp/nooploop 10
	[ perf record: Woken up 4 times to write data ]
	[ perf record: Captured and wrote 0.886 MB perf.data (~38714 samples) ]

	# /tmp/perf report -D | tail -15

	Aggregated stats:
		   TOTAL events:      19307
		    MMAP events:         42
		    COMM events:          2
		    EXIT events:          2
		  SAMPLE events:      19261
	cycles stats:
		   TOTAL events:       9993
		    MMAP events:          4
		    COMM events:          1
		    EXIT events:          2
		  SAMPLE events:       9986
	cycles stats:
		   TOTAL events:       9275
		  SAMPLE events:       9275

After applying both patches:

	# /tmp/perf record -e cycles,cycles /tmp/nooploop 10
	[ perf record: Woken up 1 times to write data ]
	[ perf record: Captured and wrote 0.006 MB perf.data (~260 samples) ]

	# /tmp/perf report -D | tail -15

	Aggregated stats:
		   TOTAL events:         80
		    MMAP events:         42
		    COMM events:          2
		    EXIT events:          2
		  SAMPLE events:         34
	cycles stats:
		   TOTAL events:         24
		    MMAP events:          4
		    COMM events:          1
		    EXIT events:          2
		  SAMPLE events:         17

	cycles stats:
		   TOTAL events:         17
		  SAMPLE events:         17

Sukadev

