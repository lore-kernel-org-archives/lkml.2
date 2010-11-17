Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628Ab0KQDpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 22:45:47 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41708 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab0KQDpn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 22:45:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RX9UFkTP0/++RuD1+UIFfZ4NF9ETlskfmbQHaL1sAKmlKNoJwR5T/u5dcqVVJEsZCf
         16vo+QBOU2eOE8wyyxy4crhtfXvPPyABO172vHByuZftH6d7wU07kADWcMjh5i4v8W5Y
         lGCRtQKKPEaYQwr9NIOinRytdjwImLgY+wzS0=
MIME-Version: 1.0
Date: Tue, 16 Nov 2010 22:45:42 -0500
Message-ID: <AANLkTinop4_JT4JLtdmWkydPgDDU=TyZNbtiBbgeh1dj@mail.gmail.com>
Subject: Behavior of BUG() [Was: Re: [PATCH 2/5] of/fdt: add kernel command
 line option for dtb_compat string]
From: Arnaud Lacombe <lacombar@gmail.com>
To: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Cc: dirk.brandewie@gmail.com, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[CC: list reduced as starting a new thread, most on the context
removed as this concern a different issue.]

On Tue, Nov 16, 2010 at 7:16 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Tue, Nov 16, 2010 at 3:41 PM,  <dirk.brandewie@gmail.com> wrote:
>> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>> [...]
> The kernel needs to complain *loudly* if this occurs because it
> represents a bug.  I'm tempted to say use BUG, but that would halt the
> kernel and prevent any possibility of kernel log output.
> [...]
does it ? if CONFIG_BUG is not enabled and the arch has no define for
it, the default does _nothing_:

from `include/asm-generic/bug.h':

#else /* !CONFIG_BUG */
#ifndef HAVE_ARCH_BUG
#define BUG() do {} while(0)
#endif

#ifndef HAVE_ARCH_BUG_ON
#define BUG_ON(condition) do { if (condition) ; } while(0)
#endif
[...]

gcc is triggering about ~30 warnings (like [0]) on code path using
BUG(). Most of these path assume BUG() will never return, which is not
true.

The commit message introducing this behavior state:

commit c8538a7aa5527d02c7191ac5da124efadf6a2827
Author: Matt Mackall <mpm@selenic.com>
Date:   Sun May 1 08:59:01 2005 -0700

    [PATCH] remove all kernel BUGs

    This patch eliminates all kernel BUGs, trims about 35k off the typical
    kernel, and makes the system slightly faster.

    Signed-off-by: Matt Mackall <mpm@selenic.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

[...]

+config BUG
+       bool "BUG() support" if EMBEDDED
+       default y
+       help
+          Disabling this option eliminates support for BUG and WARN, reducing
+          the size of your kernel image and potentially quietly ignoring
+          numerous fatal conditions. You should only consider disabling this
+          option for embedded systems with no facilities for reporting errors.

So how should BUG() been used ?
 1) assuming it will never _ever_ return ?
 2) assuming it may return ?

if (1), its definition has to be changed, if (2) a lot of path have to be fixed.

Thanks in advance,
 - Arnaud

[0]: fs/dcache.c:1899:1: warning: control reaches end of non-void
function, line match an old revision, but the BUG() is still there.
