Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab1CLFvu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 00:51:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:11393 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab1CLFvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 00:51:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,307,1297065600"; 
   d="scan'208";a="719346374"
Date: Sat, 12 Mar 2011 00:51:46 -0500
From: Matthew Wilcox <willy@linux.intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REVIEW] NVM Express driver
Message-ID: <20110312055146.GA4183@linux.intel.com>
References: <20110303204749.GY3663@linux.intel.com>
 <m24o79cmv4.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m24o79cmv4.fsf@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 02:29:19PM -0800, Andi Kleen wrote:
> Matthew Wilcox <willy@linux.intel.com> writes:
> > +
> > +static struct nvme_queue *get_nvmeq(struct nvme_ns *ns)
> > +{
> > +	int qid, cpu = get_cpu();
> > +	if (cpu < ns->dev->queue_count)
> > +		qid = cpu + 1;
> > +	else
> > +		qid = (cpu % rounddown_pow_of_two(ns->dev->queue_count))
> > + 1;
> 
> This will be likely a full divide, better use a mask.

I have a TODO to replace this calculation with a lookup; I've discovered
that not even all Intel systems number the CPUs in the logical fashion
(eg on a two-socket system; cpu 0 in socket 0, cpu 1 in socket 1, cpu
2 in socket 0, etc; some two socket systems have cpus 0-3 in socket 0;
4-7 in socket 1; and 8-15 are the HT siblings of 0-7).

Is there a good API to iterate through each socket, then each core in a
socket, then each HT sibling?  eg, if I have 20 queues and 2x6x2 CPUs,
I want to assign at least one queue to each core; some threads will get
their own queues and others will have to share with their HT sibling.

> > +	nprps = DIV_ROUND_UP(length, PAGE_SIZE);
> > +	npages = DIV_ROUND_UP(8 * nprps, PAGE_SIZE);
> > +	prps = kmalloc(sizeof(*prps) + sizeof(__le64 *) * npages, GFP_ATOMIC);
> > +	prp_page = 0;
> > +	if (nprps <= (256 / 8)) {
> > +		pool = dev->prp_small_pool;
> > +		prps->npages = 0;
> 
> 
> Unchecked GFP_ATOMIC allocation? That will oops soon.
> Besides GFP_ATOMIC a very risky thing to do on a low memory situation,
> which can trigger writeouts.

Ah yes, thank you.  There are a few other places like this.  Bizarrely,
they've not oopsed during the xfstests runs.

My plan for this is, instead of using a mempool, to submit partial I/Os
in the rare cases where a write cannot allocate memory.  I have the
design in my head, just not committed to code yet.  The design also
avoids allocating any memory in the driver for I/Os that do not cross
a page boundary.

