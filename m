Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab0HSPuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:50:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:50511 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab0HSPuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:50:04 -0400
Message-ID: <4C6D51AF.3050008@kernel.org>
Date: Thu, 19 Aug 2010 17:45:51 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
CC: Mike Snitzer <snitzer@redhat.com>, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de,
        tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com,
        konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net,
        jack@suse.cz, rwheeler@redhat.com, hare@suse.de, neilb@suse.de,
        rusty@rustcorp.com.au, mst@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 5/5] dm: implement REQ_FLUSH/FUA support
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <1281977523-19335-6-git-send-email-tj@kernel.org> <20100816190203.GA22299@redhat.com> <4C6A5780.2090100@kernel.org> <20100817140734.GA30768@redhat.com> <4C6ABE12.40705@kernel.org> <4C6D0824.3070908@ct.jp.nec.com>
In-Reply-To: <4C6D0824.3070908@ct.jp.nec.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 19 Aug 2010 15:49:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/19/2010 12:32 PM, Kiyoshi Ueda wrote:
>> I see but single pending flush and steady write streams w/o saturating
>> the mempool would be able to stall dm_wait_for_completeion(), no?  Eh
>> well, it's a separate issue, I guess.
> 
> Your understanding is correct, dm_wait_for_completion() for flush
> will stall in such cases for request-based dm.
> That's why I mentioned below in
> https://www.redhat.com/archives/dm-devel/2010-August/msg00026.html.
> 
>     In other words, current request-based device-mapper can't handle
>     other requests while a flush request is in progress.
>
> In flush request handling, request-based dm uses dm_wait_for_completion()
> to wait for the completion of cloned flush requests, depending on
> the fact that there should be only flush requests in flight owning
> to the block layer sequencing.

I see.  bio based implementation also uses dm_wait_for_completion()
but it also has DMF_QUEUE_IO_TO_THREAD to plug all the follow up bio's
while flush is in progress, which sucks for throughput but
successfully avoids starvation.

> It's not a separate issue and we need to resolve it at least.
> I'm still considering how I can fix the request-based dm.

Right, I thought you were talking about REQ_FLUSHes not sycnhronized
against barrier write.  Anyways, yeah, it's a problem.  I don't think
not being able to handle multiple flushes concurrently would be a
major issue.  The problem is not being able to process other
bios/requests while a flush is in progress.  All that's necessary is
making the completion detection a bit more fine grained so that it
counts the number of in flight flush bios/requests and completes when
it reaches zero instead of waiting for all outstanding commands.
Shouldn't be too hard.

Thanks.

-- 
tejun
