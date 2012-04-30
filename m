Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab2D3QG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 12:06:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47100 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab2D3QG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 12:06:28 -0400
Date: Mon, 30 Apr 2012 11:50:18 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: udev races with 'arch_register_cpu' to write 1 to
 /sys/devices/system/cpu/cpu1/online (which is not yet created).
Message-ID: <20120430155018.GA16794@kroah.com>
References: <20120430153623.GA23485@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120430153623.GA23485@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 11:36:23AM -0400, Konrad Rzeszutek Wilk wrote:
> Hey Greg,
> 
> Hoping you can help with some guidance on how to fix this.
> 
> The issue is with CPU hotplug is that when a CPU goes up
> it calls 'arch_register_cpu' which eventually calls
> register_cpu. That function does these two things:
> 
> 251         error = device_register(&cpu->dev);
> 252         if (!error && cpu->hotpluggable)
> 253                 register_cpu_control(cpu);
> 
> and the device_register creates a nice little SysFS directory:
> 
> /sys/devices/system/cpu/cpu2/ which at line 251 has the 'add' attribute
> but no 'online' attribute. udev then tries to echo 1 to the 'online'
> and it we get:
> udevd-work[2421]: error opening ATTR{/sys/devices/system/cpu/cpu2/online} for writing: No such file or directory
> 
> Line 253 creates said 'online' and at that time udev [or the system admin]
> can write 1 to 'online' and the CPU goes up.
> 
> So .. any thoughts? Is there some way to inhibit from uevent being sent
> until line 253 has run?

Yes.
