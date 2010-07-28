Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab0G1MBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 08:01:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56912 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab0G1MBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 08:01:47 -0400
Message-ID: <4C501B57.4030300@monstr.eu>
Date: Wed, 28 Jul 2010 13:58:15 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: John Williams <john.williams@petalogix.com>,
        "Edgar E. Iglesias" <edgar.iglesias@petalogix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] microblaze: Add KGDB support
References: <1280309353-9172-1-git-send-email-monstr@monstr.eu> <1280309353-9172-2-git-send-email-monstr@monstr.eu> <4C501B83.9070400@windriver.com>
In-Reply-To: <4C501B83.9070400@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wessel wrote:
> On 07/28/2010 04:29 AM, Michal Simek wrote:
>> Kgdb uses brki r16, 0x18 instruction to call
>> low level _debug_exception function which save
>> current state to pt_regs and call microblaze_kgdb_break
>> function. _debug_exception should be called only from
>> the kernel space. User space calling is not supported
>> because user application debugging uses different handling.
>>
>> pt_regs_to_gdb_regs loads additional special registers
>> which can't be changed
>>
>>  * Enable KGDB in Kconfig
>>  * Remove ancient not-tested KGDB support
>>  * Remove ancient _debug_exception code from entry.S
>>
>> Only MMU KGDB support is supported.
>>
>>   
> There is only one place I saw a problem and if you fix it, you can add:
> 
> Acked-by: Jason Wessel <jason.wessel@windriver.com>
> 
>> +
>> +int kgdb_arch_handle_exception(int vector, int signo, int err_code,
>> +			       char *remcom_in_buffer, char *remcom_out_buffer,
>> +			       struct pt_regs *regs)
>> +{
>> +	char *ptr;
>> +	unsigned long address;
>> +	int cpu = smp_processor_id();
>> +
>> +	switch (remcom_in_buffer[0]) {
>> +	case 's':
>> +	case 'c':
>> +		/* handle the optional parameter */
>> +		ptr = &remcom_in_buffer[1];
>> +		if (kgdb_hex2long(&ptr, &address))
>> +			regs->pc = address;
>> +		atomic_set(&kgdb_cpu_doing_single_step, -1);
>> +		if (remcom_in_buffer[0] == 's')
>> +			atomic_set(&kgdb_cpu_doing_single_step, cpu);
>> +
>> +		return 0;
>> +	}
>>   
> 
> As far as I can see there is no code in the arch specific portion to
> make use of single stepping.  It needs to be implemented using hardware
> assist, or a software breakpoint strategy, else you simply omit the 's'
> case from statement so that kdb will not enable single stepping at run time.
> 
> Example:
> 
> 	switch (remcom_in_buffer[0]) {
> 	case 'c':
> 		/* handle the optional parameter */
> 		ptr = &remcom_in_buffer[1];
> 		if (kgdb_hex2long(&ptr, &address))
> 			regs->pc = address;
> 
> 		return 0;
> 	}
> 
> 
> You can also remove the kgdb_cpu_doing_single_step operations because
> this arch does not currently implement the kgdb single stepping.

Ok. I will remove it. I copied this part of the code from somewhere.
gdb handle single stepping and always send Z0 packet to the next 
instruction or two breakpoints for branches.

Thanks,
Michal

> 
> 
> Cheers,
> Jason.


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
