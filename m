Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab0INRpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:45:17 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:58524
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751852Ab0INRpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:45:15 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L8QZT5-02-FD9-02
X-M-MSG: 
Date: Tue, 14 Sep 2010 19:41:32 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: Don Zickus <dzickus@redhat.com>, "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "eranian@google.com" <eranian@google.com>
Subject: Re: [PATCH] x86: fix duplicate calls of the nmi handler
Message-ID: <20100914174132.GN13563@erda.amd.com>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
 <1284118900.402.35.camel@laptop>
 <20100910132741.GB4879@redhat.com>
 <20100910144634.GA1060@elte.hu>
 <20100910155659.GD13563@erda.amd.com>
 <20100911094157.GA11521@elte.hu>
 <20100911114404.GE13563@erda.amd.com>
 <20100911124537.GA22850@elte.hu>
 <20100912095202.GF13563@erda.amd.com>
 <20100913143713.GK13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100913143713.GK13563@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.09.10 16:37:13, Robert Richter wrote:
> Ingo, Peter,
> 
> I finally found a system here, will start debugging

I found the reason why we get the unknown nmi. For some reason
cpuc->active_mask in x86_pmu_handle_irq() is zero. Thus, no counters
are handled when we get an nmi. It seems there is somewhere a race
accessing the active_mask. So far I don't have a fix available.
Changing x86_pmu_stop() did not help:

static void x86_pmu_stop(struct perf_event *event, int flags)
{
        struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
        struct hw_perf_event *hwc = &event->hw;

        if (test_bit(hwc->idx, cpuc->active_mask)) {
                x86_pmu.disable(event);
                __clear_bit(hwc->idx, cpuc->active_mask);
                cpuc->events[hwc->idx] = NULL;
                WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);
                hwc->state |= PERF_HES_STOPPED;
        }
	...
}

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

