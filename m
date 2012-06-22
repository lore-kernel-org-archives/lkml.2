Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761103Ab2FVDgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 23:36:38 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:54512 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab2FVDgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 23:36:37 -0400
Date: Fri, 22 Jun 2012 05:36:34 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Peter Zijlstra <peterz@infradead.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
Message-ID: <20120622033634.GG29505@aftab.osrc.amd.com>
References: <1340121811-4477-3-git-send-email-bp@amd64.org>
 <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
 <20120619232857.GH5996@aftab.osrc.amd.com>
 <4FE26155.8030207@zytor.com>
 <20120621100721.GB6437@aftab.osrc.amd.com>
 <4FE3ADDF.2060908@zytor.com>
 <20120622025631.GD29505@aftab.osrc.amd.com>
 <4FE3E428.8080207@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE3E428.8080207@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 08:19:04PM -0700, H. Peter Anvin wrote:
> On 06/21/2012 07:56 PM, Borislav Petkov wrote:
> >>
> >> That is orthogonal.  Anyway, my only concern about the request_firmware
> >> interface is that the timing will be inherently wrong.
> > 
> > Timing? Please elaborate.
> > 
> 
> The request_firmware will happen as soon as the driver is loaded; with
> the early microcode blob scheme the driver will need to be built in and
> so the request_firmware will happen, redundantly, immediately...

I see the problem: we will just have updated the latest ucode from the
early scheme and then shortly after do a request_firmware to find out
that we don't have a newer patch anyway.

Hmm, ok, when I tried compiling in the microcode driver this week, it
didn't wait for 60 seconds because there was no userspace at 3 seconds
within the boot - it simply continued booting.

I think there's a guard for this in microcode_init_cpu:

        if (system_state != SYSTEM_RUNNING)
		return UCODE_NFOUND;

so that we don't call request_firmware that early.

But I haven't verified this yet.

In any case, we should disallow the request_firmware call temporarily
during init when the early scheme is in place.

But there is another problem:

What if BIOS has patch version 1 (numbers are only for showing what I
mean), then early scheme applies patch v2 but there is a newer patch
version 3 in /lib/firmware?

If the ucode driver is built in, we don't get to update to v3
automatically. User has to do it.

The current fix for this situation is have the microcode.ko as module
(and only allow it as M) which then automatically does request_firmware
at module init time and loads v3.

Which doesn't help people who don't build modules...

Hmmm.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
