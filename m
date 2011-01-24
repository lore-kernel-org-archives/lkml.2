Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab1AXTLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:11:31 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:50862 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab1AXTLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:11:31 -0500
X-ASG-Debug-ID: 1295896289-01de280c5331620001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D3DCEDD.4010509@fusionio.com>
Date: Mon, 24 Jan 2011 20:11:25 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 07/10] fs: make generic file read/write functions plug
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com> <1295659049-2688-8-git-send-email-jaxboe@fusionio.com> <20110124035717.GC16267@dastard>
X-ASG-Orig-Subj: Re: [PATCH 07/10] fs: make generic file read/write functions plug
In-Reply-To: <20110124035717.GC16267@dastard>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1295896289
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.60
X-Barracuda-Spam-Status: No, SCORE=0.60 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=MARKETING_SUBJECT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.53327
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.60 MARKETING_SUBJECT      Subject contains popular marketing words
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-24 04:57, Dave Chinner wrote:
> On Sat, Jan 22, 2011 at 01:17:26AM +0000, Jens Axboe wrote:
>> Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
>> ---
>>  mm/filemap.c |    7 +++++++
>>  1 files changed, 7 insertions(+), 0 deletions(-)
>>
> .....
>> @@ -2432,11 +2436,13 @@ ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
>>  {
>>  	struct file *file = iocb->ki_filp;
>>  	struct inode *inode = file->f_mapping->host;
>> +	struct blk_plug plug;
>>  	ssize_t ret;
>>  
>>  	BUG_ON(iocb->ki_pos != pos);
>>  
>>  	mutex_lock(&inode->i_mutex);
>> +	blk_start_plug(&plug);
>>  	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
>>  	mutex_unlock(&inode->i_mutex);
>>  
>> @@ -2447,6 +2453,7 @@ ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
>>  		if (err < 0 && ret > 0)
>>  			ret = err;
>>  	}
>> +	blk_finish_plug(&plug);
>>  	return ret;
>>  }
>>  EXPORT_SYMBOL(generic_file_aio_write);
> 
> Why do you want to plug all writes? For non-synchronous buffered
> writes we won't be doing any IO, so why woul dwe want to plug and
> unplug in that case? Shouldn't the plug/unplug be places in
> .writepage for the buffered writeback case (which would handle sync
> writes, too)?

Good point, it probably should be placed a bit more clever.

> Also, what is the impact of not plugging here? You change
> generic_file_aio_write, but filesystems like XFS supply their own
> .aio_write method and hence woul dneed some kind of change, too?

Generally, performance tests need to be run and the appropriate places
to plug need to be found. It could potentially cause lower queue depth
on the device side, or less merging of ios if we miss one of the heavy
IO spots.

-- 
Jens Axboe

