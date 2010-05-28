Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab0E1WMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 18:12:33 -0400
Received: from s12.ALPHA-c2.vectant.ne.jp ([222.230.51.12]:52764 "EHLO
	s12.ALPHA-c2.vectant.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753864Ab0E1WMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 18:12:31 -0400
Message-Id: <201005282211.AA00413@tamuki.linet.gr.jp>
From: TAMUKI Shoichi <tamuki@linet.gr.jp>
Date: Sat, 29 May 2010 07:11:06 +0900
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Anton Blanchard <anton@samba.org>, Andy Green <andy@warmcat.com>,
       TAMUKI Shoichi <tamuki@linet.gr.jp>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] panic: keep blinking in spite of long spin timer mode
In-Reply-To: <20100528091354.GA16587@basil.fritz.box>
References: <20100528091354.GA16587@basil.fritz.box>
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.13
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, May 28, 2010 at 11:13:54 +0200, Andi Kleen wrote:
> > To keep panic_timeout accuracy when running under a hypervisor, the
> > current implementation only spins on long time (1 second) calls to
> > mdelay.  That brings a good effect, but we must give up blinking even
> > if we have a panic_blink.
> > 
> > This patch keeps blinking in spite of long spin timer mode.
> > 
> > We now have new kernel parameter (panic_longspin) to enable long spin
> > timer mode when kernel panics.  This is to be used when running under
> > a hypervisor (default is disable).
> 
> Sorry I didn't understand the problem based on your description.
> 
> What exactly is the problem with the current code under your
> hypervisor?
> 
> New parameters for this are probably not the right answer,
> who would figure out when to set them.

Sorry for my poor explanation.

As Anton Blanchard wrote, who posted "[PATCH] panic: Fix panic_timeout
accuracy when running on a hypervisor", he had had some complaints
about panic_timeout being wildly innacurate on shared processor PowerPC
partitions (a 3 minute panic_timeout taking 30 minutes).

The fact is we loop on mdelay(1) and with a 1ms in 10ms hypervisor
timeslice each of these will take 10ms (i.e. 10x) longer.  To avoid
this, it had been changed to do 1 second mdelays if we don't have a
panic_blink.

The problem is the keyboard LEDs don't blink at all on that situation.

Therefore, I changed to call panic_blink_enter() between every mdelay.
The default time calls to mdelay is 1ms.  If the kernel parameter
panic_longspin is set to true, it will be switched to 240ms and the
maximum speed of blinking will be automatically limited slower due to
the granularity of the blinking time.

It is complicated to change the speed of panic blink that the indi-
vidual drivers do.

This is the reason why the place to control blinking has been moved
from panic_blink() (i.e. gta02_panic_blink() or i8042_panic_blink()
for now) to panic_blink_enter().

Regards,
TAMUKI Shoichi
