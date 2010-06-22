Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab0FVUSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 16:18:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755611Ab0FVUSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 16:18:01 -0400
Date: Tue, 22 Jun 2010 13:16:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: TAMUKI Shoichi <tamuki@linet.gr.jp>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Blanchard <anton@samba.org>,
       Andi Kleen <andi@firstfloor.org>, Andy Green <andy@warmcat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH v4] panic: keep blinking in spite of long spin timer
 mode
Message-Id: <20100622131654.05032c22.akpm@linux-foundation.org>
In-Reply-To: <201006202252.AA00437@tamuki.linet.gr.jp>
References: <201006202252.AA00437@tamuki.linet.gr.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010 07:52:24 +0900
TAMUKI Shoichi <tamuki@linet.gr.jp> wrote:

> To keep panic_timeout accuracy when running under a hypervisor, the
> current implementation only spins on long time (1 second) calls to
> mdelay.  That brings a good effect, but the problem is the keyboard
> LEDs don't blink at all on that situation.
> 
> This patch changes to call to panic_blink_enter() between every mdelay
> and keeps blinking in spite of long spin timer mode.
> 
> The time to call to mdelay is now 100ms.  Even this change will keep
> panic_timeout accuracy enough when running under a hypervisor.
> 

Thaks for sticking with it - I think the code's a lot better now.  Are
you happy with it?

> ---
>  Changes since v3:
>  - get rid of CONFIG_PANIC_LONGSPIN_TIMER kernel config option
> 
>  Documentation/kernel-parameters.txt |    3 -
>  arch/arm/mach-s3c2440/mach-gta02.c  |   17 ++-----
>  drivers/input/serio/i8042.c         |   25 ++---------
>  include/linux/kernel.h              |    2 
>  kernel/panic.c                      |   58 +++++++++++---------------
>  5 files changed, 37 insertions(+), 68 deletions(-)

And isn't that a nice sight.

> --- a/drivers/input/serio/i8042.c
> +++ b/drivers/input/serio/i8042.c

Dmitry, I think drivers/input/serio/i8042.c is buggy.  It does

	panic_blink = NULL;

as the very last thing on module exit.  However it surely should do
this at least at the _start_ of i8042_exit() and I suspect it really
should be doing this at the start of i8042_shutdown()?

As things stand, a well-timed panic will end up trying to flash LEDs
via hardware which has been "shut down".

