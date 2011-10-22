Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab1JVSle (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 14:41:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39994 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1JVSld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 14:41:33 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFx_9D8jY2sqcZ+Tm305W9d8o+ZhEv8XNWuN4--S2bqRwQ@mail.gmail.com>
References: <20111021213916.914462C0A5@topped-with-meat.com>
 <CA+55aFy3ALC34AyrsHi9yjBgRMwg9G5w2PhDfr_JVti1M8GbNQ@mail.gmail.com>
 <20111022172450.0BCCE2C0A9@topped-with-meat.com> <CA+55aFx_9D8jY2sqcZ+Tm305W9d8o+ZhEv8XNWuN4--S2bqRwQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 22 Oct 2011 21:41:08 +0300
X-Google-Sender-Auth: UdWT_apOfCutAK9sXhjr8FTATMg
Message-ID: <CA+55aFxNOS7ZTq9wgQEXNue9wZMqymdWSN+zTuXB-gLgX0gRNg@mail.gmail.com>
Subject: Re: [PATCH 1/2] LSM: Do not apply mmap_min_addr check to PROT_NONE mappings
To: Roland McGrath <roland@hack.frob.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, selinux@tycho.nsa.gov,
        John Johansen <john.johansen@canonical.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 22, 2011 at 9:32 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So I was looking for some *other* reason for the patch.
>
> Because, quite frankly, "security hardening" is absolutely *not* a
> reason to do it - complex security is not "hardened", it's just
> "harder and more likely to be buggy".

Btw, if the only concern is "you don't want to elevate the selinux
denial to be some user-visible thing", then I'd suggest attacking
*that* issue directly.

For example, maybe we could fail the PROT_NONE mmap (ie not actually
create any mapping at all, and certainly not create anything that is
then mprotectable), but return success and not elevate it to be
reported.

But then it really is important to return success, because otherwise
it would be a "silent probe" of the security model (ie a bad user
could use the mmap(PROT_NONE) to see if min_mmap_addr is on or not
without triggering any selinux warnings).

And unlike your patch, it wouldn't open up some new interface
(mprotect) to worry about.

So I think it might be valid to say "always allow mmap(PROT_NONE)
under mmap_min_limit, by simply turning it into a no-op".

                       Linus
