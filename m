Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab1EQUno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 16:43:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50007
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932259Ab1EQUnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 16:43:43 -0400
Date: Tue, 17 May 2011 13:43:12 -0700 (PDT)
Message-Id: <20110517.134312.226762699.davem@davemloft.net>
To: mroos@linux.ee
Cc: sparclinux@vger.kernel.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Subject: Re: SBus devices sometimes detected, sometimes not
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.SOC.1.00.1105021259220.6200@math.ut.ee>
References: <alpine.SOC.1.00.1105021259220.6200@math.ut.ee>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Mon, 2 May 2011 13:39:46 +0300 (EEST)

> This is 2.6.39-rc3..rc5 on Sun Ultra 1 with SBus hme card.
> On about 50% of boots, hme is found fine and works. On other half boots 
> (not strictly in any order) SBus hme is not detected with this error:
> 
> hme: probe of f006be34 failed with error -22
> 
> grepping the logs, I sometimes also find similar errors about qlogicpti:
> 
> qpti: probe of f00798c4 failed with error -22
> 
> The node addresses are always the same for the device.
> 
> 2.6.38 did not have this problem.

Grant, I'm trying to diagnose this bug report which is a 2.6.39-rcX regression
and I think it's a side-effect of your changes to move away from
of_platform_{,un}register_driver().

Somehow an OF device driver's ->probe() is being called with a NULL
"->of_match", that's why the probe returns -22 (-EINVAL) since in
your transformations that is the first thing you check.

There are only a few ways this can happen that I can tell, firstly
the of_driver_match_device() call has to fail.

It could then happen if pdrv->id_table is non-NULL, but in these two
cases (drivers/net/sunhme.c:hme_sbus_driver and
drivers/scsi/qlogicpti.c:qpti_sbus_driver) no id_table is assigned.

The next possibility would be if pdrv->name matches the device's
name, but in these two cases ("SUNW,hme" vs. "hme" and "QLGC,pti"
vs. "qpti") that should not be the case either.

There is only one more way this could happen, and that is if the
device bus pointer is NULL.  Because in that situation the
match function doesn't get called and all devices can match.

This is also very unlikely, because platform_device_add() always
assigns pdev->dev.bus to &platform_bus_type before the device_add()
call.

The fact that this failure happens only on some boots for Meelis leads
me to belive that some datastructure is corrupted.  Perhaps there is
an incorrect __init or __devinit somewhere, or we reference freed up
data some other way.

Any ideas?
