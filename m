Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab0CTEIi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 00:08:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50307 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab0CTEIh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 00:08:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=d3hEWPFPKWm1Vefy3CLBBxKiHI1bVd9ys0sxORrG4SEfb0vTLPnWHcBrPYPvjwR3Kd
         NYsneEGDfsu/y4LkU20dun2rZwPm6D3mptM4AKoVbZeCExZtyF8QhRE6oaQet0Hrvxul
         5eYQjYZD5uHcy7S6aTFPFN3V46eGMgo3nkgRE=
MIME-Version: 1.0
In-Reply-To: <4BA3FBB5.2050008@zytor.com>
References: <1268936453-3727-1-git-send-email-brgerst@gmail.com>
	 <1268936453-3727-2-git-send-email-brgerst@gmail.com>
	 <4BA3FBB5.2050008@zytor.com>
Date: Sat, 20 Mar 2010 00:08:36 -0400
Message-ID: <73c1f2161003192108n72311e00h49fcf9eac5a2b4fc@mail.gmail.com>
Subject: Re: [PATCH 1/5] x86-32: Split cache flush handler from simd handler
From: Brian Gerst <brgerst@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 6:33 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/18/2010 11:20 AM, Brian Gerst wrote:
>> Make the cache flush handler a seperate function, and use
>> an alternative to call the appropriate handler.
>>
>> +#ifdef CONFIG_X86_32
>> +dotraplinkage void
>> +do_cache_flush_error(struct pt_regs *regs, long error_code)
>> +{
>> +     conditional_sti(regs);
>> +
>> +     /*
>> +      * Handle strange cache flush from user space exception.
>> +      * This is undocumented behaviour.
>> +      */
>> +     if (regs->flags & X86_VM_MASK) {
>> +             handle_vm86_fault((struct kernel_vm86_regs *)regs, error_code);
>> +             return;
>> +     }
>> +     current->thread.trap_no = 19;
>> +     current->thread.error_code = error_code;
>> +     die_if_kernel("cache flush denied", regs, error_code);
>> +     force_sig(SIGSEGV, current);
>> +}
>> +#endif
>
> Does anyone have *any idea* what processor this applies to?  I've
> tracked the code back all the way to the original inclusion in the
> kernel, and there isn't even the slightest hint.
>
> The comment, of course, is a great example on how *not* to write
> comments... it should have mentioned the CPU in question.

This thread appears to describe the problem:
http://marc.info/?t=104960872800014&r=1&w=2

And the initial patch:
http://marc.info/?l=linux-kernel&m=104960870106838&w=2

It looks like to me, that an AMD 486 clone has an erratum where the
invd instruction from userspace generates exception 19 (13 hex)
instead of #GP (13 dec).

--
Brian Gerst
