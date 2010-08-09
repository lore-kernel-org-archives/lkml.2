Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab0HIOOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 10:14:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33189 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab0HIOOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 10:14:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DBeKQbMUvccadXewcLlMifIcDHS+MsJSvhusw7eHup/MXdk7VtFYuFr/KXYXJquuCt
         dF7lY/n7YXP6TzVhv1CY4DM/N5lh6b4tF0NJslGI2vVsO3Yjmw/uLnFHKKiN/xmbFQcf
         B82etxzjFzRMYfb13TkML+PDGfNJyp7NhrmS0=
Message-ID: <4C600918.9030503@gmail.com>
Date: Mon, 09 Aug 2010 06:56:40 -0700
From: walt <w41ter@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b3pre) Gecko/20100727 Shredder/3.2a1pre
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH wq#for-linus] workqueue: workqueue_cpu_callback() should
 be cpu_notifier not hotcpu_notifier
References: <i3n3dh$t48$1@dough.gmane.org> <20100809063742.GA1632@arch.tripp.de> <20100809083053.GB2169@osiris.boeblingen.de.ibm.com> <20100809083451.GC2169@osiris.boeblingen.de.ibm.com> <4C5FC49B.9040208@kernel.org> <4C5FCC14.6030901@gmail.com>
In-Reply-To: <4C5FCC14.6030901@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2010 02:36 AM, Tejun Heo wrote:
> Commit 6ee0578b (workqueue: mark init_workqueues as early_initcall)
> made workqueue SMP initialization depend on workqueue_cpu_callback(),
> which however was registered as hotcpu_notifier() and didn't get
> called if CONFIG_HOTPLUG_CPU is not set.  This made gcwqs on non-boot
> CPUs not create their initial workers leading to boot failures.  Fix
> it by making it a cpu_notifier.
> ---
> So, something like this.  Can you please verify the fix?

>
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index da6c482..2994a0e 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -3527,7 +3527,7 @@ static int __init init_workqueues(void)
>   	unsigned int cpu;
>   	int i;
>
> -	hotcpu_notifier(workqueue_cpu_callback, CPU_PRI_WORKQUEUE);
> +	cpu_notifier(workqueue_cpu_callback, CPU_PRI_WORKQUEUE);

This fixes the hang during boot for me too, thanks.
