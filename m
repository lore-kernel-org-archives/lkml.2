Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620Ab0EUPrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 11:47:45 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:43554 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757544Ab0EUPrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 11:47:43 -0400
Date: Fri, 21 May 2010 16:46:59 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-mips@linux-mips.org, Paul Mundt <lethal@linux-sh.org>,
       linux-sh@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: Re: bkl: Pushdowns for sound/oss ?
Message-ID: <20100521154659.GA2346@linux-mips.org>
References: <alpine.LFD.2.00.1005211536330.25348@localhost.localdomain>
 <20100521144055.GB13174@linux-mips.org>
 <alpine.LFD.2.00.1005211613200.4344@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005211613200.4344@eddie.linux-mips.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 04:34:54PM +0100, Maciej W. Rozycki wrote:

> > > particular in:
> > > sound/oss/swarm_cs4297a.c
> > 
> > This one is specific to the Swarm, a MIPS-based platform indeed; I'll cc
> > Maciej Rozycki who most likely is the only person on the planet knowing the
> > technical details.  I don't even recall touching that file so my (C)
> > header in there is a surprise :)
> 
>  You probably added a missing header inclusion or suchlike. ;)

That may well be true - I haven't touched much sound code since my time
at Waldorf Electronics but that was a slightly different calibre than
sound in Linux.

>  That's a Crystal Sound CS4297A AC'97 codec wired to a synchronous serial 
> interface of the SWARM board.  It used to work with 2.4 after some tweaks 
> I did back then (it broke in the little-endian mode or something like 
> that), but I can't say anything about 2.6.  I think the driver should be 
> dropped and the serial port in the sound mode (there's a demux to switch 
> the interface's external connection between the codec and a DE-9 
> connector; the serial port supports asynchronous mode as well) properly 
> abstracted as a "sound card".
> 
>  There's a separate CS4297A driver already in our tree, so it should be 
> used in place of the codec bits from this driver (which I believe were 
> simply copied over at some point).  The rest is glue logic to set up 
> serial line parameters correctly for the codec and switch the demux to the 
> codec (no proper resource management is done for that though; the 
> selection used to be made at the kernel build time).  This glue logic is 
> all that's needed to be carried over to the new "sound card" driver.
> 
>  I have plans to do so in some indefinite future, probably when I retire 
> and my grandchildren have grown up; anyone please feel free to take it 
> first. ;)

I've patched up what there to build without warnings but that doesn't
make any less ugly or wrong.  I'm trying to motivate a few folks to
offload the work from you; until that has happened it might be nice if this
driver would stick around as some form of documentation.

As for the grandchildren - is there something I haven't heared of yet?  :)

  Ralf

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/sound/oss/swarm_cs4297a.c b/sound/oss/swarm_cs4297a.c
index 3136c88..17ae26b 100644
--- a/sound/oss/swarm_cs4297a.c
+++ b/sound/oss/swarm_cs4297a.c
@@ -78,6 +78,7 @@
 #include <linux/mutex.h>
 #include <linux/kernel.h>
 
+#include <asm/addrspace.h>
 #include <asm/byteorder.h>
 #include <asm/dma.h>
 #include <asm/io.h>
@@ -160,10 +161,10 @@ module_param(cs_debugmask, int, 0);
 #define CS_TYPE_ADC 0
 #define CS_TYPE_DAC 1
 
-#define SER_BASE    (A_SER_BASE_1 + KSEG1)
-#define SS_CSR(t)   (SER_BASE+t)
-#define SS_TXTBL(t) (SER_BASE+R_SER_TX_TABLE_BASE+(t*8))
-#define SS_RXTBL(t) (SER_BASE+R_SER_RX_TABLE_BASE+(t*8))
+#define SER_BASE    CKSEG1ADDR(A_SER_BASE_1)
+#define SS_CSR(t)   ((void *) SER_BASE + (t))
+#define SS_TXTBL(t) ((void *) (SER_BASE + R_SER_TX_TABLE_BASE + (t * 8)))
+#define SS_RXTBL(t) ((void *) (SER_BASE + R_SER_RX_TABLE_BASE + (t * 8)))
 
 #define FRAME_BYTES            32
 #define FRAME_SAMPLE_BYTES      4
