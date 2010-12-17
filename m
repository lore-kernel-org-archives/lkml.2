Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab0LQEq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 23:46:56 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:62314 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab0LQEqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 23:46:55 -0500
Message-ID: <4D0AEB0F.5020909@kernel.org>
Date: Thu, 16 Dec 2010 20:46:07 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maxim Uvarov <muvarov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
References: <20101207105053.GA2803@redhat.com> <4CFE89FE.1090901@kernel.org> <20101208141942.GA2335@redhat.com> <4D00823A.9050808@kernel.org> <20101209124117.GA6032@redhat.com> <4D01377B.5070809@kernel.org> <20101213100848.GA2237@redhat.com> <4D0663F0.2060103@kernel.org> <4D06783C.6040009@zytor.com> <20101214224135.GB19693@redhat.com> <20101215103954.GA2243@redhat.com> <4D09958D.2040907@kernel.org> <4D0AD976.3020504@zytor.com> <3C6B7683-9CDC-4C4A-A32A-56227DE01387@kernel.org> <4D0AE231.4010804@zytor.com>
In-Reply-To: <4D0AE231.4010804@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2010 08:08 PM, H. Peter Anvin wrote:
> On 12/16/2010 07:58 PM, Yinghai wrote:
>> Please don't do that to 64 bit
>>
>> My big system with 1024g memory and a lot of cards with rhel 6 to make kdump work must have crashkernel=512m and second kernel need to take pci=nomsi
>>
>> Thanks
>>
> 
> Hm, this seems like an epic FAIL.
> 
> First of all, the current code still limits it to 896 MiB, so 512 MiB is
> not a significant restriction.

You only have chance to get 512M under 896M but not under 512M.

> 
> Second, this patch only applies if "crashkernel=" is not specified, so
> it doesn't even apply to your situation.
current code:
        /* 0 means: find the address automatically */
        if (crash_base <= 0) {
                const unsigned long long alignment = 16<<20;    /* 16M */

                /*
                 *  kexec want bzImage is below DEFAULT_BZIMAGE_ADDR_MAX
                 */
                crash_base = memblock_find_in_range(alignment,
                               DEFAULT_BZIMAGE_ADDR_MAX, crash_size, alignment);

                if (crash_base == MEMBLOCK_ERROR) {
                        pr_info("crashkernel reservation failed - No suitable area found.\n");
                        return;
                }
        } else {
                unsigned long long start;

                start = memblock_find_in_range(crash_base,
                                 crash_base + crash_size, crash_size, 1<<20);
                if (start != crash_base) {
                        pr_info("crashkernel reservation failed - memory is in use.\n");
                        return;
                }
        }

first branch : will take only crash_size.
second branch : will need to specify crash_base and crash_size.

> 
> Third, if you have to specify "crashkernel=" that means that there is
> yet another problem here that should be fixed.

no, every kdump need to specify crashkernel=128M or more.

	Yinghai
