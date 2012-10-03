Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab2JCFTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 01:19:48 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:61464 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454Ab2JCFTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 01:19:46 -0400
Message-ID: <506BCAEE.3080508@gmail.com>
Date: Tue, 02 Oct 2012 22:19:42 -0700
From: Jim Hill <gjthill@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Alessandro Rubini <rubini@unipv.it>
CC: jrnieder@gmail.com, dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, 607242@bugs.debian.org
Subject: Re: [PATCH v2] psmouse: mitigate failing-mouse symptoms
References: <20120930174353.GA29129@elie.Belkin>  <4D2A3008.3000609@gmail.com> <20120930180240.GA31164@mail.gnudd.com>
In-Reply-To: <20120930180240.GA31164@mail.gnudd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2012 11:02 AM, Alessandro Rubini wrote:
>> I think this would be less controversial if the run-time default were
>> to disable the feature.
>
> Yes, that's the common sensible path

Fixed, there's no way I can test it well enough for anything more widespread.

> Then, I think it would be good to have a specific sub-structure for
> this stuff.

I don't care much either way, though I think I'm missing the point of subbing
in a memset -- only reason I can think of is efficiency which doesn't make
sense to me here.  Ask and I'll add one or both.

> I also think it would make it clearer what these are:

I did de-jargonize the names some,  "interval_start" for "base" makes it
clearer which as you say it could use.

I encountered one other person with this problem and he ran it for a long while
and was happy to have it.  I'm appending the latest version, which is a good
bit improved and what I've been running for the last year amended with the name
and default-filter changes above.

But of course I upgraded a month ago to a box with no PS/2 mouse port, so at
this point all I can do is hope someone finds it helpful.  The reorg'd code 
kinda highlights how incomplete it is, there's lots of mouse models out there.

So if it looks good or almost-good to you and there's anything else I can do,
tell me and I'll be glad to do it.

Thanks,
Jim

>From 2681957a610191cb5d7b7f65be11ea2be06df00f Mon Sep 17 00:00:00 2001
From: Jim Hill <gjthill@gmail.com>
Date: Mon, 28 Mar 2011 13:10:36 -0700
Subject: [PATCH]     Input: psmouse - further improve error handling for
 basic protocols

  Keep a failing PS/2 mouse usable until it's convenient to replace it.
  Filter incoming packets: drop invalid ones and attempt to correct for
  dropped bytes.
 
  New parameter 'filter' makes filtering and logging selectable, leave at 0
  to shut off all effects, 3 to work silently.
--
 drivers/input/mouse/psmouse-base.c | 197 +++++++++++++++++++++++++++++++++++++
 drivers/input/mouse/psmouse.h      |   7 ++
 2 files changed, 204 insertions(+)

diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mous/psmouse-base.c
index 22fe254..4a3a95f 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -72,6 +72,25 @@ static unsigned int psmouse_resync_time;
 module_param_named(resync_time, psmouse_resync_time, uint, 0644);
 MODULE_PARM_DESC(resync_time, "How long can mouse stay idle before forcing resync (in seconds, 0 = never).");

+enum {
+	DROP_BAD_PACKET = 1,
+	ATTEMPT_SYNC = 2,
+	LOG_SUMMARIES = 4,
+	LOG_MALFORMED = 8,
+	LOG_ALL	 = 16,
+	REPORT_SYNC_FAILURE = 32,
+
+	DEFAULT_FILTER = 0
+};
+static int psmouse_filter = DEFAULT_FILTER;
+module_param_named(filter, psmouse_filter, int, 0644);
+MODULE_PARM_DESC(filter, "1 = drop invalid or hotio packets"
+		", +2 = attempt-sync"
+		", +4 = summary logs"
+		", +8 = log-malformed"
+		",+16 = log-all"
+		",+32 = use hard resets");
+
 PSMOUSE_DEFINE_ATTR(protocol, S_IWUSR | S_IRUGO,
 			NULL,
 			psmouse_attr_show_protocol, psmouse_attr_set_protocol);
