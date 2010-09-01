Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab0IAR7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 13:59:38 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:36917 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab0IAR7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 13:59:37 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzbb2cK154dM1432N98dNzz1202hzz8275dhz32i2a8h5bep5bfs43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L82XW2-02-77G-02
X-M-MSG: 
Date: Wed, 1 Sep 2010 16:57:28 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Don Zickus <dzickus@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/4] [x86] perf: fix accidentally ack'ing a second
 event on intel perf counter
Message-ID: <20100901145728.GM22783@erda.amd.com>
References: <AANLkTimA-AZWJugaLR3VPGVhBaJid=t=a1rPVNUE_8Dh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AANLkTimA-AZWJugaLR3VPGVhBaJid=t=a1rPVNUE_8Dh@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.09.10 09:04:45, Stephane Eranian wrote:
> Don,
> 
> Found your patch on LKML (I am not on it).
> 
> In your changelog you said:
> 
> > During testing of a patch to stop having the perf subsytem swallow nmis,
> > it was uncovered that Nehalem boxes were randomly getting unknown nmis
> > when using the perf tool.
> >
> > Moving the ack'ing of the PMI closer to when we get the status allows
> > the hardware to properly re-set the PMU bit signaling another PMI was
> > triggered during the processing of the first PMI.  This allows the new
> > logic for dealing with the shortcomings of multiple PMIs to handle the
> > extra NMI by 'eat'ing it later.
> 
> > Now one can wonder why are we getting a second PMI when we disable all
> > the PMUs in the beginning of the NMI handler to prevent such a case, for
> > that I do not know.  But I know the fix below helps deal with this quirk.
> >
> 
> I am assuming you're talking about back-to-back NMIs here, not nested NMIs.
> I don't quite understand the scenario here. Is it the case that you handled 1
> overflow, and then right as you return from the interrupt, you get a second
> PMI with a ovfl_status=0 ?
> 
> What events did you measure? Which counters did you use?
> Did you have HT turned on?

It is related to this thread:

 http://lkml.org/lkml/2010/8/25/124

Not acking the status immediately triggered an nmi, but the status was
0. Acking after reading and before processing the counters results in
a non-zero status and thus, no empty nmi.

-Robert

> 
> > Tested on multiple Nehalems where the problem was occuring.  With the
> > patch, the code now loops a second time to handle the second PMI (whereas
> > before it was not).
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

