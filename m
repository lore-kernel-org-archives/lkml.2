Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab1LGSy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 13:54:59 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51561 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757925Ab1LGSy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 13:54:57 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzRz6DcmP8uYaeYAUkpBfePZTYQg-hvERnA9huCQu4X3g@mail.gmail.com>
References: <20111206235815.GA21764@www.outflux.net>
	<CA+55aFzRz6DcmP8uYaeYAUkpBfePZTYQg-hvERnA9huCQu4X3g@mail.gmail.com>
Date: Wed, 7 Dec 2011 10:54:55 -0800
X-Google-Sender-Auth: N7hlPZNOlFPw_HsCMl7fjvR8gf8
Message-ID: <CAGXu5j+F0Zr=xORUxXfqDsivAfv4WH872pnUERC8zPE=GET64Q@mail.gmail.com>
Subject: Re: [PATCH v2011.1] fs: symlink restrictions on sticky directories
From: Kees Cook <keescook@chromium.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Rik van Riel <riel@redhat.com>,
        Federica Teodori <federica.teodori@googlemail.com>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 7, 2011 at 10:41 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Dec 6, 2011 at 3:58 PM, Kees Cook <keescook@chromium.org> wrote:
>> A long-standing class of security issues is the symlink-based
>> time-of-check-time-of-use race, most commonly seen in world-writable
>> directories like /tmp.
>
> Ugh. I really dislike the implementation.
>
> Wouldn't it be much nicer to instead actually use the symlink
> protection fields, and make the rules be:
>
>  - creating a symlink as root does the traditional "lrwxrwxrwx" thing
>  - creating a symlink in a directory you own similarly does "lrwxrwxrwx"
>  - creating a symlink anywhere else (which implies either sticky or
> world-writable directory) does "lrwx------", so only you can use it.
>
> That seems to be much nicer semantics, and makes the protection
> *visible* instead of some kind of hacky run-time random behavior
> depending on some invisible config option that people aren't even
> aware of.
>
> Of course, it needs to handle renames too (and maybe lchown?), and it
> would still need to be an option you enable explicitly, but it seems
> much more polite to make things like this something you can actually
> see.
>
> No, I have not thought this through deeply, but I really dislike your
> kind of "change random semantics in ways that are very hidden and
> subtle". The symlink protection approach seems to be much less hidden
> and subtle, and should result in largely the same result.
>
> Notably, you can install a system without it on, and turn it on even
> after install - who cares if there are *long-term* symlinks with
> lrwxrwxrwx and that thus allow all access, it's the racily-created
> ones we need to worry about, so it should actually be perfectly ok to
> enable the symlink creation protection dynamically. In fact, it could
> be a inheritable per-*process* (or per-container) flag rather than a
> global flag that says how symlink creation acts.
>
> I dunno.

This seems like a much deeper and wider change. This would expand it
to non-sticky, non-world-writable directories as well, meaning
symlinks on fileservers couldn't be managed by non-directory owners
any more, etc. I think there would be a lot of negative fall-out from
that.

Also it wouldn't track the state of a potentially dangerous
environment. Creation isn't the problem; existing is the problem. As
an attacker, I could: "mkdir /tmp/foo; ln -s /etc/shadow
/tmp/foo/evil-symlink; mv /tmp/foo/evil-symlink /tmp" and suddenly the
lrwxrwxrwx would follow the mv. To fix this we'd have to change the
permissions across a move, or other weird hidden behaviors.

Given that the patch is tweaking what "sticky directory" means, I
don't think it's impolite. Only attackers have ever depended on this
behavior, so let's just eliminate it.

-Kees

-- 
Kees Cook
ChromeOS Security
