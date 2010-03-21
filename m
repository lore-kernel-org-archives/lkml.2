Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab0CUVRw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 17:17:52 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50387 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443Ab0CUVRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 17:17:50 -0400
Date: Sun, 21 Mar 2010 22:17:47 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: "Digi International, Inc" <Eng.Linux@digi.com>, Eng.Linux@digi.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/char/epca.c: eliminate unnecessary NULL test
Message-ID: <Pine.LNX.4.64.1003212217300.12371@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Since chan0 must be a valid pointer at this point, it seems very unlikely
that ch could be NULL.  If ch could be NULL, without channel >=
bd->numports, then something else has to be done to avoid the NULL pointer
dereference in the subsequent initialization of bc.

The semantic match that finds the problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E, E1;
identifier f;
statement S1,S3;
iterator iter;
@@

if ((E == NULL && ...) || ...)
{
  ... when != false ((E == NULL && ...) || ...)
      when != true  ((E != NULL && ...) || ...)
      when != iter(E,...) S1
      when != E = E1
(
  sizeof(E->f)
|
* E->f
)
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/char/epca.c                 |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/char/epca.c b/drivers/char/epca.c
index 17b044a..ea78e6f 100644
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -1500,9 +1500,8 @@ static void doevent(int crd)
 		lstat = readb(eventbuf + 3);
 
 		ch = chan0 + channel;
-		if ((unsigned)channel >= bd->numports || !ch)  {
-			if (channel >= bd->numports)
-				ch = chan0;
+		if ((unsigned)channel >= bd->numports)  {
+			ch = chan0;
 			bc = ch->brdchan;
 			goto next;
 		}
