Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab0HNB2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 21:28:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33613 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab0HNB2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 21:28:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AVZ6O3FORGFp9kAEkv46w8+lIrwWu+R6nerCntRtsv5EgnQq7CXIBh1wSiTnx/JR7Y
         R9nypFm5XmvufF6DPnSk6D3xGSGqcKV43MG7hrTE06tlhkNNz9VJa/u6hO5P+2BPMiFU
         8N8OC6FXiawE7aZf1kHsEjdA3JxXfXL750OAs=
Date: Sat, 14 Aug 2010 03:28:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] perf, x86: try to handle unknown nmis with running
	perfctrs
Message-ID: <20100814012804.GB5343@nowhere>
References: <20100804184806.GL26154@erda.amd.com> <20100804192634.GG5130@lenovo> <20100806065203.GR26154@erda.amd.com> <20100806142131.GA1874@redhat.com> <20100809194829.GB26154@erda.amd.com> <20100810204856.GA16571@redhat.com> <20100811024451.GA26835@nowhere> <20100811111046.GQ26154@erda.amd.com> <20100813043746.GB9669@nowhere> <20100813082230.GZ26154@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100813082230.GZ26154@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 10:22:30AM +0200, Robert Richter wrote:
> On 13.08.10 00:37:48, Frederic Weisbecker wrote:
> 
> > > 
> > > ... but this will not work. You have to mark the *absolute* nmi number
> > > here. If you only raise a flag, the next unknown nmi will be dropped,
> > > every.
> > 
> > 
> > 
> > Isn't it what we want? Only the next unknown nmi gets dropped.
> > 
> > 
> > 
> > 
> > > Because, in between there could have been other nmis that
> > > stopped the chain and thus the 'unknown' path is not executed.
> > 
> > 
> > 
> > I'm not sure what you mean here. Are you thinking about a third
> > NMI source that triggers while we are still handling the first
> > NMI in the back to back sequence?
> > 
> > 
> > 
> > > The trick in my patch is that you *know*, which nmi you want to skip.
> > 
> > 
> > Well with the flag you also know which nmi you want to skip.
> 
> We cannot assume that all cpus have the same behavior here. Imagine a
> cpu that handles 2 counters and *does not* trigger a back-to-back
> nmi. With flags only implemented, the next unknown nmi will be dropped
> anyway, no matter when it fires. We have to check the nmi sequence.



I'd expect it to be an ABI. NMIs can't nest, but if one triggers while
servicing another, it should trigger right after (once we "iret", which
reenables NMIs).

But I haven't checked intel or amd documentation about that.


 
> The next thing you have to be aware is, a registered nmi handler is
> not called with every nmi. If there was another nmi source and a
> handler with higher priority was returning a stop, when all other
> subsequent handlers are not called. Esp. 'unknown nmi' is called only
> in rare cases. So, a handler might not get noticed of an nmi. This
> means, if a handler gets called a 2nd time, it must not necessarily
> the next (2nd) nmi.


Yeah, in this case we can just clear the __ger_cpu_var(next_nmi_skip)
when another handler service the next NMI.

