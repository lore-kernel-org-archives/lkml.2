Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab1AIWAq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:00:46 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:57066 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1AIWAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:00:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=JvRwIJIrI6BY28VDiJlDlNppUlrmUNicgQ/Lill1/SuEseoF403f+/Ctcbvl8rOb3V
         AyoCw/GcI9tzMZQNR02aV/eRRVnW2CeXc/f4z08cK0ySPHd9/XUMJ5Efcbv2zx8iC+6K
         vI1hEDdSCKMA6G88B2SaEx6378QHVayAZjAE8=
Message-ID: <4D2A3008.3000609@gmail.com>
Date: Sun, 09 Jan 2011 14:00:40 -0800
From: Jim Hill <gjthill@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Alessandro Rubini <rubini@cvml.unipv.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        607242@bugs.debian.org
Subject: [PATCH v2] psmouse: mitigate failing-mouse symptoms
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep a failing PS/2 mouse usable until it's convenient to replace it.
Filter incoming packets: drop invalid ones and attempt to correct for
dropped bytes.

New parameter 'filter' makes filtering and logging selectable, set to 0
to shut off all effects.

Tested on AMD64, full coverage. No one else has tried this yet.

Signed-off-by: Jim Hill <gjthill@gmail.com>

---

This is a second version, choosier about accepting apparently-valid
start bytes, no redundant test and more concise syslog and changelog
text.

This is my first patch, I hope I got the procedures right, apologies in
advance if I goofed something.

My mouse failed while in XP, but I didn't know it - it seemed it'd need
cleaning soon. On booting into Linux, it was dangerous, wild slews and
random clicks.  The difference was consistent, making it seem the
problem wasn't the mouse.

Jim
---
 drivers/input/mouse/psmouse-base.c |  108 ++++++++++++++++++++++++++++++++++++
 drivers/input/mouse/psmouse.h      |    7 ++
 2 files changed, 115 insertions(+), 0 deletions(-)

diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index cd9d0c9..f7421ea 100644
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
@@ -119,6 +135,85 @@ struct psmouse_protocol {
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
+				todo & DROP_PACKET ? " bad" : "");
+	}
+
+	if (m->err_log_counter && time_after(m->last, m->err_log_base + HZ) &&
+		psmouse_filter & (SUMMARIZE_ERRORS | LOG_ALL)) {
+		printk(KERN_WARNING "psmouse.c: %s at %s %lu bad packets\n",
+				m->name, m->phys, m->err_log_counter);
+		m->err_log_counter = m->err_log_base = 0;
+	}
+
+	if (m->hotio_log_counter && time_after(m->last, m->hotio_log_base + HZ)
+			&& psmouse_filter & (SUMMARIZE_ERRORS | LOG_ALL)) {
+		printk(KERN_WARNING "psmouse.c: %s at %s %lu excess packets\n",
+				m->name, m->phys, m->hotio_log_counter);
+		m->hotio_log_counter = m->hotio_log_base = 0;
+	}
+
+	/*
+	 * Take a flyer on recovery, works ok on dropped bytes. Work backwards
+	 * from end looking for a byte that could be a valid start-byte with
+	 * the same buttons down and general direction as the last good packet.
+	 */
+	if (todo & psmouse_filter & ATTEMPT_RECOVERY) {
+		int p = m->pktcnt;
+		while (--p) {
+			if (m->packet[p] == m->last_mbstate) {
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
+		m->last_mbstate = m->packet[0] & 0x3f;
+	return 0;
+}
+
 /*
  * psmouse_process_byte() analyzes the PS/2 data stream and reports
  * relevant events to the input module once full packet has arrived.
@@ -135,6 +230,13 @@ static psmouse_ret_t psmouse_process_byte(struct psmouse *psmouse)
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
@@ -223,6 +325,12 @@ static inline void __psmouse_set_state(struct psmouse *psmouse, enum psmouse_sta
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
index 593e910..fc4a939 100644
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
-- 
1.7.2.3

