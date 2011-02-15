Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab1BORb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 12:31:29 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59151 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab1BORb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 12:31:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mDzkzHY06dadpOk7LqxvRsYT0AGYe0+9wF0C1aCbNvBAq1z6PCno6Dt6B3Nu9HdXRr
         LZBlLTPhJcqT0ztm2prWA9/SoZlqw/opE4y1JhT8aVwKFrWWaoVGfNXO2Ygx3eb7TsS6
         dPBDRMq8OK/hlHqDtRypA5UvHCkD+LR38OIEY=
Message-ID: <4D5AB86A.9030009@gmail.com>
Date: Tue, 15 Feb 2011 20:31:22 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 10/26] x86-64, NUMA: Move apicid to numa mapping initialization
 from amd_scan_nodes() to amd_numa_init()
References: <1297530663-26234-1-git-send-email-tj@kernel.org> <1297530663-26234-11-git-send-email-tj@kernel.org> <4D59B3CE.7010408@gmail.com> <20110215093631.GG3160@htj.dyndns.org>
In-Reply-To: <20110215093631.GG3160@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2011 12:36 PM, Tejun Heo wrote:
...
>>
>>    Hi Tejun, while you at it, it seems apicid_base conditional assignment is
>> redundant here (boot_cpu_physical_apicid is unsigned int) so we might have
>> something like
>>
>> 	apicid_start	= boot_cpu_physical_apicid;
>> 	apicid_end	= apicid_start + cores;
>>
>> 	for_each_node_mask(i, cpu_nodes_parsed) {
>> 		for (j = apicid_start; j<   apicid_end; j++)
>> 			set_apicid_to_node((i<<   bits) + j, i);
>> 	}
>
> Right, I think the intention there was
>
> 	if (boot_cpu_physical_apicid == -1U)
>
> because that's the initial value and we don't really want to index the
> apicid nid table with -1U.  Care to send a patch?  I'm gonna have to
> rebase anyway and can put the patch at the front.
>
> Thanks.
>

  Hi Tejun again :) I've looked some more and if I'm not missing something
(Yinghai?) the code is broken in another way. We might have AMD system
with corrupted MADT table so boot_cpu_physical_apicid remains =-1U
and then we better BUG_ON instead of possible access of out-of-range
__apicid_to_node array. If MADT is parsed successfully boot_cpu_physical_apicid
will have correct value. So I think we rather should add something like the
patch below. Again better Yinghai check it first so I would not _miss_ the
point that such situation is impossible at all. (And if I'm right we need to
check for set_apicid_to_node(apicid, ) never exceed MAX_LOCAL_APIC as well.

Yinghai am I missing something?

-- 
     Cyrill

---
x86, numa: amd -- Check for screwed MADT table

In case if MADT table is corrupted we might end up
with boot_cpu_physical_apicid = -1U, corebits > 0 and
get out of __apicid_to_node array bound access. Check for
boot_cpu_physical_apicid being not default value.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
  arch/x86/mm/amdtopology_64.c |    7 ++++++-
  1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/mm/amdtopology_64.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/mm/amdtopology_64.c
+++ linux-2.6.git/arch/x86/mm/amdtopology_64.c
@@ -271,9 +271,14 @@ int __init amd_scan_nodes(void)
  	bits = boot_cpu_data.x86_coreid_bits;
  	cores = (1<<bits);
  	apicid_base = 0;
+
  	/* get the APIC ID of the BSP early for systems with apicid lifting */
  	early_get_boot_cpu_id();
-	if (boot_cpu_physical_apicid > 0) {
+	if (boot_cpu_physical_apicid == -1U || ) {
+		pr_err("BAD APIC ID: %02x, NUMA node scaning canceled\n",
+			boot_cpu_physical_apicid);
+		return -1;
+	} else if (boot_cpu_physical_apicid > 0) {
  		pr_info("BSP APIC ID: %02x\n", boot_cpu_physical_apicid);
  		apicid_base = boot_cpu_physical_apicid;
  	}
