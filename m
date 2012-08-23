Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab2HWDOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 23:14:16 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:46349 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab2HWDOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 23:14:14 -0400
Subject: Re: [v2][PATCH 3/3] powerpc/kgdb: restore current_thread_info
 properly
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Tiejun Chen <tiejun.chen@windriver.com>
Cc: benh@kernel.crashing.org, jason.wessel@windriver.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1345687820-5248-3-git-send-email-tiejun.chen@windriver.com>
References: <1345687820-5248-1-git-send-email-tiejun.chen@windriver.com>
	 <1345687820-5248-3-git-send-email-tiejun.chen@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Aug 2012 20:14:10 -0700
Message-ID: <1345691650.10190.31.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-23 at 10:10 +0800, Tiejun Chen wrote:
> For powerpc BooKE and e200, singlestep is handled on the critical/dbg
> exception stack. This causes current_thread_info() to fail for kgdb
> internal, so previously We work around this issue by copying
> the thread_info from the kernel stack before calling kgdb_handle_exception,
> and copying it back afterwards.
> 
> But actually we don't do this properly. We should backup current_thread_info
> then restore that when exit.
> 
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
> ---
> v2: fix a typo in patch head description.
> 
>  arch/powerpc/kernel/kgdb.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
> index 05adb69..c470a40 100644
> --- a/arch/powerpc/kernel/kgdb.c
> +++ b/arch/powerpc/kernel/kgdb.c
> @@ -25,6 +25,7 @@
>  #include <asm/processor.h>
>  #include <asm/machdep.h>
>  #include <asm/debug.h>
> +#include <linux/slab.h>
>  
>  /*
>   * This table contains the mapping between PowerPC hardware trap types, and
> @@ -153,6 +154,8 @@ static int kgdb_handle_breakpoint(struct pt_regs *regs)
>  static int kgdb_singlestep(struct pt_regs *regs)
>  {
>  	struct thread_info *thread_info, *exception_thread_info;
> +	struct thread_info *backup_current_thread_info = \
> +		(struct thread_info *)kmalloc(sizeof(struct thread_info), GFP_KERNEL);
>  

Looks like a rouge '\' in the above assignment..


