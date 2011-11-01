Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab1KAMx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 08:53:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947Ab1KAMx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 08:53:26 -0400
Message-ID: <4EAFEBBE.3070604@redhat.com>
Date: Tue, 01 Nov 2011 10:53:18 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: wharms@bfs.de
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        "Mark A. Grondona" <mgrondona@llnl.gov>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] edac: sb_edac: add sanity check to silence static checker
References: <20111101062852.GA19020@elgon.mountain> <4EAFE6DF.8030403@bfs.de>
In-Reply-To: <4EAFE6DF.8030403@bfs.de>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 01-11-2011 10:32, walter harms escreveu:
> 
> 
> Am 01.11.2011 07:28, schrieb Dan Carpenter:
>> I assume the the check on if (limit <= prv) prevents n_tads from
>> actually reaching MAX_TAD.  The problem with that is that it relies
>> on the hardware returning the right value and Smatch complains that
>> if it doesn't we could have a buffer overflow.
>>
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>> ---
>> Feel free to ignore this patch if you want.  I don't have very stong
>> feelings about this either way.
>>
>> diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
>> index 7a402bf..ebf386c 100644
>> --- a/drivers/edac/sb_edac.c
>> +++ b/drivers/edac/sb_edac.c
>> @@ -970,6 +970,12 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
>>  			break;
>>  		prv = limit;
>>  	}
>> +	if (n_tads == MAX_TAD) {
>> +		sprintf(msg, "Could not discover the memory channel");
> 
> why the sprintf() ? can you not simply:
> 	edac_mc_handle_ce_no_info(mci,"Could not discover the memory channel");

Yes, please us the edac-specific call. I'm working on some patches that will
provide an additional functionality to those edac report calls. So, using
sprintf() won't do the right thing after applying those patches (likely for
Kernel v3.3).

> 		
> 	re,
>  	 wh
>> +		edac_mc_handle_ce_no_info(mci, msg);
>> +		return -EINVAL;
>> +	}
>> +
>>  	ch_way = TAD_CH(reg) + 1;
>>  	sck_way = TAD_SOCK(reg) + 1;
>>  	/*

