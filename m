Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab2BQENJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 23:13:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37043 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab2BQENG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 23:13:06 -0500
Message-ID: <4F3DD39C.9090905@zytor.com>
Date: Thu, 16 Feb 2012 20:12:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Will Drewry <wad@chromium.org>
CC: Eric Paris <eparis@redhat.com>, Markus Gutschke <markus@chromium.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu,
        pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net,
        eric.dumazet@gmail.com, keescook@chromium.org
Subject: Re: [PATCH v8 3/8] seccomp: add system call filtering using BPF
References: <1329422549-16407-1-git-send-email-wad@chromium.org> <1329422549-16407-3-git-send-email-wad@chromium.org> <4F3D61CB.2000301@zytor.com> <CABqD9hb3WxKxLZ2GuUrbDM--koW+a3ser5TU8y6+e0sAhOT9dw@mail.gmail.com> <4F3D7250.6040504@zytor.com> <CAE6n16kweRehdozft0tKOB1P5LtGFJDCLQP=2EXfm8P0enyH=A@mail.gmail.com> <4F3D766E.7040205@zytor.com> <CABqD9haWxRLac1w3m9rSmyDvcg8jxYcxdmAAsgB7pEEBMHr=2g@mail.gmail.com> <4F3D7DD4.6070103@zytor.com> <CABqD9hZd41AWZub+wxGWwxJtGWfk+pVWQhn7DM_0q0tS9r_wDA@mail.gmail.com> <1329439809.2337.32.camel@localhost> <CABqD9hY06gaA7T8f0Te9PFpip6ix7CcbRShWcXutxbivEZJ2og@mail.gmail.com>
In-Reply-To: <CABqD9hY06gaA7T8f0Te9PFpip6ix7CcbRShWcXutxbivEZJ2og@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2012 07:53 PM, Will Drewry wrote:
> 
> An earlier change Roland had prodded me toward was adding a
> syscall_get_arch() call to asm/syscall.h which returned the
> appropriate audit arch value for the current calling convention.  I
> hate to suggest this, but should I go ahead and wire that up for x86
> now, make it a dependency for HAVE_ARCH_SECCOMP_FILTER (and officially
> part of asm/syscall.h) then let it trickle into existence?  Maybe
> something like:
> 

... and we have been talking about making a regset and export it to
ptrace and core dumps, too.

> static inline int syscall_get_arch(struct task_struct *task, struct
> pt_regs *regs)
> {
> #ifdef CONFIG_IA32_EMULATION
>   if (task_thread_info(task)->status & TS_COMPAT)
>     return AUDIT_ARCH_I386;
> #endif
> #ifdef CONFIG_64BIT
>   return AUDIT_ARCH_X86_64;
> #else
>   return AUDIT_ARCH_I386;
> #endif
> }
> 

In this case it could be is_compat_task().

> There would be no other callers, though, because everywhere AUDIT_ARCH
> is used it is hardcoded as appropriate.  Then when x32 comes along, it
> can figure out where it belongs using tif status and/or regs.

For x32 you have the option of introducing a new value or relying on bit
30 in eax (and AUDIT_ARCH_X86_64).  The latter is more natural, probably.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

