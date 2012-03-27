Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab2C0HKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 03:10:55 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31208 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133Ab2C0HKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 03:10:54 -0400
Date: Tue, 27 Mar 2012 10:10:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: drbd-user@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: array underflow in receive_SyncParam()?
Message-ID: <20120327071036.GA19008@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090207.4F7167F6.0023,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had a question about the following code:

drivers/block/drbd/drbd_receiver.c
  2808                  if (apv == 88) {
  2809                          if (data_size > SHARED_SECRET_MAX) {
  2810                                  dev_err(DEV, "verify-alg too long, "
  2811                                      "peer wants %u, accepting only %u byte\n",
  2812                                                  data_size, SHARED_SECRET_MAX);
  2813                                  return false;
  2814                          }
  2815  
  2816                          if (drbd_recv(mdev, p->verify_alg, data_size) != data_size)
  2817                                  return false;
  2818  
  2819                          /* we expect NUL terminated string */
  2820                          /* but just in case someone tries to be evil */
  2821                          D_ASSERT(p->verify_alg[data_size-1] == 0);
  2822                          p->verify_alg[data_size-1] = 0;
                                              ^^^^^^^^^
Is it possible for data_size to be zero here leading to an array
underflow?  We test for overflows, but I don't see any place where we
test for zero.

regards,
dan carpenter
