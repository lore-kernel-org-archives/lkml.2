Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab1BOJgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 04:36:44 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61719 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab1BOJgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 04:36:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ihHxtCpgnPJGjW+4zq/9Kr4ohM1a2N0VhkHDaJBWAIEbzlTt5rIZBlCTTpEQpsZp1o
         fF4CcLPnyJPfDUPFis8pVDm3jQHhEhCtURo8CFjOj0wcOcRoSCoFs5Zau+gt8SzyqTCU
         0ONS9Vj1xBJvixnCHiTHKxzAS03U90CSTSlUw=
Date: Tue, 15 Feb 2011 10:36:31 +0100
From: Tejun Heo <tj@kernel.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 10/26] x86-64, NUMA: Move apicid to numa mapping
 initialization from amd_scan_nodes() to amd_numa_init()
Message-ID: <20110215093631.GG3160@htj.dyndns.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
 <1297530663-26234-11-git-send-email-tj@kernel.org>
 <4D59B3CE.7010408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D59B3CE.7010408@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Cyrill.

On Tue, Feb 15, 2011 at 01:59:26AM +0300, Cyrill Gorcunov wrote:
> >+	/* get the APIC ID of the BSP early for systems with apicid lifting */
> >+	early_get_boot_cpu_id();
> >+	if (boot_cpu_physical_apicid>  0) {
> >+		pr_info("BSP APIC ID: %02x\n", boot_cpu_physical_apicid);
> >+		apicid_base = boot_cpu_physical_apicid;
> 		^^^
> >+	}
> >+
> >+	for_each_node_mask(i, cpu_nodes_parsed)
> >+		for (j = apicid_base; j<  cores + apicid_base; j++)
> >+			set_apicid_to_node((i<<  bits) + j, i);
> >+
> >  	return 0;
> >  }
> >
> 
>   Hi Tejun, while you at it, it seems apicid_base conditional assignment is
> redundant here (boot_cpu_physical_apicid is unsigned int) so we might have
> something like
> 
> 	apicid_start	= boot_cpu_physical_apicid;
> 	apicid_end	= apicid_start + cores;
> 
> 	for_each_node_mask(i, cpu_nodes_parsed) {
> 		for (j = apicid_start; j <  apicid_end; j++)
> 			set_apicid_to_node((i <<  bits) + j, i);
> 	}

Right, I think the intention there was

	if (boot_cpu_physical_apicid == -1U)

because that's the initial value and we don't really want to index the
apicid nid table with -1U.  Care to send a patch?  I'm gonna have to
rebase anyway and can put the patch at the front.

Thanks.

-- 
tejun
