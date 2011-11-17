Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab1KQS5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 13:57:39 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52551 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab1KQS5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 13:57:37 -0500
MIME-Version: 1.0
In-Reply-To: <874nybqo0o.fsf@rustcorp.com.au>
References: <20111108214452.28884.14840.stgit@miche.sea.corp.google.com>
	<20111108214504.28884.61814.stgit@miche.sea.corp.google.com>
	<874nybqo0o.fsf@rustcorp.com.au>
Date: Thu, 17 Nov 2011 10:57:37 -0800
Message-ID: <CAB8RdapbaueyWLJuJDE_ZdvLkRNM4sQHTxgmgO=jrnXZ6YPSmA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] hvc_init(): Enforce one-time initialization.
From: Miche Baker-Harvey <miche@google.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Anton Blanchard <anton@samba.org>, Amit Shah <amit.shah@redhat.com>,
        Mike Waychison <mikew@google.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Eric Northrup <digitaleric@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty, Michael, Stephen, et al,

Thanks for your comments on these patches.

For what I'm trying to do, all three patches are necessary, but maybe
I'm going about it the wrong way. Your input would be appreciated.
I'm in no way claiming that these patches are "right", just that it's
working for me, and that what's in the current pool is not.

What I'm trying to do is:
On X86,
under KVM,
start a virtio console device,
with multiple ports on the device,
at least one of which is also a console (as well as ttyS0).

(Eventually, we want to be able to add virtio console ports on the
fly, and to have multiple virtio console ports be consoles.)

When all three of the patches are in place, this works great. (By
great, I mean that getty's start up on all of ttyS0, hvc0 and hvc1,
and console output goes to ttyS0 and to hvc0.
"who" shows three users:  ttyS0, hvc0, and hvc1.
"cat /proc/consoles" shows both ttyS0 and hvc0.
I can use all three getty's, and console output really does appear on
both the consoles.

Based on Rusty's comments, I tried removing each of the patches
individually. Here's what happens today. I've seen other failure modes
depending on what precisely I'm passing the guest.
There's three patches:
1/3 "fix locking of vtermno"
2/3 "enforce one-time initialization with hvc_init
"3/3 "use separate struct console * for each console"

If I remove the "fix locking of vtermno", I only get one virtio
console terminal.  "who" shows the ttyS0 and the hvc0, and I can log
into the gettys on both. I don't get the second virtio console getty.
Interestingly, hvc0 shows up in /proc/consoles twice, and in fact the
console output is dumped twice to hvc0 (as you'd expect from looking
at printk.c, each line appears twice, followed by the next line.)

If I remove the "enforce one-time initialization with hvc_init" patch,
which makes sure only a single thread is doing the hvc_init, and gates
anyone from continuing until it has completed, I get different
failures, including hangs, and dereferences of NULL pointers.

If I remove the "use separate struct console * for each console"patch,
what I'm seeing now is that while all of ttyS0, hvc0, and hvc1 are
present with gettys running on them, of the three, only ttyS0 is a
console.

I also re-tried each patch alone:

For either the "fix locking of vtermno" or "use separate struct
console * for each console" patches (in other words, not the "enforce
one-time initialization with hvc_init" patch), I panic during boot
with a null dereference.

For just the "enforce one-time initialization with hvc_init" patch, I
see all of hvc0, hvc1, and ttyS0 in a "who" listing, but only one
getty is available with an hvc.  Also, an echo to *either* "hvc0"
or"hvc1" appears on the single hvc getty.  Also, no virtio console
appears in the /proc/consoles list.

Michael, I agree with you about the comment and naming of the mutex
around hvc_init.
Stephen, the duplicate messages are not something I'm seeing.  It's
probably the case that there are two "consoles" (registered in printk)
that have the same tty as their target.  I've added a call to
register_console in hvc_alloc, and I'm guessing that something in your
system is making your tty register as a console in hvc_instantiate,
and then it's re-registered in hvc_alloc, but I really am not sure. We
don't have earlyprintk support, so the register_console in
hvc_instantiate is never called.

Miche
