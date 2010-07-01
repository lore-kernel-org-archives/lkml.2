Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419Ab0GASie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:38:34 -0400
Received: from kroah.org ([198.145.64.141]:40604 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757947Ab0GASXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:23:45 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:14 2010
Message-Id: <20100701173214.151803924@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:31:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [patch 087/149] xen: avoid allocation causing potential swap activity on the resume path
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Campbell <ian.campbell@citrix.com>

commit b3831cb55d383e8eb55d3b56c715fb48459b87c9 upstream.

Since the device we are resuming could be the device containing the
swap device we should ensure that the allocation cannot cause
IO.

On resume, this path is triggered when the running system tries to
continue using its devices.  If it cannot then the resume will fail;
to try to avoid this we let it dip into the emergency pools.

The majority of these changes were made when linux-2.6.18-xen.hg
changeset e8b49cfbdac0 was ported upstream in
a144ff09bc52ef3f3684ed23eadc9c7c0e57b3aa but somehow this hunk was
dropped.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/xen/xenbus/xenbus_xs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -499,7 +499,7 @@ int xenbus_printf(struct xenbus_transact
 #define PRINTF_BUFFER_SIZE 4096
 	char *printf_buffer;
 
-	printf_buffer = kmalloc(PRINTF_BUFFER_SIZE, GFP_KERNEL);
+	printf_buffer = kmalloc(PRINTF_BUFFER_SIZE, GFP_NOIO | __GFP_HIGH);
 	if (printf_buffer == NULL)
 		return -ENOMEM;
 


