Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab2JIMau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:30:50 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:24610 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab2JIMas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:30:48 -0400
Date: Tue, 9 Oct 2012 14:30:35 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Michael Krufky <mkrufky@linuxtv.org>, kernel-janitors@vger.kernel.org,
        rmallon@gmail.com, shubhrajyoti@ti.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/13] drivers/media/tuners/mxl5007t.c: use macros for
 i2c_msg initialization
Message-ID: <20121009143035.557951bb@endymion.delvare>
In-Reply-To: <1349624323-15584-4-git-send-email-Julia.Lawall@lip6.fr>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
	<1349624323-15584-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

On Sun,  7 Oct 2012 17:38:33 +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Introduce use of I2c_MSG_READ/WRITE/OP, for readability.

Next time you send this patch set, please Cc me on every post so that I
don't have to hunt for them on lkml.org.

> In each case, a length expressed as an explicit constant is also
> re-expressed as the size of the buffer, when this is possible.

This is conceptually wrong, please don't do that. It is perfectly valid
to use a buffer which is larger than the message being written or read.
When exchanging multiple messages, it is actually quite common to
declare only 2 buffers and reuse them:

	char reg;
	char val[2];

	struct i2c_msg msg[2] = {
		{ .addr = addr, .flags = 0, .buf = &reg, .len = 1 },
		{ .addr = addr, .flags = I2C_M_RD, .buf = val, .len = 1 },
	};

	reg = 0x04;
	i2c_transfer(i2c_adap, msg, 2);
	/* Do stuff with val */

	reg = 0x06;
	msg[1].len = 2;
	i2c_transfer(i2c_adap, msg, 2);
	/* Do stuff with val */

Your conversion would read 2 bytes from register 0x04 instead of 1 in
the example above.

I am not opposed to the idea of i2c_msg initialization helper macros,
but please don't mix that with actual code changes which could have bad
side effects.

Thanks,
-- 
Jean Delvare
