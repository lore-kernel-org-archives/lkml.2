Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635Ab1LOWe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 17:34:56 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47099 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759565Ab1LOWey convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 17:34:54 -0500
MIME-Version: 1.0
In-Reply-To: <1323988092.22363.11.camel@localhost>
References: <87obwof06x.fsf@tucsk.pomaz.szeredi.hu> <87ipljcjc2.fsf@tucsk.pomaz.szeredi.hu>
 <CA+55aFxuGPj5rhFYt3O1yci_CqHe+Xs8U7WrWOih2W9U73N69w@mail.gmail.com>
 <20111215084050.GQ2203@ZenIV.linux.org.uk> <87fwgmjjr9.fsf@tucsk.pomaz.szeredi.hu>
 <87aa6ujjf6.fsf@tucsk.pomaz.szeredi.hu> <20111215200631.GA2379@Neptun> <1323988092.22363.11.camel@localhost>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 15 Dec 2011 14:34:32 -0800
X-Google-Sender-Auth: H8yxrtCNlrmeoW9rHjefbeipk84
Message-ID: <CA+55aFz6vpv01OAGcq9n8Q4bVgihqSiwz2qwNjBAHeFFvUD5Hg@mail.gmail.com>
Subject: Re: [PATCH resend] audit: fix mark refcounting
To: Eric Paris <eparis@redhat.com>
Cc: Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 2:28 PM, Eric Paris <eparis@redhat.com> wrote:
>
> How expensive is an atomic_inc()/atomic_dec() combo?  If it's mostly
> free we can do it in the right place.

It's pretty expensive, but it depends a lot on cache details etc. It
involves a memory barrier on x86 too, and depending on architecture it
might be anything from 150 cycles (P4 - but by now probably nobody
cares) to "a few tens" of cycles (roughly 10-35 on modern x86).

The cache miss itself - if it happens - is not counted in the above cost.

A totally uncontended spinlock is actually cheaper than a pair of
atomic ops. So if it's a hot path it probably should be moved
elsewhere if possible.

                       Linus
