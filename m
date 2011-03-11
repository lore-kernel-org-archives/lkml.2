Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab1CKPXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 10:23:39 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:51683 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab1CKPXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 10:23:38 -0500
X-IronPort-AV: E=Sophos;i="4.62,303,1297036800"; 
   d="scan'208";a="4747709"
Subject: Re: [PATCH] xen/e820: Don't mark balloon memory as E820_UNUSABLE
 when running as guest.
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
In-Reply-To: <1299789405-30802-2-git-send-email-konrad.wilk@oracle.com>
References: <1299789405-30802-1-git-send-email-konrad.wilk@oracle.com>
	 <1299789405-30802-2-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Fri, 11 Mar 2011 15:23:36 +0000
Message-ID: <1299857016.17339.2071.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 20:36 +0000, Konrad Rzeszutek Wilk wrote:
> If we have a guest that asked for:
> 
> memory=1024
> maxmem=20448
> 
> Which means we want 1GB now, and create pagetables so that we can expand
> up to 2GB, we would have this E820 layout:
> 
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  Xen: 0000000000000000 - 00000000000a0000 (usable)
> [    0.000000]  Xen: 00000000000a0000 - 0000000000100000 (reserved)
> [    0.000000]  Xen: 0000000000100000 - 0000000080800000 (usable)
> 
> Due to patch: "xen/setup: Inhibit resource API from using System RAM E820 gaps as PCI mem gaps."
> we would mark the memory past the 1GB mark as unusuable resulting in:
> 
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  Xen: 0000000000000000 - 00000000000a0000 (usable)
> [    0.000000]  Xen: 00000000000a0000 - 0000000000100000 (reserved)
> [    0.000000]  Xen: 0000000000100000 - 0000000040000000 (usable)
> [    0.000000]  Xen: 0000000040000000 - 0000000080800000 (unusable)
> 
> which meant that we could not balloon up anymore. We could
> balloon the guest down. The fix is to run the code introduced
> by the above mentioned patch only for the initial domain.
> 
> We will have to revisit this once we start introducing a modified
> E820 for PCI passthrough so that we can utilize the P2M identity code.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/setup.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index 2a4add9..6e676fa 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -200,7 +200,8 @@ char * __init xen_memory_setup(void)
>  			 * used as potential resource for I/O address (happens
>  			 * when 'allocate_resource' is called).
>  			 */
> -			if (delta && end < 0x100000000UL)
> +			if (delta &&
> +				(xen_initial_domain() && end < 0x100000000UL))

Not a new problem but 0x100000000 will overflow an unsigned long on 32
bit:
  CC      arch/x86/xen/setup.o
arch/x86/xen/setup.c: In function 'xen_memory_setup':
arch/x86/xen/setup.c:254: warning: integer constant is too large for 'unsigned long' type

I think you want ULL? (end is "unsigned long long").

Ian.


