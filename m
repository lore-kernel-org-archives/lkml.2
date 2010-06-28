Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab0F1P3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 11:29:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45550 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab0F1P3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 11:29:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YxuJUq2E7BBds1sj6l1mqUj1Rfa0jFsMSdBcGv9rLRqOJleeCnUhmWw0gQzy3BdRqB
         y340ZRs8yqmQuGRGZL5iPrA3UsqnSG85Ws/7o3RjShL4d+hTUM55FelPE+BobglVPp8C
         kmwrQ8RCoFW0+xy4flTNg3amaut1pImWN9j5I=
Date: Mon, 28 Jun 2010 17:29:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 05/11] perf: register pmu implementations
Message-ID: <20100628152924.GA5492@nowhere>
References: <20100624142804.431553874@chello.nl> <20100624143406.764162308@chello.nl> <20100628132101.GB5668@nowhere> <1277738197.3561.132.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277738197.3561.132.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 05:16:37PM +0200, Peter Zijlstra wrote:
> > >  	}
> > > +	srcu_read_unlock(&pmus_srcu, idx);
> > >  
> > >  	return pmu;
> > >  }
> > 
> > 
> > 
> > I'm still not sure why all this locking is needed. We don't even
> > support pmus in modules.
> > 
> > Is there something coming soon that will use this?
> > I remember something about KVM.
> 
> Possibly, not sure. We could put the unregister thing in a later patch,
> but I wanted to make sure it was sanely possibly and its only a few
> lines of code.



Ok.

 
> > And who will have to use srcu? It seems the event fastpath would
> > be concerned, right? Will that have an impact on the performances?
> 
> Only event creation like above (perf_init_event) will have to use SRCU,
> so not really a hot path.



Ah I see. The event itself is synchronized against the fast-path using rcu.
And then pmus themselves would be synchronized against events. Right
that makes sense.

But then why RCU (or SRCU, whatever)? I mean parent event creation is
quite rare. And child events won't need to be synchronized as far as the parent
keeps a reference to the pmu.

