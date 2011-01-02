Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab1ABTQm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 14:16:42 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57246 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab1ABTQl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 14:16:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:reply-to
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=kLTUk4tH3UxHqYBhNxUDudHlhy6Ts/N44l/uzwYHM9lKxWyb3adtPg1op6pPBOGviW
         oI0XaiHCi/RVOgGSqZ2pBTc4C3HFA7vrsvnNj6HJJECjmRLgN/CD/o+h5gR+l8c3kmFF
         AZXaahZ45WA6nGTcHSy93FMkhkIH1/bG8ZTK4=
Date: Sun, 2 Jan 2011 21:16:57 +0200
From: Yotam Medini <yotam.medini@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, Avery Pennarun <apenwarr@alumnit.ca>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: CONFIG_APM_POWER - still possible?
Message-ID: <20110102211657.164f92c6@janini.home>
In-Reply-To: <20101231142335.84e00497.rdunlap@xenotime.net>
References: <20101231193858.2c742025@janini.home>
	<20101231103345.baba0f8c.rdunlap@xenotime.net>
	<20101231212800.1e47f200@janini.home>
	<20101231113954.dc9adbdf.rdunlap@xenotime.net>
	<20101231234010.0165f0e8@janini.home>
	<20101231142335.84e00497.rdunlap@xenotime.net>
Reply-To: yotam.medini@gmail.com
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the hints I got here, I realized that /proc/apm
is supposed to be created (for x86) by:
   apm_init() @ arch/x86/kernel/apm_32.c
I added some debug printk messages in some places I considered related.
>From these I learned the following:

1. In setup_arch(...) @ arch/x86/kernel/setup.c:
	apm_info.bios = boot_params.apm_bios_info;
   it has the value:
        apm_info.bios.version == 0

2. In apm_init() @ arch/x86/kernel/apm_32.c:
  if (apm_info.bios.version == 0 || paravirt_enabled() || machine_is_olpc()) {
    printk(KERN_INFO "apm: BIOS not found.\n");
    return -ENODEV;
  }

  It gets here with
     apm_info.bios.version == 0
  This is why 'dmesg' shows:
     apm: BIOS not found
  and thus /proc/apm is not created.

3. In  query_apm_bios() @ arch/x86/boot/apm.c
   I added debug puts messages.
   But 'dmesg' showed none of them.

Could it be that some boot-command line parameters are not well passed
to the kernel?
Is the 'initrd' involved in this? I am not familiar with the 'black art' of
constructing 'initrd'. I am using mkinitramfs for this.
The initrd I get does manage to bring up the kernel, the file-systems
and a essentially - a running system.

I still have not tried compiling apm directly into the kernel.
I may try it later, but I believe the problem lies elsewhere.

Thanks for all the tips -- yotam


On Fri, 31 Dec 2010 14:23:35 -0800
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On Fri, 31 Dec 2010 23:40:10 +0200 Yotam Medini wrote:
>
> > ....
> >   $ sudo modprobe apm
> >   FATAL: Error inserting apm
> >     (/lib/modules/2.6.32.yumax/kernel/arch/x86/kernel/apm.ko): No such device
> > ....
> > Also the "/proc/apm" is created in
> >   drivers/char/Makefile:71
> >     obj-$(CONFIG_APM_EMULATION)	+= apm-emulation.o
> >   drivers/char/apm-emulation.c:668-670
>
> Hint: This is not the only place that /proc/apm is created.
> ....
