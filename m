Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab0JUJWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 05:22:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab0JUJWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 05:22:51 -0400
Message-ID: <4CC00740.3050404@redhat.com>
Date: Thu, 21 Oct 2010 17:26:24 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Len Brown <len.brown@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Eric Paris <eparis@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/2] sysctl: remove sysctl syscall
References: <1287476560-5874-1-git-send-email-amwang@redhat.com>	<1287476560-5874-2-git-send-email-amwang@redhat.com>	<4CBD9B7F.6040307@linux.intel.com> <m1vd4yi977.fsf@fess.ebiederm.org>	<4CBDB385.6080100@linux.intel.com> <m1eibmdvew.fsf@fess.ebiederm.org>	<4CBE86E0.3050505@redhat.com> <m1zku99dh4.fsf@fess.ebiederm.org>
In-Reply-To: <m1zku99dh4.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/10 21:54, Eric W. Biederman wrote:
> Cong Wang<amwang@redhat.com>  writes:
>
>> On 10/20/10 00:00, Eric W. Biederman wrote:
>>> To the best of my knowledge the last and user of sys_sysctl is the glibc
>>> ioperm (my apologies I mispoke when I said iopl) implementation on arm.
>>> Not that people run around calling ioperm very often in any distro.
>>
>>
>> I saw that in Changelog of glibc too, but that was back to 2000, 10 years
>> past, I don't see any code using sysctl() in glibc now, except sys_sysctl()
>> itself, of course.
>
> You have to look in the glibc-ports tree to see the arm code.
>
> The arm support is not in the main glibc tree for some reason.
>
> Hmm. Looking I thought sys_sysctl had stopped being exported from glibc
> but it appears I was wrong.


Ok, got it.


>> I believe they should see the kernel warnings if they are still using
>> sysctl.
>
> Unfortunately sometimes a word to the wise isn't quite enough. Sigh.  I
> very much think having the sysctl code disabled by default is definitely
> safe right now, and the first responsible step in getting this code
> removed from the kernel.
>
> There were two original reasons for the deprecations.  Maintaining the
> binary sysctl logic was bug prone, and no one was using sysctl.
>
> The rewriting of the binary interface into binary_sysctl.c takes care of
> most if not all of the maintenance concerns.  You may think you are
> using the binary interface but the kernel just rewrites it into a /proc
> access.
>
> What is left is an interface in the kernel that no one uses and that
> will eventually bit rot, for lack of care, attention, and testing, but we
> still have a while until that happens.
>
> I recommend this:


This sounds ok for me.
Do you want to me to carry this patch for you and resend?

>
> ---
> diff --git a/init/Kconfig b/init/Kconfig
> index 2de5b1c..a9e1cda 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -808,7 +808,7 @@ config UID16
>   config SYSCTL_SYSCALL
>   	bool "Sysctl syscall support" if EMBEDDED
>   	depends on PROC_SYSCTL
> -	default y
> +	default n
>   	select SYSCTL
>   	---help---
>   	  sys_sysctl uses binary paths that have been found challenging
> @@ -816,11 +816,15 @@ config SYSCTL_SYSCALL
>   	  using paths with ascii names is now the primary path to this
>   	  information.
>
> -	  Almost nothing using the binary sysctl interface so if you are
> -	  trying to save some space it is probably safe to disable this,
> -	  making your kernel marginally smaller.
> +	  This option is kept as a service to our loyal customers who
> +	  have ignored all of our warnings over the years and have a
> +	  binary somewhere that won't work without this.
> +
> +	  This code is not regularly used or tested and will probably have
> +	  bit-rotted before someone cares enough to do more maintenance on it
> +	  so enable at your own risk.
>
> -	  If unsure say Y here.
> +	  Say N here.
>
>   config KALLSYMS
>   	 bool "Load all symbols for debugging/ksymoops" if EMBEDDED


Thanks!
