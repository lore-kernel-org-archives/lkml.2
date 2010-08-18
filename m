Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab0HRT30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 15:29:26 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:32839 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab0HRT3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 15:29:24 -0400
Date: Wed, 18 Aug 2010 21:28:58 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Joerg Roedel <joro@8bytes.org>, "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Seidel, Conny" <Conny.Seidel@amd.com>,
        "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>,
        "greg@kroah.com" <greg@kroah.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2 2/2] x86, cpu hotplug: Fix cpu bringup concurrency
 issue
Message-ID: <20100818192858.GC12842@aftab>
References: <4C5AC736.20903@zytor.com>
 <20100812144142.GY23755@8bytes.org>
 <4C64148D.5080305@zytor.com>
 <20100812170644.GZ23755@8bytes.org>
 <4C644507.9020606@zytor.com>
 <20100812190414.GA23755@8bytes.org>
 <20100813123543.GC9046@aftab>
 <20100816121933.GA28147@aftab>
 <20100816123959.GC28147@aftab>
 <4C6C2E85.9050401@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6C2E85.9050401@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, Aug 18, 2010 at 03:03:33PM -0400

> On 08/16/2010 05:39 AM, Borislav Petkov wrote:
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index dcb0593..1598663 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -58,6 +58,7 @@ config X86
> >  	select ANON_INODES
> >  	select HAVE_ARCH_KMEMCHECK
> >  	select HAVE_USER_RETURN_NOTIFIER
> > +	select ARCH_CPU_PROBE_RELEASE
> >  
> 
> warning: (X86) selects ARCH_CPU_PROBE_RELEASE which has unmet direct
> dependencies (HOTPLUG_CPU)

well I got 

+config ARCH_CPU_PROBE_RELEASE
+       def_bool y
+       depends on HOTPLUG_CPU

but I guess ARCH_CPU_PROBE_RELEASE gets selected still. Why isn't that
"depends on" forcing it, I guess select is stronger.

> ... and build failure when compiling without CONFIG_HOTPLUG_CPU.

This hunk fixes the !CONFIG_HOTPLUG_CPU build here but I should've
caught it earlier, shame on me. Sorry for the inconvenience, can you
please drop this second patch for now, I'll send you a revised version
tomorrow.

Thanks.

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 251acea..273cfb9 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -261,7 +261,7 @@ int __init cpu_dev_init(void)
 }
 
 static struct sysdev_class_attribute *cpu_sysdev_class_attrs[] = {
-#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
+#if defined(CONFIG_ARCH_CPU_PROBE_RELEASE) && defined(CONFIG_HOTPLUG_CPU)
        &attr_probe,
        &attr_release,
 #endif


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
