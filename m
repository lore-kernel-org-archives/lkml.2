Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab2LRJvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 04:51:24 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:37303 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab2LRJvV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 04:51:21 -0500
From: "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "jarkko.sakkinen@intel.com" <jarkko.sakkinen@intel.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "agordeev@redhat.com" <agordeev@redhat.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>
Subject: Why Linux kernel forced to enter X2APIC mode( just because of
 booting cpu has supported x2apic) without depending on BIOS' setting in
 MSR->x2apic enablement bit ?
Thread-Topic: Why Linux kernel forced to enter X2APIC mode( just because of
 booting cpu has supported x2apic) without depending on BIOS' setting in
 MSR->x2apic enablement bit ?
Thread-Index: Ac3dBDEGb3itVOfRRseMR0luplSOQw==
Date: Tue, 18 Dec 2012 09:50:44 +0000
Message-ID: <92645B27BF79D04FBD2B0F8494FFD0F91F1CAF@G1W3649.americas.hpqcorp.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.193.232.27]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suresh and other guys , 
	
	In 3.4.4/3.6.6 ,I found a x2apic issue . if I am wrong , sorry first , and welcome your correction . thanks for your forwarding other maintainers. 
I am testing a server , its BIOS is like this:
a) If BIOS think the system is of x2apic , it will set x2apic enablement bit in MSR and create x2apic ACPI tables and pass control to OS with x2apic mode
b) If BIOS feel the system doesn't meet x2apic conditions , it will not set x2apic enablement bit in MSR ,and pass control to OS with xapic mode. 

It seems that MSR should be interface to OS to use. OS should leverage this, but it seems not. 
In linux kernel source code , 
We see:
void check_x2apic(void)  
{
	if (x2apic_enabled()) {  // this depends on 2 conditions : cpu has supported x2apic or not, bios setting MSR bit or not .
		pr_info("x2apic enabled by BIOS, switching to x2apic ops\n");
		x2apic_preenabled = x2apic_mode = 1;
	}
It seems that Linux kernel will follow BIOS' result in early booting. 

But I found that in other source : enable_IR_x2apic() , linux kernel obviously discard BIOS' result like this:

	#define x2apic_supported()	(cpu_has_x2apic)  // just depends on if booting CPU has supported x2apic
Enable_IR_x2apic {
........
	x2apic_enabled = 1;
	if (x2apic_supported() && !x2apic_mode) {  //x2apic_mode depends on BIOS's MSR. 
		x2apic_mode = 1;
		enable_x2apic();					// OS will write MSR->x2apic enablement bit and print 
		pr_info("Enabled x2apic\n");
	}
......
}

void enable_x2apic(void)
{
	u64 msr;

	rdmsrl(MSR_IA32_APICBASE, msr);
	if (x2apic_disabled) {
		__disable_x2apic(msr);
		return;
	}

	if (!x2apic_mode)
		return;

	if (!(msr & X2APIC_ENABLE)) {
		printk_once(KERN_INFO "Enabling x2apic\n");
		// linux kernel will write MSR->x2apic_enable ,work around BIOS , this is reasonable ?
		wrmsrl(MSR_IA32_APICBASE, msr | X2APIC_ENABLE);            
			}
}
I am very surprised for this ,why BIOS has claimed that BIOS didn't support x2apic , but Linux kernel will force enabling x2apic 
(although booting CPU has supported x2apic) ?
I have one machine , in booting log , 
There is no " x2apic enabled by BIOS, switching to x2apic ops "
But later , linux kernel will print 
" [    0.464649] parse_iosapics: ecap f0207e
[    0.469728] IOAPIC id 8 under DRHD base  0xa8000000 IU 0
[    0.576731] IOAPIC id 0 under DRHD base  0xa8000000 IOMMU 0
[    0.584065] parse_io_apic: io_apic 2 nr 2
[    0.589590] Enabled IRQ remapping in x2apic mode
[    0.595663] Enabling x2apic
[    0.599337] Enabled x2apic
[    0.603007] Switched APIC routing to cluster x2apic."  ( I can add x2apic_phys to force using physical mode).


1, I quite worry about this , try to think , BIOS didn't enable x2apic , it just did enable xAPIC mode , 
it didn't create ACPI tables of x2apic. In this case, how Linux kernel can run normally in x2apic mode ?  
in fact, in this machine , Linux kernel didn't run into some issues ,but I still think this is a potential defect. 
2, why Linux kernel first depends on MSR and later will discard MSR ?  is there any history ?  
Linux kernel wants to completely discard MSR checking in future ?
3, anybody test machines which support x2apic ? do you have similar problems ?  
in these machines , will you check MSR bit ?


-- Bob(LinBao Zhang)
HP linux kernel enginner


