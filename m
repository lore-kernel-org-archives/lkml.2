Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab1IMVNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 17:13:31 -0400
Received: from mail-gx0-f170.google.com ([209.85.161.170]:49599 "EHLO
	mail-gx0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab1IMVNa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 17:13:30 -0400
MIME-Version: 1.0
In-Reply-To: <4E6A0700.9030401@suse.cz>
References: <1313800642-32418-1-git-send-email-lacombar@gmail.com>
	<4E6A0700.9030401@suse.cz>
Date: Tue, 13 Sep 2011 17:13:29 -0400
Message-ID: <CACqU3MUfJAeur_65i5vDegu1d1VqAdq15EedfX9A3w52J23MPg@mail.gmail.com>
Subject: Re: [RFC] Kbuild: allow code re-use across different directories
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/9/9 Michal Marek <mmarek@suse.cz>:
> On 20.8.2011 02:37, Arnaud Lacombe wrote:
>> Hi folks,
>>
>> The attached patch modify Kbuild to allow to directly re-use code in multiple
>> directory without having to go through a copy. Technically, it changes Kbuild to
>> use by default the VPATH feature of GNU make and provides accessors for Makefile
>> to change it indirectly.
>>
>> Considering:
>>
>> arch/foo/lib:
>> fancy.c
>>
>> We want to be able to build it with -DPANTS=32 in the kernel, but the
>> bootloader requires -DPANTS_SIZE=30.
>>
>> Currently we would do, either:
>>
>> arch/foo/lib/Makefile
>> LDFLAGS_fancy.o := -DPANTS=32
>> obj-y += fancy.o
>>
>> and, either:
>>
>> arch/foo/boot/Makefile:
>> LDFLAGS_fancy.o := -DPANTS=30
>> obj-y += fancy.o
>> $(obj)/fancy.c: $(srctree)/arch/foo/lib/fancy.c
>>       $(call cmd,shipped)
>>
>> or
>>
>> arch/foo/boot/Makefile:
>> LDFLAGS_fancy.o := -DPANTS=30
>> obj-y += fancy.o
>> $(obj)/fancy.o: $(srctree)/arch/foo/lib/fancy.c
>>       $(call cmd,cc_c_o)
>>
>> The former implies an extra copy of the source file, the latter expose Kbuild
>> internal function.
>>
>> With the attached patch, we would do:
>>
>> arch/foo/boot/Makefile:
>> LDFLAGS_fancy.o := -DPANTS=30
>> obj-y += fancy.o
>> vpath-y += $(srctree)/arch/foo/lib
>>
>> and let GNU make do the job.
>
> I like this. The only issue I can think of right now, is that if you add
> a large directory to vpath-y, then it would be easy to accidentally
> reuse more files from that directory than intended. But that could be
> easily prevented by isolating those reusable source files.
>
I do not think it is that dangerous. We enforce unique access to VPATH
and we still prioritize $(src) over any other specified path.

That said, what would you want to pull the patch into -next, beside
kernel.org being up ?

Thanks,
 - Arnaud
