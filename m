Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab1IJAMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 20:12:52 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49903 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1IJAMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 20:12:51 -0400
Message-ID: <4E6AAB81.2010600@vflare.org>
Date: Fri, 09 Sep 2011 20:12:49 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] zram: Simplify zram disk resizing interface
References: <1315609264-13632-1-git-send-email-ngupta@vflare.org> <1315609264-13632-5-git-send-email-ngupta@vflare.org> <20110909231128.GA24604@kroah.com>
In-Reply-To: <20110909231128.GA24604@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2011 07:11 PM, Greg KH wrote:

> "simplify" it in what way?
> 
> What just got changed, and why, and did it just break any documentation?
> 


Its simplification in the sense that earlier we had to be pass total RAM
size in bytes when setting zram disksize using zram_set_disksize()
which is not intuitive.  The replaced version instead just requires
the new size to be set which seems to make more sense.

> 
> On Fri, Sep 09, 2011 at 07:01:03PM -0400, Nitin Gupta wrote:
>> Also remove unnecessary messages.
>>
>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
>> Reviewed-by: Jerome Marchand <jmarchan@redhat.com>
>> ---
>>  drivers/staging/zram/zram_drv.c |   42 +++++++++++---------------------------
>>  1 files changed, 12 insertions(+), 30 deletions(-)
>>
>> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
>> index b2e29dd..b1c4abd 100644
>> --- a/drivers/staging/zram/zram_drv.c
>> +++ b/drivers/staging/zram/zram_drv.c
>> @@ -104,33 +104,16 @@ static int page_zero_filled(void *ptr)
>>  	return 1;
>>  }
>>  
>> -static void zram_set_disksize(struct zram *zram, size_t totalram_bytes)
>> +static u64 zram_default_disksize_bytes(void)
>>  {
>> -	if (!zram->disksize) {
>> -		pr_info(
>> -		"disk size not provided. You can use disksize_kb module "
>> -		"param to specify size.\nUsing default: (%u%% of RAM).\n",
>> -		default_disksize_perc_ram
>> -		);
>> -		zram->disksize = default_disksize_perc_ram *
>> -					(totalram_bytes / 100);
>> -	}
>> -
>> -	if (zram->disksize > 2 * (totalram_bytes)) {
>> -		pr_info(
>> -		"There is little point creating a zram of greater than "
>> -		"twice the size of memory since we expect a 2:1 compression "
>> -		"ratio. Note that zram uses about 0.1%% of the size of "
>> -		"the disk when not in use so a huge zram is "
>> -		"wasteful.\n"
>> -		"\tMemory Size: %zu kB\n"
>> -		"\tSize you selected: %llu kB\n"
>> -		"Continuing anyway ...\n",
>> -		totalram_bytes >> 10, zram->disksize
>> -		);
>> -	}
> 
> Why are these print messages removed, aren't they useful to people?
> 


The first message is no longer required since we now set some default
value (25% of RAM) instead of zero. So, if user doesn't provide any
disksize value, we use the default.

The second message really doesn't belong in a kernel driver. That's more
of a documentation or user commonsense thing.  If a user really thinks
that the data to be written is going to be highly compressible, setting
zram to such large value makes some sense and there is little point in
throwing out this big warning in system logs.

Thanks,
Nitin
