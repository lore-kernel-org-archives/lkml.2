Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760611Ab0KRV11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:27:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756899Ab0KRV10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:27:26 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1011182140510.8526@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1011181957500.3651@swampdragon.chaosbits.net>
 <AANLkTi=McRJSHp8==o+=coK0_pK5s9dwUgLmrkohSmTX@mail.gmail.com> <alpine.LNX.2.00.1011182140510.8526@swampdragon.chaosbits.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Nov 2010 13:18:58 -0800
Message-ID: <AANLkTim1MChiEa9rBL0ZfSCak6G2x4ivK47Svd6swEBS@mail.gmail.com>
Subject: Re: [PATCH][resend][SCSI] Reduce number of sequential pointer derefs
 in scsi_error.c and reduce size as well
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-kernel@vger.kernel.org, Eric Youngdale <eric@andante.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mike Anderson <andmike@us.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 12:49 PM, Jesper Juhl <jj@chaosbits.net> wrote:
>
> Fair enough. Seeing your version of this and looking a second time at mine
> I have to agree completely.
> You are absolutely right in stating that the compiler will handle this
> just fine, so it's only a readabillity issue and your version is a *lot*
> more readable than what I came up with.

Btw, one thing to look out for is all those function calls: it really
looks like many of them would be better off not having to dereference
the thing inside each helper function, but just have it dereferenced
in the caller.

You might trying passing in "struct Scsi_Host *host" to a lot of those
helper functions in addition to the 'scmd' part. There's a lot of
"scmd->device->host" going on, and even if you remove some of them
_within_ a function, if you really want to get rid of them you should
probably do one of them in the caller.

That's why the queuecommand() function was changed to take

    struct Scsi_Host *h, struct scsi_cmnd *

as its arguments, because that host is used so commonly. And passing
two arguments is usually free (ie almost all architectures pass it in
registers), and that host variable almost always already exists in the
caller because the caller already needed it.

So if you changed the functions that only take "scsi_cmnd *" as an
argument to match the new queuecommand() interface, I bet you'd get
more cleanups. And the interfaces would match.

              Linus
