Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab2BGSEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 13:04:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288Ab2BGSEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 13:04:33 -0500
Date: Tue, 7 Feb 2012 13:04:23 -0500
From: Jason Baron <jbaron@redhat.com>
To: Rabin Vincent <rabin@rab.in>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 5/6] jump label: detect %c support for ARM
Message-ID: <20120207180423.GD2388@redhat.com>
References: <1327757725-10114-1-git-send-email-rabin@rab.in>
 <1327757725-10114-6-git-send-email-rabin@rab.in>
 <CAH+eYFDzsWjrxOFiYcYO6sgPDusxcHOTQcjvN8hDaEPG+=LgAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH+eYFDzsWjrxOFiYcYO6sgPDusxcHOTQcjvN8hDaEPG+=LgAQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 09:48:24PM +0530, Rabin Vincent wrote:
> Jason,
> 
> On Sat, Jan 28, 2012 at 19:05, Rabin Vincent <rabin@rab.in> wrote:
> > Some versions of ARM GCC which do support asm goto, have problems
> > handling the the %c specifier.  Since we need the %c to support jump
> > labels on ARM, detect that too in the asm goto detection script to avoid
> > build errors with these versions.
> >
> > http://gcc.gnu.org/bugzilla/show_bug.cgi?id=48637
> >
> > Cc: Jason Baron <jbaron@redhat.com>
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Rabin Vincent <rabin@rab.in>
> 
> Could you please ack this patch if it's OK for you?  Then I could try to
> send it via rmk's ARM patch system along with the rest of the series.
> 
> Thanks.
> 
> > ---
> >  scripts/gcc-goto.sh |   18 +++++++++++++++++-
> >  1 files changed, 17 insertions(+), 1 deletions(-)
> >
> > diff --git a/scripts/gcc-goto.sh b/scripts/gcc-goto.sh
> > index 98cffcb..9b744de 100644
> > --- a/scripts/gcc-goto.sh
> > +++ b/scripts/gcc-goto.sh
> > @@ -2,4 +2,20 @@
> >  # Test for gcc 'asm goto' support
> >  # Copyright (C) 2010, Jason Baron <jbaron@redhat.com>
> >
> > -echo "int main(void) { entry: asm goto (\"\"::::entry); return 0; }" | $@ -x c - -c -o /dev/null >/dev/null 2>&1 && echo "y"
> > +cat << "END" | $@ -x c - -c -o /dev/null >/dev/null 2>&1 && echo "y"
> > +int main(void)
> > +{
> > +#ifdef __arm__
> > +       /*
> > +        * Not related to asm goto, but used by jump label
> > +        * and broken on some ARM GCC versions (see GCC Bug 48637).
> > +        */
> > +       static struct { int dummy; int state; } tp;
> > +       asm ("@ %c0" :: "i" (&tp.state));
> > +#endif
> > +
> > +entry:
> > +       asm goto ("" :::: entry);
> > +       return 0;
> > +}
> > +END
> > --
> > 1.7.8.3
> >

Sure, patch works for me.

Acked-by: Jason Baron <jbaron@redhat.com>

