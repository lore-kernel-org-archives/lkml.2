Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab2DUTfI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 15:35:08 -0400
Received: from plane.gmane.org ([80.91.229.3]:44268 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089Ab2DUTfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 15:35:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Adrian Yanes <devel@ayanes.com>
Subject: Re: [PATCH] i2c-at91: fix data-loss issue
Date: Sat, 21 Apr 2012 22:33:11 +0300
Message-ID: <4F930B77.8070909@ayanes.com>
References: <20120413103937.GH7154@arwen.pp.htv.fi> <1334317476-10044-1-git-send-email-h.feurstein@gmail.com> <EF2E73589CA71846A15D0B2CDF79505D0905D5A1AA@wm021.weinmann.com> <20120418143920.GA19802@pengutronix.de>
Reply-To: devel@ayanes.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: duw0.kyla.fi
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.5; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
In-Reply-To: <20120418143920.GA19802@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

we performed some measurements with the new version of the patch (v10),
in order to verify that the twi clock was performing better with the new
ternary operator introduced for the calculation of CLDIV & CHDIV.

However, we noticed we were using the wrongs resistors in our setup,
changing them to the correct ones, the driver gives us a frequency rate
of ~396kHz when we tweak the TWI_CLK_HZ to 400000. Using the previous
version the driver (without the specific offset for the AT91RM9200) it
gives a frequency rate of ~392kHz. Therefore, both rates are inside of
the error margin that the oscilloscope can give, so we suggest to keep
the latest code introduced for it, mostly because it behaves as the
datasheet claims.

On the other hand we found that the Underrun Error (UNRE) is not handled
in the driver. When we send data up > 2-4 bytes (quite random to say
when it really fails) and we add some dev_dbg() to print
dev->transfer_status we get 141 (==UNRE). According with the datasheet,
after the first UNRE received "this action automatically generated a
STOP bit in Master Mode. Reset by read in TWI_SR when TXCOMP is set."

We thought that one possibility for this was that the board was too slow
to process the requests or that other interrupts were interfering.
Disabling the interrupts inside of the twi interrupt handler did not
help either.

The datasheet does not mention any method to implement some mechanism to
avoid the UNRE telling the hardware to wait a bit longer for the next
byte. Thus, one way will be to restart the transfer with the remaining
bytes (maybe only applicable to at91rm9200) or just to return some
error/message to userland informing that could not send all the data.

Adrian

