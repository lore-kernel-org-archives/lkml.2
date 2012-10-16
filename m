Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab2JPGij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 02:38:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57247 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab2JPGii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 02:38:38 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Date: Tue, 16 Oct 2012 15:38:17 +0900 (JST)
Message-Id: <20121016.153817.42643171.d.hatayama@jp.fujitsu.com>
To: fenghua.yu@intel.com
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, x86@kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, len.brown@intel.com,
        vgoyal@redhat.com, ebiederm@xmission.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Subject: Re: [PATCH v1 0/2] x86, apic: Disable BSP if boot cpu is AP
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C7122030B0DD91@ORSMSX105.amr.corp.intel.com>
References: <3E5A0FA7E9CA944F9D5414FEC6C7122030B0DD68@ORSMSX105.amr.corp.intel.com>
	<20121016.140313.279437418.d.hatayama@jp.fujitsu.com>
	<3E5A0FA7E9CA944F9D5414FEC6C7122030B0DD91@ORSMSX105.amr.corp.intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: RE: [PATCH v1 0/2] x86, apic: Disable BSP if boot cpu is AP
Date: Tue, 16 Oct 2012 05:14:46 +0000

>> >> My motivation is to use multiple CPUs in order to quickly generate
>> >> crash dump on the machine with huge amount of memory. I assume such
>> >> machine tends to also have a lot of CPUs. So disabling one CPU would
>> >> be no problem.
>> >
>> > Luckily you don't need to disable any CPU to archive your goal with
>> > the BSP hotplug pachest:)
>> >
>> > On a dual core/single thread machine, this means you get 100%
>> performance
>> > boost with BSP's help.
>> >
>> > Plus crash dump kernel code is better structured by not treating BSP
>> > specially.
>> >
>> 
>> Hello Fenghua.
>> 
>> I've of course noticed your patch set and locally tested, but I saw
>> NMI to BSP failed in the 2nd kernel. I'll send a log to you later.
>> 
>> BTW, I tested with your previous v8 patch set. Did you change
>> something during v8 to v9 relevant to this issue?
> 
> In the patch 0/12 in v9, I describe what change is in v9 on the top of v8:
> 
> v9: Add Intel vendor check to support the feature on Intel platforms only.
> 
> Did you see the BSP wake up failure on the latest tip tree?
> 
> There is a rcu regression issue which prevents BSP from waking up in 3.6.0.
> The issue has been fixed on 10/12. The commit is a4fbe35a. Please make sure
> your tip tree has this commit.
> 

Thanks for pointing out this. And I've recalled my investigation in
the past now. So I want to stop retrying your patch v9 now. This NMI
method is definitely not applicable to 2nd kernel without any change.

Your NMI method assumes BSP thread is halting in play dead loop. But
on the 2nd kernel, BSP is halting in the 1st kernel (or possibly in a
fatail system error). Even if throwing NMI to BSP, it goes back to the
1st kernel soon again. I at least confirmed NMI handler is executed in
this case.

Also, throwing NMI changes stack in the 1st kernel, which is
unpermissible from kdump's perspective. But x86_64 uses Interrupt
Stack Table (IST), in which stack switching is not performed. So 2nd
kernel's stack is used at least on x86_64.

To sum up, to apply NMI method in the 2nd kernel, I think it necessary
to modify contexts pushed on the stack so execution goes to the 2nd
kernel's start_secondary() while initializing its state
appropreately.

Also I think it necessary to discuss whether this NMI method is
reliable enough for kdump use.

Thanks.
HATAYAMA, Daisuke

