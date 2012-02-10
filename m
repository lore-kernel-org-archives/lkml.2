Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab2BJWn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:43:59 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35084 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932853Ab2BJWny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:43:54 -0500
MIME-Version: 1.0
Message-Id: <20120210222950.457188757@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:20 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Russell King <rmk+kernel@arm.linux.org.uk>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [patch 61/86] pcmcia: fix socket refcount decrementing on each resume
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 025e4ab3db07fcbf62c01e4f30d1012234beb980 upstream.

This fixes a memory-corrupting bug: not only does it cause the warning,
but as a result of dropping the refcount to zero, it causes the
pcmcia_socket0 device structure to be freed while it still has
references, causing slab caches corruption.  A fatal oops quickly
follows this warning - often even just a 'dmesg' following the warning
causes the kernel to oops.

While testing suspend/resume on an ARM device with PCMCIA support, and a
CF card inserted, I found that after five suspend and resumes, the
kernel would complain, and shortly die after with slab corruption.

  WARNING: at include/linux/kref.h:41 kobject_get+0x28/0x50()

As the message doesn't give a clue about which kobject, and the built-in
debugging in drivers/base/power/main.c happens too late, this was added
right before each get_device():

  printk("%s: %p [%s] %u\n", __func__, dev, kobject_name(&dev->kobj), atomic_read(&dev->kobj.kref.refcount));

and on the 3rd s2ram cycle, the following behaviour observed:

On the 3rd suspend/resume cycle:

  dpm_prepare: c1a0d998 [pcmcia_socket0] 3
  dpm_suspend: c1a0d998 [pcmcia_socket0] 3
  dpm_suspend_noirq: c1a0d998 [pcmcia_socket0] 3
  dpm_resume_noirq: c1a0d998 [pcmcia_socket0] 3
  dpm_resume: c1a0d998 [pcmcia_socket0] 3
  dpm_complete: c1a0d998 [pcmcia_socket0] 2

4th:

  dpm_prepare: c1a0d998 [pcmcia_socket0] 2
  dpm_suspend: c1a0d998 [pcmcia_socket0] 2
  dpm_suspend_noirq: c1a0d998 [pcmcia_socket0] 2
  dpm_resume_noirq: c1a0d998 [pcmcia_socket0] 2
  dpm_resume: c1a0d998 [pcmcia_socket0] 2
  dpm_complete: c1a0d998 [pcmcia_socket0] 1

5th:

  dpm_prepare: c1a0d998 [pcmcia_socket0] 1
  dpm_suspend: c1a0d998 [pcmcia_socket0] 1
  dpm_suspend_noirq: c1a0d998 [pcmcia_socket0] 1
  dpm_resume_noirq: c1a0d998 [pcmcia_socket0] 1
  dpm_resume: c1a0d998 [pcmcia_socket0] 1
  dpm_complete: c1a0d998 [pcmcia_socket0] 0
  ------------[ cut here ]------------
  WARNING: at include/linux/kref.h:41 kobject_get+0x28/0x50()
  Modules linked in: ucb1x00_core
  Backtrace:
  [<c0212090>] (dump_backtrace+0x0/0x110) from [<c04799dc>] (dump_stack+0x18/0x1c)
  [<c04799c4>] (dump_stack+0x0/0x1c) from [<c021cba0>] (warn_slowpath_common+0x50/0x68)
  [<c021cb50>] (warn_slowpath_common+0x0/0x68) from [<c021cbdc>] (warn_slowpath_null+0x24/0x28)
  [<c021cbb8>] (warn_slowpath_null+0x0/0x28) from [<c0335374>] (kobject_get+0x28/0x50)
  [<c033534c>] (kobject_get+0x0/0x50) from [<c03804f4>] (get_device+0x1c/0x24)
  [<c0388c90>] (dpm_complete+0x0/0x1a0) from [<c0389cc0>] (dpm_resume_end+0x1c/0x20)
  ...

[changelog edited to make quilt mail happy, stupid tool...]


As can be seen, the original function called pcmcia_get_socket() and
pcmcia_put_socket() around the guts, whereas the replacement code
calls pcmcia_put_socket() only in one path.  This creates an imbalance
in the refcounting.

Testing with pcmcia_put_socket() put removed shows that the bug is gone:

  dpm_suspend: c1a10998 [pcmcia_socket0] 5
  dpm_suspend_noirq: c1a10998 [pcmcia_socket0] 5
  dpm_resume_noirq: c1a10998 [pcmcia_socket0] 5
  dpm_resume: c1a10998 [pcmcia_socket0] 5
  dpm_complete: c1a10998 [pcmcia_socket0] 5

Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pcmcia/ds.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -1269,10 +1269,8 @@ static int pcmcia_bus_add(struct pcmcia_
 
 static int pcmcia_bus_early_resume(struct pcmcia_socket *skt)
 {
-	if (!verify_cis_cache(skt)) {
-		pcmcia_put_socket(skt);
+	if (!verify_cis_cache(skt))
 		return 0;
-	}
 
 	dev_dbg(&skt->dev, "cis mismatch - different card\n");
 


