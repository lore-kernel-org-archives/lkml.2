Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024Ab0HDSM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:12:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32906 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab0HDSM0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 14:12:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Kw+mGF6259cN71HCJAxZgaSZk4jaJtnwYNK8gRoWkIHFGd+V50jXJ+WWPmcOUbWotv
         aX1bYL5L5+vpFVmLoKHjfckIC7DJo5tmtyARcHM7y8DnpM5Q5M8810RlvVmR7YDUWAZY
         iV9ZTnmPhYQK3N7hBgwZWP3apGj4auRJxaFOs=
MIME-Version: 1.0
In-Reply-To: <20100804115658.GA21357@merkur.ravnborg.org>
References: <AANLkTilVZ3GCU_hsfVNeR4oG6ETREb9UeJ0Cv_5hSwVZ@mail.gmail.com> 
	<20100804115658.GA21357@merkur.ravnborg.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 4 Aug 2010 14:12:03 -0400
Message-ID: <AANLkTikz7pvirg7VUxrm-6v=yrLwHy4UeaJTS0wz3BLc@mail.gmail.com>
Subject: Re: missing .data.shared_align placement in vmlinux
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 4, 2010 at 07:56, Sam Ravnborg wrote:
> On Fri, May 21, 2010 at 04:58:53PM -0400, Mike Frysinger wrote:
>> am i missing something or does the .data.shared_align section lack
>> definition in vmlinux.lds.h and all arch vmlinux.lds.S files ?
>>
>> with the recent change "net: remove time limit in process_backlog()",
>> the softnet_data variable changed from "DEFINE_PER_CPU()" to
>> "DEFINE_PER_CPU_ALIGNED()" which moved it from the .data section to
>> the .data.shared_align section.  i'm not saying this patch is wrong,
>> just that is what caused me to notice this larger problem.  no one
>> else in the kernel is using this aligned macro variant, so i imagine
>> that's why no one has noticed yet.
>>
>> since .data.shared_align isnt declared in any vmlinux files that i can
>> see, the linker just places it last.  this "just works" for most
>> people, but when building a ROM kernel on Blackfin systems, it causes
>> section overlap errors:
>> bfin-uclinux-ld.real: section .init.data [00000000202e06b8 ->
>> 00000000202e48b7] overlaps section .data.shared_aligned
>> [00000000202e06b8 -> 00000000202e0723]
>> i imagine other arches which support the ROM config option and thus do
>> funky placement would see similar issues ...
>>
>> on x86, it is stuck in a dedicated section:
>>   [ 8] .data             PROGBITS        ffffffff810ec000 2ec000
>> 0303a8 00  WA  0   0 4096
>>   [ 9] .data.shared_alig PROGBITS        ffffffff8111c3c0 31c3c0
>> 0000c8 00  WA  0   0 64
>>
>> the ifdef forest in asm-generic/percpu.h is beyond a quick glance &
>> fix, so i leave it up to someone else ;)
>
> as there any resolution on this?
> I briefly looked at it some time ago.
> And it looks like a plain oversight.

no, it's still broken in 2.6.35 :(
$ make ARCH=blackfin BF537-STAMP_defconfig
$ make ARCH=blackfin -s -j4
$ readelf -WS vmlinux | grep '\<data\>'
  [10] .data             PROGBITS        0018369c 17269c 012964 00  WA  0   0  4
  [11] .data..shared_aligned PROGBITS        00196000 185000 00006c 00
 WA  0   0  4
-mike
