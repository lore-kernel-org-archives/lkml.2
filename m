Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab2ECR7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 13:59:05 -0400
Received: from tservice.ru ([195.178.208.66]:54129 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754117Ab2ECR7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 13:59:03 -0400
Date: Thu, 3 May 2012 21:58:57 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] w1: Introduce a slave mutex for serializing IO.
Message-ID: <20120503175857.GA13988@ioremap.net>
References: <20120425124914.3187a794@notabene.brown>
 <20120501213958.GA15560@ioremap.net>
 <20120502162627.50544c8b@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120502162627.50544c8b@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 04:26:27PM +1000, NeilBrown (neilb@suse.de) wrote:
> Take takes me back to the deadlock.
> To be precise:
>   while scanning the w1 bus - with master->mutex held - w1_attach_slave_device
>   eventually calls into bq27000_battery_probe  which calls
>     power_supply_register -> device_add -> kobject_uevent_env
> 
>   and the to get all the data for the uevent, power_supply_uevent calls
>   the get_property callback which tries to read from the w1 bus and so
>   needs the master->mutex.  Which is held.  Deadlock.
> 
> So options seems to be:
>  - drop the lock while attaching slave devices
>  - create a list of slave devices, then attach them after the bus scan has
>    finished.
>  - have device_add run the kobject_uevent in a separate task (work_queue)
>  - or maybe the following which feels ugly but is easy.  Mark the bq27000 as
>    not ready until after the power_supply_register, and if get_property is 
>    called before the device is ready, return ENODATA.
>    Simple and works.  Maybe horrible.
>    power_supply_register will have scheduled a power_supply_changed() which
>    will poll

You can check mutex owner - and if it is you who holds it, then dig into
low-level function without lock.

-- 
	Evgeniy Polyakov
