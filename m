Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab1A0VM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 16:12:26 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48818 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab1A0VMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 16:12:25 -0500
Date: Thu, 27 Jan 2011 21:11:51 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-sh <linux-sh@vger.kernel.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@google.com>, Ben Dooks <ben-linux@fluff.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Richard Zhao <linuxzsc@gmail.com>
Subject: Re: Locking in the clk API
Message-ID: <20110127211151.GC1597@n2100.arm.linux.org.uk>
References: <AANLkTinHL9X_bqMPR=W8Va01O4xngUnpGCkCiE3xEdiQ@mail.gmail.com> <4D386ABF.9060908@fluff.org> <20110120190822.GK6335@n2100.arm.linux.org.uk> <4D3932B4.8010904@codeaurora.org> <20110121094042.GD13235@n2100.arm.linux.org.uk> <4D40F5CC.6080809@codeaurora.org> <20110127085438.GA25239@n2100.arm.linux.org.uk> <4D41D5EC.6030405@codeaurora.org> <20110127204354.GB1597@n2100.arm.linux.org.uk> <20110127210729.79eef2c1@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110127210729.79eef2c1@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 09:07:29PM +0000, Alan Cox wrote:
> > > For internal tree purposes, does .set_termios need to be atomic? Can it  
> > > grab mutexes instead of spinlock?
> > 
> > I think I already answered that question above where I said "protect
> > against the interrupt handler accessing the port->* stuff".
> 
> I'm not sure you answered it correctly however as the locking nowdays is
> a bit different.
> 
> Architecturally the termios handling doesn't need a spin lock nor is it
> called under one. In fact it's vital this is the case because of USB.

It needs to protect against the read_status_mask and ignore_status_mask
being read half-way through an update by the interrupt handler, otherwise
you can end up with god-knows-what coming through from each termios
change.

Eg, you could see an effective CREAD flip when the state of CREAD wasn't
actually changed.
