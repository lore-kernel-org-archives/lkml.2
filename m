Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab1FHV52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 17:57:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47998 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab1FHV5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 17:57:25 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1106081407440.10320@chino.kir.corp.google.com>
References: <BANLkTimq+h+WyboMbPGVH1uJuj64YuRLdw@mail.gmail.com>
 <alpine.DEB.2.00.1106081305430.10320@chino.kir.corp.google.com>
 <1307564248.4204.1013.camel@calx> <alpine.DEB.2.00.1106081407440.10320@chino.kir.corp.google.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Wed, 8 Jun 2011 17:57:04 -0400
Message-ID: <BANLkTi=jYTViMUQAN2cvyg_gfBkPwmWsJA@mail.gmail.com>
Subject: Re: 3.0.0-rc2-git1 -- BUG: sleeping function called from invalid
 context at mm/slub.c:847
To: David Rientjes <rientjes@google.com>
Cc: Matt Mackall <mpm@selenic.com>, David Howells <dhowells@redhat.com>,
        Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        John Johansen <john.johansen@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whoops, sent my previous reply as HTML... sorry!

On Wed, Jun 8, 2011 at 17:34, David Rientjes <rientjes@google.com> wrote:
> On Wed, 8 Jun 2011, Matt Mackall wrote:
>
>> > Not sure why this ever actually worked with apparmor if prepare_creds()
>> > does an unconditional GFP_KERNEL allocation since this codepath hasn't
>> > changed in at least a year and we're holding a spinlock from setrlimit.
>> > John?
>>
>> Probably a lack of people enabling (and using!) both apparmor and
>> might_sleep. I don't this would be caught by a randconfig boot test.
>>
>
> Right, CONFIG_DEBUG_SPINLOCK_SLEEP isn't enabled by default even though
> CONFIG_DEBUG_KERNEL is.  We should probably just allow prepare_creds() to
> take a gfp_t argument just like security_prepare_creds() and change
> existing callers to use GFP_KERNEL with the exception of those using
> setrlimit where we're always holding the spinlock.
>
> Documentation/security/credentials.txt says this:
>
>        To alter the current process's credentials, a function should first prepare a
>        new set of credentials by calling:
>
>                struct cred *prepare_creds(void);
>
>        this locks current->cred_replace_mutex and then allocates and constructs a
>        duplicate of the current process's credentials, returning with the mutex still
>        held if successful.  It returns NULL if not successful (out of memory).
>
> although that mutex doesn't exist.  David, any downsides to passing the
> gfp_t into prepare_creds()?

Are you sure that would actually help?  The bit about the "cred_replace_mutex"
seems to suggest that you would be locking a mutex *inside* of a spinlock, which
is not OK either, right?

I'm not all that familiar with the problematic code, but I think the
design is that the
code should call prepare_creds() *before* it takes the spinlock and then it can
decide inside the spinlock whether or not it actually needs to change
credentials.
I could be wrong, though.

Cheers,
Kyle Moffett
