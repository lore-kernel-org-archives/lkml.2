Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab0EGPcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:32:18 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:53239
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756621Ab0EGPcM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:32:12 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432P98dN936eM62a3Lab9bhzz1202hzz6ff19hz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L222ZP-01-H2J-02
X-M-MSG: 
Date: Fri, 7 May 2010 17:28:35 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf: fix raw sample size if no sampling data is attached
Message-ID: <20100507152835.GU6450@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
 <1271190201-25705-13-git-send-email-robert.richter@amd.com>
 <n2wbd4cb8901004190519m9c939c26wbe49701fdfd2379a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <n2wbd4cb8901004190519m9c939c26wbe49701fdfd2379a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.04.10 14:19:57, Stephane Eranian wrote:
> > +       perf_sample_data_init(&data, 0);
> > +       if (event->attr.sample_type & PERF_SAMPLE_RAW) {
> > +               for (i = 1; i < size; i++)
> > +                       rdmsrl(msr++, *buf++);
> > +               raw.size = sizeof(u64) * size;
> > +               raw.data = buffer;
> > +               data.raw = &raw;
> > +       }
> > +
> 
> Need to add the padding: raw.size = sizeof(u64) * size + sizeof(u32);
> 
> > +       regs = *iregs; /* later: update ip from ibs sample */
> > +
> > +       if (perf_event_overflow(event, 1, &data, &regs))

During code review I found a bug in perf_output_sample(). A fix is
below.

> > +               x86_pmu_stop(event);
> > +       else
> > +               __x86_pmu_enable_event(&event->hw, reenable);
> > +
> > +       return 1;
> > +}

--

>From 6373951f1c660400650066b73c3bb2f6d232be67 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Fri, 7 May 2010 15:49:56 +0200
Subject: [PATCH] perf: fix raw sample size if no sampling data is attached

The header size of a raw sample is not included in the total size of a
raw data sample. Thus, if no data is attached the size must be
null. In this case a buffer overflow may occur when copying the
sampling data.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 9dbe8cd..f6ddae9 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3229,7 +3229,7 @@ void perf_output_sample(struct perf_output_handle *handle,
 				u32	size;
 				u32	data;
 			} raw = {
-				.size = sizeof(u32),
+				.size = 0,
 				.data = 0,
 			};
 			perf_output_put(handle, raw);
-- 
1.7.0.3

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

