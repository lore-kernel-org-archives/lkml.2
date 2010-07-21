Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276Ab0GUNzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 09:55:48 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:41578 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756936Ab0GUNzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 09:55:46 -0400
Date: Wed, 21 Jul 2010 14:25:28 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: akpm@linux-foundation.org, torvalds@osdl.org
Cc: kaber@trash.net, linux-pcmcia@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCMCIA bugfix for 2.6.35-rc6
Message-ID: <20100721122528.GA13332@comet.dominikbrodowski.net>
Mail-Followup-To: akpm@linux-foundation.org, torvalds@osdl.org,
	kaber@trash.net, linux-pcmcia@lists.infradead.org,
	linux-kernel@vger.kernel.org
References: <201007202221.o6KMLg9n021204@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007202221.o6KMLg9n021204@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

one PCMCIA bugfix slipped through... In order to solve this issue, please
pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git urgent

The diffstat and list of changes follows; the patch is also attached below.

Patrick McHardy (1):
      pcmcia: fix 'driver ... did not release config properly' warning

 drivers/pcmcia/pcmcia_resource.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

---
From: Patrick McHardy <kaber@trash.net>

Up to 2.6.34 pcmcia_release_irq() reset p_dev->_irq to 0 after releasing
the irq.  The IRQ is now released in pcmcia_disable_device(), however
p_dev->_irq is not reset, triggering a warning in pcmcia_device_remove().

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
---

 drivers/pcmcia/pcmcia_resource.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/pcmcia/pcmcia_resource.c~pcmcia-fix-driver-did-not-release-config-properly-warning drivers/pcmcia/pcmcia_resource.c
--- a/drivers/pcmcia/pcmcia_resource.c~pcmcia-fix-driver-did-not-release-config-properly-warning
+++ a/drivers/pcmcia/pcmcia_resource.c
@@ -857,8 +857,10 @@ void pcmcia_disable_device(struct pcmcia
 {
 	pcmcia_release_configuration(p_dev);
 	pcmcia_release_io(p_dev, &p_dev->io);
-	if (p_dev->_irq)
+	if (p_dev->_irq) {
 		free_irq(p_dev->irq, p_dev->priv);
+		p_dev->_irq = 0;
+	}
 	if (p_dev->win)
 		pcmcia_release_window(p_dev, p_dev->win);
 }
