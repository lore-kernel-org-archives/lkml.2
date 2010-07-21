Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760382Ab0GUQRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 12:17:12 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:52926
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759108Ab0GUQRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 12:17:06 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz1432N98dN936eMzz1202hzzz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L5X185-02-VIU-02
X-M-MSG: 
Date: Wed, 21 Jul 2010 18:16:54 +0200
From: Robert Richter <robert.richter@amd.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] x86, xsave: some code cleanups and reworks
Message-ID: <20100721161654.GR26154@erda.amd.com>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
 <20100720192717.GC6227@lenovo>
 <20100720194606.GO26154@erda.amd.com>
 <20100720200729.GD6227@lenovo>
 <20100720201740.GE6227@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100720201740.GE6227@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.07.10 16:17:40, Cyrill Gorcunov wrote:

> note the snippet
> 
> 		if (cpu == boot_cpu_id)
> 			switch_to_new_gdt(cpu);
> 
> but cycle of assignment is done over all possible cpus so
> smp_processor_id will be = 0 for BP but definitely it's
> confusing and better to check for BP via explicit cpu == boot_cpu_id
> I think. Though I might be missing something.

This in smpboot.c makes it clear:

void __cpuinit smp_store_cpu_info(int id)
{
        struct cpuinfo_x86 *c = &cpu_data(id);

        copy_cpuinfo_x86(c, &boot_cpu_data);
        c->cpu_index = id;
        if (id != 0)
                identify_secondary_cpu(c);
}

So boot cpu id is always 0.

Also note, as Hans Peter already pointed out, this for CONFIG_SMP:

 &cpu_data(0) != &boot_cpu_data

The data in boot_cpu_data is (partly) already available after
early_cpu_init(). It is later copied to the &cpu_data() structures. So
boot_cpu_data should be used for init code.

Also, to make the test obviously, instead of testing (cpu ==
boot_cpu_id) I rather tend to use an is_boot_cpu() macro as you
suggested in your earlier mail.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

