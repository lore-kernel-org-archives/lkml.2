Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab0LRXG7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 18:06:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42558 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab0LRXG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 18:06:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gvqzAk5VqMf1JRbuRca9wcXQ0ORbDj6BFsY90WLIDj1CAt6AEY2PyMGFDABwYTzRLC
         JlvT69qQjrwh2JMTQAuzyzs3MrH+CFe43G7Nsx5Q/GaMEMn9Xp4Arx1WJ+2apqNGRMVe
         OLradiT+WLmo/PJP7Fo+Lk7j2hGmiybWkc3rY=
MIME-Version: 1.0
In-Reply-To: <AANLkTinoV_pL=Ygqq4qt4f8c+wsdc9r9K7rcJ58aHjD1@mail.gmail.com>
References: <4d0662e511688484b3@agluck-desktop.sc.intel.com>
	<AANLkTindPUkF7fCkdbqSstNHFjF3_7fEYh18nhQFx_AJ@mail.gmail.com>
	<AANLkTim3OpjPysjdCLDuFgFOipmcxyr2ay5cvUAu5PHi@mail.gmail.com>
	<AANLkTinpYJddhgbf7=Pw_TtGrnWaC8fwo2xv1XRsT1w7@mail.gmail.com>
	<AANLkTimA4x8oWyq71nOxB=Otp3Y0i3Kcu27DG0ajaXUG@mail.gmail.com>
	<AANLkTinCG+E6ZzpeRqsJP+-qvNDQXW4VZFgJ1c-sTryL@mail.gmail.com>
	<4D0BEE1F.7020008@zytor.com>
	<AANLkTinwFt+KDKNEYP9MWQ7wGb9qk=E2Xa3RJB3+MJnN@mail.gmail.com>
	<AANLkTinoV_pL=Ygqq4qt4f8c+wsdc9r9K7rcJ58aHjD1@mail.gmail.com>
Date: Sat, 18 Dec 2010 15:06:57 -0800
Message-ID: <AANLkTikhtWjFBQmA111Q+2JGRudrRNAmegGThMagr4vF@mail.gmail.com>
Subject: Re: [concept & "good taste" review] persistent store
From: Tony Luck <tony.luck@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        greg@kroah.com, akpm@linux-foundation.org, ying.huang@intel.com,
        Borislav Petkov <bp@alien8.de>, David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 10:23 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> You want to have a ring of events, and into that ring you also have a
> "this event has been read" pointer. And you _never_ overwrite entries
> that haven't been read yet, because quite frankly, if you get some
> nasty memory corruption, you may end up with a thousand oopses in
> rapid succession, and the latter ones are likely to be just fallout
> from the earlier ones. So you definitely don't want to overwrite the
> earlier ones, because they are more likely to contain the clues about
> the actual original cause.
>
> At the same time, you do want to have the capability of saying "I've
> seen this", and let it be overwritten. For example, if we end up
> teaching syslogd or something like that to use this, syslogd would
> write the oops to disk, do a fdatasync() on the oops file, and after
> it's stable on disk it can mark it "read".
>
> Also, since this is very much about persistent storage, I think any
> events from a previous boot that still exists should be marked "read".
> You still want to be able to read them (so marking something "read"
> does not mean that it goes away), but if a new oops happens, you don't
> want some old entries from long ago to stop it from being written to
> persistent storage. So if you don't have any syslogd or any other tool
> that saves things to disk, you'd still get the new oopses into
> persistent storage.
>
> Doesn't that sound like the best of both worlds?

It sounds like an excellent heuristic for how the platform layer
should manage the persistent store when space is tight. But
I think that I can still keep my /dev/pstore filesystem as a
presentation layer to make the bits available to the user in
a device independent way.

Or perhaps the pstore layer can help with the implementation
of the heuristic. It knows what items are in the pstore, so it
could build & maintain the "ring" and pass the id of the least
wanted item down to the platform layer whenever it wants to
write a record ... with the platform layer giving a status to
say whether it had to delete that item to make space for the
new one?

-Tony
