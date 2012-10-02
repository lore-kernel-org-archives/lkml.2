Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab2JBWiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:38:13 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:61200 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2JBWiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:38:11 -0400
MIME-Version: 1.0
In-Reply-To: <CABA=pqdRwA5_AVysq_0ynuChQ++oQ0j2BWyPg4Qq=LjYa-7P2A@mail.gmail.com>
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com>
 <4FE37194.30407@redhat.com> <4FE8B8BC.3020702@iki.fi> <4FE8C4C4.1050901@redhat.com>
 <4FE8CED5.104@redhat.com> <20120625223306.GA2764@kroah.com>
 <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com>
 <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com> <CABA=pqdRwA5_AVysq_0ynuChQ++oQ0j2BWyPg4Qq=LjYa-7P2A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 2 Oct 2012 15:37:49 -0700
X-Google-Sender-Auth: Qam_ZyQcGcRhL1Su-5ZUskvYHzg
Message-ID: <CA+55aFwi2F1PYv39FxTKz1zu2tFqVDSAAxeSRW1BVK+==5H-6g@mail.gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
To: Ivan Kalvachev <ikalvachev@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 2:03 PM, Ivan Kalvachev <ikalvachev@gmail.com> wrote:
>
> I'm not kernel developer and probably my opinion would be a little
> naive, but here it is.
>
> Please, make the kernel load firmware from the filesystem on its own.

We probably should do that, not just for firmware, but for modules
too. It would also simplify the whole "built-in firmware" thing

Afaik, the only thing udev really does is to lok in
/lib/firmware/updates and /lib/firmware for the file, load it, and
pass it back to the kernel. We could make the kernel try to do it
manually first, and only fall back to udev if that fails.

Afaik, nobody ever does anything else anyway.

I'd prefer to not have to do that, but if the udev code is buggy or
the maintainership is flaky, I guess we don't really have much choice.

Doing the same thing for module loading is probably a good idea too.
There were already people (from the google/Android camp) who wanted to
do module loading based on filename rather than the buffer passed to
it, because they have a "I trust this filesystem" model.

> I've heard that the udev userland piping of firmware is done to avoid
> some licensing issues.

No, I think it was mainly a combination of

 - some people like the whole "let's do things in user land" model
even when it makes things more complicated

 - we do tend to try to punt "policy" issues to user space, and the
whole "/lib/firmware" location is an example of such a policy issue.

along with the fact that we already had the hotplug model for these
kinds of things (eg module loading used to actually have a big user
space component that did the whole relocation etc, so we had real
historical reasons to do that in user space)

Does anybody want to try to cook up a patch, leaving the udev path as
a fallback?

We already have the case of "builtin firmware" as one option, this
would go after that..

                 Linus
