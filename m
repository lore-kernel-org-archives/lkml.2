Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab1I1WDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:03:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41109 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab1I1WD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:03:29 -0400
Date: Wed, 28 Sep 2011 15:03:25 -0700
From: Andrew Morton <akpm00@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20110928150325.52c12c1e.akpm00@gmail.com>
In-Reply-To: <20110928192220.6d85ae23a2f2ef316139a310@canb.auug.org.au>
References: <20110928192220.6d85ae23a2f2ef316139a310@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Sep 2011 19:22:20 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> After merging the akpm tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> In file included from arch/powerpc/boot/stdio.c:12:0:
> arch/powerpc/boot/stdio.h:10:17: error: expected declaration specifiers or '...' before numeric constant
> arch/powerpc/boot/stdio.h:10:20: error: expected declaration specifiers or '...' before numeric constant
> arch/powerpc/boot/stdio.h:10:8: warning: return type defaults to 'int'
> arch/powerpc/boot/stdio.h:10:8: warning: function declaration isn't a prototype
> arch/powerpc/boot/stdio.h: In function '__printf':
> arch/powerpc/boot/stdio.h:14:17: error: expected declaration specifiers or '...' before numeric constant
> arch/powerpc/boot/stdio.h:14:20: error: expected declaration specifiers or '...' before numeric constant
> arch/powerpc/boot/stdio.h:14:23: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'int'
> arch/powerpc/boot/stdio.h:16:12: error: storage class specified for parameter 'vsprintf'
> 
> And went down hill from there (it produced hundreds of errors).

I could only find two non-kernel files which were modified by that
patch so afaict we just need to revert those two bits.  I'll test the
below..



From: Andrew Morton <akpm@google.com>
Subject: treewide-use-__printf-not-__attribute__formatprintf-fix

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from arch/powerpc/boot/stdio.c:12:0:
arch/powerpc/boot/stdio.h:10:17: error: expected declaration specifiers or '...' before numeric constant
arch/powerpc/boot/stdio.h:10:20: error: expected declaration specifiers or '...' before numeric constant
arch/powerpc/boot/stdio.h:10:8: warning: return type defaults to 'int'
arch/powerpc/boot/stdio.h:10:8: warning: function declaration isn't a prototype
arch/powerpc/boot/stdio.h: In function '__printf':
arch/powerpc/boot/stdio.h:14:17: error: expected declaration specifiers or '...' before numeric constant
arch/powerpc/boot/stdio.h:14:20: error: expected declaration specifiers or '...' before numeric constant
arch/powerpc/boot/stdio.h:14:23: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'int'
arch/powerpc/boot/stdio.h:16:12: error: storage class specified for parameter 'vsprintf'
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 arch/powerpc/boot/ps3.c   |    3 ++-
 arch/powerpc/boot/stdio.h |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN arch/alpha/boot/misc.c~treewide-use-__printf-not-__attribute__formatprintf-fix arch/alpha/boot/misc.c
diff -puN arch/alpha/include/asm/console.h~treewide-use-__printf-not-__attribute__formatprintf-fix arch/alpha/include/asm/console.h
diff -puN arch/frv/include/asm/system.h~treewide-use-__printf-not-__attribute__formatprintf-fix arch/frv/include/asm/system.h
diff -puN arch/ia64/include/asm/mca.h~treewide-use-__printf-not-__attribute__formatprintf-fix arch/ia64/include/asm/mca.h
diff -puN arch/m68k/include/asm/natfeat.h~treewide-use-__printf-not-__attribute__formatprintf-fix arch/m68k/include/asm/natfeat.h
diff -puN arch/mn10300/include/asm/gdb-stub.h~treewide-use-__printf-not-__attribute__formatprintf-fix arch/mn10300/include/asm/gdb-stub.h
diff -puN arch/powerpc/boot/ps3.c~treewide-use-__printf-not-__attribute__formatprintf-fix arch/powerpc/boot/ps3.c
--- a/arch/powerpc/boot/ps3.c~treewide-use-__printf-not-__attribute__formatprintf-fix
+++ a/arch/powerpc/boot/ps3.c
@@ -36,7 +36,8 @@ extern int lv1_get_repository_node_value
 #ifdef DEBUG
 #define DBG(fmt...) printf(fmt)
 #else
