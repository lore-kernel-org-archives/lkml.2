Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab1KUVE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:04:27 -0500
Received: from mail-va3.bigfish.com ([216.32.180.10]:21046 "EHLO
	VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752595Ab1KUVE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:04:26 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh87h2a8h668h839h8e2h8e3h944h)
X-Forefront-Antispam-Report: CIP:160.36.179.132;KIP:(null);UIP:(null);IPV:NLI;H:kedge1.utk.tennessee.edu;RD:kedge1.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 21 Nov 2011 16:04:08 -0500
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, <mingo@redhat.com>,
        <hpa@zytor.com>, <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@elte.hu>
Subject: Re: [tip:perf/urgent] perf/x86: Enable raw event access to Intel
 offcore events
In-Reply-To: <CABPqkBRHW0ZmeqADptvBySLZpi6jc_bEFKoukkA6rtd5o04ziQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1111211559190.24943@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1108031200390.703@cl320.eecs.utk.edu> <tip-ed13ec58bfe0d5dc95f748e6118432cb0fa283cb@git.kernel.org> <alpine.DEB.2.00.1111211321390.21667@cl320.eecs.utk.edu> <1321901536.28118.20.camel@twins> <alpine.DEB.2.00.1111211358570.23676@cl320.eecs.utk.edu>
 <CABPqkBRHW0ZmeqADptvBySLZpi6jc_bEFKoukkA6rtd5o04ziQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011, Stephane Eranian wrote:

> > We have a workaround, but it currently disables kernel multiplexing and a
> > few other nice features.
> 
> I don't understand why you have a problem with NMI watchdog. Multiplexing
> allows you to still measure more events than there are counters.

The PAPI code currently uses FORMAT_GROUP and puts as many events as 
possible in a group.  The way we maximize events in a group is to
add events until perf_events indicates a failure.

When NMI watchdog is enabled, a counter is stolen.  Yet the perf_events
code does not account for this.

So say on an AMD machine with 4 counters (3 after one is stolen) 
perf_events lets you add 4 events to an event group, even though only 3 
are available.  It does not report failure upon open or start, only at 
read.  By then it's too late.

We have to work around this, by doing an extra read at open time to verify 
that the event group actually is valid, adding overhead.

Our multiplex code tries to maximize the number of events in a group too.
Currently PAPI works around this by just not doing kernel multiplexing
if a NMI watchdog is detected.  There's probably more elegant solutions 
such as checking with a read there too, or not using FORMAT_GROUP at all, 
but since this is an ABI regression I was hoping it would get fixed 
quickly enough that I wouldn't have to construct better workarounds.

Vince
vweaver1@eecs.utk.edu

