Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab0E0RRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:17:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759330Ab0E0RRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:17:39 -0400
Date: Thu, 27 May 2010 19:15:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Richard Henderson <rth@twiddle.net>, wezhang@redhat.com,
       linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
       William Cohen <wcohen@redhat.com>
Subject: Re: [PATCH 1/3] sys_personality: validate personality before
	set_personality()
Message-ID: <20100527171530.GA18284@redhat.com>
References: <20100525141720.GA2253@redhat.com> <20100525193348.83F1549A54@magilla.sf.frob.com> <20100526123622.GA26033@redhat.com> <20100526203105.59D7849A56@magilla.sf.frob.com> <20100527153522.GA13858@redhat.com> <20100527153548.GB13858@redhat.com> <alpine.LFD.2.00.1005270921540.3689@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005270921540.3689@i5.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27, Linus Torvalds wrote:
>
> On Thu, 27 May 2010, Oleg Nesterov wrote:
> >
> > --- 34-rc1/kernel/exec_domain.c~1_CK_OVERFLOW_EARLIER	2009-04-06 00:03:42.000000000 +0200
> > +++ 34-rc1/kernel/exec_domain.c	2010-05-27 15:15:12.000000000 +0200
> > @@ -193,9 +193,9 @@ SYSCALL_DEFINE1(personality, u_long, per
> >  	u_long old = current->personality;
> >
> >  	if (personality != 0xffffffff) {
> > -		set_personality(personality);
> > -		if (current->personality != personality)
> > +		if ((unsigned int)personality != personality)
> >  			return -EINVAL;
> > +		set_personality(personality);
> >  	}
>
> I think this is total random noise. The whole type system is crazy - don't
> just paper over it.

Of course! I agree very much.

> And if we decide that the field must fit in an unsigned int (reasonable),
> then let's just ignore the top bits, and make it work right even if
> somebody passes in an unsigned int!

Certainly, this was my first thought.

But I didn't dare to do this change because it is obviously user-visible,
and while this is not very important, we should change the declaration
of personality() in /usr/include/sys/personality.h

> -SYSCALL_DEFINE1(personality, u_long, personality)
> +SYSCALL_DEFINE1(personality, unsigned int, personality)

Indeed!

But. Suppose an application does personality(0xffffffff << 32) on x86_64.

Before this patch we return -EINVAL (but wrongly change ->personality).
After this patch this is equal to personality(0), right?

If you think this is fine - I agree. In case we have a bug report we
know who should be blamed ;)

As for 2/3 - once again, I think this is user-space problem, but I
can't explain this to the bug-reportes.

> -	u_long old = current->personality;
> +	unsigned int old = current->personality;
>
>  	if (personality != 0xffffffff) {
>  		set_personality(personality);
> @@ -198,7 +198,7 @@ SYSCALL_DEFINE1(personality, u_long, personality)
>  			return -EINVAL;

You can also remove this "return -EINVAL", this is no longer possible.

Oleg.

