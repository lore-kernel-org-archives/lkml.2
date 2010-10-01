Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab0JAHUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:20:04 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:30721
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750968Ab0JAHUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:20:00 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 0,
X-WSS-ID: 0L9LO9P-01-D0Y-02
X-M-MSG: 
Date: Fri, 1 Oct 2010 09:17:50 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: Stephane Eranian <eranian@google.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
 disabling counters
Message-ID: <20101001071750.GB13563@erda.amd.com>
References: <20100929151253.GL13563@erda.amd.com>
 <20100929152745.GC9440@lenovo>
 <AANLkTikvYreYiyCbGeG02j+r4dWVLRH7BqeeG9O=VTNN@mail.gmail.com>
 <20100929154528.GD9440@lenovo>
 <AANLkTinkqTXXD5fMUYTT4zrRD6YoTi_G+uOA5CsOgxtT@mail.gmail.com>
 <20100929170924.GR13563@erda.amd.com>
 <20100929181207.GW26290@redhat.com>
 <AANLkTimp=+1GzBOYaUZWtDF6teGt6FZe+RTpb9fAyOyd@mail.gmail.com>
 <20100930091246.GV13563@erda.amd.com>
 <20100930194451.GI26290@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100930194451.GI26290@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.09.10 15:44:51, Don Zickus wrote:
> On Thu, Sep 30, 2010 at 11:12:46AM +0200, Robert Richter wrote:

> > As soon as you stop executing the chain, there are chances to miss an
> > nmi for other parts of the system. Where is no way to avoid this. So
> > your argument above is valid also for regular perf nmis and not only
> > for catched-spurious or back-to-back nmis.
> 
> I don't agree with that.  Most nmi handlers can do a check to see if their
> subsystem triggered an nmi or not.  Now we may not catch it in the right
> order because one handler is higher in the chain than the other, but
> ultimately the other handler will get its chance to execute because it
> fired its own nmi (which hasn't been lost).

No, as soon as a handler with higher priority detected an nmi by its
own and handled it, it returns with a stop and all subsequent handlers
get ignored without the chance to check their hardware. So, if perf
consumes an nmi because a counter triggered, there are rare cases that
other handlers may not be executed.

> Whereas the problem Stephane is describing is that the heurestics of the
> perf counters 'eats' an NMI, thus possibly starving another handler.  With
> back-to-back nmis we are at least polite, letting everyone have a chance to
> process the nmi before we indulge ourselves and 'eat' it (if it still
> around to be eaten).
> 
> However in the case of the 'catched-spurious', we selfishly 'eat' the NMI
> without really knowing if it was our to be eaten.  That was the
> difference and the concern.

But, this argument is valid. It would be better to handle
catched-spurious in the 'unknown' path to give other handlers the
chance to check their hardware.

I don't think this is a show-stopper for v2.6.36 even because the perf
handler runs with the lowest priority now. So we will have enough time
after the merge window to improve the code here.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

