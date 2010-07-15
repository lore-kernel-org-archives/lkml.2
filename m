Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933936Ab0GORnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 13:43:43 -0400
Received: from commune-des.alpes.fr.eu.org ([195.88.84.51]:57405 "EHLO
	commune-des.alpes.fr.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933810Ab0GORnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 13:43:39 -0400
X-Greylist: delayed 473 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jul 2010 13:43:39 EDT
From: Julien Moutinho <julm+linux@savines.alpes.fr.eu.org>
Cc: Julien Moutinho <julm+linux@savines.alpes.fr.eu.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: mousedev - Fix mousedev_poll() to advertise when /dev/input/mice is writable.
Date: Thu, 15 Jul 2010 19:31:27 +0200
Message-Id: <1279215089-20361-1-git-send-email-julm+linux@savines.alpes.fr.eu.org>
X-Mailer: git-send-email 1.7.1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Microsoft ImPS/2 mouse protocol being bidirectionnal (sic)
one may have to write in /dev/input/mice; and that works better
if select() does not hang.

Signed-off-by: Julien Moutinho <julm+linux@savines.alpes.fr.eu.org>
---
 drivers/input/mousedev.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index f34b22b..1f67b8f 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -768,7 +768,8 @@ static unsigned int mousedev_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &mousedev->wait, wait);
 	return ((client->ready || client->buffer) ? (POLLIN | POLLRDNORM) : 0) |
-		(mousedev->exist ? 0 : (POLLHUP | POLLERR));
+		(mousedev->exist ?
+			(POLLOUT | POLLWRNORM) : (POLLHUP | POLLERR));
 }
 
 static const struct file_operations mousedev_fops = {
-- 
1.7.1

