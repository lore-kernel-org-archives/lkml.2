Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab2EXWt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 18:49:56 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33506 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754126Ab2EXWtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 18:49:53 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Kay Sievers <kay@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 2/3] treewide: Fix declaration and uses of old KERN_<LEVEL> style
Date: Thu, 24 May 2012 15:49:32 -0700
Message-Id: <4357b0bfa997bf4914ca8a9c98029cf179910893.1337899274.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1337899274.git.joe@perches.com>
References: <cover.1337899274.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that KERN_<LEVEL> is no longer "<.>",
some code that relied on that form needed to
be updated.

Replace direct declarations of <.> and fix
the parsing of <.> to use the new KERN_SOH
style.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/lib/io-acorn.S              |    4 +++-
 arch/arm/vfp/vfphw.S                 |    8 +++++---
 arch/frv/kernel/kernel_thread.S      |    2 +-
 drivers/staging/wlags49_h2/hcf.c     |    8 ++++----
 drivers/staging/wlags49_h2/wl_main.c |    4 ++--
 fs/btrfs/super.c                     |    9 +++++----
 net/bridge/netfilter/ebt_log.c       |    2 +-
 sound/core/misc.c                    |    8 ++++----
 8 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/arch/arm/lib/io-acorn.S b/arch/arm/lib/io-acorn.S
index 1b197ea..6b5b6ee 100644
--- a/arch/arm/lib/io-acorn.S
+++ b/arch/arm/lib/io-acorn.S
@@ -13,11 +13,13 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 
+#define	KERN_WARNING	"\001" "4"
+
 		.text
 		.align
 
 .Liosl_warning:
-		.ascii	"<4>insl/outsl not implemented, called from %08lX\0"
+		.ascii	KERN_WARNING "insl/outsl not implemented, called from %08lX\0"
 		.align
 
 /*
diff --git a/arch/arm/vfp/vfphw.S b/arch/arm/vfp/vfphw.S
index 2d30c7f..640f25e 100644
--- a/arch/arm/vfp/vfphw.S
+++ b/arch/arm/vfp/vfphw.S
@@ -18,13 +18,15 @@
 #include <asm/vfpmacros.h>
 #include "../kernel/entry-header.S"
 
+#define KERN_DEBUG "\001" "7"
+
 	.macro	DBGSTR, str
 #ifdef DEBUG
 	stmfd	sp!, {r0-r3, ip, lr}
 	add	r0, pc, #4
 	bl	printk
 	b	1f
-	.asciz  "<7>VFP: \str\n"
+	.asciz  KERN_DEBUG "VFP: \str\n"
 	.balign 4
 1:	ldmfd	sp!, {r0-r3, ip, lr}
 #endif
@@ -37,7 +39,7 @@
 	add	r0, pc, #4
 	bl	printk
 	b	1f
-	.asciz  "<7>VFP: \str\n"
+	.asciz  KERN_DEBUG "VFP: \str\n"
 	.balign 4
 1:	ldmfd	sp!, {r0-r3, ip, lr}
 #endif
@@ -52,7 +54,7 @@
 	add	r0, pc, #4
 	bl	printk
 	b	1f
-	.asciz  "<7>VFP: \str\n"
+	.asciz  KERN_DEBUG "VFP: \str\n"
 	.balign 4
 1:	ldmfd	sp!, {r0-r3, ip, lr}
 #endif
diff --git a/arch/frv/kernel/kernel_thread.S b/arch/frv/kernel/kernel_thread.S
index 4531c83..a3b69e9 100644
--- a/arch/frv/kernel/kernel_thread.S
+++ b/arch/frv/kernel/kernel_thread.S
@@ -13,7 +13,7 @@
 #include <asm/unistd.h>
 
 #define CLONE_VM	0x00000100	/* set if VM shared between processes */
-#define	KERN_ERR	"<3>"
+#define	KERN_ERR	"\001" "3"
 
 	.section .rodata
 kernel_thread_emsg:
