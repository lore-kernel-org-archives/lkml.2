Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab2LFCwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 21:52:07 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58273 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab2LFCwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 21:52:05 -0500
MIME-Version: 1.0
Date: Thu, 6 Dec 2012 10:52:03 +0800
Message-ID: <CADApbej+f9P1sgLMR8_McoCCSLDjJt_qitWdNd8X1v6PwZqsnQ@mail.gmail.com>
Subject: common clock framwork: clk_set_rate issue
From: Chao Xie <xiechao.mail@gmail.com>
To: mturquette@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, haojian.zhuang@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi
When develop the clk drivers for SOCs based on common clock framework.
I met a issue.
For example there is a uart device, it's function clock comes from a
divider, and the divider's parent is a mux. It means

MUX --> DIV --> UART

As we know that UART can work at low baudrate for a terminal, while it
can also connect to GPS module which needs a high rate. So the MUX
will provide two clock source, a low clock rate and high clock rate.

The MUX clk driver clk-mux.c does not implement a ->round_rate callbacks.
It means that when uart driver is used for a GPS and it want to change
it clock, the driver will call clk_set_rate(); clk_set_rate will loop
upward to DIV, and DIV will try to set its divider, and it need loop
upward to MUX.
In fact the current clk drivers have some issue.
MUX clk driver should provide the round_rate callback, it then can
provide a new_rate. It means that in clk_calc_subtree MUX can switch
the clock source.

So in the uart driver we can depends on the configuration passed by
device tree to initiaze the clock for different purpose. This driver
may be shared by many SOCs, so it does not care the clock framework.
