Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab0IBHNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 03:13:25 -0400
Received: from gw1.transmode.se ([213.115.205.20]:49931 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab0IBHNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 03:13:24 -0400
X-Greylist: delayed 536 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Sep 2010 03:13:24 EDT
In-Reply-To: <1283366151.2209.21.camel@brekeke>
References: <1283357021-16187-1-git-send-email-w.sang@pengutronix.de> <1283366151.2209.21.camel@brekeke>
Subject: Re: [RFC] jffs2: use cond_resched() instead of yield()
X-KeepSent: 213EDC22:80E0A084-C1257792:0025CB36;
 type=4; name=$KeepSent
To: dedekind1@gmail.com
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Ingo Molnar <mingo@elte.hu>, Wolfram Sang <w.sang@pengutronix.de>
X-Mailer: Lotus Notes Release 8.5.2 August 10, 2010
Message-ID: <OF213EDC22.80E0A084-ONC1257792.0025CB36-C1257792.00268F36@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Thu, 2 Sep 2010 09:01:10 +0200
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5.1FP3|May 23, 2010) at
 2010-09-02 09:04:26
MIME-Version: 1.0
Content-type: text/plain; charset=KOI8-R
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o827DjZ9012457

>
> This 'yield()' was introduced by dwmw2, so he may have strong feelings
> about it. CCed.

Actually, it was introduced by me with commit fd5324909e410a3202c1b01bd507c2dfba58fca5 :

[JFFS2] Fix hanging close for /dev/mtd character device.

    When pdflush is erasing lots of sectors, drivers calling
    mtd->sync will hang until all blocks are erased. Be nicer.

    Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
    Signed-off-by: David Woodhouse <dwmw2@infradead.org>


@@ -142,7 +142,7 @@ void jffs2_erase_pending_blocks(struct jffs2_sb_info *c, int count)
 		}

 		/* Be nice */
-		cond_resched();
+		yield();
 		spin_lock(&c->erase_completion_lock);
 	}

At the time cond_resched() was a problem but now I don't know. The erasing
has moved to the GC thread and been somewhat reworked. I don't know if
it still needs yield(). Perhaps David can tell?

    Jocke
>
> On Wed, 2010-09-01 at 18:03 +0200, Wolfram Sang wrote:
> > yield() has different semantics meanwhile and even causes RT-kernels to
> > BUG. Replace the only appearance left in jffs2.
> >
> > Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> > Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > ---
> >
> > The aforementioned BUG() showed up in one of our customer's RT-projects. While
> > this could be handled by rearranging his thread-priorities, I wondered if such
> > a patch would be worthwhile, still. Reading through the material covering
> > yield() and related replacements, I believe this patch should be appropriate.
> > Please say if I missed some side-effects.
> >
> >  fs/jffs2/erase.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/fs/jffs2/erase.c b/fs/jffs2/erase.c
> > index abac961..e513f19 100644
> > --- a/fs/jffs2/erase.c
> > +++ b/fs/jffs2/erase.c
> > @@ -151,7 +151,7 @@ int jffs2_erase_pending_blocks(struct jffs2_sb_info *c, int count)
> >        }
> >
> >        /* Be nice */
> > -      yield();
> > +      cond_resched();
> >        mutex_lock(&c->erase_free_sem);
> >        spin_lock(&c->erase_completion_lock);
> >     }
>
> --
> Best Regards,
> Artem Bityutskiy (âÉÔÀÃËÉÊ áÒÔ£Í)
>
>
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
