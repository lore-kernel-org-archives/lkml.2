Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab1GVJDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 05:03:24 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:42673 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab1GVJDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 05:03:22 -0400
Date: Fri, 22 Jul 2011 11:03:17 +0200
From: Tejun Heo <tj@kernel.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-ide@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jgarzik@pobox.com>,
        Michael Leun <lkml20100708@newton.leun.net>,
        linux-kernel@vger.kernel.org, Jian Peng <jipeng2005@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>
Subject: Re: ahci_start_engine compliance with AHCI spec
Message-ID: <20110722090317.GH2622@htj.dyndns.org>
References: <CAN8TOE9CCSiS2koyx=UsZj=9KwaWZW5yDjUUqgJf2=qZU70k1w@mail.gmail.com>
 <20110713131407.GN2872@htj.dyndns.org>
 <CAN8TOE9Rjujf9aLQGONDULNasFiQmVkiUPWUDX=Vf0Nx2pka7w@mail.gmail.com>
 <20110721084917.GE3455@htj.dyndns.org>
 <CAN8TOE_dCg6Wi_trE97hXjBPnZi4jpLyoeUEVrbMpgDH-BwKWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN8TOE_dCg6Wi_trE97hXjBPnZi4jpLyoeUEVrbMpgDH-BwKWA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Brian.

On Thu, Jul 21, 2011 at 10:13:16AM -0700, Brian Norris wrote:
> On Thu, Jul 21, 2011 at 1:49 AM, Tejun Heo <tj@kernel.org> wrote:
> > On Mon, Jul 18, 2011 at 11:40:17AM -0700, Brian Norris wrote:
> >> On Wed, Jul 13, 2011 at 6:14 AM, Tejun Heo <tj@kernel.org> wrote:
> >> > Hmmm... what happens if you don't comment out ahci_start_engine() call
> >> > from ahci_start_port()?
> >>
> >> I wasn't commenting out the ahci_start_engine() from
> >> ahci_start_port(). Can you clarify what you mean?
> >
> > Oh, I meant "what if you comment out..."  I wrote that sentence in
> > negative and then switched but forgot removing "don't".
> 
> OK, well I tried simply commenting out that ahci_start_engine() on
> both my special controller and on the Dell E6410 laptop and it worked
> just fine (solved my issues and didn't cause any issues on the Dell).
> Is this safe? It seems like we end up calling ahci_start_engine() at
> the end of the error handling process anyway, so maybe this call is
> not really necessary in the first place?

Yes, I believe so.

> Anyway, I also tried my own fix for this: adding a small delay to wait
> for some link recognition at the end of ahci_power_up(). I'm not sure
> if this is the greatest, but it also works for both systems I'm
> testing. I included the test patch here (based on linux-2.6). BTW, I'm
> not sure my mail will be formatted perfectly here. I can resend with
> my other mailer if needed.

The problem is that both my and your approach aren't ultimately safe
on this particular IP block.  I don't think it's possible make things
completely safe for it.  There's no mutual exclusion against PHY
events - be it flaky signal, power surge or actual hotplug - and
driver operation.  No matter how careful the driver behaves, if PHY
events happen after the last check before starting DMA engine, DRQ may
be set by the time driver gets to it.

The IP block you're dealing with is inherently buggy.  What the spec
means, I think, is the DMA engine might not start or behave properly
if enabled while DRQ is set, which is fine.  Driver will notice that,
reset stuff and retry.  It is *completely* different from "the
controller becomes brick until power cycled if that happens".  So, we
can work around all we want but that is one buggy controller.  If
possible, please tell the manufacturer or licensor to fix it.

For now, let's first try removing ahci_start_engine() call from
port_start and see how that goes.

Thanks.

-- 
tejun
