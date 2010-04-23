Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0DWDDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 23:03:32 -0400
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:59699 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755372Ab0DWDDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 23:03:31 -0400
Message-ID: <4BD10DC5.4030407@lougher.demon.co.uk>
Date: Fri, 23 Apr 2010 04:02:29 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Aaro Koskinen <aaro.koskinen@iki.fi>, hsweeten@visionengravers.com,
       "H. Peter Anvin" <hpa@zytor.com>, eric.piel@tremplin-utc.net,
       stable <stable@kernel.org>
Subject: [PATCH] initramfs: handle unrecognised decompressor when unpacking
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The unpack routine fails to handle the decompress_method() returning
unrecognised decompressor (compress_name == NULL).  This results in
the routine looping eventually oopsing on an out of bounds memory
access.

Note this bug is usually hidden, only triggering on trailing
junk after one or more correct compressed blocks.  The
case of the compressed archive being complete junk
is (by accident?) caught by the if (state != Reset) check
because state is initialised to Start, but not updated due to
the decompressor not having been called.   Obviously if the junk
is trailing a correctly decompressed buffer, state == Reset from the
previous call to the decompressor.

Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
  init/initramfs.c |    3 ++-
  1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index 37d3859..4b9c202 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -457,7 +457,8 @@ static char * __init unpack_to_rootfs(char *buf, unsigned len)
  					 compress_name);
  				message = msg_buf;
  			}
-		}
+		} else
+			error("junk in compressed archive");
  		if (state != Reset)
  			error("junk in compressed archive");
  		this_header = saved_offset + my_inptr;
-- 
1.6.3.3

