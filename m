Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711Ab1J1Wqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 18:46:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752Ab1J1Wqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 18:46:31 -0400
Date: Fri, 28 Oct 2011 15:46:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: holzheu@linux.vnet.ibm.com
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, schwidefsky@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [PATCH] kdump: Add udev events for memory online/offline
Message-Id: <20111028154630.77c7b96c.akpm@linux-foundation.org>
In-Reply-To: <1319707965.2830.1.camel@br98xy6r>
References: <1319645292.3321.24.camel@br98xy6r>
	<20111026192449.GE355@redhat.com>
	<20111027073058.GA2422@osiris.boeblingen.de.ibm.com>
	<1319707965.2830.1.camel@br98xy6r>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Oct 2011 11:32:45 +0200
Michael Holzheu <holzheu@linux.vnet.ibm.com> wrote:

> From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> 
> Currently no udev events for memory hotplug "online" and "offline" are
> generated:
> 
> # udevadm monitor
> # echo offline > /sys/devices/system/memory/memory4/state
> ==> No event
> 
> When kdump is loaded, kexec detects the current memory configuration and
> stores it in the pre-allocated ELF core header. Therefore, for kdump it is
> necessary to reload the kdump kernel with kexec when the memory
> configuration changes (e.g. for online/offline hotplug memory).
> 
> In order to do this automatically, udev rules should be used. This kernel
> patch adds udev events for "online" and "offline". Together with this kernel
> patch, the following udev rules for online/offline have to be added to
> "/etc/udev/rules.d/98-kexec.rules":
> 
> SUBSYSTEM=="memory", ACTION=="online", PROGRAM="/etc/init.d/kdump restart"
> SUBSYSTEM=="memory", ACTION=="offline", PROGRAM="/etc/init.d/kdump restart"
> 
> Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> ---
>  drivers/base/memory.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -310,11 +310,15 @@ store_mem_state(struct sys_device *dev,
>  
>  	mem = container_of(dev, struct memory_block, sysdev);
>  
> -	if (!strncmp(buf, "online", min((int)count, 6)))
> +	if (!strncmp(buf, "online", min((int)count, 6))) {
>  		ret = memory_block_change_state(mem, MEM_ONLINE, MEM_OFFLINE);
> -	else if(!strncmp(buf, "offline", min((int)count, 7)))
> +		if (ret == 0)
> +			kobject_uevent(&dev->kobj, KOBJ_ONLINE);
> +	} else if (!strncmp(buf, "offline", min((int)count, 7))) {
>  		ret = memory_block_change_state(mem, MEM_OFFLINE, MEM_ONLINE);
> -
> +		if (ret == 0)
> +			kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
> +	}
>  	if (ret)
>  		return ret;
>  	return count;

I think a safer place from which to send the uevent is
memory_block_change_state() or even memory_block_action().  Because if
either of those functions later gets new callers, those callers might
forget to send the uevent?

