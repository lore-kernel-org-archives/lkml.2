Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab2JPFQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 01:16:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43230 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab2JPFQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 01:16:08 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Date: Tue, 16 Oct 2012 14:15:47 +0900 (JST)
Message-Id: <20121016.141547.73846029.d.hatayama@jp.fujitsu.com>
To: fenghua.yu@intel.com
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, x86@kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, len.brown@intel.com,
        vgoyal@redhat.com, ebiederm@xmission.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Subject: Re: [PATCH v1 0/2] x86, apic: Disable BSP if boot cpu is AP
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <20121016.140313.279437418.d.hatayama@jp.fujitsu.com>
References: <20121016043357.20003.5885.stgit@localhost6.localdomain6>
	<3E5A0FA7E9CA944F9D5414FEC6C7122030B0DD68@ORSMSX105.amr.corp.intel.com>
	<20121016.140313.279437418.d.hatayama@jp.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: Re: [PATCH v1 0/2] x86, apic: Disable BSP if boot cpu is AP
Date: Tue, 16 Oct 2012 14:03:13 +0900

> From: "Yu, Fenghua" <fenghua.yu@intel.com>
> Subject: RE: [PATCH v1 0/2] x86, apic: Disable BSP if boot cpu is AP
> Date: Tue, 16 Oct 2012 04:51:36 +0000
> 
>>> -----Original Message-----
>>> From: HATAYAMA Daisuke [mailto:d.hatayama@jp.fujitsu.com]
>>> Sent: Monday, October 15, 2012 9:35 PM
>>> To: linux-kernel@vger.kernel.org; kexec@lists.infradead.org;
>>> x86@kernel.org
>>> Cc: mingo@elte.hu; tglx@linutronix.de; hpa@zytor.com; Brown, Len; Yu,
>>> Fenghua; vgoyal@redhat.com; ebiederm@xmission.com;
>>> grant.likely@secretlab.ca; rob.herring@calxeda.com;
>>> d.hatayama@jp.fujitsu.com
>>> Subject: [PATCH v1 0/2] x86, apic: Disable BSP if boot cpu is AP
>>> 
>>> Multiple CPUs are useful for CPU-bound processing like compression and
>>> I do want to use compression to generate crash dump quickly. But now
>>> we cannot wakeup the 2nd and later cpus in the kdump 2nd kernel if
>>> crash happens on AP. If crash happens on AP, kexec enters the 2nd
>>> kernel with the AP, and there BSP in the 1st kernel is expected to be
>>> haling in the 1st kernel or possibly in any fatal system error state.
>>> 
>>> To wake up AP, we use the method called INIT-INIT-SIPI. INIT causes
>>> BSP to jump into BIOS init code. A typical visible behaviour is hang
>>> or immediate reset, depending on the BIOS init code.
>>> 
>>> AP can be initiated by INIT even in a fatal state: MP spec explains
>>> that processor-specific INIT can be used to recover AP from a fatal
>>> system error. On the other hand, there's no method for BSP to recover;
>>> it might be possible to do so by NMI plus any hand-coded reset code
>>> that is carefully designed, but at least I have no idea in this
>>> direction now.
>> 
>> In my BSP hotplug patchset, BPS is waken up by NMI. The patchset is
>> not in tip tree yet.
>> 
>> BSP hotplug patchset can be found at https://lkml.org/lkml/2012/10/12/336
>> 
>>> 
>>> Therefore, the idea I do in this patch set is simply to disable BSP if
>>> vboot cpu is AP.
>>> 
>> 
>> The BSP hotplug patchset will be useful for you goal. With the BSP hotplug
>> patcheset, you can wake up BSP and don't need to disable it.
>> 
>>> My motivation is to use multiple CPUs in order to quickly generate
>>> crash dump on the machine with huge amount of memory. I assume such
>>> machine tends to also have a lot of CPUs. So disabling one CPU would
>>> be no problem.
>> 
>> Luckily you don't need to disable any CPU to archive your goal with
>> the BSP hotplug pachest:)
>> 
>> On a dual core/single thread machine, this means you get 100% performance
>> boost with BSP's help.
>> 
>> Plus crash dump kernel code is better structured by not treating BSP
>> specially.
>> 
> 
> Hello Fenghua.
> 
> I've of course noticed your patch set and locally tested, but I saw
> NMI to BSP failed in the 2nd kernel. I'll send a log to you later.
> 
> BTW, I tested with your previous v8 patch set. Did you change
> something during v8 to v9 relevant to this issue?
> 

I've fogetten saying one comment that your patch distinguish BSP by
CPU#0. CPU#0 is assigned to the boot cpu, which can be AP in the kdump
2nd kernel. Distinguishing BSP by CPU#0 is not enough here.

I have my local patch set based on your v8 patch doing this, but NMI
to BSP failed. I guess this comes from the difference of BSP states:
halting in play dead in your NMI method and halting in the 1st kernel
on crash or possibly in a fatal system error on actual situation.

Thanks.
HATAYAMA, Daisuke

