Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966385Ab2EOSlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:41:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49233 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966258Ab2EOSlZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:41:25 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzrJNd5J7i3Rp7-ctc=bDn5GTWu=H1xyCgGZ-rzu74Gbw@mail.gmail.com>
References: <1336963631-3541-1-git-send-email-zohar@us.ibm.com> <CA+55aFzrJNd5J7i3Rp7-ctc=bDn5GTWu=H1xyCgGZ-rzu74Gbw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 May 2012 11:41:03 -0700
X-Google-Sender-Auth: b89zzU781_eDNNSt5QX87-9xfy0
Message-ID: <CA+55aFyPPZ0wayqPMCZtfP1w9nN-GnKJxYc9i_XM_Qk8d-zJzg@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
To: Mimi Zohar <zohar@us.ibm.com>
Cc: linux-security-module@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 10:19 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>  - move the whole call to security_file_mmap() to outside the
> mmap_sem, and test the *suggested* address (which is not the same as
> the final address)

Actually, I think I have a simpler approach.

We already actually have two *different* security_file_mmap() calls:
it's just that currently the difference is shown by the last argument
to the function ("addr_only").

Which is totally static by call-site.

And the ones that have addr_only set are all inside the mmap_sem region.

So here's my new suggestion, which avoids the semantic changes: let's
just split that "security_file_mmap()" call into two. One that checks
the file, and one that checks the address.

And we'll continue to check the address within the mmap_sem region,
but nobody will care, because that one doesn't need any other locking.

So we'll just split the file check - along with the ima_file_mmap() -
into the "security_mmap_file()" function (no "addr_only" argument),
and move that outside the lock.

And then the address-only check (let's call it "security_mmap_addr()")
we leave at the place we *currently* do our security_file_mmap()
check, along with (obviously) the calls that currently have
"addr_only=1" and only give the address anyway).

That cleans up the whole nasty piece of crap calling convention too,
getting rid of idiotic unreadable code like

    ret = security_file_mmap(NULL, 0, 0, 0, new_addr, 1);

and replacing it with

    ret = security_mmap_addr(new_addr);

which actually shows what it is doing.

Hmm? That looks like a fairly mechanical conversion, and we could
start with Mimi's patch that already splits it up that way (except it
calls "security_mmap_file()" ima_file_mmap() and doesn't call  the LSM
function pointer there)

                   Linus
