Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab1DWNwf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 09:52:35 -0400
Received: from www17.your-server.de ([213.133.104.17]:40751 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab1DWNwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 09:52:34 -0400
Subject: Re: FW: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel"
 on quad Pentium Pro system
From: Thomas Meyer <thomas@m3y3r.de>
To: Yuhong Bao <yuhongbao_386@hotmail.com>
Cc: hpa@zytor.com, chris@csamuel.org, alan@lxorguk.ukuu.org.uk,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <SNT125-W501A69BD9948F037646EDFC3940@phx.gbl>
References: <201104222333.25546.chris@csamuel.org>
	 <201104231522.06057.chris@csamuel.org>
	 <SNT125-W25B0C502FF72465BC6B55BC3940@phx.gbl>
	 ,<201104231855.47680.chris@csamuel.org>
	 <SNT125-W501A69BD9948F037646EDFC3940@phx.gbl>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Apr 2011 15:52:27 +0200
Message-ID: <1303566747.12067.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 23.04.2011, 03:47 -0700 schrieb Yuhong Bao:
> FYI, I walked Chris on how to use DOS DEBUG via private email, and below is the results after the INT 15, using the instruction sequence I posted on the mailing list.Notice HIMEM was not loaded. 
> 
> ----------------------------------------
> > From: chris@csamuel.org
> > To: yuhongbao_386@hotmail.com
> > Subject: Re: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on quad Pentium Pro system
> > Date: Sat, 23 Apr 2011 18:55:44 +1000
> >
> > On Sat, 23 Apr 2011 06:28:26 PM Yuhong Bao wrote:
> >
> >> Actually, execute with G instead, and do it without HIMEM.SYS
> >> loaded.
> >
> > I couldn't see any HIMEM.SYS on the FreeDOS floppy (including
> > looking for hidden files) so I'm presuming it's not there. There
> > was a HIMEM.EXE so I've renamed it to NOHIMEM.OFF in the hope
> > that it won't get executed, even in the safe mode I was using.
> >
> > Using G instead of A I now get:
> >
> > -G
> > Unexpected breakpoint interrupt.
> > AX=3C00 BX=0F00 CX=0000 DX=0000 SP=FFFE BP=0000 SI=0000 DI=0000
> > DS=2890 ES=2890 SS=2890 CS=2890 IP=0106 NV UP DI PL NZ NA PE NC
> > 2890:0106 0000 ADD [BX+SI], AL D:0F00=00
> > -
> >

so your bios seems to report the size in AX/BX. the code in
arch/x86/boot/memory.c move the return sizes from CX/DX into AX/BX, when
CX or DX is not zero.

Could you try to change the line:

	} else if (oreg.ax == 15*1024) {
		boot_params.alt_mem_k = (oreg.dx << 6) + oreg.ax;

to
	} else if (oreg.ax == 15*1024) {
		boot_params.alt_mem_k = (oreg.bx << 6) + oreg.ax;

That should fix your misdetection.

The assembler code in arch/i386/boot/setup.S seemed to move AX/BX into
CX/DX, when CX and(!) DX were zero. Then used CX/DX to calc the memory
size.

PS: gitk --follow arch/x86/boot/memory.c seems to react strangley...


