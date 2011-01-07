Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab1AGIGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 03:06:53 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:60157 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab1AGIGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 03:06:51 -0500
Message-id: <4D26C98F.9060000@gmail.com>
Date: Fri, 07 Jan 2011 00:06:39 -0800
From: Jim Hill <gjthill@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16)
 Gecko/20101226 Icedove/3.0.11
MIME-version: 1.0
To: Alessandro Rubini <rubini@cvml.unipv.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] psmouse: mitigate failing-mouse symptoms
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the worst symptoms of a failing mouse go away. Drop packets that fail
basic sniff tests and packets reported at excessive rates. Drop packets
reporting unrepresentable speeds. Attempt to recover synchronization in case of
a dropped input byte. Log summaries of actions taken. Allow logging of rejected
or all packets.

The solution to failing hardware is to replace the hardware, but is it better
to have to do it on the hardware's schedule not mine?

All behaviors optional, all but the last default, all controlled by
bitflags in /sys. It's a straight filter on incoming completed packets,
see the code for dropout recovery which works well for the mouse that
got me to do this. To effectively disable the patch write 0 to
/sys/module/psmouse/parameters/filter.

My mouse failed while in XP, but I didn't know it - it seemed it'd need
cleaning soon. On booting into Linux, it was dangerous. The difference
was consistent, making it seem the problem wasn't the mouse.

Tested on AMD64, full coverage - syslog is a good argument for
replacing this mouse soon. No one else has tried this yet.

Signed-off-by: Jim Hill <gjthill@gmail.com>

---

Hi, this is my first patch, I hope I got the procedures right, apologies in
advance if I goofed something.

Happy New Year and all,
Jim
---
 drivers/input/mouse/psmouse-base.c |  122 ++++++++++++++++++++++++++++++++++++
 drivers/input/mouse/psmouse.h      |    8 +++
 2 files changed, 130 insertions(+), 0 deletions(-)

diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index cd9d0c9..3664c68 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -69,6 +69,22 @@ static unsigned int psmouse_resync_time;
 module_param_named(resync_time, psmouse_resync_time, uint, 0644);
 MODULE_PARM_DESC(resync_time, "How long can mouse stay idle before forcing resync (in seconds, 0 = never).");
 
+enum {
+	DROP_BAD = 1,
+	SUMMARIZE_ERRORS = 2,
+	LOG_REJECTS = 4,
+	LOG_ALL	 = 8,
+	ATTEMPT_RECOVERY = 16,
+	DROP_CLAMPED = 32,
+	DROP_PACKET = DROP_CLAMPED | DROP_BAD
+};
+static unsigned int psmouse_filter = DROP_BAD | SUMMARIZE_ERRORS |
+						ATTEMPT_RECOVERY | DROP_CLAMPED;
+module_param_named(filter, psmouse_filter, uint, 0644);
+MODULE_PARM_DESC(filter, "1 = drop invalid or hotio packets, +2=summary-log, "
+		"+4=log-rejected, +8=log-all, +16=attempt-recovery, "
+		"+32=drop-clamped.");
+
 PSMOUSE_DEFINE_ATTR(protocol, S_IWUSR | S_IRUGO,
 			NULL,
 			psmouse_attr_show_protocol, psmouse_attr_set_protocol);
@@ -119,6 +135,99 @@ struct psmouse_protocol {
 	int (*init)(struct psmouse *);
 };
 
