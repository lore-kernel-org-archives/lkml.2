Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab1DATzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 15:55:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32004 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab1DATzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 15:55:20 -0400
Message-ID: <4D962D72.2010501@kernel.org>
Date: Fri, 01 Apr 2011 12:54:26 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Michael Leun <lkml20101129@newton.leun.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Mike Pagano <mpagano@gentoo.org>
Subject: Re: 2.6.38.2 breaks suspend to disk
References: <20110330203215.0a1a41a7@xenia.leun.net> <20110331090524.07ad0069@xenia.leun.net> <alpine.DEB.2.00.1103311546480.16492@kaball-desktop> <201103312348.53678.rjw@sisk.pl> <4D94FE37.8070109@kernel.org> <alpine.DEB.2.00.1104011230550.16492@kaball-desktop> <4D95F80D.7070201@kernel.org> <4D95FBDD.9050901@zytor.com> <alpine.DEB.2.00.1104011729000.16492@kaball-desktop> <4D961FBC.2030105@zytor.com> <4D962837.2070300@kernel.org> <4D96294B.5050909@zytor.com>
In-Reply-To: <4D96294B.5050909@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D962D83.0015,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2011 12:36 PM, H. Peter Anvin wrote:
> On 04/01/2011 12:32 PM, Yinghai Lu wrote:
>>
>> So for 32 bit, PAE support is not compiled in for old 486 cpus.
>> mmu_cr4_feautres will be used to make sure head_32.S will not access cr4.
>>
>> that could be the reason why 32 bit does not do read back at beginning.
>>
>
> Yes, but that doesn't explain why we shouldn't set new bits like NX and
> PSE in this register.

ok, please check if you are happy with this one.

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

[PATCH -v3] x86: Save cr4 to mmu_cr4_features at boot time

Save cr4 to mmu_cr4_features at boot time

Michael reported 2.6.38.2 hibernation is broken by one backported patch.
it cause a freeze when resuming from hibernation

| "x86: Cleanup highmap after brk is concluded"
| commit id e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e.

it turns out the mmu_cr4 save it lost somehow.

-v3: read back cr4 for 32bit too according to HPA

Bisected-and-tested-by: Michael Leun <lkml20101129@newton.leun.net>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
  arch/x86/kernel/setup.c |   12 ++++++++++++
  1 file changed, 12 insertions(+)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -219,6 +219,17 @@ unsigned long mmu_cr4_features;
  unsigned long mmu_cr4_features = X86_CR4_PAE;
  #endif
  
+#if defined(CONFIG_X86_PAE) || defined(CONFIG_X86_64)
+static void __init read_back_mmu_cr4(void)
+{
+	mmu_cr4_features = read_cr4();
+}
+#else
+static void __init read_back_mmu_cr4(void)
+{
+}
+#endif
+
  /* Boot loader ID and version as integers, for the benefit of proc_dointvec */
  int bootloader_type, bootloader_version;
  
@@ -892,6 +903,7 @@ void __init setup_arch(char **cmdline_p)
  
  	high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
  #endif
+	read_back_mmu_cr4();
  
  	/*
  	 * Find and reserve possible boot-time SMP configuration:
