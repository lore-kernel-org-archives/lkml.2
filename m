Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934072Ab1EWUEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:04:48 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:41650 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933224Ab1EWUEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:04:44 -0400
Message-ID: <4DDABDC4.1010800@us.ibm.com>
Date: Mon, 23 May 2011 15:04:20 -0500
From: Maynard Johnson <maynardj@us.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Eric B Munson <emunson@mgebm.net>
CC: benh@kernel.crashing.org, robert.richter@amd.com,
        oprofile-list@lists.sf.net, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oprofile, powerpc: Handle events that raise an exception
 without overflowing
References: <1306160560-5309-1-git-send-email-emunson@mgebm.net> <20110523193736.GA2997@mgebm.net>
In-Reply-To: <20110523193736.GA2997@mgebm.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric B Munson wrote:
> On Mon, 23 May 2011, Eric B Munson wrote:
> 
>> Commit 0837e3242c73566fc1c0196b4ec61779c25ffc93 fixes a situation on POWER7
>> where events can roll back if a specualtive event doesn't actually complete.
>> This can raise a performance monitor exception.  We need to catch this to ensure
>> that we reset the PMC.  In all cases the PMC will be less than 256 cycles from
>> overflow.
>>
>> This patch lifts Anton's fix for the problem in perf and applies it to oprofile
>> as well.
>>
>> Signed-off-by: Eric B Munson <emunson@mgebm.net>
>> Cc: <stable@kernel.org> # as far back as it applies cleanly
> 
> I'd like to get this patch into mainline this merge window if at all possible.
Ack.  I've been able to create a system hang profiling with speculative events on POWER7.  This patch fixes that problem.

-Maynard

> 
>> ---
>>  arch/powerpc/oprofile/op_model_power4.c |   24 +++++++++++++++++++++++-
>>  1 files changed, 23 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/powerpc/oprofile/op_model_power4.c b/arch/powerpc/oprofile/op_model_power4.c
>> index 8ee51a2..e6bec74 100644
>> --- a/arch/powerpc/oprofile/op_model_power4.c
>> +++ b/arch/powerpc/oprofile/op_model_power4.c
>> @@ -261,6 +261,28 @@ static int get_kernel(unsigned long pc, unsigned long mmcra)
>>  	return is_kernel;
>>  }
>>  
>> +static bool pmc_overflow(unsigned long val)
>> +{
>> +	if ((int)val < 0)
>> +		return true;
>> +
>> +	/*
>> +	 * Events on POWER7 can roll back if a speculative event doesn't
>> +	 * eventually complete. Unfortunately in some rare cases they will
>> +	 * raise a performance monitor exception. We need to catch this to
>> +	 * ensure we reset the PMC. In all cases the PMC will be 256 or less
>> +	 * cycles from overflow.
>> +	 *
>> +	 * We only do this if the first pass fails to find any overflowing
>> +	 * PMCs because a user might set a period of less than 256 and we
>> +	 * don't want to mistakenly reset them.
>> +	 */
>> +	if (__is_processor(PV_POWER7) && ((0x80000000 - val) <= 256))
>> +		return true;
>> +
>> +	return false;
>> +}
>> +
>>  static void power4_handle_interrupt(struct pt_regs *regs,
>>  				    struct op_counter_config *ctr)
>>  {
>> @@ -281,7 +303,7 @@ static void power4_handle_interrupt(struct pt_regs *regs,
>>  
>>  	for (i = 0; i < cur_cpu_spec->num_pmcs; ++i) {
>>  		val = classic_ctr_read(i);
>> -		if (val < 0) {
>> +		if (pmc_overflow(val)) {
>>  			if (oprofile_running && ctr[i].enabled) {
>>  				oprofile_add_ext_sample(pc, regs, i, is_kernel);
>>  				classic_ctr_write(i, reset_value[i]);
>> -- 
>> 1.7.4.1
>>
>>
>>
>> _______________________________________________
>> Linuxppc-dev mailing list
>> Linuxppc-dev@lists.ozlabs.org
>> https://lists.ozlabs.org/listinfo/linuxppc-dev

