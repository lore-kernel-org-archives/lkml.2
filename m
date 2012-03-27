Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab2C0Lmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 07:42:49 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:43650 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab2C0Lmr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 07:42:47 -0400
X-Greylist: delayed 610 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Mar 2012 07:42:46 EDT
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: array underflow in receive_SyncParam()?
Date: Tue, 27 Mar 2012 13:32:35 +0200
Message-ID: <2865608.JOP40HBeUa@fat-tyre>
Organization: LINBIT
User-Agent: KMail/4.7.3 (Linux/3.0.0-16-generic; KDE/4.7.4; i686; ; )
In-Reply-To: <20120327071036.GA19008@elgon.mountain>
References: <20120327071036.GA19008@elgon.mountain>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 27. März 2012, 10:10:36 schrieb Dan Carpenter:
> I had a question about the following code:
> 
> drivers/block/drbd/drbd_receiver.c
>   2808                  if (apv == 88) {
>   2809                          if (data_size > SHARED_SECRET_MAX) {
>   2810                                  dev_err(DEV, "verify-alg too long, "
> 2811                                      "peer wants %u, accepting only %u
> byte\n", 2812                                                  data_size,
> SHARED_SECRET_MAX); 2813                                  return false;
>   2814                          }
>   2815
>   2816                          if (drbd_recv(mdev, p->verify_alg,
> data_size) != data_size) 2817                                  return
> false;
>   2818
>   2819                          /* we expect NUL terminated string */
>   2820                          /* but just in case someone tries to be evil
> */ 2821                          D_ASSERT(p->verify_alg[data_size-1] == 0);
> 2822                          p->verify_alg[data_size-1] = 0;
>                                               ^^^^^^^^^
> Is it possible for data_size to be zero here leading to an array
> underflow?  We test for overflows, but I don't see any place where we
> test for zero.
> 

Hi Dan,

You are right, we are relying on the fact that DRBD peers that
use the protocol 88 send a positive data_size (what they do).

But if we consider a modified peer, then this is a bug. Suggesting
the following patch:

diff --git a/drbd/drbd_receiver.c b/drbd/drbd_receiver.c
index 3ef6130..317d307 100644
--- a/drbd/drbd_receiver.c
+++ b/drbd/drbd_receiver.c
@@ -3086,9 +3086,9 @@ STATIC int receive_SyncParam(struct drbd_conf *mdev, 
enum drbd_packets cmd, unsi
 
        if (apv >= 88) {
                if (apv == 88) {
-                       if (data_size > SHARED_SECRET_MAX) {
-                               dev_err(DEV, "verify-alg too long, "
-                                   "peer wants %u, accepting only %u byte\n",
+                       if (data_size > SHARED_SECRET_MAX || data_size == 0) {
+                               dev_err(DEV, "verify-alg of wrong size, "
+                                       "peer wants %u, accepting only %u 
byte\n",
                                                data_size, SHARED_SECRET_MAX);
                                return false;
                        }

Best,
 Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

