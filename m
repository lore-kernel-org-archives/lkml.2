Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab2DPOYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:24:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36280 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab2DPOYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:24:16 -0400
Message-ID: <1334586234.28150.53.camel@twins>
Subject: Re: [RFCv2 0/8] perf tool: Add new event group management
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org
Date: Mon, 16 Apr 2012 16:23:54 +0200
In-Reply-To: <20120416121627.GA1660@m.brq.redhat.com>
References: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
	 <1334503015.28150.16.camel@twins> <20120416121627.GA1660@m.brq.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-16 at 14:16 +0200, Jiri Olsa wrote:
> also, any thoughts about the displaying question? ;)
> 
> > I'm looking on how to present this data in perf and it seems we need
> > to reset all siblings once we read/store them (in kernel) to the
> > leader sample.
> > 
> > My current thinking is to store siblings' sum values for each
> > hists entry of the sample (perf report count unit) .. and display
> > them in similar way we display callchains: for each hists entry
> > display the sum value for each sibling.
> > 
> > Could you provide more of your world examples? Your expectations about
> > presenting this..
> > 
> > Maybe we want to make the reset optional, and do some do some other
> > math with siblings' values..?


My thought was to do the exact same thing with it that we do with the
regular multi-event thing (which could be improved too). Simply create
individual event views with variable period based on the sample delta
for that particular event.

So suppose you have a group of 3 with only the leader sampling and you
get tuples like:

 IP=x {1000,  500,  750}
 IP=y {2000,  800, 1500}
 IP=z {3000, 1100, 2000}

This could be decomposed into 3 event views like:

 IP=x,period=1000	IP=x,period=500		IP=x,period=750
 IP=y,period=1000	IP=y,period=300		IP=y,period=750
 IP=z,period=1000	IP=z,period=300		IP=z,period=500

Just like what would've happened if you'd used multiple events like:

 attr = {
	.sample_type = PERF_SAMPLE_IP|PERF_SAMPLE_PERIOD,
	.freq = 1,
	.sample_period = 1000,
 }


