Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab0KPNyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 08:54:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:52328 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756474Ab0KPNyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 08:54:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,206,1288594800"; 
   d="scan'208";a="574293752"
Date: Tue, 16 Nov 2010 13:34:00 +0000
From: Alan Cox <alan@linux.intel.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Mike Frysinger <vapier@gentoo.org>,
        Feng Tang <feng.tang@intel.com>, Tobias Klauser <tklauser@distanz.ch>,
        linux-kernel@vger.kernel.org, yong.y.wang@intel.com, qi.wang@intel.com,
        kok.howg.ewe@intel.com, andrew.chih.howe.khor@intel.com
Subject: Re: [PATCH v3] EG20T: Update PCH_UART driver to 2.6.36
Message-ID: <20101116133400.11020a70@linux.intel.com>
In-Reply-To: <4CE126DB.4080500@dsn.okisemi.com>
References: <4CE126DB.4080500@dsn.okisemi.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010 21:26:03 +0900
Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com> wrote:

> Hi Alan,
> 
> I have modified for your all indications.
> 
> Please check below.

+static int push_rx(struct eg20t_port *priv, const unsigned char *buf,
+		   int size)
+{
+	struct uart_port *port;
+	struct tty_struct *tty;
+	int sz, i, j;
+	int loop;
+	int pushed;
+
+	port = &priv->port;
+	tty = tty_port_tty_get(&port->state->port);
+	if (!tty) {
+		pr_debug("%s:tty is busy now", __func__);
+		return -EBUSY;
+	}
+
+	for (pushed = 0, i = 0, loop = 1; (pushed < size) && loop;
+	     pushed += sz, i++) {
+		sz = tty_insert_flip_string(tty, &buf[pushed], size - pushed);
+		for (j = 0; (j < 100000) && (sz == 0); j++) {
+			tty_flip_buffer_push(tty);
+			sz = tty_insert_flip_string(tty, &buf[pushed],
+						    size - pushed);
+		}
+	}

tty_insert_flip_string will deal with retries itself for the cases you have
here. So you shouldn't need the loop

+static int dma_push_rx(struct eg20t_port *priv, int size)
+{
+	struct tty_struct *tty;
+	int room;
+	struct uart_port *port = &priv->port;
+
+	port = &priv->port;
+	tty = tty_port_tty_get(&port->state->port);
+	if (!tty) {
+		pr_info("%s:tty is busy now", __func__);

As I said last time- this isn't an error or unusual so it shouldn't be
logged

+static void pch_dma_rx_complete(void *arg)
+{
+	struct eg20t_port *priv = arg;
+	struct uart_port *port = &priv->port;
+	struct tty_struct *tty = tty_port_tty_get(&port->state->port);
+	if (!tty) {
+		pr_info("%s:tty is busy now", __func__);

Same comment

Otherwise looks great.

Alan