@@ -123,6 +142,169 @@ struct psmouse_protocol {
 };

 /*
+ * psmouse_filter_*: diagnose bad data, recover what we can, drop the rest, log
+ * selected events. See input_report_*()s in psmouse_process_byte below, and
+ * <http://www.computer-engineering.org/ps2mouse/>
+ */
+
+static int psmouse_filter_header_byte(enum psmouse_type type, int byte)
+{
+	int todo = 0;
+	if ((byte & 0xc0) &&
+			type != PSMOUSE_THINKPS &&
+			type != PSMOUSE_GENPS)
+		todo |= DROP_BAD_PACKET+ATTEMPT_SYNC;
+	if ((byte & 0x08) == 0 &&
+			type != PSMOUSE_THINKPS &&
+			type != PSMOUSE_CORTRON)
+		todo |= DROP_BAD_PACKET+ATTEMPT_SYNC;
+	return todo;
+}
+
+static int psmouse_filter_wheel_byte(enum psmouse_type type, int byte)
+{
+	int todo = 0;
+	if (type == PSMOUSE_IMPS || type == PSMOUSE_GENPS)
+		if (abs(byte) > 3)
+			todo = DROP_BAD_PACKET+ATTEMPT_SYNC;
+	if (type == PSMOUSE_IMEX)
+		if (((byte&0xC0) == 0) || ((byte&0XC0) == 0xC0))
+			if (abs((byte&0x08)-(byte&0x07)) > 3)
+				todo = DROP_BAD_PACKET+ATTEMPT_SYNC;
+	return todo;
+}
+
+static int psmouse_filter_motion(struct psmouse *m)
+{	/*
+	 * Hunt for implausible accelerations here if it ever seems necessary.
+	 * Header/wheel sniffing seems to detect everything recoverable so far.
+	 */
+	return 0;
+}
+
+static int psmouse_filter_hotio(struct psmouse *m)
+{
+	int ret = 0;
+	if (time_after(m->last, m->hotio_interval_start + HZ/m->rate)) {
+		m->hotio_interval_pkts = 0;
+		m->hotio_interval_start = m->last;
+	}
+	if (m->hotio_interval_pkts++ > m->rate/HZ + 1) {
+		if (m->hotio_log_counter == 0)
+			m->hotio_log_interval_start = m->last;
+		++m->hotio_log_counter;
+		ret = DROP_BAD_PACKET;
+	}
+	return ret;
+}
+
+static void psmouse_filter_packet_logger(struct psmouse *m, int todo,
+		const char *tag)
+{
+	if ((todo & psmouse_filter & LOG_MALFORMED) ||
+			(psmouse_filter & LOG_ALL)) {
+		unsigned long long packet = 0;
+		int p;
+		for (p = 0; p < m->pktcnt; ++p)
+			packet = packet<<8 | m->packet[p];
+		printk(KERN_INFO "psmouse.c: packet %0*llx%s\n", p*2, packet,
+			tag ? tag : "");
+	}
+}
+
+static int psmouse_filter_inspect_packet(struct psmouse *m)
+{
+	int todo = 0;
+	todo |= psmouse_filter_header_byte(m->type, m->packet[0]);
+	todo |= psmouse_filter_motion(m);
+	todo |= psmouse_filter_wheel_byte(m->type, (signed char)m->packet[3]);
+	if (todo & DROP_BAD_PACKET) {
+		todo |= LOG_MALFORMED;
+		if (m->err_log_counter == 0)
+			m->err_log_interval_start = m->last;
+		++m->err_log_counter;
+	}
+	return todo;
+}
+
+/*
+ * find-sync: if the mouse dropped one or more bytes the next packet start
+ * byte's almost certainly in this buffer. Return its offset if we can find it.
+ */
+static unsigned psmouse_filter_find_sync(struct psmouse *m)
+{
+	int p;
+
+	/* same buttons, same general direction as last report? Seems best */
+	for (p = m->pktcnt; --p ; )
+		if (m->packet[p] == m->last_good_packet[0])
+			return p;
+
+	/* same or no buttons, plausible direction from what we can see? */
+	for (p = m->pktcnt; --p ; ) {
+		signed char test0 = (signed char)m->packet[p];
+		signed char last0 = (signed char)m->last_good_packet[0];
+		signed char test1 = (signed char)m->packet[(p+1)%m->pktcnt];
+		signed char test2 = (signed char)m->packet[(p+2)%m->pktcnt];
+		if (((test0&7) == 0 || (test0&7) == (last0&7)) &&
+				(test0>>4&1) == (test1>>7&1) &&
+				(test0>>5&1) == (test2>>7&1) &&
+				!psmouse_filter_header_byte(m->type, test0))
+			return p;
+	}
+	/* nothing looks good */
+	return 0;
+}
+
+static void psmouse_filter_write_summary_logs(struct psmouse *m)
+{
+	if (m->err_log_counter && time_after(m->last, m->err_log_interval_start+HZ)) {
+		printk(KERN_WARNING "psmouse.c: %s at %s %lu bad packets\n",
+				m->name, m->phys, m->err_log_counter);
+		m->err_log_counter = m->err_log_interval_start = 0;
+	}
+	if (m->hotio_log_counter && time_after(m->last, m->hotio_log_interval_start+HZ)) {
+		printk(KERN_WARNING "psmouse.c: %s at %s %lu excess packets\n",
+				m->name, m->phys, m->hotio_log_counter);
+		m->hotio_log_counter = m->hotio_log_interval_start = 0;
+	}
+}
+
+static int psmouse_filter_packet(struct psmouse *m)
+{
+	int todo;
+
+	if (psmouse_filter < 0)
+		psmouse_filter = DEFAULT_FILTER;
+
+	todo = psmouse_filter_inspect_packet(m);
+
+	if (!(todo & DROP_BAD_PACKET))
+		todo |= psmouse_filter_hotio(m);
+
+	psmouse_filter_packet_logger(m, todo, todo&LOG_MALFORMED ? " bad" : 0);
+	if (psmouse_filter & (LOG_SUMMARIES | LOG_ALL))
+		psmouse_filter_write_summary_logs(m);
+
+	if (todo & psmouse_filter & ATTEMPT_SYNC) {
+		unsigned p = psmouse_filter_find_sync(m);
+		if (p) {
+			m->pktcnt -= p;
+			memmove(m->packet, m->packet+p, m->pktcnt);
+			psmouse_filter_packet_logger(m, todo, " sync");
+		} else {
+			todo |= REPORT_SYNC_FAILURE;
+			todo &= ~ATTEMPT_SYNC;
+		}
+	}
+
+	if (!(todo & DROP_BAD_PACKET))
+		memcpy(m->last_good_packet, m->packet, sizeof m->packet);
+
+	return todo & psmouse_filter;
+}
+
+/*
  * psmouse_process_byte() analyzes the PS/2 data stream and reports
  * relevant events to the input module once full packet has arrived.
  */
