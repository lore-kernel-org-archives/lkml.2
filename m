Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab0LRSaw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 13:30:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932097Ab0LRSau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 13:30:50 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinwFt+KDKNEYP9MWQ7wGb9qk=E2Xa3RJB3+MJnN@mail.gmail.com>
References: <4d0662e511688484b3@agluck-desktop.sc.intel.com>
 <AANLkTindPUkF7fCkdbqSstNHFjF3_7fEYh18nhQFx_AJ@mail.gmail.com>
 <AANLkTim3OpjPysjdCLDuFgFOipmcxyr2ay5cvUAu5PHi@mail.gmail.com>
 <AANLkTinpYJddhgbf7=Pw_TtGrnWaC8fwo2xv1XRsT1w7@mail.gmail.com>
 <AANLkTimA4x8oWyq71nOxB=Otp3Y0i3Kcu27DG0ajaXUG@mail.gmail.com>
 <AANLkTinCG+E6ZzpeRqsJP+-qvNDQXW4VZFgJ1c-sTryL@mail.gmail.com>
 <4D0BEE1F.7020008@zytor.com> <AANLkTinwFt+KDKNEYP9MWQ7wGb9qk=E2Xa3RJB3+MJnN@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 18 Dec 2010 10:23:03 -0800
Message-ID: <AANLkTinoV_pL=Ygqq4qt4f8c+wsdc9r9K7rcJ58aHjD1@mail.gmail.com>
Subject: Re: [concept & "good taste" review] persistent store
To: Tony Luck <tony.luck@intel.com>
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

On Fri, Dec 17, 2010 at 3:53 PM, Tony Luck <tony.luck@intel.com> wrote:
> On Fri, Dec 17, 2010 at 3:11 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> There are two models I can think of:
>>
>> 1. a file where the head is automatically dropped as space requires.
>> 2. a filesystem where the oldest files are automatically reclaimed.
>>
>> 1 has been implemented in actual systems, 2 is kind of a logical extension.
>
> #2 sounds more applicable here (we have some multi-kilobyte
> blobs of data, one from each kmsg_dumper invocation - and
> it would seem useful to keep them as separate entities)

So I would argue that what we'd want is actually more of a mix of the two.

You want to have a ring of events, and into that ring you also have a
"this event has been read" pointer. And you _never_ overwrite entries
that haven't been read yet, because quite frankly, if you get some
nasty memory corruption, you may end up with a thousand oopses in
rapid succession, and the latter ones are likely to be just fallout
from the earlier ones. So you definitely don't want to overwrite the
earlier ones, because they are more likely to contain the clues about
the actual original cause.

At the same time, you do want to have the capability of saying "I've
seen this", and let it be overwritten. For example, if we end up
teaching syslogd or something like that to use this, syslogd would
write the oops to disk, do a fdatasync() on the oops file, and after
it's stable on disk it can mark it "read".

Also, since this is very much about persistent storage, I think any
events from a previous boot that still exists should be marked "read".
You still want to be able to read them (so marking something "read"
does not mean that it goes away), but if a new oops happens, you don't
want some old entries from long ago to stop it from being written to
persistent storage. So if you don't have any syslogd or any other tool
that saves things to disk, you'd still get the new oopses into
persistent storage.

Doesn't that sound like the best of both worlds?

                         Linus
