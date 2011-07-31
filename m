Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1GaMtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 08:49:19 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:48454 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829Ab1GaMtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 08:49:14 -0400
Subject: Re: [PATCH] staging; lirc, zilog: put_ir_rx may free 'rx' which can
 lead to double free
From: Andy Walls <awalls@md.metrocast.net>
To: Dan Carpenter <error27@gmail.com>, Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Jarod Wilson <jarod@redhat.com>,
        Jerome Brock <jbrock@users.sourceforge.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Gerd Knorr <kraxel@goldbach.in-berlin.de>,
        Jarod Wilson <jarod@wilsonet.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Thomas Reitmayr <treitmayr@yahoo.com>,
        Michal Kochanowicz <mkochano@pld.org.pl>,
        Christoph Bartelmus <lirc@bartelmus.de>, Mark Weaver <mark@npsl.co.uk>,
        Ulrich Mueller <ulrich.mueller42@web.de>,
        Stefan Jahn <stefan@lkcc.org>
Date: Sun, 31 Jul 2011 08:49:21 -0400
References: <alpine.LNX.2.00.1107282345540.20477@swampdragon.chaosbits.net>
	 <20110729060822.GF3752@shale.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312116562.2271.14.camel@palomino.walls.org>
Mime-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.4.6813,1.0.211,0.0.0000
 definitions=2011-07-31_02:2011-07-29,2011-07-31,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=2
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1012030000 definitions=main-1107310067
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-31 at 08:42 -0400, Andy Walls wrote:
> On Fri, 2011-07-29 at 09:08 +0300, Dan Carpenter wrote:
> > On Thu, Jul 28, 2011 at 11:49:51PM +0200, Jesper Juhl wrote:
> > > If calling put_ir_rx(rx, true); in
> > > drivers/staging/lirc/lirc_zilog.c::ir_probe() returns true (1) then it
> > > means that it has freed it's first argument. Subsequently jumping to
> > > 'out_put_xx' will cause us to call put_ir_rx() once more since 'rx' is
> > > not zero - leading to a double free.
> > 
> > It would be better to just remove the first call to put_ir_rx().
> 
> Jesper,
> 
> (Emails from you don't seem to make it to me, so I looked at your patch
> in lkml.org archive.)
> 
> Good catch!

Jesper,

Ah crud.  I take that back.

NACK on either form of the patch.

lirc_zilog is a ref counting PITA.  Look at ir_probe() again.

We grab 2 rx refs.

One at the line 

	kref_init(&rx->ref);

and another at

	/* An rx ref goes to the i2c_client */
        i2c_set_clientdata(client, get_ir_rx(ir));


On failure, we need two "put_ir_rx(rx, true)" calls.

That's why I wrote the comment to myself:

         /* Failure exit, so put back rx ref from i2c_client */
         i2c_set_clientdata(client, NULL);
         put_ir_rx(rx, true);

Regards,
Andy

