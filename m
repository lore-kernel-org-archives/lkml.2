Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668Ab2BAW1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 17:27:37 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46902 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab2BAW1f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 17:27:35 -0500
MIME-Version: 1.0
In-Reply-To: <A3E67C2071F49C4CBC4F17E6D77CDDD232754183@G4W3299.americas.hpqcorp.net>
References: <20120201151918.GC16714@quack.suse.cz> <CA+55aFy55Q=+pFCZcS9cOM6SL+ZT3sNDB+c4qFvVqwwSpTqJ7g@mail.gmail.com>
 <1328118174.15992.6206.camel@triegel.csb> <CA+55aFw=z2SKFGoSE5e_0ZmKcAAjK5q0DBM4PaxBH2D9tuikzA@mail.gmail.com>
 <1328128874.15992.6430.camel@triegel.csb> <CA+55aFx4SdtZcYaWZ-=JG3yVFJxsBa-Yqn0m+h4Y=QHdRjx6_w@mail.gmail.com>
 <A3E67C2071F49C4CBC4F17E6D77CDDD232754183@G4W3299.americas.hpqcorp.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Feb 2012 14:27:15 -0800
X-Google-Sender-Auth: RfGH4P_bZQcnVNeW3z5ODYDPHRE
Message-ID: <CA+55aFyfD_AEotpx=7-pyiCp1Ph5_1QSmnd2_-fS=UH8vZfj1A@mail.gmail.com>
Subject: Re: Memory corruption due to word sharing
To: "Boehm, Hans" <hans.boehm@hp.com>
Cc: Torvald Riegel <triegel@redhat.com>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>,
        "ptesarik@suse.cz" <ptesarik@suse.cz>,
        "rguenther@suse.de" <rguenther@suse.de>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 1:25 PM, Boehm, Hans <hans.boehm@hp.com> wrote:
>
> Here are some more interesting ones that illustrate the issues (all declarations are non-local, unless stated otherwise):
>
> struct { char a; int b:9; int c:7; char d} x;
>
> Is x.b = 1 allowed to overwrite x.a?  C11 says no, essentially requiring two byte stores.  Gcc currently does so.  I'm not sure I understand Linus' position here.

So I like the fact that the C11 stance seems very strict. But honestly
I also think it sounds like C11 is actually more strict than I would
necessarily be.

I really do think that bitfields imply "int", both historically and
technically. So I would not see the problem with treating the
bitfields as part of an 'int' and thus overwriting a (and d) when
writing to b. That's how bitfields work! They are fields of an int.

It would be good if it perhaps caused a *warning*, and gave a good way
to avoid it. For example, while I think using any other base type than
'int' is technically an extension of the C bitfield rules (but
whatever, I don't have any specs in front of me), I think a warning
together with alowing the user to rewrite it as

  struct { char a; char d; short b:9; short c:7; } x;

would make it clear that now a write to 'b' cannot validly overwrite
'a' or 'd'.

But forcing the compiler to do two (and sometimes three!) byte
accesses sounds excessive.

The reason I think the

   int flag:1;
   int othervariable;

overwriting of "othervariable" is so *obviously* a bug is exactly that
bitfields are historically about 'int', and no 'long' was there
anywhere, so using a 64-bit access is clearly not sane in any way,
shape or form.

I dunno.

                 Linus
