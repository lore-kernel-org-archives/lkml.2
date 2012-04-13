Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab2DMSda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:33:30 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42245 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab2DMSd3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:33:29 -0400
MIME-Version: 1.0
X-Originating-IP: [63.110.51.11]
In-Reply-To: <1334341255-11153-1-git-send-email-david.vrabel@citrix.com>
References: <1334341255-11153-1-git-send-email-david.vrabel@citrix.com>
Date: Fri, 13 Apr 2012 11:33:28 -0700
Message-ID: <CA+2rt42FmLZ4OK4ZGdpeOHBnK1msxHkxZjJx6Lzz5cRO_rwmtQ@mail.gmail.com>
Subject: Re: [PATCH] xen: always set the sched clock as unstable
From: Sheng Yang <sheng@yasker.org>
To: David Vrabel <david.vrabel@citrix.com>
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Tim Deegan <tim@xen.org>, Jan Beulich <jbeulich@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 11:20 AM, David Vrabel <david.vrabel@citrix.com> wrote:
>
> From: David Vrabel <david.vrabel@citrix.com>
>
> The sched clock was considered stable based on the capabilities of the
> underlying hardware.  This does not make sense for Xen PV guests as:
> a) the hardware TSC is not used directly as the clock source; and b)
> guests may migrate to hosts with different hardware capabilities.
>
> It is not clear to me whether the Xen clock source is supposed to be
> stable and whether it should be stable across migration.  For a clock
> source to be stable it must be: a) monotonic; c) synchronized across
> CPUs; and c) constant rate.
>
> There have also been reports of systems with apparently unstable
> clocks where clearing sched_clock_stable has fixed problems with
> migrated VMs hanging.
>
> So, always set the sched clock as unstable when using the Xen clock
> source.
>
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> ---
>  arch/x86/xen/time.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> index 0296a95..8469b5a 100644
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -473,6 +473,7 @@ static void __init xen_time_init(void)
>        do_settimeofday(&tp);
>
>        setup_force_cpu_cap(X86_FEATURE_TSC);
> +       sched_clock_stable = 0;
>
>        xen_setup_runstate_info(cpu);
>        xen_setup_timer(cpu);
> --
> 1.7.2.5
>

(Sorry for duplicate posts, gmail is really not a ideal client for
lkml - though exchange is worse...)

I really prefer to hide nonstop tsc feature from Xen side, rather than
let Linux kernel to have a condition that "Nonstop TSC feature
existed, but sched_clock_stable=0".

For the other context, please refer to the discussion at xen-devel.

http://lists.xen.org/archives/html/xen-devel/2012-04/msg00888.html
http://lists.xen.org/archives/html/xen-devel/2012-04/msg00969.html

--
regards
Yang, Sheng
