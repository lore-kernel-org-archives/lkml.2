Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1GMNOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 09:14:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41480 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab1GMNOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 09:14:12 -0400
Date: Wed, 13 Jul 2011 15:14:07 +0200
From: Tejun Heo <tj@kernel.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-ide@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jgarzik@pobox.com>,
        Michael Leun <lkml20100708@newton.leun.net>,
        linux-kernel@vger.kernel.org, Jian Peng <jipeng2005@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>
Subject: Re: ahci_start_engine compliance with AHCI spec
Message-ID: <20110713131407.GN2872@htj.dyndns.org>
References: <CAN8TOE9CCSiS2koyx=UsZj=9KwaWZW5yDjUUqgJf2=qZU70k1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN8TOE9CCSiS2koyx=UsZj=9KwaWZW5yDjUUqgJf2=qZU70k1w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jul 08, 2011 at 04:01:17PM -0700, Brian Norris wrote:
> I am able to reproduce the regressions seen by Rafael and Michael on
> my Dell Latitude E6410 laptop, in case that's helpful.

Oh yes, it is.

> - ahci_init_one
> -- ata_host_activate
> --- ata_host_start
> ---- ahci_port_start
> ---- ahci_port_resume
> ----- ahci_start_port
> ------ ahci_power_up [1]
> ------ ahci_start_engine (DRQ or BSY *will* be active) [2]
> 
> and later
> 
> - scsi_error_handler
> -- ata_scsi_error
> --- ata_scsi_port_error_handler
> ---- ahci_error_handler
> ----- sata_pmp_error_handler
> ------ ata_eh_recover
> ------- ata_eh_reset
> -------- ata_do_reset
> --------- ahci_hardreset
> ---------- ahci_start_engine (DRQ, BSY cleared, link up)
> 
> I'm not sure if the "error_handler" and "hard reset" processes are
> intended for initialization...as I said I'm a little new!

That's how it's supposed to work.  EH is integral part of probing
sequence.

> I have a few other questions:
> 
> What operation could be putting devices in DRQ or BSY states during
> initialization but before ahci_start_engine?

Hmmm... I have no idea, maybe it has something to do with the first
D2H Reg FIS device sends after link gets reset during controller init?

> I bring up all of this because it seems that if I put some amount of
> "wait time" between [1] and [2] above, then my system transitions from
> DRQ to BSY and its link is connected (PxSSTS.DET == 0x3). I still
> don't know why the device is BSY, but at least it solves my problem...
> Perhaps I will try implementing the wait with ata_wait_register (or
> maybe ata_wait_ready + ata_phys_link_online) on the PxSSTS.DET flags
> and send a patch.

Hmmm... what happens if you don't comment out ahci_start_engine() call
from ahci_start_port()?

> Sorry if this e-mail is too complicated or disorganized. I've been
> racking my brain on this one for a few weeks now, and I've only come
> up with a few half answers and some more questions. Feel free to ask
> for more explanation, but don't worry if I don't respond immediately,
> as I am on vacation for all of next week. If I don't get to them
> before I leave, I will get to your replies when I return.

Is this the same IP block that Jian Peng was using?

Thanks.

-- 
tejun
