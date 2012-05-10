Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab2EJCxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 22:53:13 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39380 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab2EJCxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 22:53:12 -0400
MIME-Version: 1.0
Date: Wed, 9 May 2012 19:53:11 -0700
Message-ID: <CANeycqor6oHnBfykWGrLkz0YhO5VXZCPh2QWzWAANRGfHVjKLw@mail.gmail.com>
Subject: =?UTF-8?Q?Race_condition_between_driver=5Fprobe=5Fdevice_and_devic?=
	=?UTF-8?Q?e=5Fshutdown=E2=80=8F?=
From: Wedson Almeida Filho <wedsonaf@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm seeing a driver crash in its shutdown routine because it's
touching some uninitialized state. It turns out that the driver's
probe routine was still running [for the same device]. There also
appears to be an issue in the remove path, where device_shutdown()
checks the dev->driver pointer and uses it later, with seemingly
nothing to guarantee that it doesn't change.

Shouldn't we synchronize the shutdown routine with probe/remove to
prevent such races?

The patch below should take care of these races.

Thoughts?

diff --git a/drivers/base/core.c b/drivers/base/core.c
index e28ce98..f2c63c6 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1823,6 +1823,9 @@ void device_shutdown(void)
                pm_runtime_get_noresume(dev);
                pm_runtime_barrier(dev);

+               if (dev->parent)        /* Needed for USB */
+                       device_lock(dev->parent);
+               device_lock(dev);
                if (dev->bus && dev->bus->shutdown) {
                        dev_dbg(dev, "shutdown\n");
                        dev->bus->shutdown(dev);
@@ -1830,6 +1833,9 @@ void device_shutdown(void)
                        dev_dbg(dev, "shutdown\n");
                        dev->driver->shutdown(dev);
                }
+               device_unlock(dev);
+               if (dev->parent)
+                       device_unlock(dev->parent);
                put_device(dev);

                spin_lock(&devices_kset->list_lock);
