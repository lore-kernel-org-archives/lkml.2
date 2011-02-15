Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab1BOS1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 13:27:42 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60121 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab1BOS1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 13:27:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lDbIkIUt2+k37ND5gZTfGt3gKf+IU9go2HRPmigtd4kzSb0wJpeIgXxzkKEJkw5FpV
         M8+sMMwgirs1fG7nH0tdKoLQTECSj3nT5QRbTuy64VDZnRm9ccQ5WW/yBUKwnuY/5GPB
         3cSWBiHdqzNQ99P22HYeaU+t3sqdVzBkXyWoI=
Message-ID: <4D5AC599.9050507@gmail.com>
Date: Tue, 15 Feb 2011 21:27:37 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, x86@kernel.org,
        brgerst@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 10/26] x86-64, NUMA: Move apicid to numa mapping initialization
 from amd_scan_nodes() to amd_numa_init()
References: <1297530663-26234-1-git-send-email-tj@kernel.org>	<1297530663-26234-11-git-send-email-tj@kernel.org>	<4D59B3CE.7010408@gmail.com>	<20110215093631.GG3160@htj.dyndns.org>	<4D5AB86A.9030009@gmail.com> <AANLkTi=pmLTRa7K0_E5qXfO2P_+nT3fRXOMDXUpHzK4S@mail.gmail.com> <4D5ABF94.6020001@gmail.com>
In-Reply-To: <4D5ABF94.6020001@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2011 09:01 PM, Cyrill Gorcunov wrote:
> On 02/15/2011 08:54 PM, Yinghai Lu wrote:
> ...
>>
>> could just change
>>
>> - if (boot_cpu_physical_apicid> 0) {
>> + if (boot_cpu_physical_apicid != -1U) {
>> pr_info("BSP APIC ID: %02x\n", boot_cpu_physical_apicid);
>> apicid_base = boot_cpu_physical_apicid;
>> }
>>
>> Thanks
>>
>> Yinghai
>
> yup, that is exactly what Tejun suggested in first place ;) I'll update to
> this form and add your Acked-by then, ok?
>

Tejun I've updated it on top of your tj-numa/x86_64-numa-unify branch
and added Acks.

-- 
x86, numa: amd -- Check for screwed MADT table

In case if MADT table is corrupted we might end up
with boot_cpu_physical_apicid = -1U, corebits > 0 and
get out of __apicid_to_node array bound access. Check for
boot_cpu_physical_apicid being a sane value.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Yinghai Lu <yinghai@kernel.org>
---
  arch/x86/mm/amdtopology_64.c |    6 ++++--
  1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.git/arch/x86/mm/amdtopology_64.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/mm/amdtopology_64.c
+++ linux-2.6.git/arch/x86/mm/amdtopology_64.c
@@ -212,14 +212,16 @@ void __init amd_fake_nodes(const struct
  {
  	unsigned int bits;
  	unsigned int cores;
-	unsigned int apicid_base = 0;
+	unsigned int apicid_base;
  	int i;

  	bits = boot_cpu_data.x86_coreid_bits;
  	cores = 1 << bits;
  	early_get_boot_cpu_id();
-	if (boot_cpu_physical_apicid > 0)
+	if (boot_cpu_physical_apicid != -1U)
  		apicid_base = boot_cpu_physical_apicid;
+	else
+		apicid_base = 0;

  	for (i = 0; i < nr_nodes; i++) {
  		int index;
