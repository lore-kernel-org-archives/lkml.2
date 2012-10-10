Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab2JJXD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:03:28 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:24778 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617Ab2JJXDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:03:19 -0400
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
        "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>
Subject: RE: [PATCH] fix x2apic defect that Linux kernel doesn't mask 8259A
 interrupt during the time window between changing VT-d table base address
 and initializing these VT-d entries(smpboot.c and apic.c )
Thread-Topic: [PATCH] fix x2apic defect that Linux kernel doesn't mask 8259A
 interrupt during the time window between changing VT-d table base address
 and initializing these VT-d entries(smpboot.c and apic.c )
Thread-Index: AQHNpbB+Rz0tU9hpbEaEjcKbxJEEKZexnhfwgAF40IA=
Date: Wed, 10 Oct 2012 23:02:29 +0000
Message-ID: <92645B27BF79D04FBD2B0F8494FFD0F9102841@G2W2429.americas.hpqcorp.net>
References: <92645B27BF79D04FBD2B0F8494FFD0F90FC806@G2W2429.americas.hpqcorp.net>
 <1349740633.11093.43.camel@sbsiddha-desk.sc.intel.com> 
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.193.232.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9AN6fIg004721


Hi Suresh, 

Now , I want to clarify 2 type of errors :
a) some interrupt doesn't work through Interrupt -remapped IO-APIC. 
b) an interrupt is coming , there is an IO-APIC entry to know how to route it to which CPU, 
but VT-d entry is empty, ITP will report Present bit is clear. 

BIOS should provide simple IO-APIC entries and VT-d entries ,although we don't trust them. 
in the issue that we have happened to is of the second case. 

1 , 
> As I mentioned earlier, the current design already ensures that all the IO-APIC
> RTE's are masked between the time we enable interrupt-remapping to the time
> when the IO-APIC RTE's are configured correctly.
> 
> So I looked at why you are seeing the problem with v2.6.32 but not with the
> recent kernels. And I think I found out the reason.

I want to know what masking IO-APIC means? 
I know from BIOS point of view ,they can disable IO-APIC, just like no IO-APIC equipment. 
So masking IO-APIC entries equals to disable IO-APIC ?  when a interrupt is coming ,  
System doesn't make it through IO-APIC ,and directly to Local APIC ? 
If yes , I have a question : 
I first draw a time line :
    a)                          Clear IO-APIC table                    c)  
    |-------------------------------------------------|------------------------------------------------------|
Change VT-d table                  b)                   create IO-APIC table and VT-d table and initialize them
Empty table                       empty IO-APIC table   
When interrupt is coming between a) and b) ?   I suppose the error : "VT-d entry 's Present bit is clear ).
When interrupt is coming between b) and c) ?   ??
When interrupt is coming after c) point ? 		I suppose everything will work fine.





2,  
We know maybe bios will provide a simple IO-APIC table for us, although we OS doesn't believe it. 
I also did a test : 

 	-  disable x2apic in BIOS. 
find kernel source 3.3.8 , and delete that patch (comment that key line) .
I found that it would display :
     Kernel panic - not syncing: timer doesn't work through Interrupt-remapped IO-APIC.   
But if we disable x2apic in BIOS , rhel6.2 doesn't need any patch, it can run. Very strange. 

	- enable x2apic in BIOS 
	delete your patch from 3.3.8 , same issue with us. VT-d entry error (Present bit0 is clear ).
But it doesn't display the error above(don't tell me it doesn't work through IO-APIC ,  
it represents io-apic entry exists) .


-- Bob(LinBao Zhang)
HP linux kernel enginner

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
