Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab1DAQHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 12:07:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58617 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758106Ab1DAQHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 12:07:21 -0400
Message-ID: <4D95F80D.7070201@kernel.org>
Date: Fri, 01 Apr 2011 09:06:37 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>,
        Michael Leun <lkml20101129@newton.leun.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Mike Pagano <mpagano@gentoo.org>
Subject: Re: 2.6.38.2 breaks suspend to disk
References: <20110330203215.0a1a41a7@xenia.leun.net> <20110331090524.07ad0069@xenia.leun.net> <alpine.DEB.2.00.1103311546480.16492@kaball-desktop> <201103312348.53678.rjw@sisk.pl> <4D94FE37.8070109@kernel.org> <alpine.DEB.2.00.1104011230550.16492@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1104011230550.16492@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D95F821.0096,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2011 04:32 AM, Stefano Stabellini wrote:
> On Thu, 31 Mar 2011, Yinghai Lu wrote:
>> Stefano, can you explain why it fixes the problem?
>>
>> or original patch uncover the bug?
>
> as I wrote in the other email, e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e
> removes cleanup_highmap_brk_end but this function was not only dealing
> with mappings but it was also setting mmu_cr4_features, therefore the
> setting of mmu_cr4_features was lost.
>
> I think the real bug is that mmu_cr4_features ended up in
> cleanup_highmap_brk_end by mistake.


originally mmu_cr4 is saved in init_memory_mapping.

and init_memory_mapping will update cr4.

so please use this version instead.


From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

[PATCH -v2] x86: Save cr4 to mmu_cr4_features at boot time

Save cr4 to mmu_cr4_features at boot time

Michael reported 2.6.38.2 hibernation is broken by one backported patch.
it cause a freeze when resuming from hibernation

| "x86: Cleanup highmap after brk is concluded"
| commit id e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e.

it turns out the mmu_cr4 save it lost somehow.

-v2: need to save mmu_cr4 after init_memory_mapping(), because it updates mmu_cr4
      and originally that storing action is after updating.  -- by Yinghai

Bisected-and-tested-by: Michael Leun <lkml20101129@newton.leun.net>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
  arch/x86/kernel/setup.c |    9 +++++++++
  1 file changed, 9 insertions(+)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -294,10 +294,17 @@ static void __init init_gbpages(void)
  	else
  		direct_gbpages = 0;
  }
+static void __init store_mmu_cr4(void)
+{
+	mmu_cr4_features = read_cr4();
+}
  #else
  static inline void init_gbpages(void)
  {
  }
+static void __init store_mmu_cr4(void)
+{
+}
  static void __init cleanup_highmap(void)
  {
  }
@@ -929,6 +936,8 @@ void __init setup_arch(char **cmdline_p)
  	/* max_pfn_mapped is updated here */
  	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
  	max_pfn_mapped = max_low_pfn_mapped;
+	/* after init_memory_mapping updating cr4*/
+	store_mmu_cr4();
  
  #ifdef CONFIG_X86_64
  	if (max_pfn > max_low_pfn) {
