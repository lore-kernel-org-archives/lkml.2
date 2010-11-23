Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab0KWTvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 14:51:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab0KWTvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 14:51:22 -0500
Subject: Re: [PATCH] fanotify: dont destroy mark when ignore mask is cleared
From: Eric Paris <eparis@redhat.com>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20101122175229.GC5512@lsanfilippo.unix.rd.tt.avira.com>
References: <20101122175229.GC5512@lsanfilippo.unix.rd.tt.avira.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 14:51:19 -0500
Message-ID: <1290541879.1443.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 18:52 +0100, Lino Sanfilippo wrote:
> In mark_remove_from_mask() the mark is destroyed regardless of whether the
> event mask or ignore mask is cleared. We should only destroy the mark if the
> event mask is cleared.
> 
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>

Hmmmm, really I'm not sure if that is right either (but it's certainly
closer)  What about something like:

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 81df3ad..29fbf17 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -527,7 +527,7 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
 	}
 	spin_unlock(&fsn_mark->lock);
 
-	if (!(oldmask & ~mask))
+	if (!fsn_mark->mask && !fsn_mark->ignored_mask)
 		fsnotify_destroy_mark(fsn_mark);
 
 	return mask & oldmask;


