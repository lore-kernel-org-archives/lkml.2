Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab1A0PCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 10:02:38 -0500
Received: from adelie.canonical.com ([91.189.90.139]:34391 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab1A0PCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 10:02:36 -0500
Message-ID: <4D418907.2030708@canonical.com>
Date: Thu, 27 Jan 2011 16:02:31 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Daniel Kiper <dkiper@net-space.pl>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, x86@kernel.org,
        xen-devel@lists.xensource.com, jeremy@goop.org, konrad.wilk@oracle.com,
        mingo@redhat.com, mingo@elte.hu
Subject: Re: [PATCH] xen: convert p2m to a 3 level tree - partial revert
References: <20110127144843.GA23746@router-fw-old.local.net-space.pl> <4D41883A.3020603@canonical.com>
In-Reply-To: <4D41883A.3020603@canonical.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2011 03:59 PM, Stefan Bader wrote:
> On 01/27/2011 03:48 PM, Daniel Kiper wrote:
>> Hi,
>>
>> Durning work on Xen memory hotplug I discoverd that
>> 2.6.38-rc2 does not boot on domU. After some investigation
>> it appeared that 58e05027b530ff081ecea68e38de8d59db8f87e0
>> commit changed CONFIG_XEN_MAX_DOMAIN_MEMORY constant value
>> to 128. This change does not allow to boot kernel on domU
>> with small memory size (I could confirm that it is even
>> not possible to boot kernel on domU with 2 GiB). Guest
>> crash silently without any warning. Durning further
>> research I found out that there is another commit published
>> recently (8e1b4cf2108488ccfb9a3e7ed7cd85a435e01d4b) which attempts
>> to fix this issue, however, it does not work on my platform.
>> I decided to reenable CONFIG_XEN_MAX_DOMAIN_MEMORY option in
>> kernel config and enable users to choose resonable values for
>> their machines until better fix will be published. I think this
>> solution is good because allow users to boot domU with newest
>> kernel and allow developers to continue their work without
>> time presure which could lead to new bugs.
>>
> 
> Have you tried with a version that contains
> 
> commit 8e1b4cf2108488ccfb9a3e7ed7cd85a435e01d4b
> Author: Stefan Bader <stefan.bader@canonical.com>
> Date:   Thu Jan 20 15:38:23 2011 +0100
> 
>     xen: p2m: correctly initialize partial p2m leaf
> 
> I still may need to send a follow up to add a matching RESERVE_BRK, but at least
> I was able to boot small DomU's again.
> 
> -Stefan
>> This patch applies cleanly to current Linus' kernel tree.
>>

Sorry, did not read careful enough. So you did. Maybe you could actually try to
make the additional change of

--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -61,6 +61,7 @@ static RESERVE_BRK_ARRAY(unsigned long *, p2m_top_mfn_p, P2M_T

 RESERVE_BRK(p2m_mid, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MID_PE
 RESERVE_BRK(p2m_mid_mfn, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MI
+RESERVE_BRK(p2m_node, PAGE_SIZE);

 static inline unsigned p2m_top_index(unsigned long pfn)
 {

This one I missed and probably that has more effects on big memory values.

-Stefan

>> Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
>> ---
>>  arch/x86/xen/Kconfig |   11 +++++++----
>>  1 files changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
>> index 5b54892..a234b9a 100644
>> --- a/arch/x86/xen/Kconfig
>> +++ b/arch/x86/xen/Kconfig
>> @@ -29,12 +29,15 @@ config XEN_PVHVM
>>  	depends on X86_LOCAL_APIC
>>  
>>  config XEN_MAX_DOMAIN_MEMORY
>> -       int
>> -       default 128
>> +       int "Maximum allowed size of a domain in gigabytes"
>> +       default 8 if X86_32
>> +       default 32 if X86_64
>>         depends on XEN
>>         help
>> -         This only affects the sizing of some bss arrays, the unused
>> -         portions of which are freed.
>> +         The pseudo-physical to machine address array is sized
>> +         according to the maximum possible memory size of a Xen
>> +         domain.  This array uses 1 page per gigabyte, so there's no
>> +         need to be too stingy here.
>>  
>>  config XEN_SAVE_RESTORE
>>         bool
> 

