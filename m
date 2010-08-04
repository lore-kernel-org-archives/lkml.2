Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab0HDPCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 11:02:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:33747 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932966Ab0HDPCw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 11:02:52 -0400
Subject: Re: A question of perf NMI handler
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Cyrill Gorcunov <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
In-Reply-To: <20100804145203.GP3353@redhat.com>
References: <1280913670.20797.179.camel@minggr.sh.intel.com>
	 <20100804100116.GH26154@erda.amd.com> <20100804140021.GN3353@redhat.com>
	 <1280931093.1923.1194.camel@laptop>  <20100804145203.GP3353@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 04 Aug 2010 17:02:41 +0200
Message-ID: <1280934161.1923.1294.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 10:52 -0400, Don Zickus wrote:
> > Right so I looked up your thing and while that limits the damage in that
> > at some point it will let NMIs pass, it will still consume too many.
> > Meaning that Yinghai will have to potentially press his NMI button
> > several times before it registers.
> 
> Ok.  Thanks for reviewing.  How does it consume to many?  I probably don't
> understand how perf is being used in the non-simple scenarios.

Suppose you have 4 counters (AMD, intel-nhm+), when more than 2 overflow
the first will raise the PMI, if the other 2+ overflow before we disable
the PMU it will try to raise 2+ more PMIs, but because hardware only has
a single interrupt pending bit it will at most cause a single extra
interrupt after we finish servicing the first one.

So then the first interrupt will see 3+ overflows, return 3+, and will
thus eat 2+ NMIs, only one of which will be the pending interrupt,
leaving 1+ NMIs from other sources to consume unhandled.

In which case Yinghai will have to press his NMI button 2+ times before
it registers.

That said, that might be a better situation than always consuming
unknown NMIs.. 
