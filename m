Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab2GaS2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 14:28:18 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40091 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab2GaS2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 14:28:16 -0400
MIME-Version: 1.0
Date: Tue, 31 Jul 2012 22:28:14 +0400
Message-ID: <CADKZ3FKDw78ac9JPXJuw0s7Mqg1RrVfonbjXZ6zHmtwF2i5HoQ@mail.gmail.com>
Subject: wlcore: might_sleep operation in interrupt handler
From: Denis Yefremov <yefremov.denis@gmail.com>
To: Luciano Coelho <coelho@ti.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Eliad Peller <eliad@wizery.com>, Arik Nemtsov <arik@wizery.com>,
        Eyal Shapira <eyal@wizery.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interrupt handler wlcore_irq in wlcore/main.c file
invokes mutex_lock that is might sleep operation.

Found by Linux Driver Verification project (linuxtesting.org)
within my participation in the GSoC 2012 program.

drivers/net/wireless/ti/wlcore/main.c

static irqreturn_t wlcore_irq(int irq, void *cookie)
{
        int ret;
        unsigned long flags;
        struct wl1271 *wl = cookie;

        /* TX might be handled here, avoid redundant work */
        set_bit(WL1271_FLAG_TX_PENDING, &wl->flags);
        cancel_work_sync(&wl->tx_work);

        mutex_lock(&wl->mutex);
...
}

int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
{
...
        ret = request_threaded_irq(wl->irq, wl12xx_hardirq, wlcore_irq,
                                   irqflags,
                                   pdev->name, wl);
...
}
