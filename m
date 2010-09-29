Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab0I2Njo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 09:39:44 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:47698 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab0I2Njn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 09:39:43 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9IGLR-01-E8F-02
X-M-MSG: 
Date: Wed, 29 Sep 2010 15:39:23 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
 disabling counters
Message-ID: <20100929133923.GI13563@erda.amd.com>
References: <20100915162034.GO13563@erda.amd.com>
 <tip-63e6be6d98e1a2bcdca86872b67052e51ab6afa1@git.kernel.org>
 <AANLkTimB2gf=2zYCwiKEgozt_Rsa1Cpb6JuLSzmHusFX@mail.gmail.com>
 <20100929125301.GG13563@erda.amd.com>
 <20100929125453.GH13563@erda.amd.com>
 <AANLkTimoE8wAhT+yxXBPnZvTTGrAtDjdaXPBN3Xg28eL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AANLkTimoE8wAhT+yxXBPnZvTTGrAtDjdaXPBN3Xg28eL@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.09.10 09:13:30, Stephane Eranian wrote:

> for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
>                 struct perf_event *event = cpuc->events[bit];
> 
>                 handled++;
> 
>                 if (!test_bit(bit, cpuc->active_mask))

			/* spurious interrupt here */

>                     continue;
> }
> 
> I think the logic is similar. What makes the difference, it seems, is that
> handled is incremented unconditionally if the ovfl_mask says it has
> an overflow, i.e., before active_mask is checked.

Note that we can use here for_each_set_bit() since we have the status
mask. So we may increment handled always.

On AMD we use for_each_counter(), but only check active counters to
avoid unnecessary rdmsrl()s for unused counters. But here, we only can
increment handled if we detect an overflow or if we know a counter was
disabled.

> On Westmere, we've seen situations where the overflow mask and active
> mask did not agree.

It's the 'spurious interrupt' branch above.

> On counter disable, the overflow mask bit is not cleared, thus one may iterate
> in the loop and fail the active_mask. But handled would be incremented in that
> case, so that would behave like in your patch.

Right, spurious interrupts are counted and a 'handled' is returned.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

