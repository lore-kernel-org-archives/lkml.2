Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab2JEP2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:28:34 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:48041 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab2JEP2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:28:33 -0400
Date: Fri, 5 Oct 2012 17:28:31 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Borislav Petkov <bp@amd64.org>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Fix bogus "callbacks suppressed" messages
Message-ID: <20121005152831.GA245@x4>
References: <20121004092055.GA21028@aftab.osrc.amd.com>
 <20121004112347.GA245@x4>
 <20121004115157.GA245@x4>
 <20121004124025.GC21028@aftab.osrc.amd.com>
 <20121004131101.GA245@x4>
 <506EC1AE.6000201@suse.cz>
 <20121005122741.GB8019@aftab.osrc.amd.com>
 <20121005125717.GB245@x4>
 <20121005142639.GA20065@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121005142639.GA20065@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.10.05 at 07:26 -0700, Greg Kroah-Hartman wrote:
> On Fri, Oct 05, 2012 at 02:57:17PM +0200, Markus Trippelsdorf wrote:
> > On the current git tree one sees messages such as:
> >  tty_init_dev: 24 callbacks suppressed
> >  tty_init_dev: 3 callbacks suppressed
> > 
> > To fix this we need to look at condition before calling __ratelimit in
> > the WARN_RATELIMIT macro. While at it remove the superfluous
> > __WARN_RATELIMIT macros.
> > 
> > Original patch is from Joe Perches and Jiri Slaby.
> > 
> > Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> > Acked-and-tested-by: Borislav Petkov <borislav.petkov@amd.com>
> > ---
> >  include/linux/ratelimit.h | 27 +++++++++------------------
> >  1 file changed, 9 insertions(+), 18 deletions(-)
> 
> I don't have a problem with this patch, but I don't understand why it's
> now showing up.  There haven't been any changes in the ratelimit.h area
> recently that I can see, so why is this change needed now?  What is in
> the tty layer that is causing this, just the fact that it's actually
> being used now?

See Jiri's recent commit:

commit 5d4121c04b3577e37e389b3553d442f44bb346d7
Author: Jiri Slaby <jslaby@suse.cz>
Date:   Fri Aug 17 14:27:52 2012 +0200

    TTY: check if tty->port is assigned
    
    And if not, complain loudly. None in-kernel module should trigger
    that, but let us find out for sure. On the other hand, all the
    out-of-tree modules will hit that. Give them some time (maybe one
    release) to catch up.
    
    Signed-off-by: Jiri Slaby <jslaby@suse.cz>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 28c3e86..41e42f1 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1415,6 +1415,10 @@ struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx)
 	if (!tty->port)
 		tty->port = driver->ports[idx];
 
+	WARN_RATELIMIT(!tty->port,
+			"%s: %s driver does not set tty->port. This will crash the kernel later. Fix the driver!\n",
+			__func__, tty->driver->name);
+
 	/*
 	 * Structures all installed ... call the ldisc open routines.
 	 * If we fail here just call release_tty to clean up.  No need

-- 
Markus
