Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab1FQBOC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 21:14:02 -0400
Received: from gate.crashing.org ([63.228.1.57]:42949 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756700Ab1FQBN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 21:13:56 -0400
Subject: [PATCH 4/5] powerpc/pseries: Re-implement HVSI as part of hvc_vio
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Jun 2011 11:08:47 +1000
Message-ID: <1308272927.2516.108.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pseries machines, consoles are provided by the hypervisor using
a low level get_chars/put_chars type interface. However, this is
really just a transport to the service processor which implements
them either as "raw" console (networked consoles, HMC, ...) or as
"hvsi" serial ports.

The later is a simple packet protocol on top of the raw character
interface that is supposed to convey additional "serial port" style
semantics. In practice however, all it does is provide a way to
read the CD line and set/clear our DTR line, that's it.

We currently implement the "raw" protocol as an hvc console backend
(/dev/hvcN) and the "hvsi" protocol using a separate tty driver
(/dev/hvsi0).

However this is quite impractical. The arbitrary difference between
the two type of devices has been a major source of user (and distro)
confusion. Additionally, there's an additional mini -hvsi implementation
in the pseries platform code for our low level debug console and early
boot kernel messages, which means code duplication, though that low
level variant is impractical as it's incapable of doing the initial
protocol negociation to establish the link to the FSP.

This essentially replaces the dedicated hvsi driver and the platform
udbg code completely by extending the existing hvc_vio backend used
in "raw" mode so that:

 - It now supports HVSI as well
 - We add support for hvc backend providing tiocm{get,set}
 - It also provides a udbg interface for early debug and boot console

This is overall less code, though this will only be obvious once we
remove the old "hvsi" driver, which is still available for now. When
the old driver is enabled, the new code still kicks in for the low
level udbg console, replacing the old mini implementation in the
platform
code, it just doesn't provide the higher level "hvc" interface.

In addition to producing generally simler code, this has several
benefits
over our current situation:

 - The user/distro only has to deal with /dev/hvcN for the hypervisor
console, avoiding all sort of confusion that has plagued us in the past

 - The tty, kernel and low level debug console all use the same code
base which supports the full protocol establishment process, thus the
console is now available much earlier than it used to be with the
old HVSI driver. The kernel console works much earlier and udbg is
available much earlier too. Hackers can enable a hard coded very-early
debug console as well that works with HVSI (previously that was only
supported for the "raw" mode).

I've tried to keep the same semantics as hvsi relative to how I react
to things like CD changes, with some subtle differences though:

 - I clear DTR on close if HUPCL is set

 - Current hvsi triggers a hangup if it detects a up->down transition
   on CD (you can still open a console with CD down). My new
implementation
   triggers a hangup if the link to the FSP is severed, and severs it
upon
   detecting a up->down transition on CD.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/Kconfig.debug               |   15 +
 arch/powerpc/include/asm/udbg.h          |    1 +
 arch/powerpc/kernel/udbg.c               |    3 +
 arch/powerpc/platforms/pseries/lpar.c    |  189 --------
 arch/powerpc/platforms/pseries/pseries.h |    3 +-
 arch/powerpc/platforms/pseries/setup.c   |    5 +-
 drivers/tty/hvc/Kconfig                  |    5 +
 drivers/tty/hvc/Makefile                 |    3 +-
 drivers/tty/hvc/hvc_console.c            |   23 +-
 drivers/tty/hvc/hvc_console.h            |    4 +
 drivers/tty/hvc/hvc_vio.c                |  725
++++++++++++++++++++++++++++--
 11 files changed, 749 insertions(+), 227 deletions(-)

diff --git a/arch/powerpc/Kconfig.debug b/arch/powerpc/Kconfig.debug
index e72dcf6..067cb84 100644
--- a/arch/powerpc/Kconfig.debug
+++ b/arch/powerpc/Kconfig.debug
@@ -167,6 +167,13 @@ config PPC_EARLY_DEBUG_LPAR
 	  Select this to enable early debugging for a machine with a HVC
 	  console on vterm 0.
 
+config PPC_EARLY_DEBUG_LPAR_HVSI
+	bool "LPAR HVSI Console"
+	depends on PPC_PSERIES
+	help
+	  Select this to enable early debugging for a machine with a HVSI
+	  console on a specified vterm.
+
 config PPC_EARLY_DEBUG_G5
 	bool "Apple G5"
 	depends on PPC_PMAC64
@@ -253,6 +260,14 @@ config PPC_EARLY_DEBUG_WSP
 
 endchoice
 
+config PPC_EARLY_DEBUG_HVSI_VTERMNO
+	hex "vterm number to use with early debug HVSI"
+	depends on PPC_EARLY_DEBUG_LPAR_HVSI
+	default "0x30000000"
+	help
+	  You probably want 0x30000000 for your first serial port and
+	  0x30000001 for your second one
+
 config PPC_EARLY_DEBUG_44x_PHYSLOW
 	hex "Low 32 bits of early debug UART physical address"
 	depends on PPC_EARLY_DEBUG_44x
diff --git a/arch/powerpc/include/asm/udbg.h
b/arch/powerpc/include/asm/udbg.h
index 58580e9..93e05d1 100644
--- a/arch/powerpc/include/asm/udbg.h
+++ b/arch/powerpc/include/asm/udbg.h
@@ -40,6 +40,7 @@ extern void udbg_adb_init_early(void);
 
 extern void __init udbg_early_init(void);
 extern void __init udbg_init_debug_lpar(void);
+extern void __init udbg_init_debug_lpar_hvsi(void);
 extern void __init udbg_init_pmac_realmode(void);
 extern void __init udbg_init_maple_realmode(void);
 extern void __init udbg_init_pas_realmode(void);
diff --git a/arch/powerpc/kernel/udbg.c b/arch/powerpc/kernel/udbg.c
index a57e61e..faa82c1 100644
--- a/arch/powerpc/kernel/udbg.c
+++ b/arch/powerpc/kernel/udbg.c
@@ -31,6 +31,9 @@ void __init udbg_early_init(void)
 #if defined(CONFIG_PPC_EARLY_DEBUG_LPAR)
 	/* For LPAR machines that have an HVC console on vterm 0 */
 	udbg_init_debug_lpar();
+#elif defined(CONFIG_PPC_EARLY_DEBUG_LPAR_HVSI)
+	/* For LPAR machines that have an HVSI console on vterm 0 */
+	udbg_init_debug_lpar_hvsi();
 #elif defined(CONFIG_PPC_EARLY_DEBUG_G5)
 	/* For use on Apple G5 machines */
 	udbg_init_pmac_realmode();
diff --git a/arch/powerpc/platforms/pseries/lpar.c
b/arch/powerpc/platforms/pseries/lpar.c
index e3a96c4..f7205d3 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -52,195 +52,6 @@ EXPORT_SYMBOL(plpar_hcall_norets);
 
 extern void pSeries_find_serial_port(void);
 
-
-static int vtermno;	/* virtual terminal# for udbg  */
-
-#define __ALIGNED__ __attribute__((__aligned__(sizeof(long))))
-static void udbg_hvsi_putc(char c)
-{
-	/* packet's seqno isn't used anyways */
-	uint8_t packet[] __ALIGNED__ = { 0xff, 5, 0, 0, c };
-	int rc;
-
-	if (c == '\n')
-		udbg_hvsi_putc('\r');
-
-	do {
-		rc = plpar_put_term_char(vtermno, sizeof(packet), packet);
-	} while (rc == H_BUSY);
-}
-
-static long hvsi_udbg_buf_len;
-static uint8_t hvsi_udbg_buf[256];
-
-static int udbg_hvsi_getc_poll(void)
-{
-	unsigned char ch;
-	int rc, i;
-
-	if (hvsi_udbg_buf_len == 0) {
-		rc = plpar_get_term_char(vtermno, &hvsi_udbg_buf_len, hvsi_udbg_buf);
-		if (rc != H_SUCCESS || hvsi_udbg_buf[0] != 0xff) {
-			/* bad read or non-data packet */
-			hvsi_udbg_buf_len = 0;
-		} else {
-			/* remove the packet header */
-			for (i = 4; i < hvsi_udbg_buf_len; i++)
-				hvsi_udbg_buf[i-4] = hvsi_udbg_buf[i];
-			hvsi_udbg_buf_len -= 4;
-		}
-	}
-
-	if (hvsi_udbg_buf_len <= 0 || hvsi_udbg_buf_len > 256) {
-		/* no data ready */
-		hvsi_udbg_buf_len = 0;
-		return -1;
-	}
-
-	ch = hvsi_udbg_buf[0];
-	/* shift remaining data down */
-	for (i = 1; i < hvsi_udbg_buf_len; i++) {
-		hvsi_udbg_buf[i-1] = hvsi_udbg_buf[i];
-	}
-	hvsi_udbg_buf_len--;
-
-	return ch;
-}
-
-static int udbg_hvsi_getc(void)
-{
-	int ch;
-	for (;;) {
-		ch = udbg_hvsi_getc_poll();
-		if (ch == -1) {
-			/* This shouldn't be needed...but... */
-			volatile unsigned long delay;
-			for (delay=0; delay < 2000000; delay++)
-				;
-		} else {
-			return ch;
-		}
-	}
-}
-
-static void udbg_putcLP(char c)
-{
-	char buf[16];
-	unsigned long rc;
-
-	if (c == '\n')
-		udbg_putcLP('\r');
-
-	buf[0] = c;
-	do {
-		rc = plpar_put_term_char(vtermno, 1, buf);
-	} while(rc == H_BUSY);
-}
-
-/* Buffered chars getc */
-static long inbuflen;
-static long inbuf[2];	/* must be 2 longs */
-
-static int udbg_getc_pollLP(void)
-{
-	/* The interface is tricky because it may return up to 16 chars.
-	 * We save them statically for future calls to udbg_getc().
-	 */
-	char ch, *buf = (char *)inbuf;
-	int i;
-	long rc;
-	if (inbuflen == 0) {
-		/* get some more chars. */
-		inbuflen = 0;
-		rc = plpar_get_term_char(vtermno, &inbuflen, buf);
-		if (rc != H_SUCCESS)
-			inbuflen = 0;	/* otherwise inbuflen is garbage */
-	}
-	if (inbuflen <= 0 || inbuflen > 16) {
-		/* Catch error case as well as other oddities (corruption) */
-		inbuflen = 0;
-		return -1;
-	}
-	ch = buf[0];
-	for (i = 1; i < inbuflen; i++)	/* shuffle them down. */
-		buf[i-1] = buf[i];
-	inbuflen--;
-	return ch;
-}
-
-static int udbg_getcLP(void)
-{
-	int ch;
-	for (;;) {
-		ch = udbg_getc_pollLP();
-		if (ch == -1) {
-			/* This shouldn't be needed...but... */
-			volatile unsigned long delay;
-			for (delay=0; delay < 2000000; delay++)
-				;
-		} else {
-			return ch;
-		}
-	}
-}
-
-/* call this from early_init() for a working debug console on
- * vterm capable LPAR machines
- */
-void __init udbg_init_debug_lpar(void)
-{
-	vtermno = 0;
-	udbg_putc = udbg_putcLP;
-	udbg_getc = udbg_getcLP;
-	udbg_getc_poll = udbg_getc_pollLP;
-}
-
-/* returns 0 if couldn't find or use /chosen/stdout as console */
-void __init find_udbg_vterm(void)
-{
-	struct device_node *stdout_node;
-	const u32 *termno;
-	const char *name;
-
-	/* find the boot console from /chosen/stdout */
-	if (!of_chosen)
-		return;
-	name = of_get_property(of_chosen, "linux,stdout-path", NULL);
-	if (name == NULL)
-		return;
-	stdout_node = of_find_node_by_path(name);
-	if (!stdout_node)
-		return;
-	name = of_get_property(stdout_node, "name", NULL);
-	if (!name) {
-		printk(KERN_WARNING "stdout node missing 'name' property!\n");
-		goto out;
-	}
-
-	/* Check if it's a virtual terminal */
-	if (strncmp(name, "vty", 3) != 0)
-		goto out;
-	termno = of_get_property(stdout_node, "reg", NULL);
-	if (termno == NULL)
-		goto out;
-	vtermno = termno[0];
-
-	if (of_device_is_compatible(stdout_node, "hvterm1")) {
-		udbg_putc = udbg_putcLP;
-		udbg_getc = udbg_getcLP;
-		udbg_getc_poll = udbg_getc_pollLP;
-		add_preferred_console("hvc", termno[0] & 0xff, NULL);
-	} else if (of_device_is_compatible(stdout_node, "hvterm-protocol")) {
-		vtermno = termno[0];
-		udbg_putc = udbg_hvsi_putc;
-		udbg_getc = udbg_hvsi_getc;
-		udbg_getc_poll = udbg_hvsi_getc_poll;
-		add_preferred_console("hvsi", termno[0] & 0xff, NULL);
-	}
-out:
-	of_node_put(stdout_node);
-}
-
 void vpa_init(int cpu)
 {
 	int hwcpu = get_hard_smp_processor_id(cpu);
diff --git a/arch/powerpc/platforms/pseries/pseries.h
b/arch/powerpc/platforms/pseries/pseries.h
index e9f6d28..24c7162 100644
--- a/arch/powerpc/platforms/pseries/pseries.h
+++ b/arch/powerpc/platforms/pseries/pseries.h
@@ -47,7 +47,8 @@ extern void pSeries_final_fixup(void);
 /* Poweron flag used for enabling auto ups restart */
 extern unsigned long rtas_poweron_auto;
 
-extern void find_udbg_vterm(void);
+/* Provided by HVC VIO */
+extern void hvc_vio_init_early(void);
 
 /* Dynamic logical Partitioning/Mobility */
 extern void dlpar_free_cc_nodes(struct device_node *);
diff --git a/arch/powerpc/platforms/pseries/setup.c
b/arch/powerpc/platforms/pseries/setup.c
index 593acce..d00e529 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -512,9 +512,10 @@ static void __init pSeries_init_early(void)
 {
 	pr_debug(" -> pSeries_init_early()\n");
 
+#ifdef CONFIG_HVC_CONSOLE
 	if (firmware_has_feature(FW_FEATURE_LPAR))
-		find_udbg_vterm();
-
+		hvc_vio_init_early();
+#endif
 	if (firmware_has_feature(FW_FEATURE_DABR))
 		ppc_md.set_dabr = pseries_set_dabr;
 	else if (firmware_has_feature(FW_FEATURE_XDABR))
diff --git a/drivers/tty/hvc/Kconfig b/drivers/tty/hvc/Kconfig
index 6f2c980..e371753 100644
--- a/drivers/tty/hvc/Kconfig
+++ b/drivers/tty/hvc/Kconfig
@@ -19,6 +19,11 @@ config HVC_CONSOLE
 	  console. This driver allows each pSeries partition to have a console
 	  which is accessed via the HMC.
 
+config HVC_OLD_HVSI
+	bool "Old driver for pSeries serial port (/dev/hvsi*)"
+	depends on HVC_CONSOLE
+	default n
+
 config HVC_ISERIES
 	bool "iSeries Hypervisor Virtual Console support"
 	depends on PPC_ISERIES
diff --git a/drivers/tty/hvc/Makefile b/drivers/tty/hvc/Makefile
index 40a25d9..69a444b 100644
--- a/drivers/tty/hvc/Makefile
+++ b/drivers/tty/hvc/Makefile
@@ -1,4 +1,5 @@
-obj-$(CONFIG_HVC_CONSOLE)	+= hvc_vio.o hvsi.o
+obj-$(CONFIG_HVC_CONSOLE)	+= hvc_vio.o
+obj-$(CONFIG_HVC_OLD_HVSI)	+= hvsi.o
 obj-$(CONFIG_HVC_ISERIES)	+= hvc_iseries.o
 obj-$(CONFIG_HVC_RTAS)		+= hvc_rtas.o
 obj-$(CONFIG_HVC_TILE)		+= hvc_tile.o
diff --git a/drivers/tty/hvc/hvc_console.c
b/drivers/tty/hvc/hvc_console.c
index e9cba13..f8ff6f5 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -184,7 +184,7 @@ static struct tty_driver *hvc_console_device(struct
console *c, int *index)
 }
 
 static int __init hvc_console_setup(struct console *co, char *options)
-{
+{	
 	if (co->index < 0 || co->index >= MAX_NR_HVC_CONSOLES)
 		return -ENODEV;
 
@@ -745,6 +745,25 @@ static int khvcd(void *unused)
 	return 0;
 }
 
+static int hvc_tiocmget(struct tty_struct *tty)
+{
+	struct hvc_struct *hp = tty->driver_data;
+
+	if (!hp || !hp->ops->tiocmget)
+		return -EINVAL;
+	return hp->ops->tiocmget(hp);
+}
+
+static int hvc_tiocmset(struct tty_struct *tty,
+			unsigned int set, unsigned int clear)
+{
+	struct hvc_struct *hp = tty->driver_data;
+
+	if (!hp || !hp->ops->tiocmset)
+		return -EINVAL;
+	return hp->ops->tiocmset(hp, set, clear);
+}
+
 static const struct tty_operations hvc_ops = {
 	.open = hvc_open,
 	.close = hvc_close,
@@ -753,6 +772,8 @@ static const struct tty_operations hvc_ops = {
 	.unthrottle = hvc_unthrottle,
 	.write_room = hvc_write_room,
 	.chars_in_buffer = hvc_chars_in_buffer,
+	.tiocmget = hvc_tiocmget,
+	.tiocmset = hvc_tiocmset,
 };
 
 struct hvc_struct *hvc_alloc(uint32_t vtermno, int data,
diff --git a/drivers/tty/hvc/hvc_console.h
b/drivers/tty/hvc/hvc_console.h
index 54381eba..c335a14 100644
--- a/drivers/tty/hvc/hvc_console.h
+++ b/drivers/tty/hvc/hvc_console.h
@@ -73,6 +73,10 @@ struct hv_ops {
 	int (*notifier_add)(struct hvc_struct *hp, int irq);
 	void (*notifier_del)(struct hvc_struct *hp, int irq);
 	void (*notifier_hangup)(struct hvc_struct *hp, int irq);
+
+	/* tiocmget/set implementation */
+	int (*tiocmget)(struct hvc_struct *hp);
+	int (*tiocmset)(struct hvc_struct *hp, unsigned int set, unsigned int
clear);
 };
 
 /* Register a vterm and a slot index for use as a console
(console_init) */
diff --git a/drivers/tty/hvc/hvc_vio.c b/drivers/tty/hvc/hvc_vio.c
index e6eea14..d4e0850 100644
--- a/drivers/tty/hvc/hvc_vio.c
+++ b/drivers/tty/hvc/hvc_vio.c
@@ -27,15 +27,27 @@
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
USA
+ *
+ * TODO:
+ *
+ *   - handle error in sending hvsi protocol packets
+ *   - retry nego on subsequent sends ?
  */
 
+#undef DEBUG
+
 #include <linux/types.h>
 #include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/console.h>
 
 #include <asm/hvconsole.h>
 #include <asm/vio.h>
 #include <asm/prom.h>
 #include <asm/firmware.h>
+#include <asm/hvsi.h>
+#include <asm/udbg.h>
 
 #include "hvc_console.h"
 
@@ -43,14 +55,47 @@ static const char hvc_driver_name[] = "hvc_console";
 
 static struct vio_device_id hvc_driver_table[] __devinitdata = {
 	{"serial", "hvterm1"},
+#ifndef HVC_OLD_HVSI
+	{"serial", "hvterm-protocol"},
+#endif
 	{ "", "" }
 };
 MODULE_DEVICE_TABLE(vio, hvc_driver_table);
 
-static int filtered_get_chars(uint32_t vtermno, char *buf, int count)
+typedef enum hv_protocol {
+	HV_PROTOCOL_RAW,
+	HV_PROTOCOL_HVSI
+} hv_protocol_t;
+
+#define HV_INBUF_SIZE		255
+
+struct hvterm_priv {
+	u32		termno;		/* HV term number */
+	hv_protocol_t	proto;		/* Raw data or HVSI packets */
+	unsigned int	inbuf_len;	/* Data in input buffer */
+	unsigned char	inbuf[HV_INBUF_SIZE];
+	unsigned int	inbuf_cur;	/* Cursor in input buffer */
+	unsigned int	inbuf_pktlen;	/* HVSI packet lenght from cursor */
+	atomic_t	seqno;		/* HVSI packet sequence number */
+	unsigned int	opened:1;	/* HVSI driver opened */
+	unsigned int	established:1;	/* HVSI protocol established */
+	unsigned int 	is_console:1;	/* Used as a kernel console device */
+	unsigned int	mctrl_update:1;	/* HVSI modem control updated */
+	unsigned short	mctrl;		/* HVSI modem control */
+	struct tty_struct *tty;		/* TTY structure */
+};
+static struct hvterm_priv *hvterm_privs[MAX_NR_HVC_CONSOLES];
+
+/* For early boot console */
+static struct hvterm_priv hvterm_priv0;
+
+static int hvterm_raw_get_chars(uint32_t vtermno, char *buf, int count)
 {
-	unsigned long got;
-	int i;
+	struct hvterm_priv *pv = hvterm_privs[vtermno];
+	unsigned long got, i;
+
+	if (WARN_ON(!pv))
+		return 0;
 
 	/*
 	 * Vio firmware will read up to SIZE_VIO_GET_CHARS at its own
discretion
@@ -60,7 +105,7 @@ static int filtered_get_chars(uint32_t vtermno, char
*buf, int count)
 	if (count < SIZE_VIO_GET_CHARS)
 		return -EAGAIN;
 
-	got = hvc_get_chars(vtermno, buf, count);
+	got = hvc_get_chars(pv->termno, buf, count);
 
 	/*
 	 * Work around a HV bug where it gives us a null
@@ -70,32 +115,527 @@ static int filtered_get_chars(uint32_t vtermno,
char *buf, int count)
 		if (buf[i] == 0 && buf[i-1] == '\r') {
 			--got;
 			if (i < got)
-				memmove(&buf[i], &buf[i+1],
-					got - i);
+				memmove(&buf[i], &buf[i+1], got - i);
 		}
 	}
 	return got;
 }
 
-static const struct hv_ops hvc_get_put_ops = {
-	.get_chars = filtered_get_chars,
-	.put_chars = hvc_put_chars,
+static int hvterm_raw_put_chars(uint32_t vtermno, const char *buf, int
count)
+{
+	struct hvterm_priv *pv = hvterm_privs[vtermno];
+
+	if (WARN_ON(!pv))
+		return 0;
+
+	return hvc_put_chars(pv->termno, buf, count);
+}
+
+static const struct hv_ops hvterm_raw_ops = {
+	.get_chars = hvterm_raw_get_chars,
+	.put_chars = hvterm_raw_put_chars,
 	.notifier_add = notifier_add_irq,
 	.notifier_del = notifier_del_irq,
 	.notifier_hangup = notifier_hangup_irq,
 };
 
+static int hvterm_hvsi_send_packet(struct hvterm_priv *pv, struct
hvsi_header *packet)
+{
+	packet->seqno = atomic_inc_return(&pv->seqno);
+
+	/* Assumes that always succeeds, works in practice */
+	return hvc_put_chars(pv->termno, (char *)packet, packet->len);
+}
+
+static void hvterm_hvsi_start_handshake(struct hvterm_priv *pv)
+{
+	struct hvsi_query q;
+
+	/* Reset state */
+	pv->established = 0;
+	atomic_set(&pv->seqno, 0);
+
+	pr_devel("HVSI@%x: Handshaking started\n", pv->termno);
+
+	/* Send version query */
+	q.hdr.type = VS_QUERY_PACKET_HEADER;
+	q.hdr.len = sizeof(struct hvsi_query);
+	q.verb = VSV_SEND_VERSION_NUMBER;
+	hvterm_hvsi_send_packet(pv, &q.hdr);
+}
+
+static int hvterm_hvsi_send_close(struct hvterm_priv *pv)
+{
+	struct hvsi_control ctrl;
+
+	pv->established = 0;
+
+	ctrl.hdr.type = VS_CONTROL_PACKET_HEADER;
+	ctrl.hdr.len = sizeof(struct hvsi_control);
+	ctrl.verb = VSV_CLOSE_PROTOCOL;
+	return hvterm_hvsi_send_packet(pv, &ctrl.hdr);
+}
+
+static void hvterm_cd_change(struct hvterm_priv *pv, int cd)
+{
+	if (cd)
+		pv->mctrl |= TIOCM_CD;
+	else {
+		pv->mctrl &= ~TIOCM_CD;
+
+		/* We copy the existing hvsi driver semantics
+		 * here which are to trigger a hangup when
+		 * we get a carrier loss.
+		 * Closing our connection to the server will
+		 * do just that.
+		 */
+		if (!pv->is_console && pv->opened) {
+			pr_devel("HVSI@%x Carrier lost, hanging up !\n",
+				 pv->termno);
+			hvterm_hvsi_send_close(pv);
+		}
+	}
+}
+
+static void hvterm_hvsi_got_control(struct hvterm_priv *pv)
+{
+	struct hvsi_control *pkt = (struct hvsi_control *)pv->inbuf;
+
+	switch (pkt->verb) {
+	case VSV_CLOSE_PROTOCOL:
+		/* We restart the handshaking */
+		hvterm_hvsi_start_handshake(pv);
+		break;
+	case VSV_MODEM_CTL_UPDATE:
+		/* Transition of carrier detect */
+		hvterm_cd_change(pv, pkt->word & HVSI_TSCD);
+		break;
+	}
+}
+
+static void hvterm_hvsi_got_query(struct hvterm_priv *pv)
+{
+	struct hvsi_query *pkt = (struct hvsi_query *)pv->inbuf;
+	struct hvsi_query_response r;
+
+	/* We only handle version queries */
+	if (pkt->verb != VSV_SEND_VERSION_NUMBER)
+		return;
+
+	pr_devel("HVSI@%x: Got version query, sending response...\n",
+		 pv->termno);
+
+	/* Send version response */
+	r.hdr.type = VS_QUERY_RESPONSE_PACKET_HEADER;
+	r.hdr.len = sizeof(struct hvsi_query_response);
+	r.verb = VSV_SEND_VERSION_NUMBER;
+	r.u.version = HVSI_VERSION;
+	r.query_seqno = pkt->hdr.seqno;
+	hvterm_hvsi_send_packet(pv, &r.hdr);
+
+	/* Assume protocol is open now */
+	pv->established = 1;
+}
+
+static void hvterm_hvsi_got_response(struct hvterm_priv *pv)
+{
+	struct hvsi_query_response *r = (struct hvsi_query_response
*)pv->inbuf;
+
+	switch(r->verb) {
+	case VSV_SEND_MODEM_CTL_STATUS:
+		hvterm_cd_change(pv, r->u.mctrl_word & HVSI_TSCD);
+		pv->mctrl_update = 1;
+		break;
+	}
+}
+
+static int hvterm_hvsi_check_packet(struct hvterm_priv *pv)
+{
+	u8 len, type;
+
+	/* Check header validity. If it's invalid, we ditch
+	 * the whole buffer and hope we eventually resync
+	 */
+	if (pv->inbuf[0] < 0xfc) {
+		pv->inbuf_len = pv->inbuf_pktlen = 0;
+		return 0;
+	}
+	type = pv->inbuf[0];
+	len = pv->inbuf[1];
+
+	/* Packet incomplete ? */
+	if (pv->inbuf_len < len)
+		return 0;
+
+	pr_devel("HVSI@%x: Got packet type %x len %d bytes:\n",
+		 pv->termno, type, len);
+
+	/* We have a packet, yay ! Handle it */
+	switch(type) {
+	case VS_DATA_PACKET_HEADER:
+		pv->inbuf_pktlen = len - 4;
+		pv->inbuf_cur = 4;
+		return 1;
+	case VS_CONTROL_PACKET_HEADER:
+		hvterm_hvsi_got_control(pv);
+		break;
+	case VS_QUERY_PACKET_HEADER:
+		hvterm_hvsi_got_query(pv);
+		break;
+	case VS_QUERY_RESPONSE_PACKET_HEADER:
+		hvterm_hvsi_got_response(pv);
+		break;
+	}
+
+	/* Swallow packet and retry */
+	pv->inbuf_len -= len;
+	memmove(pv->inbuf, &pv->inbuf[len], pv->inbuf_len);
+	return 1;
+}
+
+static int hvterm_hvsi_get_packet(struct hvterm_priv *pv)
+{
+	/* If we have room in the buffer, ask HV for more */
+	if (pv->inbuf_len < HV_INBUF_SIZE)
+		pv->inbuf_len += hvc_get_chars(pv->termno,
+					       &pv->inbuf[pv->inbuf_len],
+					       HV_INBUF_SIZE - pv->inbuf_len);
+	/*
+	 * If we have at least 4 bytes in the buffer, check for
+	 * a full packet and retry
+	 */
+	if (pv->inbuf_len >= 4)
+		return hvterm_hvsi_check_packet(pv);
+	return 0;
+}
+
+static int hvterm_hvsi_get_chars(uint32_t vtermno, char *buf, int
count)
+{
+	struct hvterm_priv *pv = hvterm_privs[vtermno];
+	unsigned int tries, read = 0;
+
+	if (WARN_ON(!pv))
+		return 0;
+
+	/* If we aren't open, dont do anything in order to avoid races
+	 * with connection establishment. The hvc core will call this
+	 * before we have returned from notifier_add(), and we need to
+	 * avoid multiple users playing with the receive buffer
+	 */
+	if (!pv->opened)
+		return 0;
+
+	/* We try twice, once with what data we have and once more
+	 * after we try to fetch some more from the hypervisor
+	 */
+	for (tries = 1; count && tries < 2; tries++) {
+		/* Consume existing data packet */
+		if (pv->inbuf_pktlen) {
+			unsigned int l = min(count, (int)pv->inbuf_pktlen);
+			memcpy(&buf[read], &pv->inbuf[pv->inbuf_cur], l);
+			pv->inbuf_cur += l;
+			pv->inbuf_pktlen -= l;
+			count -= l;
+			read += l;
+		}
+		if (count == 0)
+			break;
+
+		/* Data packet fully consumed, move down remaning data */
+		if (pv->inbuf_cur) {
+			pv->inbuf_len -= pv->inbuf_cur;
+			memmove(pv->inbuf, &pv->inbuf[pv->inbuf_cur], pv->inbuf_len);
+			pv->inbuf_cur = 0;
+		}
+
+		/* Try to get another packet */
+		if (hvterm_hvsi_get_packet(pv))
+			tries--;
+	}
+	if (!pv->established) {
+		pr_devel("HVSI@%x: returning -EPIPE\n", pv->termno);
+		return -EPIPE;
+	}
+	return read;
+}
+
+static int hvterm_hvsi_put_chars(uint32_t vtermno, const char *buf, int
count)
+{
+	struct hvterm_priv *pv = hvterm_privs[vtermno];
+	struct hvsi_data dp;
+	int rc, adjcount = min(count, HVSI_MAX_OUTGOING_DATA);
+
+	if (WARN_ON(!pv))
+		return 0;
+
+	dp.hdr.type = VS_DATA_PACKET_HEADER;
+	dp.hdr.len = adjcount + sizeof(struct hvsi_header);
+	memcpy(dp.data, buf, adjcount);
+	rc = hvterm_hvsi_send_packet(pv, &dp.hdr);
+	if (rc <= 0)
+		return rc;
+	return adjcount;
+}
+
+static void maybe_msleep(unsigned long ms)
+{
+	/* During early boot, IRQs are disabled, use mdelay */
+	if (irqs_disabled())
+		mdelay(ms);
+	else
+		msleep(ms);
+}
+
+static int hvterm_hvsi_read_mctrl(struct hvterm_priv *pv)
+{
+	struct hvsi_query q;
+	int rc, timeout;
+
+	pr_devel("HVSI@%x: Querying modem control status...\n",
+		 pv->termno);
+
+	pv->mctrl_update = 0;
+	q.hdr.type = VS_QUERY_PACKET_HEADER;
+	q.hdr.len = sizeof(struct hvsi_query);
+	q.hdr.seqno = atomic_inc_return(&pv->seqno);
+	q.verb = VSV_SEND_MODEM_CTL_STATUS;
+	rc = hvterm_hvsi_send_packet(pv, &q.hdr);
+	if (rc <= 0) {
+		pr_devel("HVSI@%x: Error %d...\n", pv->termno, rc);
+		return rc;
+	}
+
+	/* Try for up to 1s */
+	for (timeout = 0; timeout < 1000; timeout++) {
+		if (!pv->established)
+			return -ENXIO;
+		if (pv->mctrl_update)
+			return 0;
+		if (!hvterm_hvsi_get_packet(pv))
+			maybe_msleep(1);
+	}
+	return -EIO;
+}
+
+static int hvterm_hvsi_write_mctrl(struct hvterm_priv *pv, int dtr)
+{
+	struct hvsi_control ctrl;
+
+	pr_devel("HVSI@%x: %s DTR...\n", pv->termno,
+		 dtr ? "Setting" : "Clearing");
+
+	ctrl.hdr.type = VS_CONTROL_PACKET_HEADER,
+	ctrl.hdr.len = sizeof(struct hvsi_control);
+	ctrl.verb = VSV_SET_MODEM_CTL;
+	ctrl.mask = HVSI_TSDTR;
+	ctrl.word = dtr ? HVSI_TSDTR : 0;
+	if (dtr)
+		pv->mctrl |= TIOCM_DTR;
+	else
+		pv->mctrl &= ~TIOCM_DTR;
+	return hvterm_hvsi_send_packet(pv, &ctrl.hdr);
+}
+
+static void hvterm_hvsi_establish(struct hvterm_priv *pv)
+{
+	int timeout;
+
+	/* Try for up to 10ms, there can be a packet to
+	 * start the process waiting for us...
+	 */
+	for (timeout = 0; timeout < 10; timeout++) {
+		if (pv->established)
+			goto established;
+		if (!hvterm_hvsi_get_packet(pv))
+			maybe_msleep(1);
+	}
+
+	/* Failed, send a close connection packet just
+	 * in case
+	 */
+	hvterm_hvsi_send_close(pv);
+
+	/* Then restart handshake */
+	hvterm_hvsi_start_handshake(pv);
+
+	/* Try for up to 100ms */
+	for (timeout = 0; timeout < 100; timeout++) {
+		if (pv->established)
+			goto established;
+		if (!hvterm_hvsi_get_packet(pv))
+			maybe_msleep(1);
+	}
+
+	if (!pv->established) {
+		pr_devel("HVSI@%x: Timeout handshaking, giving up !\n",
+			 pv->termno);
+		return;
+	}
+ established:
+	/* Query modem control lines */
+	hvterm_hvsi_read_mctrl(pv);
+
+	/* Set our own DTR */
+	hvterm_hvsi_write_mctrl(pv, 1);
+
+	/* Set the opened flag so reads are allowed */
+	wmb();
+	pv->opened = 1;
+}
+
+static int hvterm_hvsi_open(struct hvc_struct *hp, int data)
+{
+	struct hvterm_priv *pv = hvterm_privs[hp->vtermno];
+	int rc;
+
+	pr_devel("HVSI@%x: open !\n", pv->termno);
+
+	rc = notifier_add_irq(hp, data);
+	if (rc)
+		return rc;
+
+	/* Keep track of the tty data structure */
+	pv->tty = tty_kref_get(hp->tty);
+
+	hvterm_hvsi_establish(pv);
+	return 0;
+}
+
+static void hvterm_hvsi_shutdown(struct hvc_struct *hp, struct
hvterm_priv *pv)
+{
+	unsigned long flags;
+
+	if (!pv->is_console) {
+		pr_devel("HVSI@%x: Not a console, tearing down\n",
+			 pv->termno);
+
+		/* Clear opened, synchronize with khvcd */
+		spin_lock_irqsave(&hp->lock, flags);
+		pv->opened = 0;
+		spin_unlock_irqrestore(&hp->lock, flags);
+
+		/* Clear our own DTR */
+		if (!pv->tty || (pv->tty->termios->c_cflag & HUPCL))
+			hvterm_hvsi_write_mctrl(pv, 0);
+
+		/* Tear down the connection */
+		hvterm_hvsi_send_close(pv);
+	}
+
+	if (pv->tty)
+		tty_kref_put(pv->tty);
+	pv->tty = NULL;
+}
+
+static void hvterm_hvsi_close(struct hvc_struct *hp, int data)
+{
+	struct hvterm_priv *pv = hvterm_privs[hp->vtermno];
+
+	pr_devel("HVSI@%x: close !\n", pv->termno);
+
+	hvterm_hvsi_shutdown(hp, pv);
+
+	notifier_del_irq(hp, data);
+}
+
+void hvterm_hvsi_hangup(struct hvc_struct *hp, int data)
+{
+	struct hvterm_priv *pv = hvterm_privs[hp->vtermno];
+
+	pr_devel("HVSI@%x: hangup !\n", pv->termno);
+
+	hvterm_hvsi_shutdown(hp, pv);
+
+	notifier_hangup_irq(hp, data);
+}
+
+static int hvterm_hvsi_tiocmget(struct hvc_struct *hp)
+{
+	struct hvterm_priv *pv = hvterm_privs[hp->vtermno];
+
+	if (!pv)
+		return -EINVAL;
+	return pv->mctrl;
+}
+
+static int hvterm_hvsi_tiocmset(struct hvc_struct *hp, unsigned int
set,
+				unsigned int clear)
+{
+	struct hvterm_priv *pv = hvterm_privs[hp->vtermno];
+
+	pr_devel("HVSI@%x: Set modem control, set=%x,clr=%x\n",
+		 pv->termno, set, clear);
+
+	if (set & TIOCM_DTR)
+		hvterm_hvsi_write_mctrl(pv, 1);
+	else if (clear & TIOCM_DTR)
+		hvterm_hvsi_write_mctrl(pv, 0);
+
+	return 0;
+}
+
+static const struct hv_ops hvterm_hvsi_ops = {
+	.get_chars = hvterm_hvsi_get_chars,
+	.put_chars = hvterm_hvsi_put_chars,
+	.notifier_add = hvterm_hvsi_open,
+	.notifier_del = hvterm_hvsi_close,
+	.notifier_hangup = hvterm_hvsi_hangup,
+	.tiocmget = hvterm_hvsi_tiocmget,
+	.tiocmset = hvterm_hvsi_tiocmset,
+};
+
 static int __devinit hvc_vio_probe(struct vio_dev *vdev,
-				const struct vio_device_id *id)
+				   const struct vio_device_id *id)
 {
+	const struct hv_ops *ops;
 	struct hvc_struct *hp;
+	struct hvterm_priv *pv;
+	hv_protocol_t proto;
+	int i, termno = -1;
 
 	/* probed with invalid parameters. */
 	if (!vdev || !id)
 		return -EPERM;
 
-	hp = hvc_alloc(vdev->unit_address, vdev->irq, &hvc_get_put_ops,
-			MAX_VIO_PUT_CHARS);
+	if (of_device_is_compatible(vdev->dev.of_node, "hvterm1")) {
+		proto = HV_PROTOCOL_RAW;
+		ops = &hvterm_raw_ops;
+	} else if (of_device_is_compatible(vdev->dev.of_node,
"hvterm-protocol")) {
+		proto = HV_PROTOCOL_HVSI;
+		ops = &hvterm_hvsi_ops;
+	} else {
+		pr_err("hvc_vio: Unkown protocol for %s\n",
vdev->dev.of_node->full_name);
+		return -ENXIO;
+	}
+
+	pr_devel("hvc_vio_probe() device %s, using %s protocol\n",
+		 vdev->dev.of_node->full_name,
+		 proto == HV_PROTOCOL_RAW ? "raw" : "hvsi");
+
+	/* Is it our boot one ? */
+	if (hvterm_privs[0] == &hvterm_priv0 &&
+	    vdev->unit_address == hvterm_priv0.termno) {
+		pv = hvterm_privs[0];
+		termno = 0;
+		pr_devel("->boot console, using termno 0\n");
+	}
+	/* nope, allocate a new one */
+	else {
+		for (i = 0; i < MAX_NR_HVC_CONSOLES && termno < 0; i++)
+			if (!hvterm_privs[i])
+				termno = i;
+		pr_devel("->non-boot console, using termno %d\n", termno);
+		if (termno < 0)
+			return -ENODEV;
+		pv = kzalloc(sizeof(struct hvterm_priv), GFP_KERNEL);
+		if (!pv)
+			return -ENOMEM;
+		pv->termno = vdev->unit_address;
+		pv->proto = proto;
+		hvterm_privs[termno] = pv;
+	}
+
+	hp = hvc_alloc(termno, vdev->irq, ops, MAX_VIO_PUT_CHARS);
 	if (IS_ERR(hp))
 		return PTR_ERR(hp);
 	dev_set_drvdata(&vdev->dev, hp);
@@ -106,8 +646,16 @@ static int __devinit hvc_vio_probe(struct vio_dev
*vdev,
 static int __devexit hvc_vio_remove(struct vio_dev *vdev)
 {
 	struct hvc_struct *hp = dev_get_drvdata(&vdev->dev);
+	int rc, termno;
 
-	return hvc_remove(hp);
+	termno = hp->vtermno;
+	rc = hvc_remove(hp);
+	if (rc == 0) {
+		if (hvterm_privs[termno] != &hvterm_priv0)
+			kfree(hvterm_privs[termno]);
+		hvterm_privs[termno] = NULL;
+	}
+	return rc;
 }
 
 static struct vio_driver hvc_vio_driver = {
@@ -140,34 +688,145 @@ static void __exit hvc_vio_exit(void)
 }
 module_exit(hvc_vio_exit);
 
-/* the device tree order defines our numbering */
-static int hvc_find_vtys(void)
+static void udbg_hvc_putc(char c)
 {
-	struct device_node *vty;
-	int num_found = 0;
+	int count = -1;
 
-	for (vty = of_find_node_by_name(NULL, "vty"); vty != NULL;
-			vty = of_find_node_by_name(vty, "vty")) {
-		const uint32_t *vtermno;
+	if (c == '\n')
+		udbg_hvc_putc('\r');
 
-		/* We have statically defined space for only a certain number
-		 * of console adapters.
-		 */
-		if (num_found >= MAX_NR_HVC_CONSOLES) {
-			of_node_put(vty);
+	do {
+		switch(hvterm_priv0.proto) {
+		case HV_PROTOCOL_RAW:
+			count = hvterm_raw_put_chars(0, &c, 1);
+			break;
+		case HV_PROTOCOL_HVSI:
+			count = hvterm_hvsi_put_chars(0, &c, 1);
 			break;
 		}
+	} while(count == 0);
+}
+
+static int udbg_hvc_getc_poll(void)
+{
+	int rc = 0;
+	char c;
 
-		vtermno = of_get_property(vty, "reg", NULL);
-		if (!vtermno)
-			continue;
+	switch(hvterm_priv0.proto) {
+	case HV_PROTOCOL_RAW:
+		rc = hvterm_raw_get_chars(0, &c, 1);
+		break;
+	case HV_PROTOCOL_HVSI:
+		rc = hvterm_hvsi_get_chars(0, &c, 1);
+		break;
+	}
+	if (!rc)
+		return -1;
+	return c;
+}
 
-		if (of_device_is_compatible(vty, "hvterm1")) {
-			hvc_instantiate(*vtermno, num_found, &hvc_get_put_ops);
-			++num_found;
+static int udbg_hvc_getc(void)
+{
+	int ch;
+	for (;;) {
+		ch = udbg_hvc_getc_poll();
+		if (ch == -1) {
+			/* This shouldn't be needed...but... */
+			volatile unsigned long delay;
+			for (delay=0; delay < 2000000; delay++)
+				;
+		} else {
+			return ch;
 		}
 	}
+}
+
+void __init hvc_vio_init_early(void)
+{
+	struct device_node *stdout_node;
+	const u32 *termno;
+	const char *name;
+	const struct hv_ops *ops;
+
+	/* find the boot console from /chosen/stdout */
+	if (!of_chosen)
+		return;
+	name = of_get_property(of_chosen, "linux,stdout-path", NULL);
+	if (name == NULL)
+		return;
+	stdout_node = of_find_node_by_path(name);
+	if (!stdout_node)
+		return;
+	name = of_get_property(stdout_node, "name", NULL);
+	if (!name) {
+		printk(KERN_WARNING "stdout node missing 'name' property!\n");
+		goto out;
+	}
+
+	/* Check if it's a virtual terminal */
+	if (strncmp(name, "vty", 3) != 0)
+		goto out;
+	termno = of_get_property(stdout_node, "reg", NULL);
+	if (termno == NULL)
+		goto out;
+	hvterm_priv0.termno = *termno;
+	hvterm_priv0.is_console = 1;
+	hvterm_privs[0] = &hvterm_priv0;
+
+	/* Check the protocol */
+	if (of_device_is_compatible(stdout_node, "hvterm1")) {
+		hvterm_priv0.proto = HV_PROTOCOL_RAW;
+		ops = &hvterm_raw_ops;
+	}
+	else if (of_device_is_compatible(stdout_node, "hvterm-protocol")) {
+		hvterm_priv0.proto = HV_PROTOCOL_HVSI;
+		ops = &hvterm_hvsi_ops;
+		/* HVSI, perform the handshake now */
+		hvterm_hvsi_establish(&hvterm_priv0);
+	} else
+		goto out;
+	udbg_putc = udbg_hvc_putc;
+	udbg_getc = udbg_hvc_getc;
+	udbg_getc_poll = udbg_hvc_getc_poll;
+#ifdef HVC_OLD_HVSI
+	/* When using the old HVSI driver don't register the HVC
+	 * backend for HVSI, only do udbg
+	 */
+	if (hvterm_priv0.proto == HV_PROTOCOL_HVSI)
+		goto out;
+#endif
+	add_preferred_console("hvc", 0, NULL);
+	hvc_instantiate(0, 0, ops);
+out:
+	of_node_put(stdout_node);
+}
+
+/* call this from early_init() for a working debug console on
+ * vterm capable LPAR machines
+ */
+#ifdef CONFIG_PPC_EARLY_DEBUG_LPAR
+void __init udbg_init_debug_lpar(void)
+{
+	hvterm_privs[0] = &hvterm_priv0;
+	hvterm_priv0.termno = 0;
+	hvterm_priv0.proto = HV_PROTOCOL_RAW;
+	hvterm_priv0.is_console = 1;
+	udbg_putc = udbg_hvc_putc;
+	udbg_getc = udbg_hvc_getc;
+	udbg_getc_poll = udbg_hvc_getc_poll;
+}
+#endif /* CONFIG_PPC_EARLY_DEBUG_LPAR */
 
-	return num_found;
+#ifdef CONFIG_PPC_EARLY_DEBUG_LPAR_HVSI
+void __init udbg_init_debug_lpar_hvsi(void)
+{
+	hvterm_privs[0] = &hvterm_priv0;
+	hvterm_priv0.termno = CONFIG_PPC_EARLY_DEBUG_HVSI_VTERMNO;
+	hvterm_priv0.proto = HV_PROTOCOL_HVSI;
+	hvterm_priv0.is_console = 1;
+	udbg_putc = udbg_hvc_putc;
+	udbg_getc = udbg_hvc_getc;
+	udbg_getc_poll = udbg_hvc_getc_poll;
+	hvterm_hvsi_establish(&hvterm_priv0);
 }
-console_initcall(hvc_find_vtys);
+#endif /* CONFIG_PPC_EARLY_DEBUG_LPAR_HVSI */


