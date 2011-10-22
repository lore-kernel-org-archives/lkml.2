Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab1JVSdB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 14:33:01 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47476 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1JVSc7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 14:32:59 -0400
MIME-Version: 1.0
In-Reply-To: <20111022172450.0BCCE2C0A9@topped-with-meat.com>
References: <20111021213916.914462C0A5@topped-with-meat.com>
 <CA+55aFy3ALC34AyrsHi9yjBgRMwg9G5w2PhDfr_JVti1M8GbNQ@mail.gmail.com> <20111022172450.0BCCE2C0A9@topped-with-meat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 22 Oct 2011 21:32:38 +0300
X-Google-Sender-Auth: 3v9D16GcK9XNuFRz0ZSjrauZ5pA
Message-ID: <CA+55aFx_9D8jY2sqcZ+Tm305W9d8o+ZhEv8XNWuN4--S2bqRwQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] LSM: Do not apply mmap_min_addr check to PROT_NONE mappings
To: Roland McGrath <roland@hack.frob.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, selinux@tycho.nsa.gov,
        John Johansen <john.johansen@canonical.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 22, 2011 at 8:24 PM, Roland McGrath <roland@hack.frob.com> wrote:
>
> It's exactly the case that I did mention: an application's own attempt to
> ensure robustness by doing a PROT_NONE mmap of the [0,0x10000) region.  An
> application cannot presume that this region is already precluded from being
> used by any non-MAP_FIXED mmap across all systems and configurations, so
> it's defensive coding to explicitly block it off with a PROT_NONE mapping.

Quite frankly, I don't think that's an interesting case.

The app can try to be robust by doing the mmap(PROT_NONE), but if that
fails, then the app should just let it go.

Why should the kernel make its own security more complex (and thus fragile)?

So I think that it's perfectly ok for some user-level app to do

    mmap(NULL, 64k, PROT_NONE, MAP_FIXED|MAP_ANON, -1, 0);

to try to create a PROT_NONE mapping at NULL, but then just ignore the
error if that fails. That way the app can handle the case of "maybe
the system is set up to allow NULL mappings, so I'll harden it
myself".

But that's no reason for the kernel to *allow* the mapping.

And if the app actually *fails* due to the mmap failing, then the app
is just buggy and stupid. So again, there's no reason for the kernel
to allow it.

IOW, either the app is fine with the kernel not letting it do a
PROT_NONE mapping, or the app is so braindamaged as to not be worth
worrying about. In neither case do I actually see any reason to apply
your patch.

So I was looking for some *other* reason for the patch.

Because, quite frankly, "security hardening" is absolutely *not* a
reason to do it - complex security is not "hardened", it's just
"harder and more likely to be buggy".

                  Linus
