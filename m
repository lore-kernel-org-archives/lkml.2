Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab0LQXIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 18:08:10 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64815 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab0LQXIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 18:08:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=wGXaioY3nF9D6seKOfCEtdc6qtTBWsDMMqu36e7LvPsy96FC/eGwLstAZAvG7xdKsr
         XkwnJ1W78DXmGIn0l04zJokf6035jLaxZhhT62xwjLcn0lU08QbYuKZN/WQnDuc8NxBd
         +sn7oEkvnBPImJGxxJXnVsNHC4xU+EEnE0lD8=
MIME-Version: 1.0
In-Reply-To: <AANLkTimA4x8oWyq71nOxB=Otp3Y0i3Kcu27DG0ajaXUG@mail.gmail.com>
References: <4d0662e511688484b3@agluck-desktop.sc.intel.com>
	<AANLkTindPUkF7fCkdbqSstNHFjF3_7fEYh18nhQFx_AJ@mail.gmail.com>
	<AANLkTim3OpjPysjdCLDuFgFOipmcxyr2ay5cvUAu5PHi@mail.gmail.com>
	<AANLkTinpYJddhgbf7=Pw_TtGrnWaC8fwo2xv1XRsT1w7@mail.gmail.com>
	<AANLkTimA4x8oWyq71nOxB=Otp3Y0i3Kcu27DG0ajaXUG@mail.gmail.com>
Date: Fri, 17 Dec 2010 15:08:03 -0800
X-Google-Sender-Auth: PQc7TrF39DtvOALH7IAtXO5ApWE
Message-ID: <AANLkTinCG+E6ZzpeRqsJP+-qvNDQXW4VZFgJ1c-sTryL@mail.gmail.com>
Subject: Re: [concept & "good taste" review] persistent store
From: Tony Luck <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, greg@kroah.com,
        akpm@linux-foundation.org, ying.huang@intel.com,
        Borislav Petkov <bp@alien8.de>, David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 1:38 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Yes. However, I still question the "filesystem" part.
>
> Technically, what I think any persistent storage should aim for is to
> be a "journal" - not a filesystem. It's most useful as a temporary
> area for data _before_ that data actually hits the disk, and once it
> has hit the disk (or has been picked up by a network syslog server, of
> course), the usefulness of the persistent storage immediately
> vanishes.
>
> So I don't really mind having a filesystem interface to that (the
> whole "everything is a file" model), but I think it can end up
> confusing people about what this thing is useful for. I fear that
> people will try to write to it from user space as some kind of
> mini-filesystem, and that seems pointless.

Do we have any good models for "journals" ... apart from
the console log?  Ying & I did talk about just using printk
to drop all the saved information onto the console (with
some sort of "previous" prefix on each line to make
it easy to find, and to make sure that someone glancing
at the messages wouldn't worry that that OOPs scrolling
by was happening now).  But this seemed like a really bad
idea (especially if someone has enough persistent store to
capture all of __logbuf).

So the downside of "everything is a file" is that we don't
have much infrastructure for things that don't look like
files - and trying to build some results in some special
custom tools being needed to access the data, which
just makes things harder to use.

People trying to write to /dev/pstore will figure out quickly
that you can't do that. There are no "ops" to make new files,
directories, symlinks or even to rename existing ones. You
can overwrite existing files (because I don't trap "open" to
deny them write access - but the 0444 mode is supposed
to be a visual clue to not do that).

-Tony