+static int psmouse_filter_packet(struct psmouse *m)
+{
+	int todo = 0;
+
+	int xoflow = m->packet[0]>>6 & 1;
+	int yoflow = m->packet[0]>>7 & 1;
+
+	if ((m->packet[0] & 0x08) != 0x08)
+		todo |= DROP_BAD + ATTEMPT_RECOVERY;
+	else if ((xoflow | yoflow) && psmouse_filter & DROP_CLAMPED)
+		todo |= DROP_CLAMPED;
+
+	if (todo & DROP_PACKET) {
+		todo |= LOG_REJECTS;
+		if (m->err_log_counter == 0)
+			m->err_log_base = m->last;
+		++m->err_log_counter;
+	}
+
+	if (time_after(m->last, m->interval_base + HZ/m->rate)) {
+		m->interval_pkts = 0;
+		m->interval_base = m->last;
+	}
+	if (m->interval_pkts > m->rate/HZ + 1) {
+		if (m->hotio_log_counter == 0)
+			m->hotio_log_base = m->last;
+		++m->hotio_log_counter;
+		todo |= DROP_BAD;
+	}
+	++m->interval_pkts;
+
+	if ((todo & psmouse_filter & LOG_REJECTS) |
+			(psmouse_filter & LOG_ALL)) {
+		unsigned long long packet = 0;
+		int p;
+		for (p = 0; p < m->pktcnt; ++p)
+			packet = packet<<8 | m->packet[p];
+		printk(KERN_INFO "psmouse.c: packet %0*llx%s\n", p*2, packet,
+				todo & DROP_BAD ? " rejected" : "");
+	}
+
+	if (m->err_log_counter && time_after(m->last, m->err_log_base + HZ) &&
+			psmouse_filter & (SUMMARIZE_ERRORS | LOG_ALL)) {
+		if (m->err_log_counter && psmouse_filter &
+				(SUMMARIZE_ERRORS | LOG_ALL)) {
+			printk(KERN_WARNING "psmouse.c: %s at %s "
+					"%lu rejected packets%s\n",
+					m->name, m->phys, m->err_log_counter,
+					psmouse_filter & ATTEMPT_RECOVERY ?
+						" recovery attempted" :
+					psmouse_filter & DROP_BAD ?
+						" ignored" :
+						"");
+		}
+		m->err_log_counter = 0;
+		m->err_log_base = 0;
+	}
+
+	if (m->hotio_log_counter && time_after(m->last, m->hotio_log_base + HZ)
+			&& psmouse_filter & (SUMMARIZE_ERRORS | LOG_ALL)) {
+		printk(KERN_WARNING "psmouse.c: %s at %s "
+				"%lu excess packets%s\n",
+				m->name, m->phys, m->hotio_log_counter,
+				psmouse_filter & DROP_BAD ?
+					" ignored" : "");
+		m->hotio_log_counter = 0;
+		m->hotio_log_base = 0;
+	}
+
+	/*
+	 * Take a flyer on recovery, works ok on dropped bytes. Work backwards
+	 * from end looking for a byte that could be a valid start-byte with
+	 * the same buttons down as the last valid packet.
+	 */
+	if (todo & psmouse_filter & ATTEMPT_RECOVERY) {
+		int p = m->pktcnt;
+		while (--p) {
+			if ((m->packet[p] & 0xcf) == m->last_mbstate) {
+				m->pktcnt -= p;
+				memmove(m->packet, m->packet+p, m->pktcnt);
+				return todo; /* <-- */
+			}
+		}
+		todo &= ~ATTEMPT_RECOVERY;
+	}
+
+	if (todo & psmouse_filter & DROP_PACKET)
+		return todo & psmouse_filter;
+	if (!(todo & DROP_PACKET))
+		m->last_mbstate = m->packet[0] & 0x0f;
+	return 0;
+}
+
 /*
  * psmouse_process_byte() analyzes the PS/2 data stream and reports
  * relevant events to the input module once full packet has arrived.
@@ -135,6 +244,13 @@ static psmouse_ret_t psmouse_process_byte(struct psmouse *psmouse)
 /*
  * Full packet accumulated, process it
  */
+	{
+		int check = psmouse_filter_packet(psmouse);
+		if (check & ATTEMPT_RECOVERY)
+			return PSMOUSE_GOOD_DATA;
+		if (check & DROP_PACKET)
+			return PSMOUSE_FULL_PACKET;
+	}
 
 /*
  * Scroll wheel on IntelliMice, scroll buttons on NetMice
@@ -223,6 +339,12 @@ static inline void __psmouse_set_state(struct psmouse *psmouse, enum psmouse_sta
 	psmouse->pktcnt = psmouse->out_of_sync_cnt = 0;
 	psmouse->ps2dev.flags = 0;
 	psmouse->last = jiffies;
+	psmouse->err_log_base = 0;
+	psmouse->interval_base = 0;
+	psmouse->hotio_log_base = 0;
+	psmouse->err_log_counter = 0;
+	psmouse->interval_pkts = 0;
+	psmouse->hotio_log_counter = 0;
 }
 
 
diff --git a/drivers/input/mouse/psmouse.h b/drivers/input/mouse/psmouse.h
index 593e910..9d90417 100644
--- a/drivers/input/mouse/psmouse.h
+++ b/drivers/input/mouse/psmouse.h
@@ -47,12 +47,19 @@ struct psmouse {
 	unsigned char pktcnt;
 	unsigned char pktsize;
 	unsigned char type;
+	unsigned char last_mbstate;
 	bool ignore_parity;
 	bool acks_disable_command;
 	unsigned int model;
 	unsigned long last;
 	unsigned long out_of_sync_cnt;
 	unsigned long num_resyncs;
+	unsigned long interval_base;
+	unsigned long interval_pkts;
+	unsigned long hotio_log_base;
+	unsigned long hotio_log_counter;
+	unsigned long err_log_base;
+	unsigned long err_log_counter;
 	enum psmouse_state state;
 	char devname[64];
 	char phys[32];
@@ -61,6 +68,7 @@ struct psmouse {
 	unsigned int resolution;
 	unsigned int resetafter;
 	unsigned int resync_time;
+
 	bool smartscroll;	/* Logitech only */
 
 	psmouse_ret_t (*protocol_handler)(struct psmouse *psmouse);
-- 
1.7.2.3

