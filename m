Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab0ESMFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 08:05:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab0ESMFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 08:05:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1274135154-24082-3-git-send-email-walken@google.com>
References: <1274135154-24082-3-git-send-email-walken@google.com> <1274135154-24082-1-git-send-email-walken@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 02/10] rwsem: fully separate code pathes to wake writers vs readers
Date: Wed, 19 May 2010 13:04:42 +0100
Message-ID: <2767.1274270682@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> wrote:

> + readers_only:
> +	if (!downgrading) {
> +

There's an unnecessary blank line here.

> +		/* if we came through an up_xxxx() call, we only only wake
> +		 * someone up if we can transition the active part of the
> +		 * count from 0 -> 1
> +		 */
> + try_again_read:

I hate code that jumps into braced blocks with goto.  Would it be possible for
you to do:

	readers_only:
		if (downgrading)
			goto wake_readers;
	...
	wake_readers:
		/* Grant an infinite number of read locks to the readers at the front
	...

instead, please?

Also, since the labels 'undo' and 'try_again' are now specific to the writer
path, can you label them 'undo_write' and 'try_again_write' just to make it
obvious?

Other than that, no particular objections to this patch.

David
