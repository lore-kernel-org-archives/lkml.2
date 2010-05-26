Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab0EZRdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 13:33:12 -0400
Received: from gw1.transmode.se ([213.115.205.20]:48375 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757184Ab0EZRdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 13:33:09 -0400
In-Reply-To: <alpine.LFD.2.00.1005260939030.3689@i5.linux-foundation.org>
References: <20100526110506.f2f4f22c.sfr@canb.auug.org.au> <20100525182040.f1882d0a.akpm@linux-foundation.org> <20100526140900.5b091c16.sfr@canb.auug.org.au> <OFC00BDFAC.5596A841-ONC125772F.0022984D-C125772F.0023AF14@transmode.se> <20100525234116.71889c71.akpm@linux-foundation.org> <20100526171424.447fac18.sfr@canb.auug.org.au> <OFE5212A1C.B62E8E51-ONC125772F.00371EE7-C125772F.0038EEC8@transmode.se> <alpine.LFD.2.00.1005260828320.3689@i5.linux-foundation.org> <OF6B2D521C.109F3133-ONC125772F.00576DF0-C125772F.005B18F3@transmode.se> <alpine.LFD.2.00.1005260939030.3689@i5.linux-foundation.org>
Subject: Re: linux-next: build warning in Linus'tree
X-KeepSent: E9F7159D:A4D62F91-C125772F:005CB786;
 type=4; name=$KeepSent
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
X-Mailer: Lotus Notes Release 8.5.1 September 28, 2009
Message-ID: <OFE9F7159D.A4D62F91-ONC125772F.005CB786-C125772F.00603B6C@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Wed, 26 May 2010 19:31:06 +0200
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5.1|September 28, 2009) at
 2010-05-26 19:33:08
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote on 2010/05/26 18:46:11:
>
> On Wed, 26 May 2010, Joakim Tjernlund wrote:
> >
> > 1) It silently breaks when neither of {__LITTLE_,__BIG}_ENDIAN (or both)are
> >    defined depending on the endianess of the target CPU.
> >    The glibc model generates a compile error if you forget to include __BYTE_ORDER.
>
> Umm. Except when it doesn't (yes, Linux has the "Wundefined" thing, and
> has had for a long time). I've seen the glibc model do the wrong thing
> exactly because traditional C semantics is "undefined symbol is 0 in
> evaluations"
>
> Try compiling this
>
>    #include <stdio.h>
>
>    #if NOT_HERE == NOT_THERE
>    int main()
>    {
>       printf("Hello world!\n");
>    }
>    #endif
>
> and even with -Wall it compiles perfectly happily.

Ouch! But here -Wundef really helps.

>
> So no. The glibc model is _not_ any better in practice.

In the kernel it is since it breaks the compile. The breakage
my patch introduced is a sign of that, right?

>
> > 2) It clashes with user space so one cannot use it in exported header files.
>
> Which is annoying, I agree. But you shouldn't generally use kernel headers
> for user space anyway, much less export anything that is byteorder-

Not in general, but my case could have been avoided, I sure there are others
too. Why else does some header files bother with __BYTE_ORDER?

> specific. So anybody who has this problem is likely doing something iffy
> to begin with.

hmm, so then I guess the existing use of __BYTE_ORDER in the
kernel should be removed?

>
> Besides, you can solve it cleanly by simply avoiding the crazy glibc
> semantics entirely. IOW, the CONFIG_BIG_ENDIAN option I suggested (and

CONFIG_BIG_ENDIAN would have helped me with my lib/crc32.c problem
but it does not prevent silent breakage so I figured the glibc model
would be better.
Is it such a big difference, readability wise, between
  #ifdef CONFIG_BIG_ENDIAN
and
  #if __BYTE_ORDER == __BIG_ENDIAN
that you rather risk silent breakage?

> again, you should damn well not export things that depend on it to user
> space - there are architectures where user-space might be switchable)

Such arch exists but does any of them run linux in both modes?

  Jocke

