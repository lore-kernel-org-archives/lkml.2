Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1DPIvl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 04:51:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:34391 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab1DPIvk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 04:51:40 -0400
Subject: Re: [PATCH 4/4] perf, x86: Fix event scheduler to solve complex
 scheduling problems
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1302913676-14352-5-git-send-email-robert.richter@amd.com>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
	 <1302913676-14352-5-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 16 Apr 2011 10:51:17 +0200
Message-ID: <1302943877.32491.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-04-16 at 02:27 +0200, Robert Richter wrote:
> The current x86 event scheduler fails to resolve scheduling problems
> of certain combinations of events and constraints. This happens esp.
> for events with complex constraints such as those of the AMD family
> 15h pmu. The scheduler does not find then an existing solution.
> Examples are:
> 
>         event code      counter         failure         possible
> solution
> 
> 1)      0x043           PMC[2:0]        0               1
>         0x02E           PMC[3,0]        3               0
>         0x003           PMC3            FAIL            3
> 
> 2)      0x02E           PMC[3,0]        0               3
>         0x043           PMC[2:0]        1               0
>         0x045           PMC[2:0]        2               1
>         0x046           PMC[2:0]        FAIL            2
> 
> Scheduling events on counters is a Hamiltonian path problem. To find a
> possible solution we must traverse all existing paths. This patch
> implements this.
> 
> We need to save all states of already walked paths. If we fail to
> schedule an event we now rollback the previous state and try to use
> another free counter until we have analysed all paths.
> 
> We might consider to later remove the constraint weight implementation
> completely, but I left this out as this is a much bigger and more
> risky change than this fix. 

Argh, crap. That's because AMD is now the first with overlapping
constraints. Be sure to let your hardware guys know that they went from
top to bottom om my appreciation list. AMD used to have no constraints
and now they have the absolute worst.

I'd really prefer not to do this for .39, and I'll have to sit down and
actually read this code. It looks like we went from O(n^2) to O(n!) or
somesuch, also not much of an improvement. I'll have to analyze the
solver to see what it does for 'simple' constraints set to see if it
will indeed be more expensive than the O(n^2) solver we had.

Also, I think this code could do with a tiny bit of comments ;-)