diff --git a/drivers/staging/wlags49_h2/hcf.c b/drivers/staging/wlags49_h2/hcf.c
index 366e4a4..4235446 100644
--- a/drivers/staging/wlags49_h2/hcf.c
+++ b/drivers/staging/wlags49_h2/hcf.c
@@ -705,7 +705,7 @@ hcf_action( IFBP ifbp, hcf_16 action )
 			// 800 us latency before FW switches to high power
 			MSF_WAIT(800);                              // MSF-defined function to wait n microseconds.
 //OOR			if ( ifbp->IFB_DSLinkStat & CFG_LINK_STAT_DS_OOR ) { // OutOfRange
-//				printk( "<5>ACT_INT_OFF: Deepsleep phase terminated, enable and go to AwaitConnection\n" );     //;?remove me 1 day
+//				printk(KERN_NOTICE "ACT_INT_OFF: Deepsleep phase terminated, enable and go to AwaitConnection\n" );     //;?remove me 1 day
 //				hcf_cntl( ifbp, HCF_CNTL_ENABLE );
 //			}
 //			ifbp->IFB_DSLinkStat &= ~( CFG_LINK_STAT_DS_IR | CFG_LINK_STAT_DS_OOR); //clear IR/OOR state
@@ -2979,7 +2979,7 @@ hcf_service_nic( IFBP ifbp, wci_bufp bufp, unsigned int len )
 			ltv.typ = CFG_DDS_TICK_TIME;
 			ltv.tick_time = ( ( ifbp->IFB_DSLinkStat & CFG_LINK_STAT_TIMER ) + 0x10 ) *64; //78 is more right
 			hcf_put_info( ifbp, (LTVP)&ltv );
