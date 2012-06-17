Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab2FQPy6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 11:54:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65533 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479Ab2FQPy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 11:54:57 -0400
Date: Sun, 17 Jun 2012 08:54:52 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: 3.5 regressions related to printk changes
Message-ID: <20120617155452.GA18966@kroah.com>
References: <20120617150928.GJ8450@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120617150928.GJ8450@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 05:09:28PM +0200, Willy Tarreau wrote:
> Hi Kay,
> 
> I was failing to get any 3.5-rc[123] kernel to boot on my dockstar (armv5).
> I finally found some time today to bisect it and found that the responsible
> commit was :
> 
>   From 7ff9554bb578ba02166071d2d487b7fc7d860d62 Mon Sep 17 00:00:00 2001
>   From: Kay Sievers <kay@vrfy.org>
>   Date: Thu, 3 May 2012 02:29:13 +0200
>   Subject: [PATCH] printk: convert byte-buffer to variable-length record buffer
> 
> The symptom is that the kernel loads and hangs during early boot without
> displaying anything. My config had CONFIG_EARLY_PRINTK enabled so I tried
> without it again just in case it would be related, but it desperately did
> not change anything, the kernel still fails to boot.
> 
> I have tried to revert printk changes on top of 3.5-rc3 and confirm that
> now the kernel properly boots. Here's the list of what I reverted for
> information :
> 
>     c313af145b9bc4fb8e8e0c83b8cfc10e1b894a50 printk() - isolate KERN_CONT users from ordinary complete lines
>     3ce9a7c0ac28561567fadedf1a99272e4970f740 printk() - restore prefix/timestamp printing for multi-newline str
>     1fce677971e29ceaa7c569741fa9c685a7b1052a printk: add stub for prepend_timestamp()
>     f8450fca6ecdea38b5a882fdf6cd097e3ec8651c printk: correctly align __log_buf
>     649e6ee33f73ba1c4f2492c6de9aff2254b540cb printk() - restore timestamp printing at console output
>     5c5d5ca51abd728c8de3be43ffd6bb00f977bfcd printk() - do not merge continuation lines of different threads
>     7f3a781d6fd81e397c3928c9af33f1fc63232db6 printk - fix compilation for CONFIG_PRINTK=n
>     5fc3249068c1ed87c6fd485f42ced24132405629 kmsg: use do_div() to divide 64bit integer
>     c4e00daaa96d3a0786f1f4fe6456281c60ef9a16 driver-core: extend dev_printk() to pass structured data
>     e11fea92e13fb91c50bacca799a6131c81929986 kmsg: export printk records to the /dev/kmsg interface
>     7ff9554bb578ba02166071d2d487b7fc7d860d62 printk: convert byte-buffer to variable-length record buffer
> 
> I understand that it will be hard to troubleshoot this with that little
> information :-/
> 
> I'm not posting the config not to pollute the list, but have it available
> if needed. I haven't noticed anything seemingly related on the list, but
> if you want me to test a patch or to provide more information, feel free
> to suggest !
> 
> I'm still checking if I can spot something.

Try the patch below, which is in my set of patches to go to Linus soon
and let me know if it works or not.

thanks,

greg k-h


>From 6ebb017de9d59a18c3ff9648270e8f6abaa93438 Mon Sep 17 00:00:00 2001
From: Andrew Lunn <andrew@lunn.ch>
Date: Tue, 5 Jun 2012 08:52:34 +0200
Subject: printk: Fix alignment of buf causing crash on ARM EABI

Commit 7ff9554bb578ba02166071d2d487b7fc7d860d62, printk: convert
byte-buffer to variable-length record buffer, causes systems using
EABI to crash very early in the boot cycle. The first entry in struct
log is a u64, which for EABI must be 8 byte aligned.

Make use of __alignof__() so the compiler to decide the alignment, but
allow it to be overridden using CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS,
for systems which can perform unaligned access and want to save
a few bytes of space.

Tested on Orion5x and Kirkwood.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Stephen Warren <swarren@wwwdotorg.org>
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
Acked-by: Kay Sievers <kay@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/printk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 32462d2..f205c25 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -227,10 +227,10 @@ static u32 clear_idx;
 #define LOG_LINE_MAX 1024
 
 /* record buffer */
-#if !defined(CONFIG_64BIT) || defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
 #define LOG_ALIGN 4
 #else
-#define LOG_ALIGN 8
+#define LOG_ALIGN __alignof__(struct log)
 #endif
 #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
 static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
-- 
1.7.10.2.565.gbd578b5

