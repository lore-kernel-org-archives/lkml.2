Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab2DKIsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 04:48:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175Ab2DKIsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 04:48:36 -0400
Message-ID: <4F85454E.6020201@redhat.com>
Date: Wed, 11 Apr 2012 11:48:14 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: zhangyanfei <zhangyanfei@cn.fujitsu.com>
CC: mtosatti@redhat.com, ebiederm@xmission.com, luto@mit.edu,
        joerg.roedel@amd.com, dzickus@redhat.com, paul.gortmaker@windriver.com,
        gregkh@suse.de, ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 2/4] KVM: VMX: Add functions to fill VMCSINFO
References: <4F84E0DF.8040206@cn.fujitsu.com> <4F84E365.10201@cn.fujitsu.com>
In-Reply-To: <4F84E365.10201@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 04:50 AM, zhangyanfei wrote:
> This patch is to implement the feature that at initialization of
> kvm_intel module, fills VMCSINFO with a VMCS revision identifier,
> and encoded offsets of VMCS fields. The reason why we put the
> VMCSINFO processing at the initialization of kvm_intel module
> is that it's dangerous to rob VMX resources while kvm module is
> loaded.

Maybe it should be done by a separate module.

> +
> +	kvm_cpu_vmxon(__pa(per_cpu(vmxarea, raw_smp_processor_id())));
> +	vmcs_load(vmcs);

Should do this after writing into the vmcs directly (vmcs_load() may
cache some information for vmcs_read()).

> +
> +	VMCSINFO_REVISION_ID(vmcs->revision_id);
> +
> +	/*
> +	 * Write encoded offsets into VMCS data for later vmcs_read.
> +	 */
> +	for (offset = FIELD_START; offset < vmcs_config.size;
> +	     offset += sizeof(u16))
> +		*(u16 *)((char *)vmcs + offset) = ENCODING_OFFSET(offset);

This assumes vmcs field contents use the same encoding as
vmread/vmwrite.  I guess it's a reasonable assumption.


-- 
error compiling committee.c: too many arguments to function