@@ -1179,7 +1180,7 @@ static int mixer_ioctl(struct cs4297a_state *s, unsigned int cmd,
 #if CSDEBUG
 	cs_printioctl(cmd);
 #endif
-#if CSDEBUG_INTERFACE
+#ifdef CSDEBUG_INTERFACE
 
 	if ((cmd == SOUND_MIXER_CS_GETDBGMASK) ||
 	    (cmd == SOUND_MIXER_CS_SETDBGMASK) ||
@@ -1859,7 +1860,7 @@ static ssize_t cs4297a_write(struct file *file, const char *buffer,
                                  "cs4297a: copy in %d to swptr %x\n", cnt, swptr));
 
 		swptr = (swptr + (cnt/FRAME_SAMPLE_BYTES)) % d->ringsz;
-                __raw_writeq(cnt/FRAME_SAMPLE_BYTES, SS_CSR(R_SER_DMA_DSCR_COUNT_TX));
+                __raw_writeq(cnt/FRAME_SAMPLE_BYTES, (void *) SS_CSR(R_SER_DMA_DSCR_COUNT_TX));
 		spin_lock_irqsave(&s->lock, flags);
 		d->swptr = swptr;
 		d->count += cnt;
@@ -2502,7 +2503,7 @@ static const struct file_operations cs4297a_audio_fops = {
 	.release	= cs4297a_release,
 };
 
-static void cs4297a_interrupt(int irq, void *dev_id)
+static irqreturn_t cs4297a_interrupt(int irq, void *dev_id)
 {
 	struct cs4297a_state *s = (struct cs4297a_state *) dev_id;
         u32 status;
@@ -2517,14 +2518,14 @@ static void cs4297a_interrupt(int irq, void *dev_id)
         if (!(status & (M_SYNCSER_RX_EOP_COUNT | M_SYNCSER_RX_OVERRUN | M_SYNCSER_RX_SYNC_ERR))) {
                 status = __raw_readq(SS_CSR(R_SER_STATUS));
                 printk(KERN_ERR "cs4297a: unexpected interrupt (status %08x)\n", status);
-                return;
+                return IRQ_HANDLED;
         }
 #endif
 
         if (status & M_SYNCSER_RX_SYNC_ERR) {
                 status = __raw_readq(SS_CSR(R_SER_STATUS));
                 printk(KERN_ERR "cs4297a: rx sync error (status %08x)\n", status);
-                return;
+                return IRQ_HANDLED;
         }
 
         if (status & M_SYNCSER_RX_OVERRUN) {
@@ -2534,9 +2535,9 @@ static void cs4297a_interrupt(int irq, void *dev_id)
 
                 /* Fix things up: get the receive descriptor pool
                    clean and give them back to the hardware */
-                while (__raw_readq(SS_CSR(R_SER_DMA_DSCR_COUNT_RX)))
+                while (__raw_readq((void *)SS_CSR(R_SER_DMA_DSCR_COUNT_RX)))
                         ;
-                newptr = (unsigned) (((__raw_readq(SS_CSR(R_SER_DMA_CUR_DSCR_ADDR_RX)) & M_DMA_CURDSCR_ADDR) -
+                newptr = (unsigned) (((__raw_readq((void *)SS_CSR(R_SER_DMA_CUR_DSCR_ADDR_RX)) & M_DMA_CURDSCR_ADDR) -
                                      s->dma_adc.descrtab_phys) / sizeof(serdma_descr_t));
                 for (i=0; i<DMA_DESCR; i++) {
                         s->dma_adc.descrtab[i].descr_a &= ~M_DMA_SERRX_SOP;
@@ -2544,7 +2545,7 @@ static void cs4297a_interrupt(int irq, void *dev_id)
                 s->dma_adc.swptr = s->dma_adc.hwptr = newptr;
                 s->dma_adc.count = 0;
                 s->dma_adc.sb_swptr = s->dma_adc.sb_hwptr = s->dma_adc.sample_buf;
-                __raw_writeq(DMA_DESCR, SS_CSR(R_SER_DMA_DSCR_COUNT_RX));
+                __raw_writeq(DMA_DESCR, (void *)SS_CSR(R_SER_DMA_DSCR_COUNT_RX));
         }
 
 	spin_lock(&s->lock);
@@ -2553,6 +2554,8 @@ static void cs4297a_interrupt(int irq, void *dev_id)
 
 	CS_DBGOUT(CS_INTERRUPT, 6, printk(KERN_INFO
 		  "cs4297a: cs4297a_interrupt()-\n"));
+
+	return IRQ_HANDLED;
 }
 
 #if 0
@@ -2588,14 +2591,15 @@ static int __init cs4297a_init(void)
 		"cs4297a: cs4297a_init_module()+ \n"));
 
 #ifndef CONFIG_BCM_CS4297A_CSWARM
-        mdio_val = __raw_readq(KSEG1 + A_MAC_REGISTER(2, R_MAC_MDIO)) &
+        mdio_val = __raw_readq((void *)CKSEG1ADDR(A_MAC_REGISTER(2, R_MAC_MDIO))) &
                 (M_MAC_MDIO_DIR|M_MAC_MDIO_OUT);
 
         /* Check syscfg for synchronous serial on port 1 */
-        cfg = __raw_readq(KSEG1 + A_SCD_SYSTEM_CFG);
+        cfg = __raw_readq((void *)CKSEG1ADDR(A_SCD_SYSTEM_CFG));
         if (!(cfg & M_SYS_SER1_ENABLE)) {
-                __raw_writeq(cfg | M_SYS_SER1_ENABLE, KSEG1+A_SCD_SYSTEM_CFG);
-                cfg = __raw_readq(KSEG1 + A_SCD_SYSTEM_CFG);
+                __raw_writeq(cfg | M_SYS_SER1_ENABLE,
+			     (void *)CKSEG1ADDR(A_SCD_SYSTEM_CFG));
+                cfg = __raw_readq((void *)CKSEG1ADDR(A_SCD_SYSTEM_CFG));
                 if (!(cfg & M_SYS_SER1_ENABLE)) {
                   printk(KERN_INFO "cs4297a: serial port 1 not configured for synchronous operation\n");
                   return -1;
@@ -2605,12 +2609,14 @@ static int __init cs4297a_init(void)
                 
                 /* Force the codec (on SWARM) to reset by clearing
                    GENO, preserving MDIO (no effect on CSWARM) */
-                __raw_writeq(mdio_val, KSEG1+A_MAC_REGISTER(2, R_MAC_MDIO));
+                __raw_writeq(mdio_val,
+			     (void *)CKSEG1ADDR(A_MAC_REGISTER(2, R_MAC_MDIO)));
                 udelay(10);
         }
 
         /* Now set GENO */
-        __raw_writeq(mdio_val | M_MAC_GENC, KSEG1+A_MAC_REGISTER(2, R_MAC_MDIO));
+        __raw_writeq(mdio_val | M_MAC_GENC,
+		     (void *)CKSEG1ADDR(A_MAC_REGISTER(2, R_MAC_MDIO)));
         /* Give the codec some time to finish resetting (start the bit clock) */
         udelay(100);
 #endif
@@ -2665,8 +2671,6 @@ static int __init cs4297a_init(void)
         } while (!rval && (pwr != 0xf));
 
         if (!rval) {
-		char *sb1250_duart_present;
-
                 fs = get_fs();
                 set_fs(KERNEL_DS);
 #if 0
@@ -2688,9 +2692,20 @@ static int __init cs4297a_init(void)
 
                 cs4297a_read_ac97(s, AC97_VENDOR_ID1, &id);
 
+#if 0
+		/*
+		 * Since the rewrite of the SB1250 UART driver for the
+		 * drivers/serial subsystem there is no more
+		 * sb1250_duart_present symbol in the kernel so this resource
+		 * sharing mechanism which arguably has always been fishy
+		 * does no longer work.
+		 */
+		char *sb1250_duart_present_p;
+
 		sb1250_duart_present = symbol_get(sb1250_duart_present);
 		if (sb1250_duart_present)
 			sb1250_duart_present[1] = 0;
+#endif
 
                 printk(KERN_INFO "cs4297a: initialized (vendor id = %x)\n", id);
 
@@ -2732,6 +2747,7 @@ static void __exit cs4297a_cleanup(void)
 
 MODULE_AUTHOR("Kip Walker, Broadcom Corp.");
 MODULE_DESCRIPTION("Cirrus Logic CS4297a Driver for Broadcom SWARM board");
+MODULE_LICENSE("GPL");
 
 // --------------------------------------------------------------------- 
 
