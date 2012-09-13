Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab2IMG5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 02:57:00 -0400
Received: from csmtp2.one.com ([91.198.169.22]:19729 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436Ab2IMG45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 02:56:57 -0400
From: "Henrik Rydberg" <rydberg@bitmath.se>
Date: Thu, 13 Sep 2012 09:04:10 +0200
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Minchan Kim <minchan@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Ping Cheng <pingc@wacom.com>
Subject: Re: linux-next: Tree for Sept 12 (kernel-panic after pressing any
 key at X login)
Message-ID: <20120913070410.GA309@polaris.bitmath.org>
References: <CA+icZUVEQNPGL7_BbLA-urgP6rFvdOh0SUtYESUv6ZJc+w78Nw@mail.gmail.com>
 <CA+icZUXqzV=YFjHT=5QxUf1_WHwS1-DhuXkhN8QAhn1t9+-PYA@mail.gmail.com>
 <20120913060412.GB5085@bbox>
 <CA+icZUUF=vTwSoNrs-+F08H7LAO0RUwztJ3M1_iyNR28TsrFMw@mail.gmail.com>
 <20120913064909.GF17105@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913064909.GF17105@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >> > this weeks linux-next seems to bring new and new issues, yay :-)!
> > >> >
> > >> > I have taken a photo, but can't say what can have caused.
> > >> > The issue is reproducible...
> > >> > Immediately, after pressing any key (when X-display-manager (lightdm)
> > >> > and X-greeter are up) my machine panics and is no more usable (cold
> > >> > rough brutal killer restart).
> > >> > Note: Using upstart or systemd does not matter.
> > >> >
> > >> > Any pointer to an area where to dig into or any feedback in general is welcome!
> > >> >
> > >> > Kind Regards,
> > >> > - Sedat -
> > 
> > Hey, cool. Thanks for the pointer in the source-code and the call-trace!
> > I had reverted [1], but anyway input folks should look at this.
> > 
> > Kind Regards,
> > - Sedat -
> > 
> > [1] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=b276fc1e875a51e4a9dc3322ed008bf4ae481baf
> 
> Henrik,
> 
> It looks like your changes are causing the panic.

Indeed, I have pushed the fix below to next already. Thanks for Sedat,
and sorry for not catching this earlier. :-(

Henrik

--

>From ccc6557bfd02efdca4d9dfda6cfdfe5a08d0193b Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Thu, 13 Sep 2012 08:59:40 +0200
Subject: [PATCH] Input: Fix oops caused by missing null test

Found in linux-next on September 12, thanks Sedat.

Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 5b66b2f..2dff71b 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -114,7 +114,7 @@ static unsigned int input_to_handler(struct input_handle *handle,
 
 	if (handler->events)
 		handler->events(handle, vals, count);
-	else
+	else if (handler->event)
 		for (v = vals; v != end; v++)
 			handler->event(handle, v->type, v->code, v->value);
 
-- 
1.7.12

