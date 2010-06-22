Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab0FVUdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 16:33:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54390 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab0FVUdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 16:33:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xtjJtzww9TzKS0yHBKrotnNvWGO7prWYw+/rzIy1BWHiF07H/2SejukxnPj8mnKt2S
         VZyihNLESpYRZ9QnhN+YF3+o/5hiP2Fr4WEe05a4RemXq39mcwrpXVvOW0NkoqF57oef
         K6VBWlA9FKECLt7IYiSGc2ew0nJx+J/jD2dRA=
Date: Tue, 22 Jun 2010 13:33:17 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: TAMUKI Shoichi <tamuki@linet.gr.jp>, Ingo Molnar <mingo@elte.hu>,
       Anton Blanchard <anton@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Andy Green <andy@warmcat.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] panic: keep blinking in spite of long spin timer mode
Message-ID: <20100622203317.GA7401@core.coreip.homeip.net>
References: <201006202252.AA00437@tamuki.linet.gr.jp>
 <20100622131654.05032c22.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100622131654.05032c22.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 01:16:54PM -0700, Andrew Morton wrote:
> On Mon, 21 Jun 2010 07:52:24 +0900
> TAMUKI Shoichi <tamuki@linet.gr.jp> wrote:
> 
> > To keep panic_timeout accuracy when running under a hypervisor, the
> > current implementation only spins on long time (1 second) calls to
> > mdelay.  That brings a good effect, but the problem is the keyboard
> > LEDs don't blink at all on that situation.
> > 
> > This patch changes to call to panic_blink_enter() between every mdelay
> > and keeps blinking in spite of long spin timer mode.
> > 
> > The time to call to mdelay is now 100ms.  Even this change will keep
> > panic_timeout accuracy enough when running under a hypervisor.
> > 
> 
> Thaks for sticking with it - I think the code's a lot better now.  Are
> you happy with it?
> 
> > ---
> >  Changes since v3:
> >  - get rid of CONFIG_PANIC_LONGSPIN_TIMER kernel config option
> > 
> >  Documentation/kernel-parameters.txt |    3 -
> >  arch/arm/mach-s3c2440/mach-gta02.c  |   17 ++-----
> >  drivers/input/serio/i8042.c         |   25 ++---------
> >  include/linux/kernel.h              |    2 
> >  kernel/panic.c                      |   58 +++++++++++---------------
> >  5 files changed, 37 insertions(+), 68 deletions(-)
> 
> And isn't that a nice sight.
> 
> > --- a/drivers/input/serio/i8042.c
> > +++ b/drivers/input/serio/i8042.c
> 
> Dmitry, I think drivers/input/serio/i8042.c is buggy.  It does
> 
> 	panic_blink = NULL;
> 
> as the very last thing on module exit.  However it surely should do
> this at least at the _start_ of i8042_exit() and I suspect it really
> should be doing this at the start of i8042_shutdown()?
> 
> As things stand, a well-timed panic will end up trying to flash LEDs
> via hardware which has been "shut down".
> 

Andrew,

i8042_panic_blink() is designed to work standalone, without any support
from the rest of i8042 infrastructure - becase it is called during panic
it does not rely on interrupt handlers, locks or anything else so it
really does not matter at what point during driver removal we would
replace the handler. That said, if we were to move it upward so it is
symmetrical with the order in i8042_init() that'd be fine too.

BTW, changes to i8042 looks good, so:

	Acked-by: Dmitry Torokhov <dtor@mail.ru>

Thanks.

-- 
Dmitry
