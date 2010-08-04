Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab0HDPTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 11:19:06 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46491 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab0HDPTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 11:19:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Yv70WJA861TMAtGScRwvXQ4bTKGweTx8+vQkH8SirmdJeRcNipNAnczsmjM20XswQC
         PYOFs0r1HxaT3tj6FERDUl21/+aviifX4moS8zuUEqUBjjTPgS1hDiU7s2joL1CNXqy/
         c+v+g6SQjW2MCZ+MxJm4dJTupWlTJLnjP1BO8=
Date: Wed, 4 Aug 2010 19:18:58 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>, Robert Richter <robert.richter@amd.com>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: A question of perf NMI handler
Message-ID: <20100804151858.GB5130@lenovo>
References: <1280913670.20797.179.camel@minggr.sh.intel.com> <20100804100116.GH26154@erda.amd.com> <20100804140021.GN3353@redhat.com> <1280931093.1923.1194.camel@laptop> <20100804145203.GP3353@redhat.com> <1280934161.1923.1294.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280934161.1923.1294.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 05:02:41PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-08-04 at 10:52 -0400, Don Zickus wrote:
> > > Right so I looked up your thing and while that limits the damage in that
> > > at some point it will let NMIs pass, it will still consume too many.
> > > Meaning that Yinghai will have to potentially press his NMI button
> > > several times before it registers.
> > 
> > Ok.  Thanks for reviewing.  How does it consume to many?  I probably don't
> > understand how perf is being used in the non-simple scenarios.
> 
> Suppose you have 4 counters (AMD, intel-nhm+), when more than 2 overflow
> the first will raise the PMI, if the other 2+ overflow before we disable
> the PMU it will try to raise 2+ more PMIs, but because hardware only has
> a single interrupt pending bit it will at most cause a single extra
> interrupt after we finish servicing the first one.
> 
> So then the first interrupt will see 3+ overflows, return 3+, and will
> thus eat 2+ NMIs, only one of which will be the pending interrupt,
> leaving 1+ NMIs from other sources to consume unhandled.
> 
> In which case Yinghai will have to press his NMI button 2+ times before
> it registers.
> 
> That said, that might be a better situation than always consuming
> unknown NMIs.. 
> 

Well, first I guess having Yinghai CC'ed is a bonus ;)
The second thing is that I don't get why perf handler can't be _last_
call in default_do_nmi, if there were any nmi with reason (serr or parity)
I think they should be calling first which of course don't eliminate
the former issue but somewhat make it weaken.

	-- Cyrill
