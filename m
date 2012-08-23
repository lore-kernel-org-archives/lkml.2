Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602Ab2HWXrC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 19:47:02 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53565 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab2HWXq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 19:46:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120823223514.GA6502@jshin-Toonie>
References: <1344983957-4996-1-git-send-email-jacob.shin@amd.com>
	<1344983957-4996-4-git-send-email-jacob.shin@amd.com>
	<50356BA9.5030906@zytor.com>
	<20120823145043.GA4671@jshin-Toonie>
	<50364E9E.6020104@zytor.com>
	<20120823223514.GA6502@jshin-Toonie>
Date: Thu, 23 Aug 2012 16:46:57 -0700
X-Google-Sender-Auth: 5-HGmaZX2JtUR7jolPI8uroqWqo
Message-ID: <CAE9FiQU_oMu-UdZyRLduM38seMeUmWo357YAjx2rxv+YFYNCkQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86: Only direct map addresses that are marked as E820_RAM
From: Yinghai Lu <yinghai@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Tejun Heo <tj@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 3:35 PM, Jacob Shin <jacob.shin@amd.com> wrote:
>> >So I believe in V2 of the patchset this was done, however, Dave Young
>> >from redhat reported that it broke their KVM guest with a user supplied
>> >memory map that looked like this:
>> >
>> >>>[    0.000000] e820: user-defined physical RAM map:
>> >>>[    0.000000] user: [mem 0x0000000000010000-0x000000000009dbff] usable
>> >>>[    0.000000] user: [mem 0x0000000024000000-0x0000000033f6bfff] usable
>> >
>
> I looked into this a bit more, and I think what's happening is that this
> user defined memory map leaves out the region where the kernel is loaded on
> to during the boot process. The kernel and the direct mapped page tables up
> to initial max_pfn_mapped reside somwhere under 512M (KERNEL_IMAGE_SIZE),
> I guess it depends on how big your uncompressed kernel is.
>
> And at the first attempt to set_fixmap_nocache(FIX_APIC_BASE, address) in
> arch/x86/apic/apic.c: register_lapic_address runs into badness because the
> memory region where the initial page tables live is no longer mapped
> because of the above user supplied memory map.
>
> So I guess there is a disconnect between really early code that seems to
> rely on the boot loader as to where in physical memory it resides and its
> initial page tables live, and the later memory initialization code where
> it looks at the E820 (and here user can interject their own memory map
> using the command line arguments)
>
> Not really sure how to handle this case .. any advice?

Maybe you can just put back kernel range to E820 as RAM?

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f4b9b80..e1a1f28 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -830,6 +830,9 @@ void __init setup_arch(char **cmdline_p)
        insert_resource(&iomem_resource, &code_resource);
        insert_resource(&iomem_resource, &data_resource);
        insert_resource(&iomem_resource, &bss_resource);
+       e820_add_range(code_resource.start, code_resource.end -
code_resource.start + 1, E820_RAM);
+       e820_add_range(data_resource.start, data_resource.end -
data_resource.start + 1, E820_RAM);
+       e820_add_range(bss_resource.start, bss_resource.end -
bss_resource.start + 1, E820_RAM);

        trim_bios_range();
 #ifdef CONFIG_X86_32
