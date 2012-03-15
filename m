Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761845Ab2COMlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 08:41:01 -0400
Received: from mga10.intel.com ([192.55.52.92]:20801 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753071Ab2COMk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 08:40:58 -0400
Subject: Re: [tip:x86/urgent] x86, efi: Delete efi_ioremap() and fix
 CONFIG_X86_32 oops
From: Matt Fleming <matt.fleming@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@kernel.org>, mingo@redhat.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, keithp@keithp.com, rui.zhang@intel.com,
        huang.ying.caritas@gmail.com, stable@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <CAE9FiQXA4+Ubh-6QZv5bouZchR6XZjBSGwR1ox-vug01xiGveA@mail.gmail.com>
References: <1329744626-5036-1-git-send-email-matt@console-pimps.org>
	 <tip-f75bd1837564657b21431e44243e064a77276589@git.kernel.org>
	 <CAE9FiQWFpsZotawqPD4738jTayB=KOGo0W9+AT2go3GYk1v_sQ@mail.gmail.com>
	 <4F45B35D.1010702@zytor.com>
	 <CAE9FiQUbyYYN5orG_RyVm=P-8wNh=YsET1VzGojpFTfJPueHqA@mail.gmail.com>
	 <4F471651.3080609@zytor.com> <4F4C3BA2.1070708@kernel.org>
	 <1331116250.3539.35.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CAE9FiQUoRMA_PYnOEt0ZUYXLq=hNZtDuLifT=+R72HtrwfF6AA@mail.gmail.com>
	 <1331206127.3539.69.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CAE9FiQVZVNARgs0rzgRpRdbSPydCXoeDat=4DLMNFcyBQuqwng@mail.gmail.com>
	 <1331555916.3539.88.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CAE9FiQXA4+Ubh-6QZv5bouZchR6XZjBSGwR1ox-vug01xiGveA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Thu, 15 Mar 2012 12:40:51 +0000
Message-ID: <1331815251.15493.108.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 22:39 -0700, Yinghai Lu wrote:
> On Mon, Mar 12, 2012 at 5:38 AM, Matt Fleming <matt.fleming@intel.com> wrote:
> 
> > Have you tested my patch? Have you hit this bug or is it just from code
> > inspection. I'm starting to feel a bit silly now because I can't see the
> > problem you're describing.
> 
> from code inspection.
> 
> your new init_memory_mapping() will only map mem under max_low_pfn ?

No, that's not true for x86_64, look,

        for (i = 0; i < e820.nr_map; i++) {
                entry = &e820.map[i];
                start = entry->addr;
                end = start + entry->size;

                /* We've already mapped below 1MB */
                if (end < (1 << 20))
                        continue;

                if (start < (1 << 20))
                        start = 1 << 20;
#ifdef CONFIG_X86_32
                /*
                 * The map is sorted, so bail once we hit a region
                 * that's above max_low_pfn.
                 */
                if (start >= max_low_pfn << PAGE_SHIFT)
                        break;

                if (end > max_low_pfn << PAGE_SHIFT)
                        end = max_low_pfn << PAGE_SHIFT;
#endif
                switch (entry->type) {
                case E820_RAM:
                case E820_RESERVED_EFI:
                case E820_ACPI:
                case E820_NVS:
                        last_pfn_mapped = __init_memory_mapping(start, end);
                        break;
                default:
                        continue;
                }

                if (end <= max_low_pfn << PAGE_SHIFT)
                        max_low_pfn_mapped = last_pfn_mapped;
        }

The max_low_pfn checks are only for CONFIG_X86_32 so that the behaviour
is the same as before this patch, i.e. we don't try to map above
max_low_pfn.

> and before that calling for x86_64, max_low_pfn is not updated to max_pfn yet.
> 
> +       max_pfn_mapped = init_memory_mapping();
> 
>  #ifdef CONFIG_X86_64
>        if (max_pfn > max_low_pfn) {
> -               max_pfn_mapped = init_memory_mapping(1UL<<32,
> -                                                    max_pfn<<PAGE_SHIFT);
>                /* can we preseve max_low_pfn ?*/
>                max_low_pfn = max_pfn;
>        }
> 
> Please do find one system with more than 4G to test the code.

I'm ordering some parts so that I can test this out.


