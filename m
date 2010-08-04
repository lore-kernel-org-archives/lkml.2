Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647Ab0HDKEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 06:04:41 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:40272 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983Ab0HDKEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 06:04:39 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz1432N98dN936eMzz1202hzzz32i2a8h64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0L6MH63-02-23G-02
X-M-MSG: 
Date: Wed, 4 Aug 2010 12:01:16 +0200
From: Robert Richter <robert.richter@amd.com>
To: Lin Ming <ming.m.lin@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: A question of perf NMI handler
Message-ID: <20100804100116.GH26154@erda.amd.com>
References: <1280913670.20797.179.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1280913670.20797.179.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.08.10 05:21:10, Lin Ming wrote:

> With nmi_watchdog enabled, perf_event_nmi_handler always return
> NOTIFY_STOP(active_events > 0), and the notifier call chain will not
> call further.
> 
> If it was not perf NMI, does the perf nmi handler may stop the real NMI
> handler get called because NOTIFY_STOP is returned??

There is no general mechanism for recording the NMI source (except if
it was external triggered, e.g. by the southbridge). Also, all nmis
are mapped to NMI vector 2 and therefore there is no way to find out
the reason by using apic mask registers.

Now, if multiple perfctrs trigger an nmi, it may happen that a handler
has nothing to do because the counter was already handled by the
previous one. Thus, it is valid to have unhandled nmis caused by
perfctrs.

So, with counters enabled we always have to return stop for *all* nmis
as we cannot detect that it was an perfctr nmi. Otherwise we could
trigger an unhandled nmi. To ensure that all other nmi handlers are
called, the perfctr's nmi handler must have the lowest priority. Then,
the handler will be the last in the chain.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

