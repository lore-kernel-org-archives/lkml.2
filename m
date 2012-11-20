Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab2KTQlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:41:14 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:48258 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab2KTQlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:41:13 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: andrew.cooper3@citrix.com, hpa@zytor.com, jbeulich@suse.com,
        konrad.wilk@oracle.com, mingo@redhat.com, tglx@linutronix.de,
        x86@kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com
References: <1353423893-23125-1-git-send-email-daniel.kiper@oracle.com>
	<1353423893-23125-2-git-send-email-daniel.kiper@oracle.com>
Date: Tue, 20 Nov 2012 08:40:39 -0800
In-Reply-To: <1353423893-23125-2-git-send-email-daniel.kiper@oracle.com>
	(Daniel Kiper's message of "Tue, 20 Nov 2012 16:04:43 +0100")
Message-ID: <87lidwtego.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+ST0kVCjkS5E3qgXUWsB2mRzh+wQAr9lg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Daniel Kiper <daniel.kiper@oracle.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2 01/11] kexec: introduce kexec_ops struct
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Kiper <daniel.kiper@oracle.com> writes:

> Some kexec/kdump implementations (e.g. Xen PVOPS) could not use default
> functions or require some changes in behavior of kexec/kdump generic code.
> To cope with that problem kexec_ops struct was introduced. It allows
> a developer to replace all or some functions and control some
> functionality of kexec/kdump generic code.
>
> Default behavior of kexec/kdump generic code is not changed.

Ick.

> v2 - suggestions/fixes:
>    - add comment for kexec_ops.crash_alloc_temp_store member
>      (suggested by Konrad Rzeszutek Wilk),
>    - simplify kexec_ops usage
>      (suggested by Konrad Rzeszutek Wilk).
>
> Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
> ---
>  include/linux/kexec.h |   26 ++++++++++
>  kernel/kexec.c        |  131 +++++++++++++++++++++++++++++++++++++------------
>  2 files changed, 125 insertions(+), 32 deletions(-)
>
> diff --git a/include/linux/kexec.h b/include/linux/kexec.h
> index d0b8458..c8d0b35 100644
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -116,7 +116,33 @@ struct kimage {
>  #endif
>  };
>  
> +struct kexec_ops {
> +	/*
> +	 * Some kdump implementations (e.g. Xen PVOPS dom0) could not access
> +	 * directly crash kernel memory area. In this situation they must
> +	 * allocate memory outside of it and later move contents from temporary
> +	 * storage to final resting places (usualy done by relocate_kernel()).
> +	 * Such behavior could be enforced by setting
> +	 * crash_alloc_temp_store member to true.
> +	 */

Why in the world would Xen not be able to access crash kernel memory?
As currently defined it is normal memory that the kernel chooses not to
use.

If relocate kernel can access that memory you definitely can access the
memory so the comment does not make any sense.

> +	bool crash_alloc_temp_store;
> +	struct page *(*kimage_alloc_pages)(gfp_t gfp_mask,
> +						unsigned int order,
> +						unsigned long limit);
> +	void (*kimage_free_pages)(struct page *page);
> +	unsigned long (*page_to_pfn)(struct page *page);
> +	struct page *(*pfn_to_page)(unsigned long pfn);
> +	unsigned long (*virt_to_phys)(volatile void *address);
> +	void *(*phys_to_virt)(unsigned long address);
> +	int (*machine_kexec_prepare)(struct kimage *image);
> +	int (*machine_kexec_load)(struct kimage *image);
> +	void (*machine_kexec_cleanup)(struct kimage *image);
> +	void (*machine_kexec_unload)(struct kimage *image);
> +	void (*machine_kexec_shutdown)(void);
> +	void (*machine_kexec)(struct kimage *image);
> +};

Ugh.  This is a nasty abstraction.

You are mixing and matching a bunch of things together here.

If you need to override machine_kexec_xxx please do that on a per
architecture basis.

Special case overrides of page_to_pfn, pfn_to_page, virt_to_phys,
phys_to_virt, and friends seem completely inappropriate.

There may be a point to all of these but you are mixing and matching
things badly.


Eric
