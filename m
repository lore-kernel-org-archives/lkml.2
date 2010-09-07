Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab0IGA4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 20:56:23 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:37809 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab0IGA4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 20:56:19 -0400
X-AuditID: b753bd60-a7533ba000000226-48-4c858daf2d97
Message-ID: <4C858DA8.3060600@hitachi.com>
Date: Tue, 07 Sep 2010 09:56:08 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCHv11 2.6.36-rc2-tip 4/15]  4: uprobes: x86 specific functions
 for user space breakpointing.
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6> <20100825134210.5447.10126.sendpatchset@localhost6.localdomain6> <87pqwvm8cl.fsf@basil.nowhere.org> <20100903174832.GB14891@linux.vnet.ibm.com> <20100906095319.7c2fa9b0@basil.nowhere.org> <20100906134407.GF14891@linux.vnet.ibm.com>
In-Reply-To: <20100906134407.GF14891@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/09/06 22:44), Srikar Dronamraju wrote:
> [adding Masami and Jim to the copy list] 
> 
>>> I havent tried any fuzz tests with the instruction decoder. But I am
>>> not sure if Masami has tried that out some of these. 
>>> One question: Do you want to test uprobes with crashme or test
>>> instruction decoder with crashme.

As you can see in kernel tree, x86 insn decoder has a test
which decodes vmlinux and compares results with objdump.
Similar tests had been done for glibc etc. by Jim.
But crashme looks better. :)

>> Ideally both, but as a minimum the part that is exposed
>> to user space, that is uprobes.
> 
> Okay, I will test uprobes with crashme.
> 
>>
>>>
>>> validate_insn_32bit is able to identify all valid instructions in a 32
>>> bit app and validate_insn_64bits is a superset of
>>> validate_insn_32bits; i.e it considers valid 32 bit codes as valid
>>> too.
>>
>> How can this be? e.g. 32bit has 1 byte INC/DEC but on 64bit
>> these are REX prefixes and can be in front of nearly anything.
>> So a super set cannot be correct. It has to be either / or.
>>
> 
> You are right, the validate_insn_32bits refers to good_insns_32 and
> validate_insn_64bits refers to good_insns_64 to decode 1 byte
> instructions. Some instructions like 0x06 and 0x0e seem to be valid in
> good_insns_32 but not in good_insns_64. 

Hmm, if you need to validate all instructions, you'd better to
enhance x86 decoder for checking bad instructions.
I think it can be done mostly by adding inat bitflags.

Thank you,

>>> Did you get a chance to look at
>>> validate_insn_32bit/validate_insn_64bits? If you feel that
>>> validate_insn_32bit/validate_insn_64bits? are unable to detect
>>> valid codes, then I will certainly rework.
>>
>> I don't think you can do a 100% solution because for 100%
>> you would need to know the code segment the CPU is going
>> to use later, and that's not possible in advance.
>>
> 
> I think you are referring to RIP related instructions, this how we
> handle them. 
> Please correct us if we are wrong, but here is what we do 
> - While analyzing the instruction, take into account which register acts
>   as the code segment register.
> 
> - When interrupted (but before singlestep), copy the contents of the
>   register which we think acts as code segment register in our
>   above analysis into per-task scratch variable.
> 
> - After singlestepping we retrieve the saved per-task scratch
>   variable into the corresponding register.
> 
>> A heuristic is reasonable (and leave out applications
>> that generate 64bit code from 32bit executables or vice versa)
>> but you need to test the right personality bits for that.
>>
>>
>>>> Also the compat bit is not necessarily set if no system call is
>>>> executing. You would rather need to check the exec_domain.
>>>
>>> Okay, I shall check and revert on this.
>>
>> Hmm actually I double checked and this is a separate bit.
>> So scratch that, TIF_32BIT is ok to test.
> 
> Okay, Thanks for confirming this.
