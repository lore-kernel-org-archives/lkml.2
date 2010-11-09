Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab0KITn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:43:28 -0500
Received: from mail.perches.com ([173.55.12.10]:4770 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab0KITn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:43:27 -0500
Subject: Re: [PATCH 1/2] Idd fat_msg() to unified kernel messages for FAT
 fs.
From: Joe Perches <joe@perches.com>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
In-Reply-To: <1289329124-14358-1-git-send-email-bug-track@fisher-privat.net>
References: <1289321718-6373-1-git-send-email-bug-track@fisher-privat.net>
	 <1289321718-6373-2-git-send-email-bug-track@fisher-privat.net>
	 <1289329124-14358-1-git-send-email-bug-track@fisher-privat.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 11:43:25 -0800
Message-ID: <1289331805.28590.17.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 19:58 +0100, Alexey Fisher wrote:
> Add fat_msg() function to unify printkas. And use it
> to report mounts and remounts.
> 
> new dmesg looks like this:
> [ 6264.957109] FAT-fs (sdg1): Mounted. Opts: uid=1000,gid=1000,shortname=mixed,dmask=0077,utf8=1,showexec,flush
> [ 6402.175028] FAT-fs (sdg1): re-mounted. Opts: (null)
> 
> v2 - add prototype to fat.h;
>      úse %pV; rename prefix to level;

Hi again Alexey.

I think putting this function in misc.c is better
because __fat_fs_error is already in that file.

Patch 1 should just add the prototype and function
and maybe convert __fat_fs_error to use %pV.

Maybe the __fat_fs_error %pV conversion is a
separate patch.

The last patch should do the conversions to
fat_msg.

Perhaps add this to misc.c:

diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index 970e682..b497918 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -24,15 +24,18 @@ void __fat_fs_error(struct super_block *s, int report, const char *fmt, ...)
 {
 	struct fat_mount_options *opts = &MSDOS_SB(s)->options;
 	va_list args;
+	struct va_format vaf;
 
 	if (report) {
-		printk(KERN_ERR "FAT: Filesystem error (dev %s)\n", s->s_id);
-
-		printk(KERN_ERR "    ");
 		va_start(args, fmt);
-		vprintk(fmt, args);
+
+		vaf.fmt = fmt;
+		vaf.va = &args;
+
+		printk(KERN_ERR "FAT: Filesystem error (dev %s): %pV\n",
+		       s->s_id, &vaf);
+
 		va_end(args);
-		printk("\n");
 	}
 
 	if (opts->errors == FAT_ERRORS_PANIC)



