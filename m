Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab1BORyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 12:54:14 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42488 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab1BORyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 12:54:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Sv2VrGt+uOX7pZivesUszncuwAK5kqCoI/72EBgWFrEMOJzUtwg70xxp6Sc2L+lZnO
         QREWKrafCDH+WWPoNtp1trpfILYYVYcRRePy5w9EaAxR/e44NEuXKfi4LMUpjZPEVbEI
         VaNO8PAWOyNH4a4JLowmxLNguj0jhnlf6GH6s=
MIME-Version: 1.0
In-Reply-To: <4D5AB86A.9030009@gmail.com>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
	<1297530663-26234-11-git-send-email-tj@kernel.org>
	<4D59B3CE.7010408@gmail.com>
	<20110215093631.GG3160@htj.dyndns.org>
	<4D5AB86A.9030009@gmail.com>
Date: Tue, 15 Feb 2011 09:54:09 -0800
X-Google-Sender-Auth: goA_dfmq1hxFS7-epX9KZEr5B9U
Message-ID: <AANLkTi=pmLTRa7K0_E5qXfO2P_+nT3fRXOMDXUpHzK4S@mail.gmail.com>
Subject: Re: [PATCH 10/26] x86-64, NUMA: Move apicid to numa mapping
 initialization from amd_scan_nodes() to amd_numa_init()
From: Yinghai Lu <yinghai@kernel.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, x86@kernel.org,
        brgerst@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 9:31 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On 02/15/2011 12:36 PM, Tejun Heo wrote:
> ...
>>>
>>>   Hi Tejun, while you at it, it seems apicid_base conditional assignment
>>> is
>>> redundant here (boot_cpu_physical_apicid is unsigned int) so we might
>>> have
>>> something like
>>>
>>>        apicid_start    = boot_cpu_physical_apicid;
>>>        apicid_end      = apicid_start + cores;
>>>
>>>        for_each_node_mask(i, cpu_nodes_parsed) {
>>>                for (j = apicid_start; j<   apicid_end; j++)
>>>                        set_apicid_to_node((i<<   bits) + j, i);
>>>        }
>>
>> Right, I think the intention there was
>>
>>        if (boot_cpu_physical_apicid == -1U)
>>
>> because that's the initial value and we don't really want to index the
>> apicid nid table with -1U.  Care to send a patch?  I'm gonna have to
>> rebase anyway and can put the patch at the front.
>>
>> Thanks.
>>
>
>  Hi Tejun again :) I've looked some more and if I'm not missing something
> (Yinghai?) the code is broken in another way. We might have AMD system
> with corrupted MADT table so boot_cpu_physical_apicid remains =-1U
> and then we better BUG_ON instead of possible access of out-of-range
> __apicid_to_node array. If MADT is parsed successfully
> boot_cpu_physical_apicid
> will have correct value. So I think we rather should add something like the
> patch below. Again better Yinghai check it first so I would not _miss_ the
> point that such situation is impossible at all. (And if I'm right we need to
> check for set_apicid_to_node(apicid, ) never exceed MAX_LOCAL_APIC as well.
>
> Yinghai am I missing something?
>
> --
>    Cyrill
>
> ---
> x86, numa: amd -- Check for screwed MADT table
>
> In case if MADT table is corrupted we might end up
> with boot_cpu_physical_apicid = -1U, corebits > 0 and
> get out of __apicid_to_node array bound access. Check for
> boot_cpu_physical_apicid being not default value.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  arch/x86/mm/amdtopology_64.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> Index: linux-2.6.git/arch/x86/mm/amdtopology_64.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/mm/amdtopology_64.c
> +++ linux-2.6.git/arch/x86/mm/amdtopology_64.c
> @@ -271,9 +271,14 @@ int __init amd_scan_nodes(void)
>        bits = boot_cpu_data.x86_coreid_bits;
>        cores = (1<<bits);
>        apicid_base = 0;
> +
>        /* get the APIC ID of the BSP early for systems with apicid lifting
> */
>        early_get_boot_cpu_id();
> -       if (boot_cpu_physical_apicid > 0) {
> +       if (boot_cpu_physical_apicid == -1U || ) {
> +               pr_err("BAD APIC ID: %02x, NUMA node scaning canceled\n",
> +                       boot_cpu_physical_apicid);
> +               return -1;
> +       } else if (boot_cpu_physical_apicid > 0) {
>                pr_info("BSP APIC ID: %02x\n", boot_cpu_physical_apicid);
>                apicid_base = boot_cpu_physical_apicid;
>        }

could just change

 -       if (boot_cpu_physical_apicid > 0) {
 +       if (boot_cpu_physical_apicid != -1U) {
                pr_info("BSP APIC ID: %02x\n", boot_cpu_physical_apicid);
                apicid_base = boot_cpu_physical_apicid;
        }

Thanks

Yinghai
