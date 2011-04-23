Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab1DWHuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 03:50:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37467 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1DWHuK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 03:50:10 -0400
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110422235433.GA9328@tassilo.jf.intel.com>
References: <1303407662-15564-1-git-send-email-acme@infradead.org>
	 <1303407662-15564-2-git-send-email-acme@infradead.org>
	 <20110422063429.GA16643@elte.hu> <20110422080604.GA22611@elte.hu>
	 <1303508226.4865.8.camel@laptop> <1303509293.4865.10.camel@laptop>
	 <1303510783.4865.14.camel@laptop>
	 <20110422235433.GA9328@tassilo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 23 Apr 2011 09:49:53 +0200
Message-ID: <1303544993.2298.42.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 16:54 -0700, Andi Kleen wrote:
> > 
> > #define SNB_PF_LLC_DATA_RD	(1 << 7)
> > #define SNB_PF_LLC_RFO		(1 << 8)
> > #define SNB_PF_LLC_IFETCH	(1 << 9)
> > #define SNB_BUS_LOCKS		(1 << 10)
> > #define SNB_STRM_ST		(1 << 11)
> >         			/* hole */
> > #define SNB_OFFCORE_OTHER	(1 << 15)
> > #define SNB_COMMON		(1 << 16)
> > #define SNB_NO_SUPP		(1 << 17)
> > #define SNB_LLC_HITM		(1 << 18)
> > #define SNB_LLC_HITE		(1 << 19)
> > #define SNB_LLC_HITS		(1 << 20)
> > #define SNB_LLC_HITF		(1 << 21)
> > 				/* hole */
> > #define SNB_SNP_NONE		(1 << 31)
> > #define SNB_SNP_NOT_NEEDED	(1 << 32)
> > #define SNB_SNP_MISS		(1 << 33)
> > #define SNB_SNP_NO_FWD		(1 << 34)
> > #define SNB_SNP_FWD		(1 << 35)
> > #define SNB_HITM		(1 << 36)
> > #define SNB_NON_DRAM		(1 << 37)
> > 
> > #define SNB_DMND_READ		(SNB_DMND_DATA_RD)
> > #define SNB_DMND_WRITE		(SNB_DMND_RFO|SNB_DMND_WB|SNB_STRM_ST)
> > #define SNB_DMND_PREFETCH	(SNB_PF_DATA_RD|SNB_PF_DATA_RFO)
> > 
> > Is what I came up with, but I'm stumped on how to construct:
> > 
> > #define SNB_L3_HIT
> 
> All the LLC hits together.

Bits 18-21 ?

> Or it can be done with the PEBS memory latency event (like Lin-Ming's patch) or 
> with mem_load_uops_retired (but then only for loads)
> 
> > #define SNB_L3_MISS
> 
> Don't set any of the LLC bits

So a 0 for the response type field? That's not valid. You have to set
some bit between 16-37.

> 
> > 
> > #define SNB_ALL_DRAM
> 
> Just don't set NON_DRAM

So bits 17-21|31-36 for the response type field?

That seems wrong as that would include what we previously defined to be
L3_HIT, which never makes it to DRAM.

> > #define SNB_REMOTE_DRAM
> 
> The current client SNBs for which those tables are don't have remote
> DRAM.

So what you're telling us is that simply because Intel hasn't shipped a
multi-socket SNB system yet they either:

  1) omitted a few bits from that table,
  2) have a completely different offcore response msr just for kicks?

Feh!
