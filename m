Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab0FCWbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 18:31:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751510Ab0FCWbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 18:31:14 -0400
Date: Thu, 3 Jun 2010 15:30:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: TAMUKI Shoichi <tamuki@linet.gr.jp>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Blanchard <anton@samba.org>,
       Andi Kleen <andi@firstfloor.org>, Andy Green <andy@warmcat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] panic: keep blinking in spite of long spin timer
 mode
Message-Id: <20100603153016.cbe6ff0c.akpm@linux-foundation.org>
In-Reply-To: <201006032201.AA00424@tamuki.linet.gr.jp>
References: <201006032201.AA00424@tamuki.linet.gr.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Jun 2010 07:01:16 +0900
TAMUKI Shoichi <tamuki@linet.gr.jp> wrote:

> To keep panic_timeout accuracy when running under a hypervisor, the
> current implementation only spins on long time (1 second) calls to
> mdelay.  That brings a good effect, but the problem is the keyboard
> LEDs don't blink at all on that situation.
> 
> This patch changes to call to panic_blink_enter() between every mdelay
> and keeps blinking in spite of long spin timer mode.
> 
> The default time to call to mdelay is 1ms.  If the speed of blinking
> is slow enough, the time to call to mdelay will be automatically
> switched to longer.  This is suitable when running under a hypervisor.
> 
> ...
> 
>  Documentation/kernel-parameters.txt |    8 +-
>  arch/arm/mach-s3c2440/mach-gta02.c  |   17 +----
>  drivers/input/serio/i8042.c         |   25 +-------
>  include/linux/kernel.h              |    2 
>  kernel/panic.c                      |   77 +++++++++++++++++---------
>  5 files changed, 67 insertions(+), 62 deletions(-)

It cleans up the led-blinking implementations nicely.  That's good.

> 
> ...
>
> +	panicblink=	[KNL] The speed of panic blink (default is 12 wpm)
> +			The period of panic blink can be computed by the
> +			formula T = 7200 / W, where T is the period in milli-
> +			seconds, W is the speed in wpm (words per minute).
> +			Should be 5 or less when running under a hypervisor

Nobody will know what "wpm" means.  What is a "word" in this context? 
Unclear.

How about "bpm": "blinks per minute".  That's nice and direct.

>
> ...
>
>  
> +	if (panic_blink_wpm <= 0 || panic_blink_wpm > 100)
> +		panic_blink_wpm = 12;

hm, OK.  Or we could do

	if (panic_blink_wpm <= 0)
		panic_blink_wpm = 1;
	if (panic_blink_wpm > 100)
		panic_blink_wpm = 100;

which is handily encapsulated in the clamp() macro which nobody uses.

> +	if (!panic_blink)
> +		panic_blink = no_blink;

Can we initialise panic_blink to no_blink at compile-time then remove this?

>
> ...
>

