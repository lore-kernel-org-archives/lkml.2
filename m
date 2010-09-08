Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab0IHTT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 15:19:57 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43837 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab0IHTTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 15:19:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cliff Wickman <cpw@sgi.com>
Cc: kexec@lists.infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org
References: <E1OtMLz-0001yp-Ia@eag09.americas.sgi.com>
Date: Wed, 08 Sep 2010 12:19:43 -0700
In-Reply-To: <E1OtMLz-0001yp-Ia@eag09.americas.sgi.com> (Cliff Wickman's
	message of "Wed, 08 Sep 2010 10:14:27 -0500")
Message-ID: <m1eid4gi0g.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: infradead.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Cliff Wickman <cpw@sgi.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] x86: copy_oldmem_page using cached addressing
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cliff Wickman <cpw@sgi.com> writes:

> From: Cliff Wickman <cpw@sgi.com>
>
> The copy of /proc/vmcore to a user buffer proceeds much faster
> if the kernel addresses memory as cached.
>
> With this patch we have seen an increase in transfer rate from less than
> 15MB/s to 80-460MB/s, depending on size of the transfer.  This makes
> a big difference in time needed to save a system dump.
>
> (Does anyone know of a reason why copy_oldmem_page() would need
>  to use uncached addresses?)
>
> Diffed against 2.6.36-rc3

I believe this code simply predates being able to specify the
caching attributes at ioremap time.  Being cached in this case
actually looks more correct, as that is the default for RAM
and we are talking about RAM.

Ultimately either there is another cpu running wild with these pages
mapped with some random set of attributes, and we cannot get the
permissions right or we have captured all of the cpus and this is the
only mapping so it doesn't matter.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

>
> Signed-off-by: Cliff Wickman <cpw@sgi.com>
> ---
>  arch/x86/kernel/crash_dump_64.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linus.current/arch/x86/kernel/crash_dump_64.c
> ===================================================================
> --- linus.current.orig/arch/x86/kernel/crash_dump_64.c
> +++ linus.current/arch/x86/kernel/crash_dump_64.c
> @@ -34,7 +34,7 @@ ssize_t copy_oldmem_page(unsigned long p
>  	if (!csize)
>  		return 0;
>  
> -	vaddr = ioremap(pfn << PAGE_SHIFT, PAGE_SIZE);
> +	vaddr = ioremap_cache(pfn << PAGE_SHIFT, PAGE_SIZE);
>  	if (!vaddr)
>  		return -ENOMEM;
>  
>
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
