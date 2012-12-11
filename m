Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab2LKIKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 03:10:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421Ab2LKIKu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 03:10:50 -0500
Date: Tue, 11 Dec 2012 10:10:24 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kbuild test robot <fengguang.wu@intel.com>
Subject: Re: [PATCH] x86/kexec: crash_vmclear_local_vmcss needs __rcu
Message-ID: <20121211081024.GC11016@redhat.com>
References: <50C18168.305@cn.fujitsu.com>
 <20121210203014.GB2402@amt.cnet>
 <50C6E927.9040605@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <50C6E927.9040605@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 04:04:55PM +0800, Zhang Yanfei wrote:
> 于 2012年12月11日 04:30, Marcelo Tosatti 写道:
> > On Fri, Dec 07, 2012 at 01:40:56PM +0800, Zhang Yanfei wrote:
> >> This removes the sparse warning:
> >> arch/x86/kernel/crash.c:49:32: sparse: incompatible types in comparison expression (different address spaces)
> >>
> >> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> >> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> >> ---
> >>  arch/x86/include/asm/kexec.h |    4 +++-
> >>  arch/x86/kernel/crash.c      |    4 ++--
> >>  2 files changed, 5 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
> >> index 28feeba..16882cd 100644
> >> --- a/arch/x86/include/asm/kexec.h
> >> +++ b/arch/x86/include/asm/kexec.h
> >> @@ -163,7 +163,9 @@ struct kimage_arch {
> >>  };
> >>  #endif
> >>  
> >> -extern void (*crash_vmclear_loaded_vmcss)(void);
> >> +extern void __rcu (*crash_vmclear_loaded_vmcss)(void);
> >> +#define vmclear_func_rcu(vmclear_func) \
> >> +	((void (*)(void)) rcu_dereference(vmclear_func))
> >>  
> >>  #endif /* __ASSEMBLY__ */
> >>  
> >> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
> >> index 2f6b8e8..50ce1d6 100644
> >> --- a/arch/x86/kernel/crash.c
> >> +++ b/arch/x86/kernel/crash.c
> >> @@ -38,7 +38,7 @@ int in_crash_kexec;
> >>   *
> >>   * protected by rcu.
> >>   */
> >> -void (*crash_vmclear_loaded_vmcss)(void) = NULL;
> >> +void __rcu (*crash_vmclear_loaded_vmcss)(void) = NULL;
> > 
> > Isnt this (__rcu AS tag) sufficient? After all, sparse is complaining
> > about namespaces.
> > 
> > Creating a #define to cast seems excessive.
> > 
> > 
> 
> I am not very familiar with the rcu.
> Adding __rcu tag could solve the problem. But it imported another warning
> when I try to assign rcu_dereference(crash_vmclear_loaded_vmcss) to
> do_vmclear_operation:
> 
> arch/x86/kernel/crash.c:49:30: warning: incorrect type in assignment (different modifiers)
> arch/x86/kernel/crash.c:49:30:    expected void ( *do_vmclear_operation )( ... )
> arch/x86/kernel/crash.c:49:30:    got void ( [noderef] *<noident> )( ... )
> arch/x86/kernel/crash.c:49:30: warning: incorrect type in assignment (different modifiers)
> arch/x86/kernel/crash.c:49:30:    expected void ( *do_vmclear_operation )( ... )
> arch/x86/kernel/crash.c:49:30:    got void ( [noderef] *<noident> )( ... )
> 
> So I made the #define to cast its type.
> 
> If you have any suggestion, that'll be helpful.
> 
Try to use typedef.

--
			Gleb.
