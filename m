Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab0HCU7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 16:59:45 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:4443 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab0HCU7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 16:59:44 -0400
Message-ID: <4C58833F.1080409@caviumnetworks.com>
Date: Tue, 03 Aug 2010 13:59:43 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        hschauhan@nulltrace.org
Subject: Re: [PATCH 2/5] MIPS: Add instrunction format for BREAK and SYSCALL
References: <1280859742-26364-1-git-send-email-ddaney@caviumnetworks.com> <1280859742-26364-3-git-send-email-ddaney@caviumnetworks.com> <alpine.LFD.2.00.1008032150060.20999@eddie.linux-mips.org>
In-Reply-To: <alpine.LFD.2.00.1008032150060.20999@eddie.linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Aug 2010 20:59:43.0827 (UTC) FILETIME=[CC4D3A30:01CB334E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2010 01:54 PM, Maciej W. Rozycki wrote:
> On Tue, 3 Aug 2010, David Daney wrote:
>
>> diff --git a/arch/mips/include/asm/inst.h b/arch/mips/include/asm/inst.h
>> index 6489f00..444ff71 100644
>> --- a/arch/mips/include/asm/inst.h
>> +++ b/arch/mips/include/asm/inst.h
>> @@ -247,6 +247,12 @@ struct ma_format {	/* FPU multipy and add format (MIPS IV) */
>>   	unsigned int fmt : 2;
>>   };
>>
>> +struct b_format { /* BREAK and SYSCALL */
>> +	unsigned int opcode:6;
>> +	unsigned int code:20;
>> +	unsigned int func:6;
>> +};
>> +
>>   #elif defined(__MIPSEL__)
>>
>>   struct j_format {	/* Jump format */
>
>   Please note the code field of the BREAK instruction is by toolchain
> convention (bug-compatibility with the original MIPS assembler or
> suchlike) treated as a pair of swapped 10-bit fields -- you may want to
> double-check consistency of interpretation with usage elsewhere.
>

Indeed, I am familiar with that fact.  From patch 3/5 we have:

.
.
.
+void __kprobes jprobe_return(void)
+{
+	/* Assembler quirk necessitates this '0,code' business.  */
+	asm volatile(
+		"break 0,%0\n\t"
+		".globl jprobe_return_end\n"
+		"jprobe_return_end:\n"
+		: : "n" (BRK_KPROBE_BP) : "memory");
+}
.
.
.

The 'break 0,code' construct causes gas to emit values that are 
compatible with the other use of struct b_format in the patch set.

David Daney
