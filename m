Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab0J1TrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 15:47:10 -0400
Received: from shutemov.name ([188.40.19.243]:54388 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745Ab0J1TrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 15:47:04 -0400
Date: Thu, 28 Oct 2010 22:47:03 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Brian Gerst <brgerst@gmail.com>, David Howells <dhowells@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>, x86@kernel.org
Subject: Re: [PATCH v2] preempt: fix kernel build with !CONFIG_BKL
Message-ID: <20101028194703.GA19183@shutemov.name>
References: <20101028095910.GA15970@shutemov.name>
 <201010281320.44765.arnd@arndb.de>
 <20101028134658.GA17769@shutemov.name>
 <201010281612.33732.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010281612.33732.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2010-08-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 04:12:33PM +0200, Arnd Bergmann wrote:
> The preempt count logic tries to take the BKL into account, which breaks
> when CONFIG_BKL is not set.
> 
> Use the same preempt_count offset that we use without CONFIG_PREEMPT
> when CONFIG_BKL is disabled.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Reported-by: Kirill Shutemov <kirill@shutemov.name>
> ---
> > On Thursday 28 October 2010, Kirill A. Shutemov wrote:
> > On Thu, Oct 28, 2010 at 01:20:44PM +0200, Arnd Bergmann wrote:
> > > The preempt count logic tries to take the BKL into account, which breaks
> > > when CONFIG_BKL is not set.
> > > 
> > > Use the same preempt_count offset that we use without CONFIG_PREEMPT
> > > when CONFIG_BKL is disabled.
> > > 
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > Reported-by: "Kirill A. Shutemov" <kirill@shutemov.name>
> > 
> > Remove quotes, please.
> 
> That would make it an invalid email address because of the dot. I left out
> the middle initial now, if that's better.

Hm... You are right. But this wasn't a problem before (see git log).
Let's leave it with quotes.

> 
> > I've got a lot of __schedule_bug. Log attached.
> 
> Ok. I really don't understand the preempt code all that well, let's
> hope that this one is right.
> 
> Thanks for your patience and for your testing!

It's usable now.

I'm not sure if it connected or not:

[ 6001.589151] INFO: task awesome:26743 blocked for more than 120 seconds.
[ 6001.589159] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6001.589166] awesome       D 00000555  7040 26743   3789 0x00000000
[ 6001.589182]  f19afe3c 00000046 5e569d25 00000555 c16ac7c0 f1ae0d40 c16ac7c0 c16ac7c0
[ 6001.589206]  f1ae0fc0 00000000 c16ac7c0 00000000 00000555 f1ae0d40 f4d46dc0 f19aff00
[ 6001.589228]  7fffffff f1ae0d40 f19afe9c c1317ea5 00000002 00000001 00000000 c131c57b
[ 6001.589251] Call Trace:
[ 6001.589271]  [<c1317ea5>] schedule_timeout+0x27/0xb8
[ 6001.589284]  [<c131c57b>] ? sub_preempt_count+0x9/0x8e
[ 6001.589298]  [<c105290d>] ? get_parent_ip+0xb/0x31
[ 6001.589307]  [<c131c5f3>] ? sub_preempt_count+0x81/0x8e
[ 6001.589318]  [<c13174d2>] wait_for_common+0xa0/0xef
[ 6001.589329]  [<c1057c3c>] ? default_wake_function+0x0/0x12
[ 6001.589339]  [<c13175c0>] wait_for_completion+0x17/0x19
[ 6001.589352]  [<c109a136>] stop_one_cpu+0x59/0x7f
[ 6001.589361]  [<c10579e6>] ? migration_cpu_stop+0x0/0x2d
[ 6001.589373]  [<c1317463>] ? wait_for_common+0x31/0xef
[ 6001.589384]  [<c1052e69>] sched_exec+0xa7/0xbb
[ 6001.589395]  [<c1101e09>] do_execve+0xb7/0x24a
[ 6001.589407]  [<c1030b84>] sys_execve+0x31/0x54
[ 6001.589418]  [<c102b3ba>] ptregs_execve+0x12/0x18
[ 6001.589429]  [<c1319d00>] ? syscall_call+0x7/0xb
[ 6001.589438] 1 lock held by awesome/26743:
[ 6001.589444]  #0:  (&sig->cred_guard_mutex){......}, at: [<c1100d1e>] prepare_bprm_creds+0x25/0x5a

I probably saw it previously on pre-2.6.37-rc1 with CONFIG_BKL=y.

> 
> 	Arnd
> 
> diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
> index 8a389b6..41cb31f 100644
> --- a/include/linux/hardirq.h
> +++ b/include/linux/hardirq.h
> @@ -96,11 +96,15 @@
>   */
>  #define in_nmi()	(preempt_count() & NMI_MASK)
>  
> -#if defined(CONFIG_PREEMPT)
> +#if defined(CONFIG_PREEMPT) && defined(CONFIG_BKL)
>  # define PREEMPT_INATOMIC_BASE kernel_locked()
> -# define PREEMPT_CHECK_OFFSET 1
>  #else
>  # define PREEMPT_INATOMIC_BASE 0
> +#endif
> +
> +#if defined(CONFIG_PREEMPT)
> +# define PREEMPT_CHECK_OFFSET 1
> +#else
>  # define PREEMPT_CHECK_OFFSET 0
>  #endif
>  

-- 
 Kirill A. Shutemov
