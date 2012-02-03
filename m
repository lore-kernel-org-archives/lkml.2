Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab2BCJh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 04:37:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40607 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab2BCJh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 04:37:26 -0500
Date: Fri, 3 Feb 2012 10:37:22 +0100 (CET)
From: Richard Guenther <rguenther@suse.de>
To: DJ Delorie <dj@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, dsterba@suse.cz,
        ptesarik@suse.cz, gcc@gcc.gnu.org
Subject: Re: Memory corruption due to word sharing
In-Reply-To: <xnbopg8lex.fsf@greed.delorie.com>
Message-ID: <alpine.LNX.2.00.1202031034450.4999@zhemvz.fhfr.qr>
References: <20120201151918.GC16714@quack.suse.cz> <xnbopg8lex.fsf@greed.delorie.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Feb 2012, DJ Delorie wrote:

> 
> Jan Kara <jack@suse.cz> writes:
> >   we've spotted the following mismatch between what kernel folks expect
> > from a compiler and what GCC really does, resulting in memory corruption on
> > some architectures. Consider the following structure:
> > struct x {
> >     long a;
> >     unsigned int b1;
> >     unsigned int b2:1;
> > };
> 
> If this structure were volatile, you could try
> -fstrict-volatile-bitfields, which forces GCC to use the C type to
> define the access width, instead of doing whatever it thinks is optimal.
> 
> Note: that flag is enabled by default for some targets already, most
> notably ARM.

Note that -fstrict-volatile-bitfields does not work for

volatile struct S {
    int i : 1;
    char c;
} s;
int main()
{
  s.i = 1;
  s.c = 2;
}

where it accesses s.i using SImode.  -fstrict-volatile-bitfields
falls foul of all the games bitfield layout plays and the
irrelevantness of the declared bitfield type (but maybe the
ARM ABI exactly specifies it that way).

So no, I would not recommend -fstrict-volatile-bitfields.

Richard.
