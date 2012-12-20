Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab2LTKlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 05:41:17 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:37048 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2LTKlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 05:41:05 -0500
From: "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "jarkko.sakkinen@intel.com" <jarkko.sakkinen@intel.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "agordeev@redhat.com" <agordeev@redhat.com>
Subject: RE: Why Linux kernel forced to enter X2APIC mode( just because of
 booting cpu has supported x2apic) without depending on BIOS' setting in
 MSR->x2apic enablement bit ?
Thread-Topic: Why Linux kernel forced to enter X2APIC mode( just because of
 booting cpu has supported x2apic) without depending on BIOS' setting in
 MSR->x2apic enablement bit ?
Thread-Index: Ac3dBDEGb3itVOfRRseMR0luplSOQwAQ8+AAACKpTSAADAJ0AAAlrhdg
Date: Thu, 20 Dec 2012 10:38:58 +0000
Message-ID: <92645B27BF79D04FBD2B0F8494FFD0F91F2600@G1W3649.americas.hpqcorp.net>
References: <92645B27BF79D04FBD2B0F8494FFD0F91F1CAF@G1W3649.americas.hpqcorp.net>
	<CAE9FiQUT0NZq=6JBAY4mFNx0eBxDr6fNDGQ0GW9OtxUMXJQ21w@mail.gmail.com>
	<92645B27BF79D04FBD2B0F8494FFD0F91F2222@G1W3649.americas.hpqcorp.net>
 <CAE9FiQVAPnc7P91AK8gdwgY-xFsXMM_MxYZAu2sRjsp3EdA96w@mail.gmail.com>
In-Reply-To: <CAE9FiQVAPnc7P91AK8gdwgY-xFsXMM_MxYZAu2sRjsp3EdA96w@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.193.232.27]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBKAfHdd028722


Hi Yinghai, 

	Maybe two days ago, mis-understand the usage of MSR. 
Today, I carefully researched Intel? 64 Architecture x2APIC Specification which is open for all people.

I think current core argument is our BIOS did following judgement ,
but Linux kernel did not(Linux seems just judge BSP supports x2apic mode or not by CPUID method)
++++++++++++
2.9 SYSTEM TRANSITIONS
This section describes implications for the x2APIC across system state transitions - 
specifically initialization and booting. 
The default will be for the BIOS to pass the control to the OS with the local x2APICs 
in xAPIC mode if all x2APIC IDs reported by CPUID.0BH:EDX are less than 255, and 
in x2APIC mode if there are any logical processor reporting its x2APIC ID at 255 or 
greater.
++++++++++++
Our BSP really supports x2apic mode, however,as this spec, our BIOS think some of configuration of server 
could not meet x2apic conditions ,So didn't place local xAPICs into x2apic mode. 
But linux kernel indeed enable x2apic mode(just believe BSP, didn't do above judgement) . so this is the conflict. 

I carefully read Linux kernel source code, I didn't find related code.
BIOS and OS both can configure and enable local xAPICs into x2APIC mode ,but they should follow 
the same spec .  from the spec , we should consider all cores or logical CPUs . 
if I lost some source code , sorry first , could you point me these code ? thanks very much! 

Following are some clarifications for old questions. Thanks very much for Yinghai and others' help.
>From spec:
++++++++++++++++
2.2  DETECTING AND ENABLING X 2APIC
A processor¡¯s support to operate its local APIC in the x2APIC mode can be detected 
by querying the extended feature flag information reported by CPUID. When CPUID 
is executed with EAX = 1, the returned value in ECX[Bit 21] indicates processor¡¯s 
support for the x2APIC mode. If CPUID.(EAX=01H):ECX[Bit 21] is set, then the local 
APIC in the processor supports the x2APIC capability and can be placed into the 
x2APIC mode. This bit is set only when the x2APIC hardware is present. 
? System software can place the local APIC in the x2APIC mode by setting the 
x2APIC mode enable bit (bit 10) in the IA32_APIC_BASE MSR at MSR address 
01BH. The layout for the IA32_APIC_BASE MSR is shown in Figure 2-1.
++++++++++++++++
So ,as above words: 
1, CPUID is just executed to query if CPU has supported x2apic mode.
It is read only.  It is decided by CPU vendor. 
In kernel source  , cpu_has_x2apic() should leverage CPUID interface. 

2, bit 11 and 10 of IA32_APIC_BASE MSR are used to switch to x2apic (EN=1, EXTD=1). 
So I begin to understand that  , OS certainly can control MSR to make CPU enter x2apic mode. 
BIOS also can , OS can also read it and write it as we need. 

> -----Original Message-----
> From: yhlu.kernel@gmail.com [mailto:yhlu.kernel@gmail.com] On Behalf Of
> Yinghai Lu
> Sent: 2012Äê12ÔÂ20ÈÕ 0:06
> 
> how does BIOS claim?
>
Sorry for words , BIOS didn't claim , it just didn't set MSR(en=1 , EXTD=1). OS will read it first. 
This just can indicate that before BIOS passing control to OS, local x2APICs running in xAPIC mode. 


> disable that in CPUID?
> 
No , CPUID is read only , "When CPUID is executed with EAX = 1, the returned value in ECX[Bit 21] indicates processor¡¯s 
support for the x2APIC mode." 
BIOS just will query ,can set.  OS also did like this. 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
