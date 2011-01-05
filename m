Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751129Ab1AENvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 08:51:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab1AENvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 08:51:36 -0500
Message-ID: <4D247760.9050307@redhat.com>
Date: Wed, 05 Jan 2011 14:51:28 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] block: fix accounting bug on cross partition merges
References: <20101210165553.GE31737@redhat.com> <4D07D2AC.6000500@fusionio.com> <4D0B68AF.80804@redhat.com> <4D0BB4A1.8080305@fusionio.com> <4D13664C.3020500@redhat.com> <20101223153915.GE9502@redhat.com> <4D13810B.8000304@redhat.com> <20101224192916.GB2082@redhat.com> <4D23423A.60707@redhat.com> <4D2342E1.8010405@redhat.com> <20110104210011.GB4180@kroah.com>
In-Reply-To: <20110104210011.GB4180@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2011 10:00 PM, Greg KH wrote:
> On Tue, Jan 04, 2011 at 04:55:13PM +0100, Jerome Marchand wrote:
>> Also add a refcount to struct hd_struct to keep the partition in
>> memory as long as users exist. We use kref_test_and_get() to ensure
>> we don't add a reference to a partition which is going away.
> 
> No, don't do this, use a kref correctly and no such function should be
> needed.
> 
>> +	} else {
>> +		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
> 
> That is the function that should properly increment the reference count
> on the object.

Agreed.

>  If the object is "being removed", then it will return
> NULL and you need to check that.  Do that and you do not need to add:

The object is actually removed in a rcu callback function. We could
certainly add a flag to hd_struct, set by the release function, to
indicate disk_map_sector_rcu() that the partition is being removed, but
why not use the refcount instead?

Thanks,
Jerome

> 
>> +		if (!kref_test_and_get(&part->ref)) {
> 
> At all.
> 
> thanks,
> 
> greg k-h

