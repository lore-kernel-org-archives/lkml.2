Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab2JJA2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 20:28:19 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:11718 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab2JJA2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 20:28:16 -0400
From: "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Croxon, Nigel" <nigel.croxon@hp.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "agordeev@redhat.com" <agordeev@redhat.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: RE: [PATCH] fix x2apic defect that Linux kernel doesn't mask 8259A
 interrupt during the time window between changing VT-d table base address
 and initializing these VT-d entries(smpboot.c and apic.c )
Thread-Topic: [PATCH] fix x2apic defect that Linux kernel doesn't mask 8259A
 interrupt during the time window between changing VT-d table base address
 and initializing these VT-d entries(smpboot.c and apic.c )
Thread-Index: AQHNpbB+Rz0tU9hpbEaEjcKbxJEEKZexnhfw
Date: Wed, 10 Oct 2012 00:26:53 +0000
Message-ID: <92645B27BF79D04FBD2B0F8494FFD0F90FE41E@G2W2429.americas.hpqcorp.net>
References: <92645B27BF79D04FBD2B0F8494FFD0F90FC806@G2W2429.americas.hpqcorp.net>
 <1349740633.11093.43.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1349740633.11093.43.camel@sbsiddha-desk.sc.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.193.232.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9A0SOjm008201

Hi Suresh, 

	Thanks very much for your reply!
I tested this patch in 2.6.32 with our machine , it can indeed can resolve current issue. that 's good. 
I also check 3.x version of kernel source , for example , 3.3.8 and 3.0.0 , they indeed include similar patch , 
I think the key action is this line :
+	/*
+	 * The number of IO-APIC IRQ registers (== #pins):
+	 */
+	nr_ioapic_registers[idx] = entries;

In 3.3.8 , it is like this:
			/*
4011         * The number of IO-APIC IRQ registers (== #pins):
4012         */
4013        ioapics[idx].nr_registers = entries;
I also use 3.3.8 to test , no modification don't reproduce our issue. 
If I comment this line (ioapics[idx].nr_registers = entries;) , it will reproduce the problem that occurs in 2.6.32. 
so this can prove that your patch should work for 2.6.x kernel. 

But I am not sure why it can work. Let's discuss again. I am researching the whole source again. 
It seems that we have 2 directions to fix current problem :
a) your patch : all the IO-APIC RTE's are masked between the time we enable interrupt-remapping to the time 
> when the IO-APIC RTE's are configured correctly.
b) my patch mask interrupt during VT-d table base address changing and VT-d entries initialized successfully. 
I suppose during the time window , we should disable 8259A interrupt. 

> As I mentioned earlier, the current design already ensures that all the IO-APIC
> RTE's are masked between the time we enable interrupt-remapping to the time
> when the IO-APIC RTE's are configured correctly.
> 
So , we can think ,as your patch , during the window , IO-apic is useless or we can think IO-APIC doesn't exist ? 
Could you mind please sharing your design details ? thanks very much! 

> So I looked at why you are seeing the problem with v2.6.32 but not with the
> recent kernels. And I think I found out the reason.
> 
> 2.6.32 kernel is missing this fix,
> 
Yes, 2.6.32 doesn't have this patch. 3.x.x indeed have it. 

> Because of this, in v2.6.32, mask_IO_APIC_setup() is not working as expected
> as nr_ioapic_registers[] are not yet initialized and thus the io-apic RTE's are not
> masked as expected.
> 
> We just need the last hunk of that patch, I think.
> 
> Can you please apply the appended patch to 2.6.32 kernel and see if the issue
> you mentioned gets fixed? If so, we can ask the -stable and OSV's teams to
> pick up this fix.
Yes , it can resolve current issue. 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
