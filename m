Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab1G2JPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 05:15:00 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16481 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925Ab1G2JO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 05:14:59 -0400
Date: Fri, 29 Jul 2011 11:14:57 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Dan Carpenter <error27@gmail.com>
cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Jarod Wilson <jarod@redhat.com>,
        Jerome Brock <jbrock@users.sourceforge.net>,
        Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Gerd Knorr <kraxel@goldbach.in-berlin.de>,
        Jarod Wilson <jarod@wilsonet.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Thomas Reitmayr <treitmayr@yahoo.com>,
        Michal Kochanowicz <mkochano@pld.org.pl>,
        Christoph Bartelmus <lirc@bartelmus.de>, Mark Weaver <mark@npsl.co.uk>,
        Ulrich Mueller <ulrich.mueller42@web.de>,
        Stefan Jahn <stefan@lkcc.org>
Subject: Re: [PATCH] staging; lirc, zilog: put_ir_rx may free 'rx' which can
 lead to double free
In-Reply-To: <20110729060822.GF3752@shale.localdomain>
Message-ID: <alpine.LNX.2.00.1107291112470.22532@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107282345540.20477@swampdragon.chaosbits.net> <20110729060822.GF3752@shale.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jul 2011, Dan Carpenter wrote:

> On Thu, Jul 28, 2011 at 11:49:51PM +0200, Jesper Juhl wrote:
> > If calling put_ir_rx(rx, true); in
> > drivers/staging/lirc/lirc_zilog.c::ir_probe() returns true (1) then it
> > means that it has freed it's first argument. Subsequently jumping to
> > 'out_put_xx' will cause us to call put_ir_rx() once more since 'rx' is
> > not zero - leading to a double free.
> 
> It would be better to just remove the first call to put_ir_rx().
> 

Taking a second look... Yes, you are right, that would be just fine and a 
lot simpler. Thanks for reviewing.

Here's an updated patch.


From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] staging; lirc, zilog: put_ir_rx may free 'rx' which can lead to double free

If the call to put_ir_rx(rx, true); in
drivers/staging/lirc/lirc_zilog.c::ir_probe() returns true (1) then it
means that it has freed it's first argument. Subsequently jumping to
'out_put_xx' will cause us to call put_ir_rx() once more since 'rx' is
not zero - leading to a double free.
To fix this, simply remove the first call to put_ir_rx().

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/lirc/lirc_zilog.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
index 0302d82..6be6f67 100644
--- a/drivers/staging/lirc/lirc_zilog.c
+++ b/drivers/staging/lirc/lirc_zilog.c
@@ -1577,7 +1577,6 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 			put_ir_device(ir, true);
 			/* Failure exit, so put back rx ref from i2c_client */
 			i2c_set_clientdata(client, NULL);
-			put_ir_rx(rx, true);
 			ir->l.features &= ~LIRC_CAN_REC_LIRCCODE;
 			goto out_put_xx;
 		}
-- 
1.7.6

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