-			printk( "<5>Preparing for sleep, link_status: %04X, timer : %d\n",
+			printk(KERN_NOTICE "Preparing for sleep, link_status: %04X, timer : %d\n",
 				ifbp->IFB_DSLinkStat, ltv.tick_time );//;?remove me 1 day
 			ifbp->IFB_TickCnt++; //;?just to make sure we do not keep on printing above message
 			if ( ltv.tick_time < 300 * 125 ) ifbp->IFB_DSLinkStat += 0x0010;
@@ -4221,11 +4221,11 @@ isr_info( IFBP ifbp )
 // /*4*/    if ( info[1] == CFG_LINK_STAT ) {
 //          ifbp->IFB_DSLinkStat = IPW( HREG_DATA_1 ) | CFG_LINK_STAT_CHANGE;   //corrupts BAP !! ;?
 //          ifbp->IFB_LinkStat = ifbp->IFB_DSLinkStat & CFG_LINK_STAT_FW; //;? to be obsoleted
-//          printk( "<4>linkstatus: %04x\n", ifbp->IFB_DSLinkStat );        //;?remove me 1 day
+//          printk(KERN_ERR "linkstatus: %04x\n", ifbp->IFB_DSLinkStat );        //;?remove me 1 day
 // #if (HCF_SLEEP) & HCF_DDS
 //          if ( ( ifbp->IFB_DSLinkStat & CFG_LINK_STAT_CONNECTED ) == 0 ) {    //even values are disconnected etc.
 //              ifbp->IFB_TickCnt = 0;              //start 2 second period (with 1 tick uncertanty)
-//              printk( "<5>isr_info: AwaitConnection phase started, IFB_TickCnt = 0\n" );      //;?remove me 1 day
+//              printk(KERN_NOTICE "isr_info: AwaitConnection phase started, IFB_TickCnt = 0\n" );      //;?remove me 1 day
 //          }
 // #endif // HCF_DDS
 //      }
diff --git a/drivers/staging/wlags49_h2/wl_main.c b/drivers/staging/wlags49_h2/wl_main.c
index d5bf0a7..2041078 100644
--- a/drivers/staging/wlags49_h2/wl_main.c
+++ b/drivers/staging/wlags49_h2/wl_main.c
@@ -3822,7 +3822,7 @@ static int write_int(struct file *file, const char *buffer, unsigned long count,
 		lp->timer_oor.data = (unsigned long)lp;
 		lp->timer_oor.expires = RUN_AT( 3 * HZ );
 		add_timer( &lp->timer_oor );
-		printk( "<5>wl_enable: %ld\n", jiffies );		//;?remove me 1 day
+		printk(KERN_NOTICE "wl_enable: %ld\n", jiffies );		//;?remove me 1 day
 #endif //DN554
 #ifdef DN554
 /*******************************************************************************
@@ -3852,7 +3852,7 @@ void timer_oor( u_long arg )
     DBG_ENTER( DbgInfo );
     DBG_PARAM( DbgInfo, "arg", "0x%08lx", arg );
 
-	printk( "<5>timer_oor: %ld 0x%04X\n", jiffies, lp->timer_oor_cnt );		//;?remove me 1 day
+	printk(KERN_NOTICE "timer_oor: %ld 0x%04X\n", jiffies, lp->timer_oor_cnt );		//;?remove me 1 day
 	lp->timer_oor_cnt += 10;
     if ( (lp->timer_oor_cnt & ~DS_OOR) > 300 ) {
 		lp->timer_oor_cnt = 300;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index c5f8fca..daf2e47 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -180,16 +180,17 @@ const char *logtypes[] = {
 void btrfs_printk(struct btrfs_fs_info *fs_info, const char *fmt, ...)
 {
 	struct super_block *sb = fs_info->sb;
-	char lvl[4];
+	char lvl[3];
 	struct va_format vaf;
 	va_list args;
 	const char *type = logtypes[4];
 
 	va_start(args, fmt);
 
-	if (fmt[0] == '<' && isdigit(fmt[1]) && fmt[2] == '>') {
-		strncpy(lvl, fmt, 3);
-		fmt += 3;
+	if (fmt[0] == KERN_SOH_ASCII && isdigit(fmt[1])) {
+		lvl[0] = fmt[0];
+		lvl[1] = fmt[1];
+		lvl[2] = 0;
 		type = logtypes[fmt[1] - '0'];
 	} else
 		*lvl = '\0';
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index f88ee53..31286d3 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -80,7 +80,7 @@ ebt_log_packet(u_int8_t pf, unsigned int hooknum,
 	unsigned int bitmask;
 
 	spin_lock_bh(&ebt_log_lock);
-	printk("<%c>%s IN=%s OUT=%s MAC source = %pM MAC dest = %pM proto = 0x%04x",
+	printk(KERN_SOH "%c" "%s IN=%s OUT=%s MAC source = %pM MAC dest = %pM proto = 0x%04x",
 	       '0' + loginfo->u.log.level, prefix,
 	       in ? in->name : "", out ? out->name : "",
 	       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
diff --git a/sound/core/misc.c b/sound/core/misc.c
index 7681679..4e47cd8 100644
--- a/sound/core/misc.c
+++ b/sound/core/misc.c
@@ -81,11 +81,11 @@ void __snd_printk(unsigned int level, const char *path, int line,
 #ifdef CONFIG_SND_VERBOSE_PRINTK
 	vaf.fmt = format;
 	vaf.va = &args;
-	if (format[0] == '<' && format[2] == '>') {
-		memcpy(verbose_fmt, format, 3);
-		vaf.fmt = format + 3;
+	if (format[0] == KERN_SOH_ASCII) {
+		memcpy(verbose_fmt, format, 2);
+		vaf.fmt = format + 2;
 	} else if (level)
-		memcpy(verbose_fmt, KERN_DEBUG, 3);
+		memcpy(verbose_fmt, KERN_DEBUG, 2);
 	printk(verbose_fmt, sanity_file_name(path), line, &vaf);
 #else
 	vprintk(format, args);
-- 
1.7.8.111.gad25c.dirty