@@ -135,6 +317,15 @@ psmouse_ret_t psmouse_process_byte(struct psmouse *psmouse)
 	if (psmouse->pktcnt < psmouse->pktsize)
 		return PSMOUSE_GOOD_DATA;

+	{
+		int filter = psmouse_filter_packet(psmouse);
+		if (filter & ATTEMPT_SYNC)
+			return PSMOUSE_GOOD_DATA;
+		if (filter & REPORT_SYNC_FAILURE)
+			return PSMOUSE_BAD_DATA;
+		if (filter & DROP_BAD_PACKET)
+			return PSMOUSE_FULL_PACKET;
+	}
 /*
  * Full packet accumulated, process it
  */
@@ -226,6 +417,12 @@ static inline void __psmouse_set_state(struct psmouse *psmouse, enum psmouse_sta
 	psmouse->pktcnt = psmouse->out_of_sync_cnt = 0;
 	psmouse->ps2dev.flags = 0;
 	psmouse->last = jiffies;
+	psmouse->err_log_interval_start = 0;
+	psmouse->err_log_counter = 0;
+	psmouse->hotio_interval_start = 0;
+	psmouse->hotio_interval_pkts = 0;
+	psmouse->hotio_log_interval_start = 0;
+	psmouse->hotio_log_counter = 0;
 }


diff --git a/drivers/input/mouse/psmouse.h b/drivers/input/mouse/psmouse.h
index fe1df23..7d8817e7 100644
--- a/drivers/input/mouse/psmouse.h
+++ b/drivers/input/mouse/psmouse.h
@@ -44,6 +44,7 @@ struct psmouse {
 	char *vendor;
 	char *name;
 	unsigned char packet[8];
+	unsigned char last_good_packet[8];
 	unsigned char badbyte;
 	unsigned char pktcnt;
 	unsigned char pktsize;
@@ -54,6 +55,12 @@ struct psmouse {
 	unsigned long last;
 	unsigned long out_of_sync_cnt;
 	unsigned long num_resyncs;
+	unsigned long hotio_interval_start;
+	unsigned long hotio_interval_pkts;
+	unsigned long hotio_log_interval_start;
+	unsigned long hotio_log_counter;
+	unsigned long err_log_interval_start;
+	unsigned long err_log_counter;
 	enum psmouse_state state;
 	char devname[64];
 	char phys[32];
-- 
1.7.11.rc2.220.g2b5a256

