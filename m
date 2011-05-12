Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab1ELNeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 09:34:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39489 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756572Ab1ELNd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 09:33:59 -0400
Date: Thu, 12 May 2011 15:33:56 +0200
From: Michal Marek <mmarek@suse.cz>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: make KBUILD_NOCMDDEP=1 handle empty built-in.o
Message-ID: <20110512133356.GI13293@sepie.suse.cz>
References: <1303837564-18062-1-git-send-email-rabin@rab.in>
 <BANLkTimLre+UY1fY6+HXEsJicyh_oMnWdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimLre+UY1fY6+HXEsJicyh_oMnWdA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 11:00:01PM +0530, Rabin Vincent wrote:
> On Tue, Apr 26, 2011 at 22:36, Rabin Vincent <rabin@rab.in> wrote:
> > Fix building with KBUILD_NOCMDDEP=1, which currently does not work
> > because it does not build built-in.o with no dependencies:
> >
> >  LD      fs/notify/built-in.o
> > ld: cannot find fs/notify/dnotify/built-in.o: No such file or directory
> > ld: cannot find fs/notify/inotify/built-in.o: No such file or directory
> > ld: cannot find fs/notify/fanotify/built-in.o: No such file or directory
> >
> > Signed-off-by: Rabin Vincent <rabin@rab.in>
> 
> Any comments on this patch?  I found KBUILD_NOCMDDEP useful
> when hunting down a bug that appeared only in a certain compiler
> version.  Used it to build some files using one compiler and the rest
> using the other.  It would be nice if it worked out of the box; it will
> after this patch.

OK, so you have a use case for it. I was about to ask if it wouldn't be
easier to drop this feature instead :).

> 
> > ---
> >  scripts/Kbuild.include |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> >
> > diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
> > index ed2773e..fd31781 100644
> > --- a/scripts/Kbuild.include
> > +++ b/scripts/Kbuild.include
> > @@ -187,6 +187,10 @@ ifneq ($(KBUILD_NOCMDDEP),1)
> >  # User may override this check using make KBUILD_NOCMDDEP=1
> >  arg-check = $(strip $(filter-out $(cmd_$(1)), $(cmd_$@)) \
> >                     $(filter-out $(cmd_$@),   $(cmd_$(1))) )
> > +else
> > +# Ensure that files with no dependencies are built.
> > +built-check = $(filter $(origin cmd_$@), undefined)
> > +arg-check = $(if $(strip $(obj-y)),,$(built-check))
> >  endif

I'm not sure if this is the rigt way to fix it. Kbuild.include should
not care about obj-*. The problem is that arg-check is always empty with
KBUILD_NOCMDDEP and if there are no other dependencies, the target will
not be created, right? IMO we only need to make sure that during the
first make run, arg-check always expands to non-empty, even with
KBUILD_NOCMDDEP. So we can drop the $(obj-y) test and do it like this
(untested), can't we?

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index c034dd7..be39cd1 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -197,6 +197,8 @@ ifneq ($(KBUILD_NOCMDDEP),1)
 # User may override this check using make KBUILD_NOCMDDEP=1
 arg-check = $(strip $(filter-out $(cmd_$(1)), $(cmd_$@)) \
                     $(filter-out $(cmd_$@),   $(cmd_$(1))) )
+else
+arg-check = $(if $(strip $(cmd_$@)),,1)
 endif
 
 # >'< substitution is for echo to work,


while at it, we should also add KBUILD_NOCMDDEP to
Documentation/kbuild/kbuild.txt.

Michal
