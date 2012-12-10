Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab2LJVRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:17:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab2LJVRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:17:16 -0500
Date: Mon, 10 Dec 2012 18:30:14 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Gleb Natapov <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kbuild test robot <fengguang.wu@intel.com>
Subject: Re: [PATCH] x86/kexec: crash_vmclear_local_vmcss needs __rcu
Message-ID: <20121210203014.GB2402@amt.cnet>
References: <50C18168.305@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C18168.305@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 01:40:56PM +0800, Zhang Yanfei wrote:
> This removes the sparse warning:
> arch/x86/kernel/crash.c:49:32: sparse: incompatible types in comparison expression (different address spaces)
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> ---
>  arch/x86/include/asm/kexec.h |    4 +++-
>  arch/x86/kernel/crash.c      |    4 ++--
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
> index 28feeba..16882cd 100644
> --- a/arch/x86/include/asm/kexec.h
> +++ b/arch/x86/include/asm/kexec.h
> @@ -163,7 +163,9 @@ struct kimage_arch {
>  };
>  #endif
>  
> -extern void (*crash_vmclear_loaded_vmcss)(void);
> +extern void __rcu (*crash_vmclear_loaded_vmcss)(void);
> +#define vmclear_func_rcu(vmclear_func) \
> +	((void (*)(void)) rcu_dereference(vmclear_func))
>  
>  #endif /* __ASSEMBLY__ */
>  
> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
> index 2f6b8e8..50ce1d6 100644
> --- a/arch/x86/kernel/crash.c
> +++ b/arch/x86/kernel/crash.c
> @@ -38,7 +38,7 @@ int in_crash_kexec;
>   *
>   * protected by rcu.
>   */
> -void (*crash_vmclear_loaded_vmcss)(void) = NULL;
> +void __rcu (*crash_vmclear_loaded_vmcss)(void) = NULL;

Isnt this (__rcu AS tag) sufficient? After all, sparse is complaining
about namespaces.

Creating a #define to cast seems excessive.

