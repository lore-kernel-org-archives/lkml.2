Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1JHMwk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 08:52:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58648 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab1JHMwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 08:52:38 -0400
MIME-Version: 1.0
In-Reply-To: <4E8F6785.2010104@linux.vnet.ibm.com>
References: <4E88BF33.10407@linux.vnet.ibm.com>
	<1317636215.12973.16.camel@twins>
	<4E8B07EA.4020307@linux.vnet.ibm.com>
	<4E8B09F3.4080800@linux.vnet.ibm.com>
	<1317735440.32543.4.camel@twins>
	<4E8F6785.2010104@linux.vnet.ibm.com>
Date: Sat, 8 Oct 2011 20:52:37 +0800
Message-ID: <CAM_iQpXDDeOzZ0L8MYFPhi_5rJJvinOD57nWWKfnCRxa_Jtx6Q@mail.gmail.com>
Subject: Re: [PATCH v2] CPU hotplug, freezer: Fix bugs in CPU hotplug call path
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        pavel@ucw.cz, len.brown@intel.com, mingo@elte.hu,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        lucas.demarchi@profusion.mobi, linux-pm@lists.linux-foundation.org,
        rusty@rustcorp.com.au, vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 8, 2011 at 4:56 AM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> index 1effc8b..75c65d6 100644
> --- a/include/linux/freezer.h
> +++ b/include/linux/freezer.h
> @@ -7,6 +7,9 @@
>  #include <linux/wait.h>
>
>  #ifdef CONFIG_FREEZER
> +
> +extern struct mutex freezer_lock;
> +
[...]
>  static inline int try_to_freeze(void)
>  {
>        if (freezing(current)) {
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 12b7458..b94c8f6 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -15,6 +15,7 @@
>  #include <linux/stop_machine.h>
>  #include <linux/mutex.h>
>  #include <linux/gfp.h>
> +#include <linux/freezer.h>
>
>  #ifdef CONFIG_SMP
>  /* Serializes the updates to cpu_online_mask, cpu_present_mask */
> @@ -280,7 +281,9 @@ int __ref cpu_down(unsigned int cpu)
>                goto out;
>        }
>
> -       err = _cpu_down(cpu, 0);
> +       mutex_lock(&freezer_lock);
> +       err = _cpu_down(cpu, tasks_are_frozen());
> +       mutex_unlock(&freezer_lock);
>

Can this even be compiled when CONFIG_FREEZER=n?
