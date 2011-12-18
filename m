Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab1LRKnH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 05:43:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47710 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab1LRKmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 05:42:54 -0500
Date: Sun, 18 Dec 2011 11:42:48 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: debian-kernel@lists.debian.org, linux-m68k@vger.kernel.org,
        Thorsten Glaser <tg@debian.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] m68k/irq: don't use pr_crit in an header
Message-ID: <20111218104248.GS24496@pengutronix.de>
References: <Pine.BSM.4.64L.1112161437090.856@herc.mirbsd.org>
 <1324152592-1718-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <CAMuHMdXyf_ofM+y6yKrzftyKTOyrSKzW7fUVAJyY6XTV_FVhNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdXyf_ofM+y6yKrzftyKTOyrSKzW7fUVAJyY6XTV_FVhNA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

(thanks for adding Joe to Cc:, I noticed that when I wanted to add him
myself :-)

On Sun, Dec 18, 2011 at 11:32:21AM +0100, Geert Uytterhoeven wrote:
> 2011/12/17 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> > Using pr_crit in an header results in funny messages. Consider
> >
> >        #define pr_fmt(fmt) "mydriver: " fmt
> >        #include <linux/hardirq.h>
> >
> > which makes the message from ack_bad_irq
> >
> >        mydriver: unexpected IRQ trap...
> >
> > so better use plain printk with KERN_CRIT directly.
> 
> Yep, that's expected behavior, as defining pr_fmt() modifies all kernel messages
> generated from that module.
I'm aware it is expected, I only wondered if it is also desirable to
have messages in headers modified depending on the module the header is
included in.
 
> > This fixes a build problem on m68k with aufs3 en passant because the
> > latter builds with
> >
> >        ccflags-y += -D'pr_fmt(fmt)=AUFS_NAME"\040%s:%d:%s[%d]:\040"fmt,__func__,__LINE__,current->comm,current->pid'
> >
> > without providing AUFS_NAME early enough for ack_bad_irq (which is the
> > problem of aufs).
> 
> Isn't this a problem with (out of tree) aufs?
> Why does it put a define that relies on an (apparently sometimes still
> undefined)
> variable on the build command line?
This is definitily a bug in aufs that needs fixing independant of the
issue of using or not using pr_... in headers.

> Any header may contain calls to pr_*().
> 
> > Cc: Thorsten Glaser <tg@debian.org>
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> >  arch/m68k/include/asm/hardirq.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/m68k/include/asm/hardirq.h b/arch/m68k/include/asm/hardirq.h
> > index db30ed2..1f652e0 100644
> > --- a/arch/m68k/include/asm/hardirq.h
> > +++ b/arch/m68k/include/asm/hardirq.h
> > @@ -20,7 +20,7 @@
> >
> >  static inline void ack_bad_irq(unsigned int irq)
> >  {
> > -       pr_crit("unexpected IRQ trap at vector %02x\n", irq);
> > +       printk(KERN_CRIT "unexpected IRQ trap at vector %02x\n", irq);
> 
> Nack. Nowadays pr_crit(...) is recommended over "printk(KERN_CRIT ...)".
I know that, I just wonder if the proponents of this recommendation are
aware of the issue when using pr_* in headers. Joe?
 
> Besides, there are (albeit not that many yet) other callers of pr_*() in
> header files. Do you plan to revert them to printk(), too?
That depends on the outcome of this discussion.

> Please fix aufs instead. Thanks!
I already provided a patch for that, too. (Currently only on the Debian
kernel ML.)

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
