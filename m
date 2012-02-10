Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab2BJUht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:37:49 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53318 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab2BJUhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:37:48 -0500
MIME-Version: 1.0
In-Reply-To: <20120210201850.GA26892@m.redhat.com>
References: <1328873119-21553-1-git-send-email-jolsa@redhat.com>
 <1328895795.25989.29.camel@laptop> <CA+55aFxgPXjGh0GSHaUGm6-Pfdjjk=PAP7HMuZHcFGE92VutUQ@mail.gmail.com>
 <20120210192714.GE4998@infradead.org> <20120210194426.GA17650@elte.hu> <20120210201850.GA26892@m.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 10 Feb 2012 12:37:28 -0800
X-Google-Sender-Auth: WuQEi5QvcN4rXZIO7sTzrPSN6WQ
Message-ID: <CA+55aFzhenNyPUzAVpXhuxfVpAuowY+OcvPGyfg8_o9NN4SDtw@mail.gmail.com>
Subject: Re: [RFC 0/5] kernel: backtrace unwind support
To: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 12:18 PM, Jiri Olsa <jolsa@redhat.com> wrote:
>
> yep, looks interesting.. not sure about the mathematical proof though ;)

Well, I can already say what the old code did horribly horribly wrong:

 - *all* stack accesses need to go through a validation function, they
can never *ever* just try to access the stack.

    The validation function really needs to really check the full
range of the stack area, not something random.

 - all dwarf information accesses need to similarly validate the
access, and accept that sometimes the dwarf info is simply missing or
actively wrong.

Basically, by the time a fault happens, EVERY SINGLE PIECE OF DATA YOU
ACCESS needs to be thought of as untrusted. Because it really is. We
took some kind of kernel fault, there clearly is a bug somewhere. The
old unwinder thing just had the approach that "my code is perfect, and
I can trust the unwind data", which was fundamentally incorrect and
wrong.

The code needs to be really *obviously* correct and really crazy anal
at the same time. And it's *hard* to write careful code in a way that
makes it obvious too.

It's triply hard to do it when you start off from code from user space
written by people who simply don't care and don't even have the same
kinds of issues we do in the kernel.

The code we have now isn't exactly pretty either, but it has two
*huge* advantages:

 - it's tested in real life and thus largely trusted

 - it's pretty simple, and it does have a lot of stack validation.

                    Linus
