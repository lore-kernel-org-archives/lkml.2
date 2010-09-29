Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab0I2FVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 01:21:17 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:34114 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769Ab0I2FVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 01:21:16 -0400
X-ASG-Debug-ID: 1285737673-695939fd0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CA2CCC3.8010307@fusionio.com>
Date: Wed, 29 Sep 2010 14:21:07 +0900
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Chris Frey <cdfrey@foursquare.net>
CC: Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jdike@addtoit.com" <jdike@addtoit.com>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        "user-mode-linux-user@lists.sourceforge.net" 
	<user-mode-linux-user@lists.sourceforge.net>,
        "janjaap@bos.nl" <janjaap@bos.nl>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "adobriyan@gmail.com" <adobriyan@gmail.com>,
        "syzop@vulnscan.org" <syzop@vulnscan.org>
Subject: Re: [PATCH 1/1] um: ubd: Fix data corruption
References: <1285710456-4435-1-git-send-email-richard@nod.at> <20100928150000.f007f43e.akpm@linux-foundation.org> <201009290013.11332.richard@nod.at> <20100928225202.GA30352@foursquare.net> <4CA275CE.6060401@fusionio.com> <20100929012945.GA3324@foursquare.net>
X-ASG-Orig-Subj: Re: [PATCH 1/1] um: ubd: Fix data corruption
In-Reply-To: <20100929012945.GA3324@foursquare.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1285737673
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.42202
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-29 10:29, Chris Frey wrote:
> On Wed, Sep 29, 2010 at 08:10:06AM +0900, Jens Axboe wrote:
>> It looks like that if we need to restart the requeue, then
>> we use the initial position and not the current index. Does
>> this help?
>>
>> diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
>> index 1bcd208..81ee063 100644
>> --- a/arch/um/drivers/ubd_kern.c
>> +++ b/arch/um/drivers/ubd_kern.c
>> @@ -162,7 +162,7 @@ struct ubd {
>>  	spinlock_t lock;
>>  	struct scatterlist sg[MAX_SG];
>>  	struct request *request;
>> -	int start_sg, end_sg;
>> +	int start_sg, end_sg, rq_off;
>>  };
>>  
>>  #define DEFAULT_COW { \
>> @@ -187,6 +187,7 @@ struct ubd {
>>  	.request =		NULL, \
>>  	.start_sg =		0, \
>>  	.end_sg =		0, \
>> +	.rq_off =		0, \
>>  }
>>  
>>  /* Protected by ubd_lock */
>> @@ -1241,10 +1242,11 @@ static void do_ubd_request(struct request_queue *q)
>>  			dev->request = req;
>>  			dev->start_sg = 0;
>>  			dev->end_sg = blk_rq_map_sg(q, req, dev->sg);
>> +			dev->rq_off = 0;
>>  		}
>>  
>>  		req = dev->request;
>> -		sector = blk_rq_pos(req);
>> +		sector = blk_rq_pos(req) + dev->rq_off;
>>  		while(dev->start_sg < dev->end_sg){
>>  			struct scatterlist *sg = &dev->sg[dev->start_sg];
>>  
>> @@ -1273,6 +1275,7 @@ static void do_ubd_request(struct request_queue *q)
>>  			}
>>  
>>  			dev->start_sg++;
>> +			dev->rq_off += sg->length >> 9;
>>  		}
>>  		dev->end_sg = 0;
>>  		dev->request = NULL;
>>
>> -- 
> 
> This patch does not fix the corruption issue for me.  I applied the patch
> to 2.6.35.5, and reproduced the "deleted inode referenced" errors
> in both a gentoo and ubuntu guest OS.  It does take longer to reproduce
> though, with this patch.

This seems to imply that the original commit pin pointed is not
the only issue we have in that code atm.

I think we need to find the real fix here, just disabling merging
is not a fix (it's just a nasty work-around for the real bug).

-- 
Jens Axboe

