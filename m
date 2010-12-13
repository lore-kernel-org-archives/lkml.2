Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491Ab0LMRfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:35:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:38832 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab0LMRfo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:35:44 -0500
Subject: Re: [PATCH 1/2] perf tools: Add reference timestamp to perf header
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "David S. Ahern" <daahern@cisco.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101213172216.GB7417@ghostprotocols.net>
References: <1291773285-16254-1-git-send-email-daahern@cisco.com>
	 <1291773285-16254-2-git-send-email-daahern@cisco.com>
	 <20101212201613.GA1784@nowhere> <4D06301C.2090309@cisco.com>
	 <20101213155451.GA1691@nowhere> <20101213164854.GL5407@ghostprotocols.net>
	 <20101213170923.GB1691@nowhere> <1292260289.6803.297.camel@twins>
	 <20101213171537.GC1691@nowhere> <1292260699.6803.305.camel@twins>
	 <20101213172216.GB7417@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Dec 2010 18:35:16 +0100
Message-ID: <1292261716.6803.332.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 15:22 -0200, Arnaldo Carvalho de Melo wrote:
> > No, the last one already happened, you cannot postpone the last one,
> > there will always be another excuse.
> 
> Did you understand the use case? How to have multiple reference times
> when appending?

Yes, I understood it perfectly, I just detest the existence of these
pure user records, they need to die ASAP.

> "last one" means adding a multiplexor, PERF_RECORD_LAST_ONE if you will,
> and inside it we add new events if the need arises. Then never again we
> add a PERF_RECORD_ event in userspace. 

Nah, that sucks too, the whole concept of pure user-space events in that
stream sucks.

There's multiple things you can do, you could:

 - create a kernel event PERF_RECORD_NEW_BUFFER and stuff that into each
fresh buffer when its created, it could contain all kinds of 1-time
information, like:
	* this CLOCK_MONOTONIC offset (for what little good that does, since
our clock isn't strictly sync'ed to CLOCK_MONOTONIC so we can incur
arbitrary drift).
 	* architecture details, like 64/32 host info needed for the
PERF_SAMPLE_REGS stuff.

 - extend the existing header infrastructure to write a new header in
front of the new stream. The main header already has a data section that
points to the end of the stream, add a continuation header section that
points to a continuation-header used to appends and record the clock
offset data in there.

 - something else entirely.

Just stop using these stupid fake events and be somewhat creative.
