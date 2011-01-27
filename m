Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab1A0IzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 03:55:24 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60133 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1A0IzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 03:55:23 -0500
Date: Thu, 27 Jan 2011 08:54:38 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Colin Cross <ccross@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-sh <linux-sh@vger.kernel.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Richard Zhao <linuxzsc@gmail.com>
Subject: Re: Locking in the clk API
Message-ID: <20110127085438.GA25239@n2100.arm.linux.org.uk>
References: <201101111016.42819.jeremy.kerr@canonical.com> <20110111091607.GI12552@n2100.arm.linux.org.uk> <201101111744.59712.jeremy.kerr@canonical.com> <20110111103929.GN24920@pengutronix.de> <AANLkTinHL9X_bqMPR=W8Va01O4xngUnpGCkCiE3xEdiQ@mail.gmail.com> <4D386ABF.9060908@fluff.org> <20110120190822.GK6335@n2100.arm.linux.org.uk> <4D3932B4.8010904@codeaurora.org> <20110121094042.GD13235@n2100.arm.linux.org.uk> <4D40F5CC.6080809@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D40F5CC.6080809@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 08:34:20PM -0800, Saravana Kannan wrote:
> I'm not too familiar with serial/tty, does anyone know if the  
> .set_termios needs to be atmoic? If not, we could just change  
> cpm_uart/cpm_uart_core.c to use mutex instead of spinlock.

The locking is there to protect against the interrupt handler accessing
the port->* stuff (which seems to have been forgotten by the cpm driver).

I don't see any reason why clk_set_rate() needs to be under the spinlock
there - we need the reprogramming of the baud rate within the spinlock
on 8250 because of DLAB bit hiding the data registers.  It's also a good
idea that it _is_ within the spinlock along with uart_update_timeout()
to ensure timeouts and the baud rate are updated together.
