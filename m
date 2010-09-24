Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab0IXQva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:51:30 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60768 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab0IXQuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:50:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JeG/tqNOLlBLKZFadqyNG12jNjXksYc1cd8UUkFoXpepY6+TdSQi96PkHlI7tPeN3Q
         HKWvOCcF2xng6jxoyc3DTWsUMPpzhI+mqocKcO2fAXte36C3Onqa/Z/0TNBYxMO8Mrbm
         8vt8VIDDzxNN8VlhUU7tWg1r/GJvEAjliHBpI=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>, linux-pcmcia@lists.infradead.org
Subject: [PATCH 4/5] Add an utility to parse CIS files to readable form
Date: Fri, 24 Sep 2010 20:49:24 +0400
Message-Id: <1285346965-23499-5-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285346965-23499-1-git-send-email-dbaryshkov@gmail.com>
References: <1285346965-23499-1-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Import from pcmcia-cs project a dump_cis utility. It reads
machine-readable CIS file and output text representation (which can be
processed by mkcis utility).

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 mkcis/dump_cis.c | 1992 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 1992 insertions(+), 0 deletions(-)
 create mode 100644 mkcis/dump_cis.c

diff --git a/mkcis/dump_cis.c b/mkcis/dump_cis.c
new file mode 100644
index 0000000..4de8641
--- /dev/null
+++ b/mkcis/dump_cis.c
@@ -0,0 +1,1992 @@
+/***********************************************************************
+ *     PC Card CIS dump utility
+ *
+ *     dump_cis.c from pcmcia-cs
+ *
+ *     The contents of this file are subject to the Mozilla Public
+ *     License Version 1.1 (the "License"); you may not use this file
+ *     except in compliance with the License. You may obtain a copy of
+ *     the License at http://www.mozilla.org/MPL/
+ *
+ *     Software distributed under the License is distributed on an "AS
+ *     IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
+ *     implied. See the License for the specific language governing
+ *     rights and limitations under the License.
+ *
+ *     The initial developer of the original code is David A. Hinds
+ *     <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
+ *     are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
+ *
+ *     Alternatively, the contents of this file may be used under the
+ *     terms of the GNU Public License version 2 (the "GPL"), in which
+ *     case the provisions of the GPL are applicable instead of the
+ *     above.  If you wish to allow the use of your version of this file
+ *     only under the terms of the GPL and not to allow others to use
+ *     your version of this file under the MPL, indicate your decision
+ *     by deleting the provisions above and replace them with the notice
+ *     and other provisions required by the GPL.  If you do not delete
+ *     the provisions above, a recipient may use your version of this
+ *     file under either the MPL or the GPL.
+ ***********************************************************************/
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <endian.h>
+
+#ifndef le16toh
+#  include <byteswap.h>
+#  if __BYTE_ORDER == __LITTLE_ENDIAN
+#	define le16toh(x) (x)
+#	define le32toh(x) (x)
+#  else
+#	define le16toh(x) bswap_16(x)
+#	define le32toh(x) bswap_32(x)
+#  endif
+#endif
+
+#include <sys/types.h>
+#include <unistd.h>
+#include <fcntl.h>
+
+#include <cistpl.h>
+
+/* Bits in IRQInfo1 field */
+#define IRQ_MASK				0x0f
+#define IRQ_NMI_ID				0x01
+#define IRQ_IOCK_ID				0x02
+#define IRQ_BERR_ID				0x04
+#define IRQ_VEND_ID				0x08
+#define IRQ_INFO2_VALID				0x10
+#define IRQ_LEVEL_ID				0x20
+#define IRQ_PULSE_ID				0x40
+#define IRQ_SHARE_ID				0x80
+
+typedef struct tuple_parse_t {
+	tuple_t tuple;
+	cisdata_t data[255];
+	cisparse_t parse;
+} tuple_parse_t;
+
+static int get_tuple_buf(int fd, tuple_t * tuple, int first);
+static int parse_tuple(tuple_t * tuple, cisparse_t * parse);
+
+static int verbose;
+static char indent[10] = "  ";
+
+/*====================================================================*/
+
+static void print_tuple(tuple_parse_t * tup)
+{
+	int i;
+	printf("%soffset 0x%2.2x, tuple 0x%2.2x, link 0x%2.2x\n",
+	       indent, tup->tuple.CISOffset, tup->tuple.TupleCode,
+	       tup->tuple.TupleLink);
+	for (i = 0; i < tup->tuple.TupleDataLen; i++) {
+		if ((i % 16) == 0)
+			printf("%s  ", indent);
+		printf("%2.2x ", (u_char) tup->data[i]);
+		if ((i % 16) == 15)
+			putchar('\n');
+	}
+	if ((i % 16) != 0)
+		putchar('\n');
+}
+
+/*====================================================================*/
+
+static void print_funcid(cistpl_funcid_t * fn)
+{
+	printf("%sfuncid ", indent);
+	switch (fn->func) {
+	case CISTPL_FUNCID_MULTI:
+		printf("multi_function");
+		break;
+	case CISTPL_FUNCID_MEMORY:
+		printf("memory_card");
+		break;
+	case CISTPL_FUNCID_SERIAL:
+		printf("serial_port");
+		break;
+	case CISTPL_FUNCID_PARALLEL:
+		printf("parallel_port");
+		break;
+	case CISTPL_FUNCID_FIXED:
+		printf("fixed_disk");
+		break;
+	case CISTPL_FUNCID_VIDEO:
+		printf("video_adapter");
+		break;
+	case CISTPL_FUNCID_NETWORK:
+		printf("network_adapter");
+		break;
+	case CISTPL_FUNCID_AIMS:
+		printf("aims_card");
+		break;
+	case CISTPL_FUNCID_SCSI:
+		printf("scsi_adapter");
+		break;
+	default:
+		printf("unknown");
+		break;
+	}
+	if (fn->sysinit & CISTPL_SYSINIT_POST)
+		printf(" [post]");
+	if (fn->sysinit & CISTPL_SYSINIT_ROM)
+		printf(" [rom]");
+	putchar('\n');
+}
+
+/*====================================================================*/
+
+static void print_size(u_int size)
+{
+	if (size < 1024)
+		printf("%ub", size);
+	else if (size < 1024 * 1024)
+		printf("%ukb", size / 1024);
+	else
+		printf("%umb", size / (1024 * 1024));
+}
+
+static void print_unit(u_int v, char *unit, char tag)
+{
+	int n;
+	for (n = 0; (v % 1000) == 0; n++)
+		v /= 1000;
+	printf("%u", v);
+	if (n < strlen(unit))
+		putchar(unit[n]);
+	putchar(tag);
+}
+
+static void print_time(u_int tm, u_long scale)
+{
+	print_unit(tm * scale, "num", 's');
+}
+
+static void print_volt(u_int vi)
+{
+	print_unit(vi * 10, "um", 'V');
+}
+
+static void print_current(u_int ii)
+{
+	print_unit(ii / 10, "um", 'A');
+}
+
+static void print_speed(u_int b)
+{
+	if (b < 1000)
+		printf("%u bits/sec", b);
+	else if (b < 1000000)
+		printf("%u kb/sec", b / 1000);
+	else
+		printf("%u mb/sec", b / 1000000);
+}
+
+/*====================================================================*/
+
+static const char *dtype[] = {
+	"NULL", "ROM", "OTPROM", "EPROM", "EEPROM", "FLASH", "SRAM",
+	"DRAM", "rsvd", "rsvd", "rsvd", "rsvd", "rsvd", "fn_specific",
+	"extended", "rsvd"
+};
+
+static void print_device(cistpl_device_t * dev)
+{
+	int i;
+	for (i = 0; i < dev->ndev; i++) {
+		printf("%s  %s ", indent, dtype[dev->dev[i].type]);
+		printf("%uns, ", dev->dev[i].speed);
+		print_size(dev->dev[i].size);
+		putchar('\n');
+	}
+	if (dev->ndev == 0)
+		printf("%s  no_info\n", indent);
+}
+
+/*====================================================================*/
+
+static void print_power(char *tag, cistpl_power_t * power)
+{
+	int i, n;
+	for (i = n = 0; i < 8; i++)
+		if (power->present & (1 << i))
+			n++;
+	i = 0;
+	printf("%s  %s", indent, tag);
+	if (power->present & (1 << CISTPL_POWER_VNOM)) {
+		printf(" Vnom ");
+		i++;
+		print_volt(power->param[CISTPL_POWER_VNOM]);
+	}
+	if (power->present & (1 << CISTPL_POWER_VMIN)) {
+		printf(" Vmin ");
+		i++;
+		print_volt(power->param[CISTPL_POWER_VMIN]);
+	}
+	if (power->present & (1 << CISTPL_POWER_VMAX)) {
+		printf(" Vmax ");
+		i++;
+		print_volt(power->param[CISTPL_POWER_VMAX]);
+	}
+	if (power->present & (1 << CISTPL_POWER_ISTATIC)) {
+		printf(" Istatic ");
+		i++;
+		print_current(power->param[CISTPL_POWER_ISTATIC]);
+	}
+	if (power->present & (1 << CISTPL_POWER_IAVG)) {
+		if (++i == 5)
+			printf("\n%s   ", indent);
+		printf(" Iavg ");
+		print_current(power->param[CISTPL_POWER_IAVG]);
+	}
+	if (power->present & (1 << CISTPL_POWER_IPEAK)) {
+		if (++i == 5)
+			printf("\n%s ", indent);
+		printf(" Ipeak ");
+		print_current(power->param[CISTPL_POWER_IPEAK]);
+	}
+	if (power->present & (1 << CISTPL_POWER_IDOWN)) {
+		if (++i == 5)
+			printf("\n%s ", indent);
+		printf(" Idown ");
+		print_current(power->param[CISTPL_POWER_IDOWN]);
+	}
+	if (power->flags & CISTPL_POWER_HIGHZ_OK) {
+		if (++i == 5)
+			printf("\n%s ", indent);
+		printf(" [highz OK]");
+	}
+	if (power->flags & CISTPL_POWER_HIGHZ_REQ) {
+		printf(" [highz]");
+	}
+	putchar('\n');
+}
+
+/*====================================================================*/
+
+static void print_cftable_entry(cistpl_cftable_entry_t * entry)
+{
+	int i;
+
+	printf("%scftable_entry 0x%2.2x%s\n", indent, entry->index,
+	       (entry->flags & CISTPL_CFTABLE_DEFAULT) ? " [default]" : "");
+
+	if (entry->flags & ~CISTPL_CFTABLE_DEFAULT) {
+		printf("%s ", indent);
+		if (entry->flags & CISTPL_CFTABLE_BVDS)
+			printf(" [bvd]");
+		if (entry->flags & CISTPL_CFTABLE_WP)
+			printf(" [wp]");
+		if (entry->flags & CISTPL_CFTABLE_RDYBSY)
+			printf(" [rdybsy]");
+		if (entry->flags & CISTPL_CFTABLE_MWAIT)
+			printf(" [mwait]");
+		if (entry->flags & CISTPL_CFTABLE_AUDIO)
+			printf(" [audio]");
+		if (entry->flags & CISTPL_CFTABLE_READONLY)
+			printf(" [readonly]");
+		if (entry->flags & CISTPL_CFTABLE_PWRDOWN)
+			printf(" [pwrdown]");
+		putchar('\n');
+	}
+
+	if (entry->vcc.present)
+		print_power("Vcc", &entry->vcc);
+	if (entry->vpp1.present)
+		print_power("Vpp1", &entry->vpp1);
+	if (entry->vpp2.present)
+		print_power("Vpp2", &entry->vpp2);
+
+	if ((entry->timing.wait != 0) || (entry->timing.ready != 0) ||
+	    (entry->timing.reserved != 0)) {
+		printf("%s  timing", indent);
+		if (entry->timing.wait != 0) {
+			printf(" wait ");
+			print_time(entry->timing.wait, entry->timing.waitscale);
+		}
+		if (entry->timing.ready != 0) {
+			printf(" ready ");
+			print_time(entry->timing.ready, entry->timing.rdyscale);
+		}
+		if (entry->timing.reserved != 0) {
+			printf(" reserved ");
+			print_time(entry->timing.reserved,
+				   entry->timing.rsvscale);
+		}
+		putchar('\n');
+	}
+
+	if (entry->io.nwin) {
+		cistpl_io_t *io = &entry->io;
+		printf("%s  io", indent);
+		for (i = 0; i < io->nwin; i++) {
+			if (i)
+				putchar(',');
+			printf(" 0x%4.4x-0x%4.4x", io->win[i].base,
+			       io->win[i].base + io->win[i].len - 1);
+		}
+		printf(" [lines=%d]", io->flags & CISTPL_IO_LINES_MASK);
+		if (io->flags & CISTPL_IO_8BIT)
+			printf(" [8bit]");
+		if (io->flags & CISTPL_IO_16BIT)
+			printf(" [16bit]");
+		if (io->flags & CISTPL_IO_RANGE)
+			printf(" [range]");
+		putchar('\n');
+	}
+
+	if (entry->irq.IRQInfo1) {
+		printf("%s  irq ", indent);
+		if (entry->irq.IRQInfo1 & IRQ_INFO2_VALID)
+			printf("mask 0x%04x", entry->irq.IRQInfo2);
+		else
+			printf("%u", entry->irq.IRQInfo1 & IRQ_MASK);
+		if (entry->irq.IRQInfo1 & IRQ_LEVEL_ID)
+			printf(" [level]");
+		if (entry->irq.IRQInfo1 & IRQ_PULSE_ID)
+			printf(" [pulse]");
+		if (entry->irq.IRQInfo1 & IRQ_SHARE_ID)
+			printf(" [shared]");
+		putchar('\n');
+	}
+
+	if (entry->mem.nwin) {
+		cistpl_mem_t *mem = &entry->mem;
+		printf("%s  memory", indent);
+		for (i = 0; i < mem->nwin; i++) {
+			if (i)
+				putchar(',');
+			printf(" 0x%4.4x-0x%4.4x @ 0x%4.4x",
+			       mem->win[i].card_addr,
+			       mem->win[i].card_addr + mem->win[i].len - 1,
+			       mem->win[i].host_addr);
+		}
+		putchar('\n');
+	}
+
+	if (verbose && entry->subtuples)
+		printf("%s  %d bytes in subtuples\n", indent, entry->subtuples);
+
+}
+
+/*====================================================================*/
+
+static void print_cftable_entry_cb(cistpl_cftable_entry_cb_t * entry)
+{
+	int i;
+
+	printf("%scftable_entry_cb 0x%2.2x%s\n", indent, entry->index,
+	       (entry->flags & CISTPL_CFTABLE_DEFAULT) ? " [default]" : "");
+
+	if (entry->flags & ~CISTPL_CFTABLE_DEFAULT) {
+		printf("%s ", indent);
+		if (entry->flags & CISTPL_CFTABLE_MASTER)
+			printf(" [master]");
+		if (entry->flags & CISTPL_CFTABLE_INVALIDATE)
+			printf(" [invalidate]");
+		if (entry->flags & CISTPL_CFTABLE_VGA_PALETTE)
+			printf(" [vga palette]");
+		if (entry->flags & CISTPL_CFTABLE_PARITY)
+			printf(" [parity]");
+		if (entry->flags & CISTPL_CFTABLE_WAIT)
+			printf(" [wait]");
+		if (entry->flags & CISTPL_CFTABLE_SERR)
+			printf(" [serr]");
+		if (entry->flags & CISTPL_CFTABLE_FAST_BACK)
+			printf(" [fast back]");
+		if (entry->flags & CISTPL_CFTABLE_BINARY_AUDIO)
+			printf(" [binary audio]");
+		if (entry->flags & CISTPL_CFTABLE_PWM_AUDIO)
+			printf(" [pwm audio]");
+		putchar('\n');
+	}
+
+	if (entry->vcc.present)
+		print_power("Vcc", &entry->vcc);
+	if (entry->vpp1.present)
+		print_power("Vpp1", &entry->vpp1);
+	if (entry->vpp2.present)
+		print_power("Vpp2", &entry->vpp2);
+
+	if (entry->io) {
+		printf("%s  io_base", indent);
+		for (i = 0; i < 8; i++)
+			if (entry->io & (1 << i))
+				printf(" %d", i);
+		putchar('\n');
+	}
+
+	if (entry->irq.IRQInfo1) {
+		printf("%s  irq ", indent);
+		if (entry->irq.IRQInfo1 & IRQ_INFO2_VALID)
+			printf("mask 0x%4.4x", entry->irq.IRQInfo2);
+		else
+			printf("%u", entry->irq.IRQInfo1 & IRQ_MASK);
+		if (entry->irq.IRQInfo1 & IRQ_LEVEL_ID)
+			printf(" [level]");
+		if (entry->irq.IRQInfo1 & IRQ_PULSE_ID)
+			printf(" [pulse]");
+		if (entry->irq.IRQInfo1 & IRQ_SHARE_ID)
+			printf(" [shared]");
+		putchar('\n');
+	}
+
+	if (entry->mem) {
+		printf("%s  mem_base", indent);
+		for (i = 0; i < 8; i++)
+			if (entry->mem & (1 << i))
+				printf(" %d", i);
+		putchar('\n');
+	}
+
+	if (verbose && entry->subtuples)
+		printf("%s  %d bytes in subtuples\n", indent, entry->subtuples);
+
+}
+
+/*====================================================================*/
+
+static void print_jedec(cistpl_jedec_t * j)
+{
+	int i;
+	for (i = 0; i < j->nid; i++) {
+		if (i != 0)
+			putchar(',');
+		printf(" 0x%02x 0x%02x", j->id[i].mfr, j->id[i].info);
+	}
+	putchar('\n');
+}
+
+/*====================================================================*/
+
+static void print_device_geo(cistpl_device_geo_t * geo)
+{
+	int i;
+	for (i = 0; i < geo->ngeo; i++) {
+		printf("%s  width %d erase 0x%x read 0x%x write 0x%x "
+		       "partition 0x%x interleave 0x%x\n", indent,
+		       geo->geo[i].buswidth, geo->geo[i].erase_block,
+		       geo->geo[i].read_block, geo->geo[i].write_block,
+		       geo->geo[i].partition, geo->geo[i].interleave);
+	}
+}
+
+/*====================================================================*/
+
+static void print_org(cistpl_org_t * org)
+{
+	printf("%sdata_org ", indent);
+	switch (org->data_org) {
+	case CISTPL_ORG_FS:
+		printf("[filesystem]");
+		break;
+	case CISTPL_ORG_APPSPEC:
+		printf("[app_specific]");
+		break;
+	case CISTPL_ORG_XIP:
+		printf("[code]");
+		break;
+	default:
+		if (org->data_org < 0x80)
+			printf("[reserved]");
+		else
+			printf("[vendor_specific]");
+	}
+	printf(", \"%s\"\n", org->desc);
+}
+
+/*====================================================================*/
+
+static char *data_mod[] = {
+	"Bell103", "V.21", "V.23", "V.22", "Bell212A", "V.22bis",
+	"V.26", "V.26bis", "V.27bis", "V.29", "V.32", "V.32bis",
+	"V.34", "rfu", "rfu", "rfu"
+};
+
+static char *fax_mod[] = {
+	"V.21-C2", "V.27ter", "V.29", "V.17", "V.33", "rfu", "rfu", "rfu"
+};
+
+static char *fax_features[] = {
+	"T.3", "T.4", "T.6", "error", "voice", "poll", "file", "passwd"
+};
+
+static char *cmd_protocol[] = {
+	"AT1", "AT2", "AT3", "MNP_AT", "V.25bis", "V.25A", "DMCL"
+};
+
+static char *uart[] = {
+	"8250", "16450", "16550", "8251", "8530", "85230"
+};
+static char *parity[] = { "space", "mark", "odd", "even" };
+static char *stop[] = { "1", "1.5", "2" };
+
+static char *flow[] = {
+	"XON/XOFF xmit", "XON/XOFF rcv", "hw xmit", "hw rcv", "transparent"
+};
+
+static void print_serial(cistpl_funce_t * funce)
+{
+	cistpl_serial_t *s;
+	cistpl_data_serv_t *ds;
+	cistpl_fax_serv_t *fs;
+	cistpl_modem_cap_t *cp;
+	int i, j;
+
+	switch (funce->type & 0x0f) {
+	case CISTPL_FUNCE_SERIAL_IF:
+	case CISTPL_FUNCE_SERIAL_IF_DATA:
+	case CISTPL_FUNCE_SERIAL_IF_FAX:
+	case CISTPL_FUNCE_SERIAL_IF_VOICE:
+		s = (cistpl_serial_t *) (funce->data);
+		printf("%sserial_interface", indent);
+		if ((funce->type & 0x0f) == CISTPL_FUNCE_SERIAL_IF_DATA)
+			printf("_data");
+		else if ((funce->type & 0x0f) == CISTPL_FUNCE_SERIAL_IF_FAX)
+			printf("_fax");
+		else if ((funce->type & 0x0f) == CISTPL_FUNCE_SERIAL_IF_VOICE)
+			printf("_voice");
+		printf("\n%s  uart %s", indent,
+		       (s->uart_type < 6) ? uart[s->uart_type] : "reserved");
+		if (s->uart_cap_0) {
+			printf(" [");
+			for (i = 0; i < 4; i++)
+				if (s->uart_cap_0 & (1 << i))
+					printf("%s%s", parity[i],
+					       (s->uart_cap_0 >=
+						(2 << i)) ? "/" : "]");
+		}
+		if (s->uart_cap_1) {
+			int m = s->uart_cap_1 & 0x0f;
+			int n = s->uart_cap_1 >> 4;
+			printf(" [");
+			for (i = 0; i < 4; i++)
+				if (m & (1 << i))
+					printf("%d%s", i + 5,
+					       (m >= (2 << i)) ? "/" : "");
+			printf("] [");
+			for (i = 0; i < 3; i++)
+				if (n & (1 << i))
+					printf("%s%s", stop[i],
+					       (n >= (2 << i)) ? "/" : "]");
+		}
+		printf("\n");
+		break;
+	case CISTPL_FUNCE_SERIAL_CAP:
+	case CISTPL_FUNCE_SERIAL_CAP_DATA:
+	case CISTPL_FUNCE_SERIAL_CAP_FAX:
+	case CISTPL_FUNCE_SERIAL_CAP_VOICE:
+		cp = (cistpl_modem_cap_t *) (funce->data);
+		printf("%sserial_modem_cap", indent);
+		if ((funce->type & 0x0f) == CISTPL_FUNCE_SERIAL_CAP_DATA)
+			printf("_data");
+		else if ((funce->type & 0x0f) == CISTPL_FUNCE_SERIAL_CAP_FAX)
+			printf("_fax");
+		else if ((funce->type & 0x0f) == CISTPL_FUNCE_SERIAL_CAP_VOICE)
+			printf("_voice");
+		if (cp->flow) {
+			printf("\n%s  flow", indent);
+			for (i = 0; i < 5; i++)
+				if (cp->flow & (1 << i))
+					printf(" [%s]", flow[i]);
+		}
+		printf("\n%s  cmd_buf %d rcv_buf %d xmit_buf %d\n",
+		       indent, 4 * (cp->cmd_buf + 1),
+		       cp->rcv_buf_0 + (cp->rcv_buf_1 << 8) +
+		       (cp->rcv_buf_2 << 16),
+		       cp->xmit_buf_0 + (cp->xmit_buf_1 << 8) +
+		       (cp->xmit_buf_2 << 16));
+		break;
+	case CISTPL_FUNCE_SERIAL_SERV_DATA:
+		ds = (cistpl_data_serv_t *) (funce->data);
+		printf("%sserial_data_services\n", indent);
+		printf("%s  data_rate %d\n", indent,
+		       75 * ((ds->max_data_0 << 8) + ds->max_data_1));
+		printf("%s  modulation", indent);
+		for (i = j = 0; i < 16; i++)
+			if (((ds->modulation_1 << 8) +
+			     ds->modulation_0) & (1 << i)) {
+				if (++j % 6 == 0)
+					printf("\n%s   ", indent);
+				printf(" [%s]", data_mod[i]);
+			}
+		printf("\n");
+		if (ds->error_control) {
+			printf("%s  error_control", indent);
+			if (ds->error_control & CISTPL_SERIAL_ERR_MNP2_4)
+				printf(" [MNP2-4]");
+			if (ds->error_control & CISTPL_SERIAL_ERR_V42_LAPM)
+				printf(" [V.42/LAPM]");
+			printf("\n");
+		}
+		if (ds->compression) {
+			printf("%s  compression", indent);
+			if (ds->compression & CISTPL_SERIAL_CMPR_V42BIS)
+				printf(" [V.42bis]");
+			if (ds->compression & CISTPL_SERIAL_CMPR_MNP5)
+				printf(" [MNP5]");
+			printf("\n");
+		}
+		if (ds->cmd_protocol) {
+			printf("%s  cmd_protocol", indent);
+			for (i = 0; i < 7; i++)
+				if (ds->cmd_protocol & (1 << i))
+					printf(" [%s]", cmd_protocol[i]);
+			printf("\n");
+		}
+		break;
+
+	case CISTPL_FUNCE_SERIAL_SERV_FAX:
+		fs = (cistpl_fax_serv_t *) (funce->data);
+		printf("%sserial_fax_services [class=%d]\n",
+		       indent, funce->type >> 4);
+		printf("%s  data_rate %d\n", indent,
+		       75 * ((fs->max_data_0 << 8) + fs->max_data_1));
+		printf("%s  modulation", indent);
+		for (i = 0; i < 8; i++)
+			if (fs->modulation & (1 << i))
+				printf(" [%s]", fax_mod[i]);
+		printf("\n");
+		if (fs->features_0) {
+			printf("%s  features", indent);
+			for (i = 0; i < 8; i++)
+				if (fs->features_0 & (1 << i))
+					printf(" [%s]", fax_features[i]);
+			printf("\n");
+		}
+		break;
+	}
+}
+
+/*====================================================================*/
+
+static void print_fixed(cistpl_funce_t * funce)
+{
+	cistpl_ide_interface_t *i;
+	cistpl_ide_feature_t *f;
+
+	switch (funce->type) {
+	case CISTPL_FUNCE_IDE_IFACE:
+		i = (cistpl_ide_interface_t *) (funce->data);
+		printf("%sdisk_interface ", indent);
+		if (i->interface == CISTPL_IDE_INTERFACE)
+			printf("[ide]\n");
+		else
+			printf("[undefined]\n");
+		break;
+	case CISTPL_FUNCE_IDE_MASTER:
+	case CISTPL_FUNCE_IDE_SLAVE:
+		f = (cistpl_ide_feature_t *) (funce->data);
+		printf("%sdisk_features", indent);
+		if (f->feature1 & CISTPL_IDE_SILICON)
+			printf(" [silicon]");
+		else
+			printf(" [rotating]");
+		if (f->feature1 & CISTPL_IDE_UNIQUE)
+			printf(" [unique]");
+		if (f->feature1 & CISTPL_IDE_DUAL)
+			printf(" [dual]");
+		else
+			printf(" [single]");
+		if (f->feature1 && f->feature2)
+			printf("\n%s ", indent);
+		if (f->feature2 & CISTPL_IDE_HAS_SLEEP)
+			printf(" [sleep]");
+		if (f->feature2 & CISTPL_IDE_HAS_STANDBY)
+			printf(" [standby]");
+		if (f->feature2 & CISTPL_IDE_HAS_IDLE)
+			printf(" [idle]");
+		if (f->feature2 & CISTPL_IDE_LOW_POWER)
+			printf(" [low power]");
+		if (f->feature2 & CISTPL_IDE_REG_INHIBIT)
+			printf(" [reg inhibit]");
+		if (f->feature2 & CISTPL_IDE_HAS_INDEX)
+			printf(" [index]");
+		if (f->feature2 & CISTPL_IDE_IOIS16)
+			printf(" [iois16]");
+		putchar('\n');
+		break;
+	}
+}
+
+/*====================================================================*/
+
+static const char *tech[] = {
+	"undefined", "ARCnet", "ethernet", "token_ring", "localtalk",
+	"FDDI/CDDI", "ATM", "wireless"
+};
+
+static const char *media[] = {
+	"undefined", "unshielded_twisted_pair", "shielded_twisted_pair",
+	"thin_coax", "thick_coax", "fiber", "900_MHz", "2.4_GHz",
+	"5.4_GHz", "diffuse_infrared", "point_to_point_infrared"
+};
+
+static void print_network(cistpl_funce_t * funce)
+{
+	cistpl_lan_tech_t *t;
+	cistpl_lan_speed_t *s;
+	cistpl_lan_media_t *m;
+	cistpl_lan_node_id_t *n;
+	cistpl_lan_connector_t *c;
+	int i;
+
+	switch (funce->type) {
+	case CISTPL_FUNCE_LAN_TECH:
+		t = (cistpl_lan_tech_t *) (funce->data);
+		printf("%slan_technology %s\n", indent, tech[t->tech]);
+		break;
+	case CISTPL_FUNCE_LAN_SPEED:
+		s = (cistpl_lan_speed_t *) (funce->data);
+		printf("%slan_speed ", indent);
+		print_speed(s->speed);
+		putchar('\n');
+		break;
+	case CISTPL_FUNCE_LAN_MEDIA:
+		m = (cistpl_lan_media_t *) (funce->data);
+		printf("%slan_media %s\n", indent, media[m->media]);
+		break;
+	case CISTPL_FUNCE_LAN_NODE_ID:
+		n = (cistpl_lan_node_id_t *) (funce->data);
+		printf("%slan_node_id", indent);
+		for (i = 0; i < n->nb; i++)
+			printf(" %02x", n->id[i]);
+		putchar('\n');
+		break;
+	case CISTPL_FUNCE_LAN_CONNECTOR:
+		c = (cistpl_lan_connector_t *) (funce->data);
+		printf("%slan_connector ", indent);
+		if (c->code == 0)
+			printf("Open connector standard\n");
+		else
+			printf("Closed connector standard\n");
+		break;
+	}
+}
+
+/*====================================================================*/
+
+static void print_vers_1(cistpl_vers_1_t * v1)
+{
+	int i, n;
+	char s[32];
+	sprintf(s, "%svers_1 %d.%d", indent, v1->major, v1->minor);
+	printf("%s", s);
+	n = strlen(s);
+	for (i = 0; i < v1->ns; i++) {
+		if (n + strlen(v1->str + v1->ofs[i]) + 4 > 72) {
+			n = strlen(indent) + 2;
+			printf(",\n%s  ", indent);
+		} else {
+			printf(", ");
+			n += 2;
+		}
+		printf("\"%s\"", v1->str + v1->ofs[i]);
+		n += strlen(v1->str + v1->ofs[i]) + 2;
+	}
+	putchar('\n');
+}
+
+/*====================================================================*/
+
+static void print_vers_2(cistpl_vers_2_t * v2)
+{
+	printf("%sversion 0x%2.2x, compliance 0x%2.2x, dindex 0x%4.4x\n",
+	       indent, v2->vers, v2->comply, v2->dindex);
+	printf("%s  vspec8 0x%2.2x, vspec9 0x%2.2x, nhdr %d\n",
+	       indent, v2->vspec8, v2->vspec9, v2->nhdr);
+	printf("%s  vendor \"%s\"\n", indent, v2->str + v2->vendor);
+	printf("%s  info \"%s\"\n", indent, v2->str + v2->info);
+}
+
+/*====================================================================*/
+
+#ifdef CISTPL_FORMAT_DISK
+static void print_format(cistpl_format_t * fmt)
+{
+	if (fmt->type == CISTPL_FORMAT_DISK)
+		printf("%s  [disk]", indent);
+	else if (fmt->type == CISTPL_FORMAT_MEM)
+		printf("%s  [memory]", indent);
+	else
+		printf("%s  [type 0x%02x]\n", indent, fmt->type);
+	if (fmt->edc == CISTPL_EDC_NONE)
+		printf(" [no edc]");
+	else if (fmt->edc == CISTPL_EDC_CKSUM)
+		printf(" [cksum]");
+	else if (fmt->edc == CISTPL_EDC_CRC)
+		printf(" [crc]");
+	else if (fmt->edc == CISTPL_EDC_PCC)
+		printf(" [pcc]");
+	else
+		printf(" [edc 0x%02x]", fmt->edc);
+	printf(" offset 0x%04x length ", fmt->offset);
+	print_size(fmt->length);
+	putchar('\n');
+}
+#endif
+
+/*====================================================================*/
+
+static void print_config(int code, cistpl_config_t * cfg)
+{
+	printf("%sconfig%s base 0x%4.4x", indent,
+	       (code == CISTPL_CONFIG_CB) ? "_cb" : "", cfg->base);
+	if (code == CISTPL_CONFIG)
+		printf(" mask 0x%4.4x", cfg->rmask[0]);
+	printf(" last_index 0x%2.2x\n", cfg->last_idx);
+	if (verbose && cfg->subtuples)
+		printf("%s  %d bytes in subtuples\n", indent, cfg->subtuples);
+}
+
+/*====================================================================*/
+
+static int nfn = 0, cur = 0;
+
+static void print_parse(tuple_parse_t * tup)
+{
+	static int func = 0;
+	int i;
+
+	switch (tup->tuple.TupleCode) {
+	case CISTPL_DEVICE:
+	case CISTPL_DEVICE_A:
+		if (tup->tuple.TupleCode == CISTPL_DEVICE)
+			printf("%sdev_info\n", indent);
+		else
+			printf("%sattr_dev_info\n", indent);
+		print_device(&tup->parse.device);
+		break;
+	case CISTPL_CHECKSUM:
+		printf("%schecksum 0x%04x-0x%04x = 0x%02x\n",
+		       indent, tup->parse.checksum.addr,
+		       tup->parse.checksum.addr + tup->parse.checksum.len - 1,
+		       tup->parse.checksum.sum);
+		break;
+	case CISTPL_LONGLINK_A:
+		if (verbose)
+			printf("%slong_link_attr 0x%04x\n", indent,
+			       tup->parse.longlink.addr);
+		break;
+	case CISTPL_LONGLINK_C:
+		if (verbose)
+			printf("%slong_link 0x%04x\n", indent,
+			       tup->parse.longlink.addr);
+		break;
+	case CISTPL_LONGLINK_MFC:
+		if (verbose) {
+			printf("%smfc_long_link\n", indent);
+			for (i = 0; i < tup->parse.longlink_mfc.nfn; i++)
+				printf("%s function %d: %s 0x%04x\n", indent, i,
+				       tup->parse.longlink_mfc.fn[i].space ?
+				       "common" : "attr",
+				       tup->parse.longlink_mfc.fn[i].addr);
+		}
+
+		printf("%smfc {\n", indent);
+		nfn = tup->parse.longlink_mfc.nfn;
+		cur = 0;
+		strcat(indent, "  ");
+		while (cur < nfn) {
+			tuple_parse_t tuple_parse = *tup;
+			tuple_parse.tuple.CISOffset =
+			    tup->parse.longlink_mfc.fn[cur].addr;
+			tuple_parse.tuple.TupleLink = 0;
+
+			while (1) {
+				if (get_tuple_buf(-1, &tuple_parse.tuple, 0))
+					break;
+				if (verbose)
+					print_tuple(&tuple_parse);
+				if (parse_tuple
+				    (&tuple_parse.tuple,
+				     &tuple_parse.parse) == 0)
+					print_parse(&tuple_parse);
+				else
+					printf("%sparse error\n", indent);
+				if (verbose)
+					putchar('\n');
+				if (tuple_parse.tuple.TupleCode == CISTPL_END)
+					break;
+			}
+		}
+		break;
+	case CISTPL_NO_LINK:
+		if (verbose)
+			printf("%sno_long_link\n", indent);
+		break;
+#ifdef CISTPL_INDIRECT
+	case CISTPL_INDIRECT:
+		if (verbose)
+			printf("%sindirect_access\n", indent);
+		break;
+#endif
+	case CISTPL_LINKTARGET:
+		if (verbose)
+			printf("%slink_target\n", indent);
+
+		if (cur++)
+			printf("%s}, {\n", indent + 2);
+		break;
+	case CISTPL_VERS_1:
+		print_vers_1(&tup->parse.version_1);
+		break;
+	case CISTPL_ALTSTR:
+		break;
+	case CISTPL_JEDEC_A:
+	case CISTPL_JEDEC_C:
+		if (tup->tuple.TupleCode == CISTPL_JEDEC_C)
+			printf("%scommon_jedec", indent);
+		else
+			printf("%sattr_jedec", indent);
+		print_jedec(&tup->parse.jedec);
+		break;
+	case CISTPL_DEVICE_GEO:
+	case CISTPL_DEVICE_GEO_A:
+		if (tup->tuple.TupleCode == CISTPL_DEVICE_GEO)
+			printf("%scommon_geometry\n", indent);
+		else
+			printf("%sattr_geometry\n", indent);
+		print_device_geo(&tup->parse.device_geo);
+		break;
+	case CISTPL_MANFID:
+		printf("%smanfid 0x%4.4x, 0x%4.4x\n", indent,
+		       tup->parse.manfid.manf, tup->parse.manfid.card);
+		break;
+	case CISTPL_FUNCID:
+		print_funcid(&tup->parse.funcid);
+		func = tup->parse.funcid.func;
+		break;
+	case CISTPL_FUNCE:
+		switch (func) {
+		case CISTPL_FUNCID_SERIAL:
+			print_serial(&tup->parse.funce);
+			break;
+		case CISTPL_FUNCID_FIXED:
+			print_fixed(&tup->parse.funce);
+			break;
+		case CISTPL_FUNCID_NETWORK:
+			print_network(&tup->parse.funce);
+			break;
+		}
+		break;
+	case CISTPL_BAR:
+		printf("%sBAR %d size ", indent,
+		       tup->parse.bar.attr & CISTPL_BAR_SPACE);
+		print_size(tup->parse.bar.size);
+		if (tup->parse.bar.attr & CISTPL_BAR_SPACE_IO)
+			printf(" [io]");
+		else
+			printf(" [mem]");
+		if (tup->parse.bar.attr & CISTPL_BAR_PREFETCH)
+			printf(" [prefetch]");
+		if (tup->parse.bar.attr & CISTPL_BAR_CACHEABLE)
+			printf(" [cacheable]");
+		if (tup->parse.bar.attr & CISTPL_BAR_1MEG_MAP)
+			printf(" [<1mb]");
+		putchar('\n');
+		break;
+	case CISTPL_CONFIG:
+	case CISTPL_CONFIG_CB:
+		print_config(tup->tuple.TupleCode, &tup->parse.config);
+		break;
+	case CISTPL_CFTABLE_ENTRY:
+		print_cftable_entry(&tup->parse.cftable_entry);
+		break;
+	case CISTPL_CFTABLE_ENTRY_CB:
+		print_cftable_entry_cb(&tup->parse.cftable_entry_cb);
+		break;
+	case CISTPL_VERS_2:
+		print_vers_2(&tup->parse.vers_2);
+		break;
+	case CISTPL_ORG:
+		print_org(&tup->parse.org);
+		break;
+#ifdef CISTPL_FORMAT_DISK
+	case CISTPL_FORMAT:
+	case CISTPL_FORMAT_A:
+		if (tup->tuple.TupleCode == CISTPL_FORMAT)
+			printf("%scommon_format\n", indent);
+		else
+			printf("%sattr_format\n", indent);
+		print_format(&tup->parse.format);
+#endif
+	}
+}
+
+/*====================================================================*/
+
+static int get_tuple_buf(int fd, tuple_t * tuple, int first)
+{
+	u_int ofs;
+	static int nb = 0;
+	static u_char buf[1024];
+
+	if (first) {
+		nb = read(fd, buf, sizeof(buf));
+		tuple->TupleLink = tuple->CISOffset = 0;
+	}
+	ofs = tuple->CISOffset + tuple->TupleLink;
+	if (ofs >= nb)
+		return -1;
+	tuple->TupleCode = buf[ofs++];
+	tuple->TupleDataLen = tuple->TupleLink = buf[ofs++];
+	tuple->CISOffset = ofs;
+	memcpy(tuple->TupleData, buf + ofs, tuple->TupleLink);
+	return 0;
+}
+
+/*======================================================================
+
+	Parsing routines for individual tuples
+
+======================================================================*/
+
+static const u_char mantissa[] = {
+	10, 12, 13, 15, 20, 25, 30, 35,
+	40, 45, 50, 55, 60, 70, 80, 90
+};
+
+static const u_int exponent[] = {
+	1, 10, 100, 1000, 10000, 100000, 1000000, 10000000
+};
+
+/* Convert an extended speed byte to a time in nanoseconds */
+#define SPEED_CVT(v) \
+	(mantissa[(((v)>>3)&15)-1] * exponent[(v)&7] / 10)
+/* Convert a power byte to a current in 0.1 microamps */
+#define POWER_CVT(v) \
+	(mantissa[((v)>>3)&15] * exponent[(v)&7] / 10)
+#define POWER_SCALE(v)				(exponent[(v)&7])
+
+static int parse_device(tuple_t * tuple, cistpl_device_t * device)
+{
+	int i;
+	u_char scale;
+	u_char *p, *q;
+
+	p = (u_char *) tuple->TupleData;
+	q = p + tuple->TupleDataLen;
+
+	device->ndev = 0;
+	for (i = 0; i < CISTPL_MAX_DEVICES; i++) {
+
+		if (*p == 0xff)
+			break;
+		device->dev[i].type = (*p >> 4);
+		device->dev[i].wp = (*p & 0x08) ? 1 : 0;
+		switch (*p & 0x07) {
+		case 0:
+			device->dev[i].speed = 0;
+			break;
+		case 1:
+			device->dev[i].speed = 250;
+			break;
+		case 2:
+			device->dev[i].speed = 200;
+			break;
+		case 3:
+			device->dev[i].speed = 150;
+			break;
+		case 4:
+			device->dev[i].speed = 100;
+			break;
+		case 7:
+			if (++p == q)
+				return -1;
+			if (p == q)
+				return -1;
+			device->dev[i].speed = SPEED_CVT(*p);
+			while (*p & 0x80)
+				if (++p == q)
+					return -1;
+			break;
+		default:
+			return -1;
+		}
+
+		if (++p == q)
+			return -1;
+		if (*p == 0xff)
+			break;
+		scale = *p & 7;
+		if (scale == 7)
+			return -1;
+		device->dev[i].size = ((*p >> 3) + 1) * (512 << (scale * 2));
+		device->ndev++;
+		if (++p == q)
+			break;
+	}
+
+	return 0;
+}
+
+/*====================================================================*/
+
+static int parse_checksum(tuple_t * tuple, cistpl_checksum_t * csum)
+{
+	u_char *p;
+	if (tuple->TupleDataLen < 5)
+		return -1;
+	p = (u_char *) tuple->TupleData;
+	csum->addr = tuple->CISOffset + (short)le16toh(*(u_short *) p) - 2;
+	csum->len = le16toh(*(u_short *) (p + 2));
+	csum->sum = *(p + 4);
+	return 0;
+}
+
+/*====================================================================*/
+
+static int parse_longlink(tuple_t * tuple, cistpl_longlink_t * link)
+{
+	if (tuple->TupleDataLen < 4)
+		return -1;
+	link->addr = le32toh(*(u_int *) tuple->TupleData);
+	return 0;
+}
+
+/*====================================================================*/
+
+static int parse_longlink_mfc(tuple_t * tuple, cistpl_longlink_mfc_t * link)
+{
+	u_char *p;
+	int i;
+
+	p = (u_char *) tuple->TupleData;
+
+	link->nfn = *p;
+	p++;
+	if (tuple->TupleDataLen <= link->nfn * 5)
+		return -1;
+	for (i = 0; i < link->nfn; i++) {
+		link->fn[i].space = *p;
+		p++;
+		link->fn[i].addr = le32toh(*(u_int *) p);
+		p += 4;
+	}
+	return 0;
+}
+
+/*====================================================================*/
+
+static int parse_strings(u_char * p, u_char * q, int max,
+			 char *s, u_char * ofs, u_char * found)
+{
+	int i, j, ns;
+
+	if (p == q)
+		return -1;
+	ns = 0;
+	j = 0;
+	for (i = 0; i < max; i++) {
+		if (*p == 0xff)
+			break;
+		ofs[i] = j;
+		ns++;
+		for (;;) {
+			s[j++] = (*p == 0xff) ? '\0' : *p;
+			if ((*p == '\0') || (*p == 0xff))
+				break;
+			if (++p == q)
+				return -1;
+		}
+		if ((*p == 0xff) || (++p == q))
+			break;
+	}
+	if (found) {
+		*found = ns;
+		return 0;
+	} else {
+		return (ns == max) ? 0 : -1;
+	}
+}
+
+/*====================================================================*/
+
+static int parse_vers_1(tuple_t * tuple, cistpl_vers_1_t * vers_1)
+{
+	u_char *p, *q;
+
+	p = (u_char *) tuple->TupleData;
+	q = p + tuple->TupleDataLen;
+
+	vers_1->major = *p;
+	p++;
+	vers_1->minor = *p;
+	p++;
+	if (p >= q)
+		return -1;
+
+	return parse_strings(p, q, CISTPL_VERS_1_MAX_PROD_STRINGS,
+			     vers_1->str, vers_1->ofs, &vers_1->ns);
+}
+
+/*====================================================================*/
+
+static int parse_altstr(tuple_t * tuple, cistpl_altstr_t * altstr)
+{
+	u_char *p, *q;
+
+	p = (u_char *) tuple->TupleData;
+	q = p + tuple->TupleDataLen;
+
+	return parse_strings(p, q, CISTPL_MAX_ALTSTR_STRINGS,
+			     altstr->str, altstr->ofs, &altstr->ns);
+}
+
+/*====================================================================*/
+
+static int parse_jedec(tuple_t * tuple, cistpl_jedec_t * jedec)
+{
+	u_char *p, *q;
+	int nid;
+
+	p = (u_char *) tuple->TupleData;
+	q = p + tuple->TupleDataLen;
+
+	for (nid = 0; nid < CISTPL_MAX_DEVICES; nid++) {
+		if (p > q - 2)
+			break;
+		jedec->id[nid].mfr = p[0];
+		jedec->id[nid].info = p[1];
+		p += 2;
+	}
+	jedec->nid = nid;
+	return 0;
+}
+
+/*====================================================================*/
+
+static int parse_manfid(tuple_t * tuple, cistpl_manfid_t * m)
+{
+	u_short *p;
+	if (tuple->TupleDataLen < 4)
+		return -1;
+	p = (u_short *) tuple->TupleData;
+	m->manf = le16toh(p[0]);
+	m->card = le16toh(p[1]);
+	return 0;
+}
+
+/*====================================================================*/
+
+static int parse_funcid(tuple_t * tuple, cistpl_funcid_t * f)
+{
+	u_char *p;
+	if (tuple->TupleDataLen < 2)
+		return -1;
+	p = (u_char *) tuple->TupleData;
+	f->func = p[0];
+	f->sysinit = p[1];
+	return 0;
+}
+
+/*====================================================================*/
+
+static int parse_funce(tuple_t * tuple, cistpl_funce_t * f)
+{
+	u_char *p;
+	int i;
+	if (tuple->TupleDataLen < 1)
+		return -1;
+	p = (u_char *) tuple->TupleData;
+	f->type = p[0];
+	for (i = 1; i < tuple->TupleDataLen; i++)
+		f->data[i - 1] = p[i];
+	return 0;
+}
+
+/*====================================================================*/
+
+static int parse_config(tuple_t * tuple, cistpl_config_t * config)
+{
+	int rasz, rmsz, i;
+	u_char *p;
+
+	p = (u_char *) tuple->TupleData;
+	rasz = *p & 0x03;
+	rmsz = (*p & 0x3c) >> 2;
+	if (tuple->TupleDataLen < rasz + rmsz + 4)
+		return -1;
+	config->last_idx = *(++p);
+	p++;
+	config->base = 0;
+	for (i = 0; i <= rasz; i++)
+		config->base += p[i] << (8 * i);
+	p += rasz + 1;
+	for (i = 0; i < 4; i++)
+		config->rmask[i] = 0;
+	for (i = 0; i <= rmsz; i++)
+		config->rmask[i >> 2] += p[i] << (8 * (i % 4));
+	config->subtuples = tuple->TupleDataLen - (rasz + rmsz + 4);
+	return 0;
+}
+
+/*======================================================================
+
+	The following routines are all used to parse the nightmarish
+	config table entries.
+
+======================================================================*/
+
+static u_char *parse_power(u_char * p, u_char * q, cistpl_power_t * pwr)
+{
+	int i;
+	u_int scale;
+
+	if (p == q)
+		return NULL;
+	pwr->present = *p;
+	pwr->flags = 0;
+	p++;
+	for (i = 0; i < 7; i++)
+		if (pwr->present & (1 << i)) {
+			if (p == q)
+				return NULL;
+			pwr->param[i] = POWER_CVT(*p);
+			scale = POWER_SCALE(*p);
+			while (*p & 0x80) {
+				if (++p == q)
+					return NULL;
+				if ((*p & 0x7f) < 100)
+					pwr->param[i] +=
+					    (*p & 0x7f) * scale / 100;
+				else if (*p == 0x7d)
+					pwr->flags |= CISTPL_POWER_HIGHZ_OK;
+				else if (*p == 0x7e)
+					pwr->param[i] = 0;
+				else if (*p == 0x7f)
+					pwr->flags |= CISTPL_POWER_HIGHZ_REQ;
+				else
+					return NULL;
+			}
+			p++;
+		}
+	return p;
+}
+
+/*====================================================================*/
+
+static u_char *parse_timing(u_char * p, u_char * q, cistpl_timing_t * timing)
+{
+	u_char scale;
+
+	if (p == q)
+		return NULL;
+	scale = *p;
+	if ((scale & 3) != 3) {
+		if (++p == q)
+			return NULL;
+		timing->wait = SPEED_CVT(*p);
+		timing->waitscale = exponent[scale & 3];
+	} else
+		timing->wait = 0;
+	scale >>= 2;
+	if ((scale & 7) != 7) {
+		if (++p == q)
+			return NULL;
+		timing->ready = SPEED_CVT(*p);
+		timing->rdyscale = exponent[scale & 7];
+	} else
+		timing->ready = 0;
+	scale >>= 3;
+	if (scale != 7) {
+		if (++p == q)
+			return NULL;
+		timing->reserved = SPEED_CVT(*p);
+		timing->rsvscale = exponent[scale];
+	} else
+		timing->reserved = 0;
+	p++;
+	return p;
+}
+
+/*====================================================================*/
+
+static u_char *parse_io(u_char * p, u_char * q, cistpl_io_t * io)
+{
+	int i, j, bsz, lsz;
+
+	if (p == q)
+		return NULL;
+	io->flags = *p;
+
+	if (!(*p & 0x80)) {
+		io->nwin = 1;
+		io->win[0].base = 0;
+		io->win[0].len = (1 << (io->flags & CISTPL_IO_LINES_MASK));
+		return p + 1;
+	}
+
+	if (++p == q)
+		return NULL;
+	io->nwin = (*p & 0x0f) + 1;
+	bsz = (*p & 0x30) >> 4;
+	if (bsz == 3)
+		bsz++;
+	lsz = (*p & 0xc0) >> 6;
+	if (lsz == 3)
+		lsz++;
+	p++;
+
+	for (i = 0; i < io->nwin; i++) {
+		io->win[i].base = 0;
+		io->win[i].len = 1;
+		for (j = 0; j < bsz; j++, p++) {
+			if (p == q)
+				return NULL;
+			io->win[i].base += *p << (j * 8);
+		}
+		for (j = 0; j < lsz; j++, p++) {
+			if (p == q)
+				return NULL;
+			io->win[i].len += *p << (j * 8);
+		}
+	}
+	return p;
+}
+
+/*====================================================================*/
+
+static u_char *parse_mem(u_char * p, u_char * q, cistpl_mem_t * mem)
+{
+	int i, j, asz, lsz, has_ha;
+	u_int len, ca, ha;
+
+	if (p == q)
+		return NULL;
+
+	mem->nwin = (*p & 0x07) + 1;
+	lsz = (*p & 0x18) >> 3;
+	asz = (*p & 0x60) >> 5;
+	has_ha = (*p & 0x80);
+	if (++p == q)
+		return NULL;
+
+	for (i = 0; i < mem->nwin; i++) {
+		len = ca = ha = 0;
+		for (j = 0; j < lsz; j++, p++) {
+			if (p == q)
+				return NULL;
+			len += *p << (j * 8);
+		}
+		for (j = 0; j < asz; j++, p++) {
+			if (p == q)
+				return NULL;
+			ca += *p << (j * 8);
+		}
+		if (has_ha)
+			for (j = 0; j < asz; j++, p++) {
+				if (p == q)
+					return NULL;
+				ha += *p << (j * 8);
+			}
+		mem->win[i].len = len << 8;
+		mem->win[i].card_addr = ca << 8;
+		mem->win[i].host_addr = ha << 8;
+	}
+	return p;
+}
+
+/*====================================================================*/
+
+static u_char *parse_irq(u_char * p, u_char * q, cistpl_irq_t * irq)
+{
+	if (p == q)
+		return NULL;
+	irq->IRQInfo1 = *p;
+	p++;
+	if (irq->IRQInfo1 & IRQ_INFO2_VALID) {
+		if (p + 2 > q)
+			return NULL;
+		irq->IRQInfo2 = (p[1] << 8) + p[0];
+		p += 2;
+	}
+	return p;
+}
+
+/*====================================================================*/
+
+static int parse_cftable_entry(tuple_t * tuple, cistpl_cftable_entry_t * entry)
+{
+	u_char *p, *q, features;
+
+	p = tuple->TupleData;
+	q = p + tuple->TupleDataLen;
+	entry->index = *p & 0x3f;
+	entry->flags = 0;
+	if (*p & 0x40)
+		entry->flags |= CISTPL_CFTABLE_DEFAULT;
+	if (*p & 0x80) {
+		if (++p == q)
+			return -1;
+		if (*p & 0x10)
+			entry->flags |= CISTPL_CFTABLE_BVDS;
+		if (*p & 0x20)
+			entry->flags |= CISTPL_CFTABLE_WP;
+		if (*p & 0x40)
+			entry->flags |= CISTPL_CFTABLE_RDYBSY;
+		if (*p & 0x80)
+			entry->flags |= CISTPL_CFTABLE_MWAIT;
+		entry->interface = *p & 0x0f;
+	} else
+		entry->interface = 0;
+
+	/* Process optional features */
+	if (++p == q)
+		return -1;
+	features = *p;
+	p++;
+
+	/* Power options */
+	if ((features & 3) > 0) {
+		p = parse_power(p, q, &entry->vcc);
+		if (p == NULL)
+			return -1;
+	} else
+		entry->vcc.present = 0;
+	if ((features & 3) > 1) {
+		p = parse_power(p, q, &entry->vpp1);
+		if (p == NULL)
+			return -1;
+	} else
+		entry->vpp1.present = 0;
+	if ((features & 3) > 2) {
+		p = parse_power(p, q, &entry->vpp2);
+		if (p == NULL)
+			return -1;
+	} else
+		entry->vpp2.present = 0;
+
+	/* Timing options */
+	if (features & 0x04) {
+		p = parse_timing(p, q, &entry->timing);
+		if (p == NULL)
+			return -1;
+	} else {
+		entry->timing.wait = 0;
+		entry->timing.ready = 0;
+		entry->timing.reserved = 0;
+	}
+
+	/* I/O window options */
+	if (features & 0x08) {
+		p = parse_io(p, q, &entry->io);
+		if (p == NULL)
+			return -1;
+	} else
+		entry->io.nwin = 0;
+
+	/* Interrupt options */
+	if (features & 0x10) {
+		p = parse_irq(p, q, &entry->irq);
+		if (p == NULL)
+			return -1;
+	} else
+		entry->irq.IRQInfo1 = 0;
+
+	switch (features & 0x60) {
+	case 0x00:
+		entry->mem.nwin = 0;
+		break;
+	case 0x20:
+		entry->mem.nwin = 1;
+		entry->mem.win[0].len = le16toh(*(u_short *) p) << 8;
+		entry->mem.win[0].card_addr = 0;
+		entry->mem.win[0].host_addr = 0;
+		p += 2;
+		if (p > q)
+			return -1;
+		break;
+	case 0x40:
+		entry->mem.nwin = 1;
+		entry->mem.win[0].len = le16toh(*(u_short *) p) << 8;
+		entry->mem.win[0].card_addr =
+		    le16toh(*(u_short *) (p + 2)) << 8;
+		entry->mem.win[0].host_addr = 0;
+		p += 4;
+		if (p > q)
+			return -1;
+		break;
+	case 0x60:
+		p = parse_mem(p, q, &entry->mem);
+		if (p == NULL)
+			return -1;
+		break;
+	}
+
+	/* Misc features */
+	if (features & 0x80) {
+		if (p == q)
+			return -1;
+		entry->flags |= (*p << 8);
+		while (*p & 0x80)
+			if (++p == q)
+				return -1;
+		p++;
+	}
+
+	entry->subtuples = q - p;
+
+	return 0;
+}
+
+/*====================================================================*/
+
+static int parse_bar(tuple_t * tuple, cistpl_bar_t * bar)
+{
+	u_char *p;
+	if (tuple->TupleDataLen < 6)
+		return -1;
+	p = (u_char *) tuple->TupleData;
+	bar->attr = *p;
+	p += 2;
+	bar->size = le32toh(*(u_int *) p);
+	return 0;
+}
+
+static int parse_config_cb(tuple_t * tuple, cistpl_config_t * config)
+{
+	u_char *p;
+
+	p = (u_char *) tuple->TupleData;
+	if ((*p != 3) || (tuple->TupleDataLen < 6))
+		return -1;
+	config->last_idx = *(++p);
+	p++;
+	config->base = le32toh(*(u_int *) p);
+	config->subtuples = tuple->TupleDataLen - 6;
+	return 0;
+}
+
+static int parse_cftable_entry_cb(tuple_t * tuple,
+				  cistpl_cftable_entry_cb_t * entry)
+{
+	u_char *p, *q, features;
+
+	p = tuple->TupleData;
+	q = p + tuple->TupleDataLen;
+	entry->index = *p & 0x3f;
+	entry->flags = 0;
+	if (*p & 0x40)
+		entry->flags |= CISTPL_CFTABLE_DEFAULT;
+
+	/* Process optional features */
+	if (++p == q)
+		return -1;
+	features = *p;
+	p++;
+
+	/* Power options */
+	if ((features & 3) > 0) {
+		p = parse_power(p, q, &entry->vcc);
+		if (p == NULL)
+			return -1;
+	} else
+		entry->vcc.present = 0;
+	if ((features & 3) > 1) {
+		p = parse_power(p, q, &entry->vpp1);
+		if (p == NULL)
+			return -1;
+	} else
+		entry->vpp1.present = 0;
+	if ((features & 3) > 2) {
+		p = parse_power(p, q, &entry->vpp2);
+		if (p == NULL)
+			return -1;
+	} else
+		entry->vpp2.present = 0;
+
+	/* I/O window options */
+	if (features & 0x08) {
+		if (p == q)
+			return -1;
+		entry->io = *p;
+		p++;
+	} else
+		entry->io = 0;
+
+	/* Interrupt options */
+	if (features & 0x10) {
+		p = parse_irq(p, q, &entry->irq);
+		if (p == NULL)
+			return -1;
+	} else
+		entry->irq.IRQInfo1 = 0;
+
+	if (features & 0x20) {
+		if (p == q)
+			return -1;
+		entry->mem = *p;
+		p++;
+	} else
+		entry->mem = 0;
+
+	/* Misc features */
+	if (features & 0x80) {
+		if (p == q)
+			return -1;
+		entry->flags |= (*p << 8);
+		if (*p & 0x80) {
+			if (++p == q)
+				return -1;
+			entry->flags |= (*p << 16);
+		}
+		while (*p & 0x80)
+			if (++p == q)
+				return -1;
+		p++;
+	}
+
+	entry->subtuples = q - p;
+
+	return 0;
+}
+
+/*====================================================================*/
+
+static int parse_device_geo(tuple_t * tuple, cistpl_device_geo_t * geo)
+{
+	u_char *p, *q;
+	int n;
+
+	p = (u_char *) tuple->TupleData;
+	q = p + tuple->TupleDataLen;
+
+	for (n = 0; n < CISTPL_MAX_DEVICES; n++) {
+		if (p > q - 6)
+			break;
+		geo->geo[n].buswidth = p[0];
+		geo->geo[n].erase_block = 1 << (p[1] - 1);
+		geo->geo[n].read_block = 1 << (p[2] - 1);
+		geo->geo[n].write_block = 1 << (p[3] - 1);
+		geo->geo[n].partition = 1 << (p[4] - 1);
+		geo->geo[n].interleave = 1 << (p[5] - 1);
+		p += 6;
+	}
+	geo->ngeo = n;
+	return 0;
+}
+
+/*====================================================================*/
+
+static int parse_vers_2(tuple_t * tuple, cistpl_vers_2_t * v2)
+{
+	u_char *p, *q;
+
+	if (tuple->TupleDataLen < 10)
+		return -1;
+
+	p = tuple->TupleData;
+	q = p + tuple->TupleDataLen;
+
+	v2->vers = p[0];
+	v2->comply = p[1];
+	v2->dindex = le16toh(*(u_short *) (p + 2));
+	v2->vspec8 = p[6];
+	v2->vspec9 = p[7];
+	v2->nhdr = p[8];
+	p += 9;
+	return parse_strings(p, q, 2, v2->str, &v2->vendor, NULL);
+}
+
+/*====================================================================*/
+
+static int parse_org(tuple_t * tuple, cistpl_org_t * org)
+{
+	u_char *p, *q;
+	int i;
+
+	p = tuple->TupleData;
+	q = p + tuple->TupleDataLen;
+	if (p == q)
+		return -1;
+	org->data_org = *p;
+	if (++p == q)
+		return -1;
+	for (i = 0; i < 30; i++) {
+		org->desc[i] = *p;
+		if (*p == '\0')
+			break;
+		if (++p == q)
+			return -1;
+	}
+	return 0;
+}
+
+/*====================================================================*/
+
+static int parse_format(tuple_t * tuple, cistpl_format_t * fmt)
+{
+	u_char *p;
+
+	if (tuple->TupleDataLen < 10)
+		return -1;
+
+	p = tuple->TupleData;
+
+	fmt->type = p[0];
+	fmt->edc = p[1];
+	fmt->offset = le32toh(*(u_int *) (p + 2));
+	fmt->length = le32toh(*(u_int *) (p + 6));
+
+	return 0;
+}
+
+/*====================================================================*/
+
+static int parse_tuple(tuple_t * tuple, cisparse_t * parse)
+{
+	int ret = 0;
+
+	if (tuple->TupleDataLen > tuple->TupleDataMax)
+		return -1;
+	switch (tuple->TupleCode) {
+	case CISTPL_DEVICE:
+	case CISTPL_DEVICE_A:
+		ret = parse_device(tuple, &parse->device);
+		break;
+	case CISTPL_BAR:
+		ret = parse_bar(tuple, &parse->bar);
+		break;
+	case CISTPL_CONFIG_CB:
+		ret = parse_config_cb(tuple, &parse->config);
+		break;
+	case CISTPL_CFTABLE_ENTRY_CB:
+		ret = parse_cftable_entry_cb(tuple, &parse->cftable_entry_cb);
+		break;
+	case CISTPL_CHECKSUM:
+		ret = parse_checksum(tuple, &parse->checksum);
+		break;
+	case CISTPL_LONGLINK_A:
+	case CISTPL_LONGLINK_C:
+		ret = parse_longlink(tuple, &parse->longlink);
+		break;
+	case CISTPL_LONGLINK_MFC:
+		ret = parse_longlink_mfc(tuple, &parse->longlink_mfc);
+		break;
+	case CISTPL_VERS_1:
+		ret = parse_vers_1(tuple, &parse->version_1);
+		break;
+	case CISTPL_ALTSTR:
+		ret = parse_altstr(tuple, &parse->altstr);
+		break;
+	case CISTPL_JEDEC_A:
+	case CISTPL_JEDEC_C:
+		ret = parse_jedec(tuple, &parse->jedec);
+		break;
+	case CISTPL_MANFID:
+		ret = parse_manfid(tuple, &parse->manfid);
+		break;
+	case CISTPL_FUNCID:
+		ret = parse_funcid(tuple, &parse->funcid);
+		break;
+	case CISTPL_FUNCE:
+		ret = parse_funce(tuple, &parse->funce);
+		break;
+	case CISTPL_CONFIG:
+		ret = parse_config(tuple, &parse->config);
+		break;
+	case CISTPL_CFTABLE_ENTRY:
+		ret = parse_cftable_entry(tuple, &parse->cftable_entry);
+		break;
+	case CISTPL_DEVICE_GEO:
+	case CISTPL_DEVICE_GEO_A:
+		ret = parse_device_geo(tuple, &parse->device_geo);
+		break;
+	case CISTPL_VERS_2:
+		ret = parse_vers_2(tuple, &parse->vers_2);
+		break;
+	case CISTPL_ORG:
+		ret = parse_org(tuple, &parse->org);
+		break;
+	case CISTPL_FORMAT:
+	case CISTPL_FORMAT_A:
+		ret = parse_format(tuple, &parse->format);
+		break;
+	case CISTPL_NO_LINK:
+	case CISTPL_LINKTARGET:
+		ret = 0;
+		break;
+	case CISTPL_END:
+		ret = 0;
+		break;
+	default:
+		ret = -1;
+		break;
+	}
+	return ret;
+}
+
+/*====================================================================*/
+
+#define MAX_SOCKS 8
+
+int main(int argc, char *argv[])
+{
+	int i, fd;
+	tuple_parse_t tuple_parse;
+	int optch, errflg, first;
+	char *infile = NULL;
+
+	errflg = 0;
+	while ((optch = getopt(argc, argv, "vi:")) != -1) {
+		switch (optch) {
+		case 'v':
+			verbose = 1;
+			break;
+		default:
+			errflg = 1;
+			break;
+		}
+	}
+	if (errflg || (optind > argc - 1)) {
+		fprintf(stderr, "usage: %s [-v] infile\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	for (i = 0; optind + i < argc; i++) {
+		infile = argv[optind + i];
+
+		nfn = cur = 0;
+		indent[0] = '\0';
+		fd = open(infile, O_RDONLY);
+		if (fd < 0) {
+			perror("open()");
+			return -1;
+		}
+
+		if (!verbose && (i > 0))
+			putchar('\n');
+
+		tuple_parse.tuple.TupleDataMax = sizeof(tuple_parse.data);
+		tuple_parse.tuple.Attributes =
+		    TUPLE_RETURN_LINK | TUPLE_RETURN_COMMON;
+		tuple_parse.tuple.DesiredTuple = RETURN_FIRST_TUPLE;
+		tuple_parse.tuple.TupleOffset = 0;
+		tuple_parse.tuple.TupleData = tuple_parse.data;
+
+		for (first = 1;; first = 0) {
+			if (get_tuple_buf(fd, &tuple_parse.tuple, first) != 0)
+				break;
+			if (verbose)
+				print_tuple(&tuple_parse);
+			if (parse_tuple(&tuple_parse.tuple, &tuple_parse.parse))
+				printf("%sparse error\n", indent);
+			else
+				print_parse(&tuple_parse);
+			if (verbose)
+				putchar('\n');
+			if (tuple_parse.tuple.TupleCode == CISTPL_END)
+				break;
+		}
+
+		if (!verbose && (nfn > 0))
+			printf("%s}\n", indent + 2);
+	}
+
+	return 0;
+}
-- 
1.7.1

