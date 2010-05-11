Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab0EKN5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 09:57:55 -0400
Received: from mail-va3.bigfish.com ([216.32.180.112]:45529 "EHLO
	mail77-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756902Ab0EKN5v convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 09:57:51 -0400
X-SpamScore: -24
X-BigFish: VPS-24(zz1432P98dN936eM1442J62a3Lab9bhzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0L29DFX-01-BEP-02
X-M-MSG: 
Date: Tue, 11 May 2010 15:57:32 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/12] perf, x86: implement AMD IBS event configuration
Message-ID: <20100511135732.GL6450@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
 <1271190201-25705-12-git-send-email-robert.richter@amd.com>
 <h2obd4cb8901004190646v8231b6a1sf47d0cff6481cc5e@mail.gmail.com>
 <20100420160557.GT11907@erda.amd.com>
 <20100421084700.GU11907@erda.amd.com>
 <o2ibd4cb8901004210202i1ba91c3dlc775a9f7759ece68@mail.gmail.com>
 <20100421092145.GV11907@erda.amd.com>
 <20100421105439.GA6450@erda.amd.com>
 <r2sbd4cb8901004210437i343850b4z94ca99b9ec0316b6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <r2sbd4cb8901004210437i343850b4z94ca99b9ec0316b6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.04.10 13:37:27, Stephane Eranian wrote:
> Robert,
> 
> Some more comments about model_spec.
> 
> > Except for the sample period IBS can only be set up with raw (model
> > specific) config values and raw data samples. The event attributes for
> > the syscall should be programmed like this (IBS_FETCH):
> >
> >        memset(&attr, 0, sizeof(attr));
> >        attr.type        = PERF_TYPE_RAW;
> >        attr.sample_type = PERF_SAMPLE_CPU | PERF_SAMPLE_RAW;
> >        attr.config      = IBS_FETCH_CONFIG_DEFAULT
> >        attr.config     |=
> >                ((unsigned long long)MODEL_SPEC_TYPE_IBS_FETCH << 32)
> >                & MODEL_SPEC_TYPE_MASK;
> >        attr.model_spec  = 1;
> >
> Why do you need model_spec, in addition to your special encoding?
> 
> >  /*
> > + * Model specific hardware events
> > + *
> > + * With the attr.model_spec bit set we can setup hardware events
> > + * others than generic performance counters. A special PMU 64 bit
> > + * config value can be passed through the perf_event interface. The
> > + * concept of PMU model-specific arguments was practiced already in
> > + * Perfmon2. The type of event (8 bits) is determinded from the config
> > + * value too, bit 32-39 are reserved for this.
> > + */
> Isn't the config field big enough to encode all the information you need?
> In the kernel, you could check bit 32-39 and based on host CPU determine
> whether it refers to IBS or is a bogus value. I am trying to figure out what
> model_spec buys you. I believe RAW does not mean the final value as
> accepted by HW but a value that must be interpreted by the model-specific
> code to eventually come up with a raw HW value. In the current code, the
> RAW value is never passed as is, it is assembled from various bits and
> pieces incl. attr.config of course.

What about introducing a raw_type? We could reuse the unused bp_type
space for this. There is no longer the model_spec flag necessary and
we could pass the raw 64 bit config value without shifting bits to
encode the type there.

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 4924c96..c9b51b3 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -222,7 +222,10 @@ struct perf_event_attr {
                __u32           wakeup_watermark; /* bytes before wakeup   */
        };
 
-       __u32                   bp_type;
+       union {
+               __u32           bp_type;
+               __u32           raw_type;
+       }
        __u64                   bp_addr;
        __u64                   bp_len;
 };

Raw type would be architecure specific, e.g. for x86:

enum perf_raw_type {
        PERF_RAW_PERFCTR                        = 0,
        PERF_RAW_IBS_FETCH                      = 1,
        PERF_RAW_IBS_OP                         = 2,

        PERF_RAW_MAX,
};

Null is the architecture's default.

The raw event syntax could be suffixed by the type (as for
breakpoints):

   -e rNNN[:TYPE]

Example:

 perf record -e r186A:1          # ... meaning IBD fetch, cycle count 100000
 perf record -e r0:1 -c 100000   # ... the same

Or with named types:

 perf record -e r186A:IBS_FETCH ...
 perf record -e r0:IBS_FETCH -c 100000 ...

I would prefer this solution as it has a number of advantages: A raw
event type may be specified without to encode the type in the config
value. The attr flags are not 'polluted'. We can follow the already
existing breakpoint concept in syntax and encoding.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

