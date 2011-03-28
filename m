Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab1C1SKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:10:06 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45471 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab1C1SKE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:10:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=k7cikWRAcjbZIaMPgzDfaGi1DRiS8JKgnvSHHqAexofl4EDQzTVQIHZ9F+n4Tl+O0L
         hxspKQ7ui71cmrtL/A7UYC15CBiaXrFjh3NeHRMKMqcam+VkXKzdLQ2K+dSM39j9v8SJ
         eCAsbqIaUP6TCVTSVKNEqVtfVm0KHn3JpOGI8=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1103281947320.2774@localhost6.localdomain6>
References: <cover.1301324270.git.luto@mit.edu> <4fef5b568241665e1d2bca64f73a437bafb574c4.1301324270.git.luto@mit.edu>
 <alpine.LFD.2.00.1103281947320.2774@localhost6.localdomain6>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 28 Mar 2011 14:09:43 -0400
X-Google-Sender-Auth: vFyYYvN7rkRpO8dU9NBhKMyhoNY
Message-ID: <AANLkTikzF27S_cBxPXyd_UUVm8Or-Uyb+BqOCDyGMCbB@mail.gmail.com>
Subject: Re: [PATCH 3/6] x86-64: Put vsyscall_gtod_data at a fixed virtual address
To: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 1:49 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 28 Mar 2011, Andy Lutomirski wrote:
>>
>> +      /* This address must be kept in sync with arch/x86/vdso/vextern.h */
>
> This is the worst idea ever. Breakage is lurking by making something:
> Must be kept in sync ...
>
>> +     .vsyscall_gtod_data ADDR(.vsyscall_0) + 3072 + 256:
>
> And this magic constant is what ? Something which will blow up sooner
> than later.

Fair enough.  The constant is pretty much arbitrary, except that it
has to be the same in both places.

Would you object less if I added a new header that just contained
offsets within the vsyscall page to clock, vgetcpu_mode, and
gtod_data?  That way I could remove the entire VMAGIC mechanism,
everything gets faster, and there's nothing to be kept in sync.

I just checked and the linker will error out of any of these data
structures get too large to fit in their assigned places.  It looks
like this:

ld: section .vsyscall_1 loaded at [00000000018ba400,00000000018ba43d]
overlaps section .vsyscall_gtod_data loaded at
[00000000018ba140,00000000018ba5d7]
ld: .tmp_vmlinux1: section .vsyscall_1 vma 0xffffffffff600400 overlaps
previous sections

(That's on an unmodified kernel, but the same thing would happen with
hardcoded offsets.)

--Andy
