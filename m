Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab0GZQ7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 12:59:21 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:56870 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab0GZQ7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 12:59:20 -0400
Message-ID: <4C4DBE8E.70102@linux.vnet.ibm.com>
Date: Mon, 26 Jul 2010 18:57:50 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Karol Lewandowski <k.lewandowsk@samsung.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: GCOV doesn't seem to work on ARM with kernel 2.6.35-rc6
References: <4C4D6458.6040402@samsung.com> <4C4D6554.30707@samsung.com>
In-Reply-To: <4C4D6554.30707@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karol Lewandowski wrote:
> On 07/26/2010 12:32 PM, Karol Lewandowski wrote:
>> I'm trying to use code coverage measurements with mainline Linux kernel
>> 2.6.35-rc6 on ARM platform (specifically on Samsung's S5PC110 board).
>>
>> I've enabled following in my .config:
>>
>> CONFIG_GCOV_KERNEL=y
>> CONFIG_DEBUG_FS=y
>>
>> After successful boot I see no gcov-related files other than
>> /sys/kernel/debug/gcov/reset.
>>
>>  From my knowledge (and from my previous experience with out-of-tree
>> gcov patchset) whole directory structure shall be created along with
>> .gcda files and various symlinks.

This expectation is correct.

> I forgot to add that I've added "GCOV_PROFILE := y" to at least
> 
>    fs/Makefile
>    kernel/Makefile
> 
> and few others.  Thus, I expect to find something more than just
> ./reset file.

I just tested gcov support for 2.6.35-rc6 on s390 and it works without
a problem. My assumption would be that you are using an EABI-GCC to
compile your kernel. Those compilers name their constructor symbols
differently than the vanilla GCC so that the whole constructor calling
mechanism on which the gcov support relies, will fail. If that is
indeed the case, the following testing patch should solve your
problem:


---
 include/asm-generic/vmlinux.lds.h |    1 +
 kernel/module.c                   |    6 ++++++
 2 files changed, 7 insertions(+)

--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -443,6 +443,7 @@
 #define KERNEL_CTORS()	. = ALIGN(8);			   \
 			VMLINUX_SYMBOL(__ctors_start) = .; \
 			*(.ctors)			   \
+			*(.init_array)			   \
 			VMLINUX_SYMBOL(__ctors_end) = .;
 #else
 #define KERNEL_CTORS()
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2405,6 +2405,12 @@ static noinline struct module *load_modu
 #ifdef CONFIG_CONSTRUCTORS
 	mod->ctors = section_objs(hdr, sechdrs, secstrings, ".ctors",
 				  sizeof(*mod->ctors), &mod->num_ctors);
+	if (!mod->num_ctors) {
+		/* Could be an EABI compiler. */
+		mod->ctors = section_objs(hdr, sechdrs, secstrings,
+					  ".init_array", sizeof(*mod->ctors),
+					  &mod->num_ctors);
+	}
 #endif
 
 #ifdef CONFIG_TRACEPOINTS

