Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab1GEPVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 11:21:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61542 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab1GEPVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 11:21:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
Date: Tue, 5 Jul 2011 17:21:01 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "David S. Miller" <davem@davemloft.net>
References: <20110704170949.11059.92774.stgit@ponder> <20110704180159.GA11278@ponder.secretlab.ca> <20110705142149.GA3498@suse.de>
In-Reply-To: <20110705142149.GA3498@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107051721.02079.arnd@arndb.de>
X-Provags-ID: V02:K0:n43uIpdhgp9M9C3gSJBAw6fT5qw7tW8NiT4xTA2hHcE
 6LQP5s5IQRd0AiJ1K0AB2Ir3m6unhEGqbOyO3oTAcwg3iTrwdT
 cVnDuEh8DAB9ZY63TNR1b0WiZOEYgTQsTFRKi49i3sGwnvJK0M
 zyenFcFfgQX5CCzxxtM4392nO/u9j/0vweQFuTGGcZ0aQ7MDlr
 oVQQWlnQC3HPcA+2KsE+w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 July 2011, Greg KH wrote:
> So the driver core is just going to sit and spin and continue to try to
> probe drivers for as long as it gets that error value returned?  What is
> going to ever cause that loop to terminate?  It seems a bit hacky to
> just keep looping over and over and hoping that sometime everything will
> all settle down so that we can go to sleep again.

Well, it only needs to try as long as there are still new devices
succeeding to get probed. The order that I think this should happen
in is:

* go through all initcalls, record any devices that are not yet ready
* retry all devices on the list as long as at least one of them has
  succeeded.
* when a new device gets matched from a module load, do that loop again

If I read the patch correctly, the workqueue would be scheduled
every time a new device gets added, which retries the devices
more often than necessary and can have significant boot time
impact, and it also introduces more asynchronicity that may expose
new bugs.

Maybe we can have a late_initcall that enables the automatic retry
and probes everything once:

static bool deferred_probe;
static int __init deferred_probe_start(void)
{
	deferred_probe = true;
	mutex_lock(&deferred_probe_mutex);
	if (!list_empty(&deferred_probe_list))
		schedule_work(&deferred_probe_work);
	mutex_unlock(&deferred_probe_mutex);
	flush_work_sync(&deferred_probe_work);
}
late_initcall(retry_devices);

	Arnd
