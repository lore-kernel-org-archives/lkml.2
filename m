Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab2JVJSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 05:18:35 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:51162
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750815Ab2JVJSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 05:18:34 -0400
X-IronPort-AV: E=Sophos;i="4.80,628,1344204000"; 
   d="scan'208";a="159892772"
Date: Mon, 22 Oct 2012 11:18:26 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Jean Delvare <khali@linux-fr.org>
cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Mauro Carvalho Chehab <mchehab@infradead.org>, ben-linux@fluff.org,
        w.sang@pengutronix.de, linux-i2c@vger.kernel.org,
        kernel-janitors@vger.kernel.org, rmallon@gmail.com,
        shubhrajyoti@ti.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/11] introduce macros for i2c_msg initialization
In-Reply-To: <20121009173237.7c1a49e9@endymion.delvare>
Message-ID: <alpine.DEB.2.02.1210221059100.2026@hadrien>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr> <20121009173237.7c1a49e9@endymion.delvare>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been looking at this again, with the macros

#define I2C_MSG_OP(_addr, _buf, _len, _flags) \
        { .addr = _addr, .buf = _buf, .len = _len, .flags = _flags }

#define I2C_MSG_WRITE(addr, buf, len) \
        I2C_MSG_OP(addr, buf, len, 0)
#define I2C_MSG_READ(addr, buf, len) \
        I2C_MSG_OP(addr, buf, len, I2C_M_RD)
#define I2C_MSG_WRITE_OP(addr, buf, len, op) \
        I2C_MSG_OP(addr, buf, len, 0 | op)
#define I2C_MSG_READ_OP(addr, buf, len, op) \
        I2C_MSG_OP(addr, buf, len, I2C_M_RD | op)

and the tuners files as a random first example.  This time I haven't made
any adjustments for arrays of size 1.

The following file is a bit unfortunate, because a single structure is
mostly used for writing, but sometimes used for reading, in the function
tda827xa_set_params.  That is, there are explicit assignments to
msg.flags.

drivers/media/tuners/tda827x.c

Currently, this is done in 8 files across the entire kernel.  Would it be
a problem to use a READ or WRITE macro to initialize such a structure,
give that the type is going to change?  Maybe the I2C_MSG_OP macro could
be used, with an explicit flag argument?

julia
