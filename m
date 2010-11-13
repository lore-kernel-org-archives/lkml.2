Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab0KMWcv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 17:32:51 -0500
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:52923 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab0KMWct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 17:32:49 -0500
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [bisected] i915 regression in post 2.6.36 kernels
Date: Sat, 13 Nov 2010 23:34:26 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1-00542-g0143832-dirty; KDE/4.5.3; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Florian Mickler <florian@mickler.org>
References: <201011100802.20332.johannes.hirte@fem.tu-ilmenau.de> <20101112192046.1c38e671@schatten.dmk.lab> <201011122108.35664.johannes.hirte@fem.tu-ilmenau.de>
In-Reply-To: <201011122108.35664.johannes.hirte@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011132334.27742.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 November 2010 21:08:34 Johannes Hirte wrote:
> On Friday 12 November 2010 19:20:46 Florian Mickler wrote:
> > On Wed, 10 Nov 2010 23:39:35 +0100
> > Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de> wrote:
> > 
> > > On Wednesday 10 November 2010 08:46:40 Chris Wilson wrote:
> > > > On Wed, 10 Nov 2010 08:02:19 +0100, Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de> wrote:
> > > > > With the latest kernel, I don't get any windows in KDE displayed. After
> > > > > starting kdm, I get the background picture and the mouse cursor but not the
> > > > > login window. I can login blindly and a ps on console shows me that the
> > > > > expected KDE processes are started but still nothing is displayed. 
> > > > > I've bisected this to:
> > > > > 
> > > > > 5c12a07e8073295ce8b57a822f811ac34e4f8420 is the first bad commit
> > > > > commit 5c12a07e8073295ce8b57a822f811ac34e4f8420
> > > > > Author: Chris Wilson <chris@chris-wilson.co.uk>
> > > > > Date:   Wed Sep 22 11:22:30 2010 +0100
> > > > > 
> > > > >     drm/i915: Drop ring->lazy_request
> > > > >     
> > > > >     We are not currently using it as intended, so remove the complication.
> > > > > 
> > > > >     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > > > 
> > > > May I ask you to recheck your bisection, since that was later reverted.
> > > > -Chris
> > > 
> > > Did so. I've started with v2.6.36 for bisect good and 
> > > f6614b7bb405a9b35dd28baea989a749492c46b2 for bisect bad (was HEAD) in this
> > > case. Again I ended in 5c12a07e8073295ce8b57a822f811ac34e4f8420 as the first
> > > bad commit. The regression was introduced there, as the commit before is fine.
> > > If it was reverted, the regression should be fixed by this. But I don't find
> > > neither the fix/revert nor the reintroduction of the regression.
> > > 
> > > regrards,
> > >   Johannes
> > 
> > The revert is a56ba56c275b1c2b982c8901ab92bf5a0fd0b757 .
> 
> Thanks for the hint. This was the commit I was searching for. Unfortunately
> this version shows the same regression. I've checked again, that
> 5c12a07e8073295ce8b57a822f811ac34e4f8420 is the first bad version.
> 2.6.36-rc5-00228-g2896b53 (2896b5397570f6857fd5d0e0533f640b05b1d162) works
> 2.6.36-rc5-00229-g5c12a07 (5c12a07e8073295ce8b57a822f811ac34e4f8420) doesn't.
> Someone with knowledge of the code should have a look what's different
> between 5c12a07e8073295ce8b57a822f811ac34e4f8420 and its revert.
> 
> regards,
>   Johannes

I've found it. 5c12a07e8073295ce8b57a822f811ac34e4f8420 contains

 static void
@@ -1945,11 +1933,6 @@ i915_gem_flush_ring(struct drm_device *dev,
 {
 	ring->flush(dev, ring, invalidate_domains, flush_domains);
 	i915_gem_process_flushing_list(dev, flush_domains, ring);
-
-	if (ring->outstanding_lazy_request) {
-		(void)i915_add_request(dev, file_priv, NULL, ring);
-		ring->outstanding_lazy_request = false;
-	}
 }

which wasn't redone by a56ba56c275b1c2b982c8901ab92bf5a0fd0b757. After adding
those five lines it works for me.

regards,
  Johannes
