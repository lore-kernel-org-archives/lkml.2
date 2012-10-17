Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab2JQW02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 18:26:28 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:53659 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab2JQW01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 18:26:27 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
Date: Wed, 17 Oct 2012 18:26:25 -0400
Message-ID: <CA+5PVA7nio3D2sivVV6h7_gHEsehhMb5_Y=GTwsov3dEmkhtUQ@mail.gmail.com>
Subject: Re: RFC: sign the modules at install time
From: Josh Boyer <jwboyer@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 4:36 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> This was based on the complaint from Davem that the "make
> allmodconfig" build got way slower because module signing takes a
> while.
>
> And quite frankly, the whole "extra strip and sign" thing at modpost
> time was just nasty ugly code.
>
> Why don't we do something *much* simpler? We already have a
> conditional stripping of modules (that whole INSTALL_MOD_STRIP) logic,
> and it really simplifies everything if we just do something very
> similar for the signing of modules. At "make modules_install" time,
> exactly like the stripping is done.

That is indeed simpler for the "build your own kernel" set of people.
There's really nothing wrong with doing it from that perspective.  It's
a bit less safe than what David has now, but it achieves the goal of
making kernel _builds_ faster.

> Sure, it means that if you want to load modules directly from your
> kernel build tree (without installing them), you'd better be running a
> kernel that doesn't need the signing (or you need to sign things
> explicitly). But seriously, nobody cares. If you are building a module
> after booting the kernel with the intention of loading that modified
> module, you aren't going to be doing that whole module signing thing
> *anyway*. Signed modules make sense when building the kernel and
> module together, so signing them as we install the kernel and module
> is just sensible.

Right, if you're building your own.

> It seems to work for me from my (very very limited) testing. Comments?

The downside is that it won't work for distros.  Or at least the distros
using RPM's debuginfo subpackage mechanism.  There's a blog post here:

http://jwboyer.livejournal.com/44787.html

that covers why in greater detail, but the short if it is that the
kernel is built by RPM, installed into the RPM_BUILD_ROOT, and _then_
the debuginfo generation is done.  So that strips the signature off of
the module at that point and the final kernel RPM winds up with no
signed modules.

I'll cleanup the patch we're currently carrying in Fedora and send it
to the list tomorrow.  My apologies for not getting it done today, but
I'm a bit jet lagged and trying to catch up on other things after being
gone for a few days.

josh
