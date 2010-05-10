Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167Ab0EJXCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:02:46 -0400
Received: from kroah.org ([198.145.64.141]:51881 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932902Ab0EJW6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:15 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:39 2010
Message-Id: <20100510223539.893052831@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: [61/98] initramfs: handle unrecognised decompressor when unpacking
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Phillip Lougher <phillip@lougher.demon.co.uk>

commit df37bd156dcb4f5441beaf5bde444adac974e9a0 upstream.

The unpack routine fails to handle the decompress_method() returning
unrecognised decompressor (compress_name == NULL).  This results in the
routine looping eventually oopsing on an out of bounds memory access.

Note this bug is usually hidden, only triggering on trailing junk after
one or more correct compressed blocks.  The case of the compressed archive
being complete junk is (by accident?) caught by the if (state != Reset)
check because state is initialised to Start, but not updated due to the
decompressor not having been called.  Obviously if the junk is trailing a
correctly decompressed buffer, state == Reset from the previous call to
the decompressor.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 init/initramfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -455,7 +455,8 @@ static char * __init unpack_to_rootfs(ch
 					 compress_name);
 				message = msg_buf;
 			}
-		}
+		} else
+			error("junk in compressed archive");
 		if (state != Reset)
 			error("junk in compressed archive");
 		this_header = saved_offset + my_inptr;


