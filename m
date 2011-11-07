Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab1KGVyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 16:54:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab1KGVyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 16:54:19 -0500
Message-ID: <4EB85387.2050008@redhat.com>
Date: Mon, 07 Nov 2011 19:54:15 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Josh Boyer <jwboyer@redhat.com>
CC: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix sb_edac compilation with 32 bits kernels
References: <20111103140716.GF19809@zod.bos.redhat.com> <4EB84DC9.8010106@redhat.com> <20111107213730.GD14216@zod.bos.redhat.com>
In-Reply-To: <20111107213730.GD14216@zod.bos.redhat.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 07-11-2011 19:37, Josh Boyer escreveu:
> On Mon, Nov 07, 2011 at 07:29:45PM -0200, Mauro Carvalho Chehab wrote:
>> @@ -670,6 +671,7 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
>>  	u32 reg;
>>  	u64 limit, prv = 0;
>>  	u64 tmp_mb;
>> +	u32 mb, kb;
>>  	u32 rir_way;
>>  
>>  	/*
>> @@ -682,8 +684,9 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
>>  	pvt->tolm = GET_TOLM(reg);
>>  	tmp_mb = (1 + pvt->tolm) >> 20;
>>  
>> -	debugf0("TOLM: %Lu.%03Lu GB (0x%016Lx)\n",
>> -		tmp_mb / 1000, tmp_mb % 1000, (u64)pvt->tolm);
>> +	mb = div_u64_rem(tmp_mb, 1000, &kb);
>> +	debugf0("TOLM: %u.%03u GB (0x%016Lx)\n",
>> +		mb, kb, (u64)pvt->tolm);
> 
> So I realize you said that EDAC_DEBUG should (for now) always be enabled
> when this driver is built, but you just added a bunch of 64-bit divides
> outside of the debugfX stuff.  Doesn't that mean you'll be doing those
> divides in the non-debug case as well, and then most likely getting an
> unused varible warning when you turn EDAC_DEBUG off?

You're right. Some additional logic is needed to remove the warnings and
unneeded calculus when debug is disabled. I may eventually work on it when
I have time.  In any case, we gave a fix already for kernel 3.2, and this
patch is an alternative for those brave enough to test this driver with a 32 bits PAE
kernel.

> 
>> @@ -858,7 +868,7 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
>>  	 * range (e. g. VGA addresses). It is unlikely, however, that the
>>  	 * memory controller would generate an error on that range.
>>  	 */
>> -	if ((addr > (u64) pvt->tolm) && (addr < (1L << 32))) {
>> +	if ((addr > (u64) pvt->tolm) && (addr < (1LL << 32))) {
>>  		sprintf(msg, "Error at TOLM area, on addr 0x%08Lx", addr);
>>  		edac_mc_handle_ce_no_info(mci, msg);
>>  		return -EINVAL;
>> @@ -1053,7 +1063,7 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
>>  	ch_addr = addr & 0x7f;
>>  	/* Remove socket wayness and remove 6 bits */
>>  	addr >>= 6;
>> -	addr /= sck_xch;
>> +	addr = div_u64(addr, sck_xch);
>>  #if 0
>>  	/* Divide by channel way */
>>  	addr = addr / ch_way;
> 
> Those two parts look ok.
> 
> josh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-edac" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

