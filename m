Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab0IRAsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 20:48:46 -0400
Received: from smtp-out.google.com ([216.239.44.51]:61337 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab0IRAsp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 20:48:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=c/cB/JZRMuv5+SwO7AP/YXDhaVI3B7Hwidu/KRzT+y6EAd3TQZAvys82gBApazc/pq
         5lxxtU/bFUunuDdsVuIQ==
MIME-Version: 1.0
In-Reply-To: <tip-a68e5c94f7d3dd64fef34dd5d97e365cae4bb42a@git.kernel.org>
References: <tip-ea53069231f9317062910d6e772cca4ce93de8c8@git.kernel.org>
	<tip-a68e5c94f7d3dd64fef34dd5d97e365cae4bb42a@git.kernel.org>
Date: Fri, 17 Sep 2010 17:48:41 -0700
Message-ID: <AANLkTimCXZWVb7ajANPg15Zuo22nst=d5p-MjXhzu1NX@mail.gmail.com>
Subject: Re: [tip:x86/idle] x86, hotplug: Move WBINVD back outside the
 play_dead loop
From: Venkatesh Pallipadi <venki@google.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        asit.k.mallick@intel.com, arjan@linux.kernel.org,
        a.p.zijlstra@chello.hl, lenb@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com, venki@google.com
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 5:13 PM, tip-bot for H. Peter Anvin
<hpa@linux.intel.com> wrote:
> Commit-ID:  a68e5c94f7d3dd64fef34dd5d97e365cae4bb42a
> Gitweb:     http://git.kernel.org/tip/a68e5c94f7d3dd64fef34dd5d97e365cae4bb42a
> Author:     H. Peter Anvin <hpa@linux.intel.com>
> AuthorDate: Fri, 17 Sep 2010 17:06:46 -0700
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Fri, 17 Sep 2010 17:10:23 -0700
>
> x86, hotplug: Move WBINVD back outside the play_dead loop
>
> On processors with hyperthreading, when only one thread is offlined
> the other thread can cause a spurious wakeup on the idled thread.  We
> do not want to re-WBINVD when that happens.
>
> Ideally, we should simply skip WBINVD unless we're the last thread on
> a particular core to shut down, but there might be similar issues
> elsewhere in the system.
>
> Thus, revert to previous behavior of only WBINVD outside the loop.
> Partly as a result, remove the mb()'s around it: they are not
> necessary since wbinvd() is a serializing instruction, but they were
> intended to make sure the compiler didn't do any funny loop
> optimizations.
>
> Reported-by: Asit Mallick <asit.k.mallick@intel.com>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Arjan van de Ven <arjan@linux.kernel.org>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Venkatesh Pallipadi <venki@google.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.hl>
> LKML-Reference: <tip-ea53069231f9317062910d6e772cca4ce93de8c8@git.kernel.org>
> ---
>  arch/x86/kernel/smpboot.c |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 07bf423..55c80ffb 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1422,9 +1422,9 @@ static inline void mwait_play_dead(void)
>                        (highest_subcstate - 1);
>        }
>
> +       wbinvd();
> +
>        while (1) {
> -               mb();
> -               wbinvd();
>                __monitor(&current_thread_info()->flags, 0, 0);
>                mb();


Just one observation. There are some CPUs with errata that need
clflush before monitor. So, if that CPU wakesup spuriously it may have
problem reentering idle. Not sure whether that will be a problem as
that errata also depended on read happening on the flag. May be its
better to do monitor (0, 0, 0).

Thanks,
Venki
