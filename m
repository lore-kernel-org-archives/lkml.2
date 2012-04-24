Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab2DXQM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 12:12:28 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:40395 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047Ab2DXQMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 12:12:25 -0400
Message-ID: <4F96D0E7.9060000@msgid.tls.msk.ru>
Date: Tue, 24 Apr 2012 20:12:23 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ian Kent <raven@themaw.net>, "stable@kernel.org" <stable@kernel.org>,
        autofs@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Breaking userspace? Re: 3.0.24 broke aufofs on mixed 32/64bit
 environment
References: <4F94222C.6080608@msgid.tls.msk.ru> <1335172741.2226.10.camel@perseus.themaw.net> <4F958352.7050106@msgid.tls.msk.ru> <4F95897B.2040103@msgid.tls.msk.ru> <4F959A5A.8070907@msgid.tls.msk.ru> <CA+55aFyQ4y9jyRXyejKwtf3yXJX52hQkLuwJ5=jfQM+yLkBNMw@mail.gmail.com>
In-Reply-To: <CA+55aFyQ4y9jyRXyejKwtf3yXJX52hQkLuwJ5=jfQM+yLkBNMw@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.04.2012 19:08, Linus Torvalds wrote:
> On Mon, Apr 23, 2012 at 11:07 AM, Michael Tokarev <mjt@tls.msk.ru> wrote:
[]
>> Kernel has been shipping with this brokeness for quite
>> some time, namely, since introduction of autofs4, dated
>> Mon Mar 27 01:14:55 2006 -0800 (commit 5c0a32fc2cd0).
> 
> Absolutely. That said, we I did have several reports of it making it
> possible to use a 64-bit kernel with user land from a couple of
> regular distributions. So it's a real fix, and I'd like to keep it
> around some way too.

I run 64bit kernel and 32bit userland for several years.  Initially
we had a bunch of machines (servers) not supporting 64bits at all,
and I wanted to keep userspace across all servers the same (so I
can roll eg updates to all them at once).  Nowadays it more historic,
but still works, -- I just updated the kernel (to support more
memory etc), and a few applications which actually _use_ that memory,
the rest of the userspace is 32bits still.

The same 32/64 environment is running on my workstations too.

>> Main userspace user of this interface adopted long ago
>> too, and has been in wide use for years as well.
> 
> Actually, that's just not true. The *main* users of the interface seem
> to have never fixed anything. As far as I know, neither the upstream
> autofs tools nor several of the big distributions ever had patches to
> make 32-bit autofs work with the old broken 64-bit compat layer.

And this is actually not the case -- that's what started this thread,
when I tried to upgrade a 64bit kernel on one of our production servers
to 3.0.28, 32bit autofs, which worked just fine before, stopped working.
Hence this bugreport/discussion.

The userspace is running debian stable (squeeze).  Debian has autofs
package based on upstream 5.0.4 version.  That (upstream) version has
the "bug-compat" code in it, in daemon/automount.c:

static size_t get_kpkt_len(void)
{
        size_t pkt_len = sizeof(struct autofs_v5_packet);
        struct utsname un;

        uname(&un);

        if (pkt_len % 8) {
                if (strcmp(un.machine, "alpha") == 0 ||
                    strcmp(un.machine, "ia64") == 0 ||
                    strcmp(un.machine, "x86_64") == 0 ||
                    strcmp(un.machine, "ppc64") == 0)
                        pkt_len += 4;

        }

        return pkt_len;
}

This is exactly the workaround for this very bug in kernel.

I don't know how old this code is, but it definitely is in the
5.0.1 upstream tarball, and the file there is dated
Feb-20, 2007 - at least 3 years after the initial bug in kernel.

> So this is a regression, but it does seem to be the case that the
> workarounds for the old broken kernel behavior were fairly limited in
> distribution too. Which makes me wonder if

No, this is unfortunately not the case: the whole issue here is that
the _only_ userspace of this interface has the fix for broken kernel
for at least 5 years already, or maybe more (with kernel bug being
6 years old).

>  (a) we could make it a kernel boot command line option (which would
> be better than a hardcoded compile-time config option)
> 
>  (b) which distros did the work-around for the old broken 32-bit user
> space compat behavior, and how widely spread is that (which would
> likely imply which way the *default* behavior should be)

That'd be all distros shipping 5.0.1 or later version, which, I think,
is all current and previous distros.  5.0.1-pre1 did not have this
workaround.

And previos, v4 version, did not know this interface.

> But yes, we'll need to fix it somehow in the kernel, even if it might
> be just a horrible hack.

I'm not sure it really needs fixing, since the only user of this interface
has a workarond for this alomst since the time the bug has been introduced.

The only real solution to this - in my humble opinion anyway - is to make
the _next_ version of the interface right, but keep current one broken but
compatible.

> Sadly, the autofs interface is *disgusting*. It just uses a pipe, so
> the kernel side of autofs doesn't even *see* how big the read will be.
> It just sees a random pipe, never seeing the read itself. So we can't
> just say "oh, he's doing a 300-byte read, so he must be the old broken
> interface". But if somebody figures out how to detect that
> automatically in the kernel, that would be really good too.

No, just keep it the way it is now.  And design new iface right :)

Thanks,

/mjt
