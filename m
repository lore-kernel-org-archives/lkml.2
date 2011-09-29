Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab1I2J1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 05:27:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53821 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755079Ab1I2J1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 05:27:12 -0400
Date: Thu, 29 Sep 2011 11:27:05 +0200
From: Borislav Petkov <bp@alien8.de>
To: Simon Kirby <sim@hostway.ca>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [3.1-rc6] kmalloc(64) leak from IDE
Message-ID: <20110929092705.GA809@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Simon Kirby <sim@hostway.ca>, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org
References: <20110922072643.GA27232@hostway.ca>
 <20110922084811.GC17640@liondog.tnic>
 <20110922202337.GB32661@hostway.ca>
 <20110923072118.GA13293@liondog.tnic>
 <20110923173808.GB26481@hostway.ca>
 <20110925085818.GA10947@liondog.tnic>
 <20110926080549.GA14697@hostway.ca>
 <20110927170755.GA31384@gere.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110927170755.GA31384@gere.osrc.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 07:07:55PM +0200, Borislav Petkov wrote:
> (forgot to Cc linux-ide earlier, sorry)
> 
> On Mon, Sep 26, 2011 at 01:05:50AM -0700, Simon Kirby wrote:
> > Ok, good. It's still running without any problem, and no new leaks
> > reported.
> 
> Ok.
> 
> [..]
> 
> > > backporting it to -stable is a good point. I'll add the proper tagging
> > > to the patch.
> > 
> > Do you know in which version the issue started, then?
> > 
> > If not, all I have to start with is that it was fine on 2.6.36, and I can
> > bisect it, if that would help.
> 
> This is exactly the question: AFAICT, it could be that changes in the
> block layer at some point have caused the ide bust and since almost no
> one tests ide...
> 
> The patch adding the dynamic ide_cmd struct allocation is
> 395d8ef5bebe547a80737692f9789d2e36da16f2 from 2008 and I don't think it
> caused the issue then but I could also be remembering it wrong.
> 
> So I wouldn't bisect it but test stable trees after 2.6.36 to see
> whether they have the issue, and if so, only then the patch should be
> backported.
> 
> And this is not that easy now with k.org down but looking at
> 
> http://web.archive.org/web/20110725015737/http://kernel.org/
> 
> the only stable trees which need to be tested are 2.6.39 and 3.0.
> 
> How does that sound?

Btw, here's the patch, if you would like to test 2.6.39 once without it
to see whether kmemleak screams and once with it, I'll add the stable
tagging.

Thanks.

--
>From 96414ddbfecaaa3d265794c0792d816cf3c1e33d Mon Sep 17 00:00:00 2001
From: Borislav Petkov <bp@alien8.de>
Date: Sun, 25 Sep 2011 13:38:04 +0200
Subject: [PATCH] ide-disk: Fix request requeuing

Simon Kirby reported that on his RAID setup with idedisk underneath
the box OOMs after a couple of days of runtime. Running with
CONFIG_DEBUG_KMEMLEAK pointed to idedisk_prep_fn() which unconditionally
allocates an ide_cmd struct. However, ide_requeue_and_plug() can be
called more than once per request, either from the request issue or the
IRQ handler path and do blk_peek_request() ends up in idedisk_prep_fn()
repeatedly, allocating a struct ide_cmd everytime and "forgetting" the
previous pointer.

Make sure the code reuses the old allocated chunk.

Reported-and-tested-by: Simon Kirby <sim@hostway.ca>
Link: http://marc.info/?l=linux-kernel&m=131667641517919
Link: http://lkml.kernel.org/r/20110922072643.GA27232@hostway.ca
Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 drivers/ide/ide-disk.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 274798068a54..16f69be820c7 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -435,7 +435,12 @@ static int idedisk_prep_fn(struct request_queue *q, struct request *rq)
 	if (!(rq->cmd_flags & REQ_FLUSH))
 		return BLKPREP_OK;
 
-	cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
+	if (rq->special) {
+		cmd = rq->special;
+		memset(cmd, 0, sizeof(*cmd));
+	} else {
+		cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
+	}
 
 	/* FIXME: map struct ide_taskfile on rq->cmd[] */
 	BUG_ON(cmd == NULL);
-- 
1.7.5.3.401.gfb674


-- 
Regards/Gruss,
    Boris.