-static inline __printf(1, 2) int DBG(const char *fmt, ...) {return 0;}
+static inline int __attribute__ ((format (printf, 1, 2))) DBG(
+	const char *fmt, ...) {return 0;}
 #endif
 
 BSS_STACK(4096);
diff -puN arch/powerpc/boot/stdio.h~treewide-use-__printf-not-__attribute__formatprintf-fix arch/powerpc/boot/stdio.h
--- a/arch/powerpc/boot/stdio.h~treewide-use-__printf-not-__attribute__formatprintf-fix
+++ a/arch/powerpc/boot/stdio.h
@@ -7,11 +7,12 @@
 #define	EINVAL		22	/* Invalid argument */
 #define ENOSPC		28	/* No space left on device */
 
-extern __printf(1, 2) int printf(const char *fmt, ...);
+extern int printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
 
 #define fprintf(fmt, args...)	printf(args)
 
-extern __printf(2, 3) int sprintf(char *buf, const char *fmt, ...);
+extern int sprintf(char *buf, const char *fmt, ...)
+	__attribute__((format(printf, 2, 3)));
 
 extern int vsprintf(char *buf, const char *fmt, va_list args);
 
diff -puN arch/powerpc/include/asm/udbg.h~treewide-use-__printf-not-__attribute__formatprintf-fix arch/powerpc/include/asm/udbg.h
diff -puN arch/s390/include/asm/debug.h~treewide-use-__printf-not-__attribute__formatprintf-fix arch/s390/include/asm/debug.h
diff -puN arch/um/include/shared/user.h~treewide-use-__printf-not-__attribute__formatprintf-fix arch/um/include/shared/user.h
diff -puN drivers/isdn/hisax/callc.c~treewide-use-__printf-not-__attribute__formatprintf-fix drivers/isdn/hisax/callc.c
diff -puN drivers/isdn/hisax/hisax.h~treewide-use-__printf-not-__attribute__formatprintf-fix drivers/isdn/hisax/hisax.h
diff -puN drivers/isdn/hisax/isdnl1.h~treewide-use-__printf-not-__attribute__formatprintf-fix drivers/isdn/hisax/isdnl1.h
diff -puN drivers/isdn/hisax/isdnl3.c~treewide-use-__printf-not-__attribute__formatprintf-fix drivers/isdn/hisax/isdnl3.c
diff -puN drivers/isdn/hisax/st5481_d.c~treewide-use-__printf-not-__attribute__formatprintf-fix drivers/isdn/hisax/st5481_d.c
diff -puN drivers/net/ethernet/mellanox/mlx4/mlx4_en.h~treewide-use-__printf-not-__attribute__formatprintf-fix drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
diff -puN drivers/net/wireless/ath/ath.h~treewide-use-__printf-not-__attribute__formatprintf-fix drivers/net/wireless/ath/ath.h
diff -puN drivers/net/wireless/ath/ath5k/debug.h~treewide-use-__printf-not-__attribute__formatprintf-fix drivers/net/wireless/ath/ath5k/debug.h
diff -puN drivers/net/wireless/ath/ath6kl/debug.h~treewide-use-__printf-not-__attribute__formatprintf-fix drivers/net/wireless/ath/ath6kl/debug.h
diff -puN drivers/net/wireless/b43/b43.h~treewide-use-__printf-not-__attribute__formatprintf-fix drivers/net/wireless/b43/b43.h
diff -puN drivers/net/wireless/b43legacy/b43legacy.h~treewide-use-__printf-not-__attribute__formatprintf-fix drivers/net/wireless/b43legacy/b43legacy.h
diff -puN drivers/staging/iio/trigger.h~treewide-use-__printf-not-__attribute__formatprintf-fix drivers/staging/iio/trigger.h
diff -puN fs/ecryptfs/ecryptfs_kernel.h~treewide-use-__printf-not-__attribute__formatprintf-fix fs/ecryptfs/ecryptfs_kernel.h
diff -puN fs/ext2/ext2.h~treewide-use-__printf-not-__attribute__formatprintf-fix fs/ext2/ext2.h
diff -puN fs/ext4/ext4.h~treewide-use-__printf-not-__attribute__formatprintf-fix fs/ext4/ext4.h
diff -puN fs/fat/fat.h~treewide-use-__printf-not-__attribute__formatprintf-fix fs/fat/fat.h
diff -puN fs/gfs2/glock.h~treewide-use-__printf-not-__attribute__formatprintf-fix fs/gfs2/glock.h
diff -puN fs/hpfs/hpfs_fn.h~treewide-use-__printf-not-__attribute__formatprintf-fix fs/hpfs/hpfs_fn.h
diff -puN fs/nilfs2/nilfs.h~treewide-use-__printf-not-__attribute__formatprintf-fix fs/nilfs2/nilfs.h
diff -puN fs/ntfs/debug.h~treewide-use-__printf-not-__attribute__formatprintf-fix fs/ntfs/debug.h
diff -puN fs/ocfs2/super.h~treewide-use-__printf-not-__attribute__formatprintf-fix fs/ocfs2/super.h
diff -puN fs/partitions/ldm.c~treewide-use-__printf-not-__attribute__formatprintf-fix fs/partitions/ldm.c
diff -puN fs/udf/udfdecl.h~treewide-use-__printf-not-__attribute__formatprintf-fix fs/udf/udfdecl.h
diff -puN fs/ufs/ufs.h~treewide-use-__printf-not-__attribute__formatprintf-fix fs/ufs/ufs.h
diff -puN fs/xfs/xfs_message.h~treewide-use-__printf-not-__attribute__formatprintf-fix fs/xfs/xfs_message.h
diff -puN include/asm-generic/bug.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/asm-generic/bug.h
diff -puN include/drm/drmP.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/drm/drmP.h
diff -puN include/linux/audit.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/linux/audit.h
diff -puN include/linux/blktrace_api.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/linux/blktrace_api.h
diff -puN include/linux/device.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/linux/device.h
diff -puN include/linux/dynamic_debug.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/linux/dynamic_debug.h
diff -puN include/linux/ext3_fs.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/linux/ext3_fs.h
diff -puN include/linux/fs.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/linux/fs.h
diff -puN include/linux/fscache-cache.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/linux/fscache-cache.h
diff -puN include/linux/gameport.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/linux/gameport.h
diff -puN include/linux/kallsyms.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/linux/kallsyms.h
diff -puN include/linux/kdb.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/linux/kdb.h
diff -puN include/linux/kernel.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/linux/kernel.h
diff -puN include/linux/kexec.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/linux/kexec.h
diff -puN include/linux/kmod.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/linux/kmod.h
diff -puN include/linux/kobject.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/linux/kobject.h
diff -puN include/linux/kthread.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/linux/kthread.h
diff -puN include/linux/libata.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/linux/libata.h
diff -puN include/linux/mmiotrace.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/linux/mmiotrace.h
diff -puN include/linux/netdevice.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/linux/netdevice.h
diff -puN include/linux/printk.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/linux/printk.h
diff -puN include/linux/quotaops.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/linux/quotaops.h
diff -puN include/linux/seq_file.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/linux/seq_file.h
diff -puN include/linux/trace_seq.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/linux/trace_seq.h
diff -puN include/net/bluetooth/bluetooth.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/net/bluetooth/bluetooth.h
diff -puN include/net/netfilter/nf_log.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/net/netfilter/nf_log.h
diff -puN include/net/sock.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/net/sock.h
diff -puN include/sound/core.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/sound/core.h
diff -puN include/sound/info.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/sound/info.h
diff -puN include/sound/seq_kernel.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/sound/seq_kernel.h
diff -puN include/xen/hvc-console.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/xen/hvc-console.h
diff -puN include/xen/xenbus.h~treewide-use-__printf-not-__attribute__formatprintf-fix include/xen/xenbus.h
diff -puN net/nfc/nfc.h~treewide-use-__printf-not-__attribute__formatprintf-fix net/nfc/nfc.h
diff -puN net/rds/rds.h~treewide-use-__printf-not-__attribute__formatprintf-fix net/rds/rds.h
diff -puN net/sunrpc/svc.c~treewide-use-__printf-not-__attribute__formatprintf-fix net/sunrpc/svc.c
diff -puN sound/firewire/cmp.c~treewide-use-__printf-not-__attribute__formatprintf-fix sound/firewire/cmp.c
_

