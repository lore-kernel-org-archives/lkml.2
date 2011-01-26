Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab1AZWc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 17:32:59 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53206 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab1AZWc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 17:32:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=w6u0RcdVfy8eTa9C+9mpUGzY5EwihcAawCqwmC75oQAyfES7E/crJc+vyHHOBcLp05
         5Fi6Zqsn4nV96JKlaouXdqrswrT2KUncvy8JzWVz2/riyfDvaiiY3yJOEB3WYOBRBETA
         CubmL7CO4Wb80GW8QJNgdDPTh7ZciWmTh4q/U=
Message-ID: <4D40A116.6040209@gmail.com>
Date: Wed, 26 Jan 2011 16:32:54 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: John Linn <John.Linn@xilinx.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lennert Buijtenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH 0/8] Basic ARM device tree support
References: <20110118195933.13011.56098.stgit@localhost6.localdomain6> <00bcd596-2108-4c54-92d3-7fda39e333e3@VA3EHSMHS015.ehs.local>
In-Reply-To: <00bcd596-2108-4c54-92d3-7fda39e333e3@VA3EHSMHS015.ehs.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2011 02:04 PM, John Linn wrote:
>> -----Original Message-----
>> From: Grant Likely [mailto:glikely@secretlab.ca] On Behalf Of Grant Likely
>> Sent: Tuesday, January 18, 2011 1:29 PM
>> To: linux-arm-kernel@lists.infradead.org
>> Cc: Nicolas Pitre; Russell King; Catalin Marinas; devicetree-discuss@lists.ozlabs.org; linux-
>> kernel@vger.kernel.org; Olof Johansson; Jeremy Kerr; John Linn; Lennert Buijtenhek
>> Subject: [PATCH 0/8] Basic ARM device tree support
>>
>> It's been a while since these patches have been circulated for review.
>> Much has changed since the last posting and there are no longer any
>> ugly hacks or workarounds to it working.  From my viewpoint, these
>> patches are complete and ready to be used.
>>
>> This patch series allows CONFIG_OF to be enabled on ARM and allows the
>> kernel to accept a dtb pointer from boot firmware instead of atags.
>> If a dtb is passed, then the kernel will use the root 'compatible'
>> property to find a matching machine_desc, and it will use it to obtain
>> the memory layout, initrd location and kernel parameters string.
>>
>> Only limited device tree support is enabled here.  It does not perform
>> any kind of device registration from device tree data.  That support
>> will be enabled in a later patch set.  Right now those patches depend
>> on the common struct clk patches that Jeremy is working on, so I'm not
>> going to post them yet.  Rather, this series is a stable base that
>> other engineers can use to start working on device tree support for
>> their platforms.
>>
>> Tested on Versatile (qemu) and nVidia Tegra Harmony.  Kernel compiles
>> an boot with CONFIG_OF both on and off, both with and without passing
>> a device tree blob.
>
> Tested on Xilinx platform.  Did see an issue with loading the device
> tree blob into higher memory.  At address 0 there was no issue.
>

I have a fix for this. The issue is the early mmu page table needs to 
map the dtb. I later realized this is also may be problem for ATAGs as 
well, so I planned to re-work to make it unconditional and work for 
ATAGs. Or perhaps ATAGs only get accessed with the MMU on later than the 
dtb and everything is okay?

This applies to the DT patch set prior to the one Grant sent out
this week, so it may need updates.

From: Rob Herring <rob.herring@calxeda.com>
Date: Tue, 5 Oct 2010 10:32:51 -0500
Subject: [PATCH] arm/dt: map devtree blob in initial page table

If the DTB is not in 1st 1MB of RAM, it will not be mapped before
memblock is setup, so map it early. We assume the dtb is less than
1MB and map 2MB so it can be at any alignment.

Some assembly optimizations from Nicolas Pitre.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
  arch/arm/kernel/head.S |   13 +++++++++++++
  1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 0480f25..1fcb962 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -228,6 +228,19 @@ __create_page_tables:
  	.endif
  	str	r6, [r0]

+#ifdef CONFIG_OF_FLATTREE
+	/* Make sure DT blob is mapped */
+	adr	r0, __devtree_pointer
+	ldr	r0, [r0]
+	mov	r0, r0, lsr #20
+	mov	r0, r0, lsl #20
+	add	r3, r0, #PAGE_OFFSET
+	add	r3, r4, r3, lsr #18
+	orr	r6, r7, r0
+	str	r6, [r3]
+	add	r6, r6, #0x100000
+	str	r6, [r3, #4]
+#endif
  #ifdef CONFIG_DEBUG_LL
  #ifndef CONFIG_DEBUG_ICEDCC
  	/*
-- 
