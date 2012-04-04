Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab2DDRKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 13:10:46 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56530 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757099Ab2DDRKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 13:10:44 -0400
X-Sasl-enc: lueUlIdVNu0y1Cjtbar4SAm6Gniel67HVNKnn5R1w30V 1333559442
Message-ID: <1333559412.10230.67.camel@lenny>
Subject: Re: [PATCH] nextfd(2)
From: Colin Walters <walters@verbum.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Wed, 04 Apr 2012 13:10:12 -0400
In-Reply-To: <4F7C777E.10608@gmail.com>
References: <20120401125741.GA7484@p183.telecom.by>
	 <CAHGf_=pgpRrQA3-YVtS=h-Bjq2LyTFmYtKGxxWgwP0XWexnh2g@mail.gmail.com>
	 <4F7A3CC2.1040200@zytor.com> <4F7C777E.10608@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-04 at 09:31 -0700, KOSAKI Motohiro wrote:

> Ideally possible. but practically impossible. 2) people don't use a their
> own malloc. they only uses open sources alternative malloc. And, I think
> you have too narrowing concern. Even though malloc people adds a workaround,
> the standard inhibit to use it

What do you mean?  If as hpa says, the maintainer of e.g. google
tcmalloc added a call to pthread_atfork(), then code which uses
opendir() would start working.

>  and people may continue to use more dangerous
> RLIM_NOFILE loop. 1) I haven't seen _practical_ userland software uses such
> linux internal hacking. Almost all major software can run on multiple OSs.

Except that if you're using /proc/self/fd, you're already relying on
Linux-specific functionality.  So it's not burdensome to use "struct
linux_dirent" and O_DIRECTORY either.

In GLib we're presently doing the regular /proc+opendir() under
#ifdef __linux__:
http://git.gnome.org/browse/glib/tree/glib/gspawn.c#n932

Now I'd happily switch to hpa's fdwalk() implementation if I was aware
of someone using glib in combination with an alternative malloc hitting
this problem.

Basically I think hpa is right here, and it's not really worth adding
a new system call.

The thing is, even if it were added today, since we need to run on old
kernels, we'd have to carry the code to use the /proc trick
approximately forever.  And in the end all nextfd() would accomplish
would be a *third* case in the already messy ifdefs/fallbacks
in the various implementations of process spawning.


