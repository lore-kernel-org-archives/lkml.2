Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab0LHIBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 03:01:39 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:35727 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab0LHIBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 03:01:38 -0500
X-ASG-Debug-ID: 1291795296-6da3145a0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CFF3B5B.30305@fusionio.com>
Date: Wed, 8 Dec 2010 16:01:31 +0800
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>
Subject: Re: [RFC]block: change sort order of elv_dispatch_sort
References: <1291786922.12777.152.camel@sli10-conroe>	 <4CFF2C1A.1010100@fusionio.com> <1291794643.12777.161.camel@sli10-conroe>
X-ASG-Orig-Subj: Re: [RFC]block: change sort order of elv_dispatch_sort
In-Reply-To: <1291794643.12777.161.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1291795296
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.4922 1.0000 0.0000
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.48809
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-08 15:50, Shaohua Li wrote:
> On Wed, 2010-12-08 at 14:56 +0800, Jens Axboe wrote:
>> On 2010-12-08 13:42, Shaohua Li wrote:
>>> Change the sort order a little bit. Makes requests with sector above boundary
>>> in ascendant order, and requests with sector below boundary in descendant
>>> order. The goal is we have less disk spindle move.
>>> For example, boundary is 7, we add sector 8, 1, 9, 2, 3, 4, 10, 12, 5, 11, 6
>>> In the original sort, the sorted list is:
>>> 8, 9, 10, 11, 12, 1, 2, 3, 4, 5, 6
>>> the spindle move is 8->12->1->6, total movement is 12*2 sectors
>>> with the new sort, the list is:
>>> 8, 9, 10, 11, 12, 6, 5, 4, 3, 2, 1
>>> the spindle move is 8->12->6->1, total movement is 12*1.5 sectors
>>
>> It was actually done this way on purpose, it's been a while since we
>> have done two way elevators even outside the dispatch list sorting
>> itself.
>>
>> Do you have any results to back this change up? I'd argue that
>> continuing to the end, sweeping back, and reading forwards again will be
>> faster then doing backwards reads usually.
> No, have no data, that is why this is a RFC patch. Part reason is I
> don't know when we dispatch several requests to the list. Appears driver
> only takes one request one time. What kind of test do you suggest?

Yes that is usually the case, it's mainly meant as a holding point for
dispatch, or for requeue, or for request that don't give sort ordering.
Or on io scheduler switches, for instance.

> I'm curious why the sweeping back is faster. It definitely needs more
> spindle move. is there any hardware trick here?

The idea is that while the initial seek is longer, due to drive prefetch
serving the latter half request series after the sweep is faster.

I know that classic OS books mentions this is a good method, but I don't
think that has been the case for a long time.

-- 
Jens Axboe

