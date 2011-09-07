Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab1IGTHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 15:07:47 -0400
Received: from relais.videotron.ca ([24.201.245.36]:13059 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab1IGTHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 15:07:45 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Wed, 07 Sep 2011 15:07:42 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Kbuild: allow code re-use across different directories
In-reply-to: <1313800642-32418-1-git-send-email-lacombar@gmail.com>
Message-id: <alpine.LFD.2.00.1109071437400.20358@xanadu.home>
References: <1313800642-32418-1-git-send-email-lacombar@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Aug 2011, Arnaud Lacombe wrote:

> Hi folks,
> 
> The attached patch modify Kbuild to allow to directly re-use code in multiple
> directory without having to go through a copy. Technically, it changes Kbuild to
> use by default the VPATH feature of GNU make and provides accessors for Makefile
> to change it indirectly.
> 
> Considering:
> 
> arch/foo/lib:
> fancy.c
> 
> We want to be able to build it with -DPANTS=32 in the kernel, but the
> bootloader requires -DPANTS_SIZE=30.
> 
> Currently we would do, either:
> 
> arch/foo/lib/Makefile
> LDFLAGS_fancy.o := -DPANTS=32
> obj-y += fancy.o
> 
> and, either:
> 
> arch/foo/boot/Makefile:
> LDFLAGS_fancy.o := -DPANTS=30
> obj-y += fancy.o
> $(obj)/fancy.c: $(srctree)/arch/foo/lib/fancy.c
> 	$(call cmd,shipped)
> 
> or
> 
> arch/foo/boot/Makefile:
> LDFLAGS_fancy.o := -DPANTS=30
> obj-y += fancy.o
> $(obj)/fancy.o: $(srctree)/arch/foo/lib/fancy.c
> 	$(call cmd,cc_c_o)
> 
> The former implies an extra copy of the source file, the latter expose Kbuild
> internal function.
> 
> With the attached patch, we would do:
> 
> arch/foo/boot/Makefile:
> LDFLAGS_fancy.o := -DPANTS=30
> obj-y += fancy.o
> vpath-y += $(srctree)/arch/foo/lib
> 
> and let GNU make do the job.
> 
> Comments welcome,

It doesn't work.  Whatever I do to arch/arm/boot/compressed/Makefile 
(which admittedly looks a bit hairy and could benefit from a shave) in 
order to remove the $(call cmd,shipped) used with lib1funcs.S, I always 
end up with:

make[2]: *** No rule to make target `arch/arm/boot/compressed/lib1funcs.S', needed by `arch/arm/boot/compressed/lib1funcs.o'.  Stop.

Obviously, restoring the explicit dependency with a $(call cmd,as_o_S) 
does make it work, but this is rather against the point of your patch.

Do you have an example of how arch/arm/boot/compressed/Makefile should 
be changed to benefit from your patch?


Nicolas
