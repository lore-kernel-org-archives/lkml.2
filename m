Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0HPRTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 13:19:31 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:24195 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab0HPRTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 13:19:30 -0400
X-SpamScore: 6
X-BigFish: VPS6(z3cfcs329eqz1432N98dN936eKzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L799B1-01-T0W-02
X-M-MSG: 
Date: Mon, 16 Aug 2010 19:16:10 +0200
From: Robert Richter <robert.richter@amd.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100816171610.GN26154@erda.amd.com>
References: <20100804162026.GU3353@redhat.com>
 <20100804163930.GE5130@lenovo>
 <20100804184806.GL26154@erda.amd.com>
 <20100804192634.GG5130@lenovo>
 <20100806065203.GR26154@erda.amd.com>
 <20100806142131.GA1874@redhat.com>
 <20100809194829.GB26154@erda.amd.com>
 <20100811220058.GT26154@erda.amd.com>
 <1281970116.1926.1495.camel@laptop>
 <20100816162706.GH5805@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100816162706.GH5805@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.08.10 12:27:06, Cyrill Gorcunov wrote:
> On Mon, Aug 16, 2010 at 04:48:36PM +0200, Peter Zijlstra wrote:
> > I liked the one without funny timestamps in better, the whole timestamps
> > thing just feels too fragile.
> > 
> 
> Me too, the former Roberts patch (if I'm not missing something) looks good
> to me.
> 
> >
> > Relying on handled > 1 to arm the back-to-back filter seems doable.

Peter, I will rip out the timestamp code from the -v2 patch. My first
patch does not deal with a 2-1-0 sequence, so it has false positives.
We do not necessarily need the timestamps if back-to-back nmis are
rare. Without using timestamps the statistically lost ratio for
unknown nmis will be as the ratio for back-to-back nmis, with
timestamps we could catch almost every unknown nmi. So if we encounter
problems we could still implement timestamp code on top.

> It's doable _but_ I think there is nothing we can do, there is no
> way (at least I known of) to check if there is latched nmi from
> perf counters. We only can assume that if there multiple counters
> overflowed most probably the next unknown nmi has the same nature,
> ie it came from perf.

As said, I think with timestamps we could be able to detect 100% of
the unknown nmis. I guess we get now more than 90% with mutliple
counters, and 100% with a single counter running. So, this is already
more than a simple improvement.

> Yes, we can loose real unknown nmi in this
> case but I think this is justified trade off. If an user need
> a precise counting of unknown nmis he should not arm perf events
> at all, if there an user with nmi button (guys where did you get this
> magic buttuns? i need one ;) he better to not arm perf events too
> otherwise he might have to click twice
> 
> (and of course we should keep in mind Andi's proposal but it
>  is a next step I think).

Yes, this patch is the first step, now we can change the nmi handler
priority. The perf handler must not have the lowest priority anymore.

> > (Also, you didn't deal with the TSC going backwards..)

Does this also happen in the case of a back-to-back nmi? I don't know
the conditions for a backward running TSC. Maybe, if an nmi is
retriggered the TSC wont be adjusted by a negative offset, I don't
know...

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

