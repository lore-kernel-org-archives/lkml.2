Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab2AaTQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 14:16:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab2AaTQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 14:16:00 -0500
Date: Tue, 31 Jan 2012 11:15:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Arthur Taylor <art@ified.ca>, Jiri Slaby <jslaby@suse.cz>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] Fix KDFONTOP 32bit compatibility layer
Message-Id: <20120131111553.e69ab58b.akpm@linux-foundation.org>
In-Reply-To: <201201311635.36367.arnd@arndb.de>
References: <20120128232858.GA18484@type.famille.thibault.fr>
	<201201311635.36367.arnd@arndb.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012 16:35:36 +0000
Arnd Bergmann <arnd@arndb.de> wrote:

> On Saturday 28 January 2012, Samuel Thibault wrote:
> > KDFONTOP(GET) currently fails with EIO when being run in a 32bit
> > userland with a 64bit kernel if the font width is not 8. This is because
> > the compatibility layer introduced by e9216651 forces the addition of
> > the KD_FONT_FLAG_OLD flag, which makes con_font_get return EIO in such
> > case.  This flag should not be set for KDFONTOP, since it's actually
> > the whole point of this flag (see comment in con_font_set for instance).
> > 
> > Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> 
> Hmm, this flag was not introduced in the patch you cite, it used to
> live in fs/compat_ioctl.c before that, since before the start of the
> git history. It seems to date back on the original sparc64 implementation
> of do_kdfontop_ioctl that was written by Eddie Dost in 1998.
> 
> > diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
> > index 5e096f4..65447c5 100644
> > --- a/drivers/tty/vt/vt_ioctl.c
> > +++ b/drivers/tty/vt/vt_ioctl.c
> > @@ -1463,7 +1463,6 @@ compat_kdfontop_ioctl(struct compat_console_font_op __user *fontop,
> >         if (!perm && op->op != KD_FONT_OP_GET)
> >                 return -EPERM;
> >         op->data = compat_ptr(((struct compat_console_font_op *)op)->data);
> > -       op->flags |= KD_FONT_FLAG_OLD;
> >         i = con_font_op(vc, op);
> >         if (i)
> >                 return i;
> 
> From all I can tell, the patch looks correct, but please update the
> description so you don't blame my innocent patch ;-)
> 
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>

Yes, we should note the fact that at least one kernel bug isn't your
fault ;)

I changed the changelog to

: KDFONTOP(GET) currently fails with EIO when being run in a 32bit userland
: with a 64bit kernel if the font width is not 8.
: 
: This is because of the setting of the KD_FONT_FLAG_OLD flag, which makes
: con_font_get return EIO in such case.  
: 
: This flag should *not* be set for KDFONTOP, since it's actually the whole
: point of this flag (see comment in con_font_set for instance).
: 
: Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
: Reviewed-by: Arnd Bergmann <arnd@arndb.de>
: Cc: Greg Kroah-Hartman <gregkh@suse.de>
: Cc: Arthur Taylor <art@ified.ca>
: Cc: Jiri Slaby <jslaby@suse.cz>
: Cc: Jiri Olsa <jolsa@redhat.com>
: Cc: <stable@vger.kernel.org>


