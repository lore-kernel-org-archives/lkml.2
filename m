Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459Ab1CDNW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 08:22:26 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:52655 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759364Ab1CDNWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 08:22:25 -0500
X-ASG-Debug-ID: 1299244945-03d6a54f61041c0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D70E78D.9000402@fusionio.com>
Date: Fri, 4 Mar 2011 14:22:21 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 07/10] fs: make generic file read/write functions plug
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com> <1295659049-2688-8-git-send-email-jaxboe@fusionio.com> <20110304040907.GB32404@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH 07/10] fs: make generic file read/write functions plug
In-Reply-To: <20110304040907.GB32404@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299244945
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.60
X-Barracuda-Spam-Status: No, SCORE=0.60 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=MARKETING_SUBJECT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57026
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.60 MARKETING_SUBJECT      Subject contains popular marketing words
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-04 05:09, Vivek Goyal wrote:
> On Sat, Jan 22, 2011 at 01:17:26AM +0000, Jens Axboe wrote:
>> Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
>> ---
>>  mm/filemap.c |    7 +++++++
>>  1 files changed, 7 insertions(+), 0 deletions(-)
>>
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index 380776c..f9a29c8 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -1243,12 +1243,15 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
>>  	unsigned long seg = 0;
>>  	size_t count;
>>  	loff_t *ppos = &iocb->ki_pos;
>> +	struct blk_plug plug;
>>  
>>  	count = 0;
>>  	retval = generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
>>  	if (retval)
>>  		return retval;
>>  
>> +	blk_start_plug(&plug);
>> +
> 
> Jens,
> 
> IIUC, read requests will be considered SYNC and it looks like that
> __make_request() will dispatch all the SYNC requests immediately. If
> that's the case then for read path blk_plug mechanism is not required?

Good catch, we need to modify that logic. If the task is currently
plugged, it should not dispatch until blk_finish_plug() is called.
Essentially SYNC will not control dispatch. Will allow us to clean up
that logic, too.

-- 
Jens Axboe

