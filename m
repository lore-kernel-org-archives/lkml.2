Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab2EUExT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 00:53:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47254 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab2EUExR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 00:53:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120520195126.GA11282@kroah.com>
References: <20120518045907.GA3397@kroah.com>
	<CACVXFVPhPmTfdB-pKpz7NpL+N03cxDvPpiFdPWeZcqBNNSffYw@mail.gmail.com>
	<20120520195126.GA11282@kroah.com>
Date: Mon, 21 May 2012 12:53:14 +0800
Message-ID: <CACVXFVPeicEStTqtdO3Jt32JuhP3+_kof7vqgErK_iSDWdt92w@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_Race_condition_between_driver=5Fprobe=5Fdevice_and_d?=
	=?UTF-8?Q?evice=5Fshutdown=E2=80=8F?=
From: Ming Lei <ming.lei@canonical.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux PM List <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc pm list because it is related with PM.

Hi Greg,

On Mon, May 21, 2012 at 3:51 AM, Greg KH <gregkh@linuxfoundation.org> wrote:

>
> And how can that happen with a real bus?  Don't we have a lock

The races may be triggered when one device is just probed(triggered
by plug) or released(triggered by unplug) at the same time of running
reboot/poweroff.

> somewhere per-bus that should be protecting this type of thing (sorry,
> can't dig through the code at the moment, on the road...)

device_shutdown is called with only holding reboot_mutex, so I think no
any protection on dev->driver there.

>
> How come no one has ever hit them in the past 10 years?  What am I
> missing here?

The window is so small that maybe it is very very difficult to trigger
the races, :-)
But looks Wedson is luck enough to observe it.

>> Looks the above makes sense to serialize .shutdown with
>> .probe and .release.
>
> Let me look at the code when I get back in a few days, but I really
> thought we already had a lock protecting all of this...

Also the previous patch don't cover the .runtime_resume races with
.probe or .release, so the right fix may be below:

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 346be8b..cbc8bd2 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1820,6 +1820,11 @@ void device_shutdown(void)
 		list_del_init(&dev->kobj.entry);
 		spin_unlock(&devices_kset->list_lock);

+		/*hold lock[s] to avoid races with .probe/.release*/
+		if (dev->parent)
+			device_lock(dev->parent);
+		device_lock(dev);
+
 		/* Don't allow any more runtime suspends */
 		pm_runtime_get_noresume(dev);
 		pm_runtime_barrier(dev);
@@ -1831,6 +1836,9 @@ void device_shutdown(void)
 			dev_dbg(dev, "shutdown\n");
 			dev->driver->shutdown(dev);
 		}
+		device_unlock(dev);
+		if (dev->parent)
+			device_unlock(dev->parent);
 		put_device(dev);

 		spin_lock(&devices_kset->list_lock);

Another candidate fix is to register a reboot notifier in driver core to prevent
driver from being bound or unbound from start of reboot/shutdown, but looks
not easy as the way of holding device locks.


Thanks,
--
Ming Lei
