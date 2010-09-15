Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab0IOWZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 18:25:52 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:19420 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab0IOWZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 18:25:51 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zzbb2cK98dN1db9Mzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L8T6XV-02-B1Z-02
X-M-MSG: 
Date: Thu, 16 Sep 2010 00:10:41 +0200
From: Robert Richter <robert.richter@amd.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: Re: [PATCH] perf, x86: catch spurious interrupts after disabling
 counters
Message-ID: <20100915221041.GT13563@erda.amd.com>
References: <20100911124537.GA22850@elte.hu>
 <20100912095202.GF13563@erda.amd.com>
 <20100913143713.GK13563@erda.amd.com>
 <20100914174132.GN13563@erda.amd.com>
 <20100915162034.GO13563@erda.amd.com>
 <20100915164610.GA5959@lenovo>
 <AANLkTim5knbg8GdUAYyx_i5WQUwnez8tHkU1SfiJJ+L7@mail.gmail.com>
 <20100915170222.GB5959@lenovo>
 <20100915172805.GR13563@erda.amd.com>
 <20100915174012.GC5959@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100915174012.GC5959@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.09.10 13:40:12, Cyrill Gorcunov wrote:
> Yeah, already noted from your previous email. Perhaps we might
> do a bit simplier approach then -- in nmi handler were we mark
> "next nmi" we could take into account not "one next" nmi but
> sum of handled counters minus one being just handled (of course
> cleaning this counter if new "non spurious" nmi came in), can't
> say I like this approach but just a thought.

If we disable a counter, it might still trigger an interrupt which we
cannot detect. Thus, if a running counter is deactivated, we must
count it as handled in the nmi handler.

Working with a sum is not possible, because a disabled counter may or
*may not* trigger an interrupt. We cannot predict the number of
counters that will be handled.

Dealing with the "next nmi" is also not handy here. Spurious nmis are
caused then stopping a counter. Since this is done outside the nmi
handler, we would then start touching the "next nmi" also outside the
handler. This might be more complex because we then have to deal with
locking or atomic access. We shouldn't do that.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

