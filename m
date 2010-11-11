Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab0KKQ32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 11:29:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60927 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab0KKQ31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 11:29:27 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=AaMaIMOBXK0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=otCdQUQxrSFt9X05veoA:9 a=J2Qm0gxqkVbpLHwld1bM0pOo7wkA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH] staging: ft1000: Copy from user into correct data
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Marek Belisko <marek.belisko@open-nandra.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 11 Nov 2010 11:29:25 -0500
Message-ID: <1289492965.12418.262.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While doing a ktest.pl I used a MIN_CONFIG that had STAGING enabled, and
a randconfig with CONFIG_DEBUG_STRICT_USER_COPY_CHECKS enabled caught
the following bug:

In file included from /home/rostedt/work/autotest/nobackup/linux-test.git/arch/x86/include/asm/uaccess.h:571:0,
                 from /home/rostedt/work/autotest/nobackup/linux-test.git/include/linux/poll.h:14,
                 from /home/rostedt/work/autotest/nobackup/linux-test.git/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c:32:
In function 'copy_from_user',
    inlined from 'ft1000_ChIoctl' at /home/rostedt/work/autotest/nobackup/linux-test.git/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c:702:36:
/home/rostedt/work/autotest/nobackup/linux-test.git/arch/x86/include/asm/uaccess_32.h:212:26: error: call to 'copy_from_user_overflow' declared with attribute error: copy_from_user() buffer size is not provably correct


Looking at the code it was obvious what the problem was. The pointer
dpram_data was being allocated but the address was being written to.
Looking at the comment above the code shows that it use to write into an
element of that pointer where the '&' is appropriate. But now that it
writes to the pointer itself, we need to remove the '&' otherwise we
write over the pointer and not into the data it points to.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index 87a6487..8e8197d 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -699,7 +699,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
 			break;
 
                 //if ( copy_from_user(&(dpram_command.dpram_blk), (PIOCTL_DPRAM_BLK)Argument, msgsz+2) ) {
-                if ( copy_from_user(&dpram_data, argp, msgsz+2) ) {
+                if ( copy_from_user(dpram_data, argp, msgsz+2) ) {
                     DEBUG("FT1000:ft1000_ChIoctl: copy fault occurred\n");
                     result = -EFAULT;
                 }


