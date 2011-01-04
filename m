Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540Ab1ADVAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 16:00:33 -0500
Received: from kroah.org ([198.145.64.141]:39648 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab1ADVAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 16:00:23 -0500
Date: Tue, 4 Jan 2011 13:00:11 -0800
From: Greg KH <greg@kroah.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] block: fix accounting bug on cross partition merges
Message-ID: <20110104210011.GB4180@kroah.com>
References: <20101210165553.GE31737@redhat.com>
 <4D07D2AC.6000500@fusionio.com>
 <4D0B68AF.80804@redhat.com>
 <4D0BB4A1.8080305@fusionio.com>
 <4D13664C.3020500@redhat.com>
 <20101223153915.GE9502@redhat.com>
 <4D13810B.8000304@redhat.com>
 <20101224192916.GB2082@redhat.com>
 <4D23423A.60707@redhat.com>
 <4D2342E1.8010405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2342E1.8010405@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 04:55:13PM +0100, Jerome Marchand wrote:
> Also add a refcount to struct hd_struct to keep the partition in
> memory as long as users exist. We use kref_test_and_get() to ensure
> we don't add a reference to a partition which is going away.

No, don't do this, use a kref correctly and no such function should be
needed.

> +	} else {
> +		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));

That is the function that should properly increment the reference count
on the object.  If the object is "being removed", then it will return
NULL and you need to check that.  Do that and you do not need to add:

> +		if (!kref_test_and_get(&part->ref)) {

At all.

thanks,

greg k-h
