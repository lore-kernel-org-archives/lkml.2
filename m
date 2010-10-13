Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab0JMOtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 10:49:52 -0400
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:58457 "HELO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752146Ab0JMOtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 10:49:51 -0400
Message-ID: <4CB5C70A.2010401@panasas.com>
Date: Wed, 13 Oct 2010 10:49:46 -0400
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/18] exofs: use iput() for inode reference count decrements
References: <1286928961-15157-1-git-send-email-david@fromorbit.com> <1286928961-15157-7-git-send-email-david@fromorbit.com> <20101013113402.GC19456@infradead.org>
In-Reply-To: <20101013113402.GC19456@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Oct 2010 14:49:47.0247 (UTC) FILETIME=[E17027F0:01CB6AE5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2010 07:34 AM, Christoph Hellwig wrote:
> Btw, this looks like a nasty enough bug that it might be worth queing
> up for 2.6.36.
> 
> On Wed, Oct 13, 2010 at 11:15:49AM +1100, Dave Chinner wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> Direct modification of the inode reference count is a no-no. Convert
>> the exofs decrements to call iput() instead of acting directly on
>> i_count.
>>
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> ---
>>  fs/exofs/inode.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
>> index b631ff3..0fb4d4c 100644
>> --- a/fs/exofs/inode.c
>> +++ b/fs/exofs/inode.c
>> @@ -1101,7 +1101,7 @@ static void create_done(struct exofs_io_state *ios, void *p)
>>  
>>  	set_obj_created(oi);
>>  
>> -	atomic_dec(&inode->i_count);
>> +	iput(inode);
>>  	wake_up(&oi->i_wq);
>>  }
>>  
>> @@ -1161,7 +1161,7 @@ struct inode *exofs_new_inode(struct inode *dir, int mode)
>>  	ios->cred = oi->i_cred;
>>  	ret = exofs_sbi_create(ios);
>>  	if (ret) {
>> -		atomic_dec(&inode->i_count);
>> +		iput(inode);
>>  		exofs_put_io_state(ios);
>>  		return ERR_PTR(ret);
>>  	}
>> -- 

I suspect it's not a bug but a useless inc/dec because in all my testing
I have not seen an inode leak. Let me investigate if it can be removed.

So I do not think we need it for 2.6.36.

I'll take this patch into my 2.6.37-rcX merge window. It should appear
in linux-next by tomorrow. Hopefully followed by a removal patch later.

Thanks for the catch
Boaz
