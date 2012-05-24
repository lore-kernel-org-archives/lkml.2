Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab2EXOGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 10:06:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52982 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab2EXOGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 10:06:49 -0400
Message-ID: <4FBE404B.2020702@zytor.com>
Date: Thu, 24 May 2012 07:06:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
References: <20120521185412.aca92107d0a8c4fdd8474e34@canb.auug.org.au> <20120521091257.GF31407@gmail.com> <20120522182542.655b939d96a8eb67390abb9a@canb.auug.org.au> <20120523153536.GD26974@gmail.com> <20120524171604.0d98284f3affc643e9714470@canb.auug.org.au>
In-Reply-To: <20120524171604.0d98284f3affc643e9714470@canb.auug.org.au>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/mixed;
 boundary="------------010002030405040302010509"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010002030405040302010509
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05/24/2012 12:16 AM, Stephen Rothwell wrote:
> 
> OK, clearly something is wrong :-( There could well be a problem with my
> toolchain.
> 

Apparently so... this is troublesome because it means that we have
silently built broken kernels not just with ld 2.22.52.0.x but with
older lds as well.

What originally made the ld problems surface was actually checking that
we didn't run into any absolute symbols we didn't know about, which
previously was supposed to be done by developers manually, i.e. never
done.  This is extremely serious because it means that a kernel compiled
with CONFIG_RELOCATABLE doesn't actually relocate.

The workaround -- and it is a workaround -- is to take these symbols as
they appear and add them to the [S_REL] whitelist in
arch/x86/tools/relocs.c.  This is the same workaround as existed before,
the only difference is that we are now enforcing it.

A patch for this particular subcase is attached and I will commit it to
tip:x86/urgent.

> $ i386-linux-ld --version
> GNU ld (GNU Binutils) 2.21
> Copyright 2010 Free Software Foundation, Inc.
> This program is free software; you may redistribute it under the terms of
> the GNU General Public License version 3 or (at your option) a later version.
> This program has absolutely no warranty.

> Invalid absolute R_386_32 relocation: jiffies
> make[3]: *** [arch/x86/boot/compressed/vmlinux.relocs] Error 1
> make[3]: *** Waiting for unfinished jobs....
> make[2]: *** [arch/x86/boot/compressed/vmlinux] Error 2
> make[1]: *** [bzImage] Error 2
> make: *** [sub-make] Error 2

jiffies is yet another symbol created by the linker script.  This one in
particular is created outside any section, so it isn't all that strange
that some versions of the linker created it absolute.  Again, such a
kernel would have malfunctioned if relocated.

The really disturbing part of this one is that it shows that these
problems covers multiple GNU ld versions.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


--------------010002030405040302010509
Content-Type: text/x-patch;
 name="0001-x86-relocs-Add-jiffies-and-jiffies_64-to-the-relativ.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-x86-relocs-Add-jiffies-and-jiffies_64-to-the-relativ.pa";
 filename*1="tch"

>From a8040166e638e3d5d982e339e20d1569641ce404 Mon Sep 17 00:00:00 2001
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 24 May 2012 07:01:38 -0700
Subject: [PATCH] x86, relocs: Add jiffies and jiffies_64 to the relative
 whitelist

The symbol jiffies is created in the linker script as an alias to
jiffies_64.  Unfortunately this is done outside any section, and
apparently GNU ld 2.21 doesn't carry the section with it, so we end up
with an absolute symbol and therefore a broken kernel.

Add jiffies and jiffies_64 to the whitelist.

The most disturbing bit with this discovery is that it shows that we
have had multiple linker bugs in this area crossing multiple
generations, and have been silently building bad kernels for some time.

Link: http://lkml.kernel.org/r/20120524171604.0d98284f3affc643e9714470@canb.auug.org.au
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/tools/relocs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index b8f7c65..b685296 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -71,6 +71,7 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
 	"__(start|stop)_notes|"
 	"__end_rodata|"
 	"__initramfs_start|"
+	"(jiffies|jiffies_64)|"
 	"_end)$"
 };
 
-- 
1.7.6.5


--------------010002030405040302010509--
