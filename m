Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab1GFPBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 11:01:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab1GFPBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 11:01:45 -0400
Date: Wed, 6 Jul 2011 11:01:43 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 2/3]CFQ: add think time check for service tree
Message-ID: <20110706150143.GC27302@redhat.com>
References: <1309757794.15392.238.camel@sli10-conroe>
 <20110705141041.GB24348@redhat.com>
 <1309917465.15392.245.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309917465.15392.245.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 09:57:45AM +0800, Shaohua Li wrote:
[..]
> [test1]
> rw=randread
> ioengine=libaio
> size=500m
> directory=/mnt
> filename=file1
> thinktime=9000
> 
> [test2]
> rw=read
> ioengine=libaio
> size=1G
> directory=/mnt
> filename=file2
> 
> 	patched		base
> test1	41k/s		33k/s
> test2	15868k/s	15789k/s
> total	15902k/s	15817k/s

Because we are not idling, throughput of randread workload has gone down.
Can you make sure it does not go down in case of launching firefox in
the presence of buffered writers. I want to make sure we got thinktime
logic right and we don't end up not idling even when thinktimes are
low.

[..]
>  static void
> @@ -3570,7 +3587,13 @@ static void cfq_completed_request(struct
>  	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
>  
>  	if (sync) {
> +		struct cfq_rb_root *service_tree;
> +
>  		RQ_CIC(rq)->ttime.last_end_request = now;
> +
> +		service_tree = service_tree_for(cfqq->cfqg, cfqq_prio(cfqq),
> +			cfqq_type(cfqq));

I think we could do.

if (cfq_cfqq_on_rr(cfqq)
	service_tree = cfqq->service_tree;
else
	service_tree = service_tree_for();

Thanks
Vivek
