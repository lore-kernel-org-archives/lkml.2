Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab1IGDET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 23:04:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:49691 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab1IGDEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 23:04:14 -0400
Date: Tue, 6 Sep 2011 20:07:36 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org, perex@perex.cz,
        tiwai@suse.de
Subject: Re: [PATCH] sound: Fix race condition in the pcm_lib "wait for
 space loop
Message-ID: <20110906200736.785edef3@infradead.org>
In-Reply-To: <20110906155954.bb9c42eb.akpm@linux-foundation.org>
References: <20110905094947.6ece87c2@infradead.org>
	<20110906155954.bb9c42eb.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Sep 2011 15:59:54 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > --- a/sound/core/pcm_lib.c
> > +++ b/sound/core/pcm_lib.c
> > @@ -1761,6 +1761,10 @@ static int wait_for_avail(struct
> > snd_pcm_substream *substream, snd_pcm_uframes_t avail = 0;
> >  	long wait_time, tout;
> >  
> > +	init_waitqueue_entry(&wait, current);
> > +	add_wait_queue(&runtime->tsleep, &wait);
> > +	set_current_state(TASK_INTERRUPTIBLE);
> 
> Well, this isn't very good either.  if a wakeup gets delivered to
> runtime->tsleep before the set_current_state(), this process will go
> ahead and incorrectly set itself into TASK_INTERRUPTIBLE state.

... and then check the condition for exit, and then set it to
TASK_RUNABLE a the end...

> 
> That looks like it will be dont-care/cant-happen in this case, but
> it's setting a bad example.

agreed that your ordering is more clean/better.....



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
