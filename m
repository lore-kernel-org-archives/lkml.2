Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038Ab1FWRqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:46:30 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:37785 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933017Ab1FWRq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:46:26 -0400
Date: Thu, 23 Jun 2011 19:46:23 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>, Sam Ravnborg <sam@ravnborg.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: __packed vs. __attribute__((packed)) in kernel headers
Message-ID: <20110623174623.GA1708@x4.trippels.de>
References: <20110622063441.GA1740@x4.trippels.de>
 <BANLkTimci1ZDZFnO5n0H3ADCEaQStwLkdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimci1ZDZFnO5n0H3ADCEaQStwLkdw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.06.23 at 19:04 +0200, richard -rw- weinberger wrote:
> On Wed, Jun 22, 2011 at 8:34 AM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
> > A recent commit 3627924acf70a changed __attribute__ ((packed)) to
> > __packed in some UBI headers. This breaks the build of busybox:
> >
> >  CC      miscutils/ubi_attach_detach.o
> > In file included from miscutils/ubi_attach_detach.c:27:0:
> > /usr/include/mtd/ubi-user.h:330:3: error: conflicting types for ‘__packed’
> > /usr/include/mtd/ubi-user.h:314:3: note: previous declaration of ‘__packed’ was here
> > /usr/include/mtd/ubi-user.h:372:3: error: conflicting types for ‘__packed’
> > /usr/include/mtd/ubi-user.h:314:3: note: previous declaration of ‘__packed’ was here
> > ...
> >
> > But this kind of change is suggested by checkpatch.pl:
> >  WARN("__packed is preferred over __attribute__((packed))\n
> >
> > One possible solution would be to let the "scripts/headers_install.pl"
> > script automatically substitute __packed with __attribute__((packed)):
> >
> > diff --git a/scripts/headers_install.pl b/scripts/headers_install.pl
> > index efb3be1..e0dc065 100644
> > --- a/scripts/headers_install.pl
> > +++ b/scripts/headers_install.pl
> > @@ -35,6 +35,7 @@ foreach my $file (@files) {
> >                $line =~ s/([\s(])__iomem\s/$1/g;
> >                $line =~ s/\s__attribute_const__\s/ /g;
> >                $line =~ s/\s__attribute_const__$//g;
> > +               $line =~ s/\s__packed/__attribute__((packed))/g;
> >                $line =~ s/^#include <linux\/compiler.h>//;
> >                $line =~ s/(^|\s)(inline)\b/$1__$2__/g;
> >                $line =~ s/(^|\s)(asm)\b(\s|[(]|$)/$1__$2__$3/g;
> >
> > Any thoughts?
> >
> 
> Hmm, this introduces a new error source.
> Whenever we change the definition of __packed we have to
> adjust headers_install.pl too.

That definition will never change as long as we use gcc.

The __packed shortcut was introduced 2007 (commit 82ddcb04057).
It's use in the exported header files could cause problems, because the
outside world doesn't necessarily know about that shortcut.

-- 
Markus
