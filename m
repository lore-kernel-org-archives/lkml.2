Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab2FWUqX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 16:46:23 -0400
Received: from ra.se.axis.com ([195.60.68.13]:35351 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508Ab2FWUqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 16:46:22 -0400
Date: Sat, 23 Jun 2012 22:46:18 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: cris: odd include in arch/cris/boot/compressed/misc.c
Message-ID: <20120623204618.GA9348@axis.com>
References: <1340413223.1773.146.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340413223.1773.146.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 03:00:23AM +0200, Paul Bolle wrote:
> Mikael, Jesper,

Hi!

> 0) Currently line 123 of arch/cris/boot/compressed/misc.c reads:
>     #include "../../../../../lib/inflate.c"
> 
> git blame tells me that line has read that way since commit
> 51533b615e605d86154ec1b4e585c8ca1b0b15b7 ("[...] CRIS update: new
> subarchitecture v32"), which predates release v2.6.13.
> 
> 1) When I try to jump to lib/inflate.c via that line in my $EDITOR, I
> see an error and nothing happens. When I check the depth, in
> directories, at which misc.c lives, I can't blame my $EDITOR.
>
> 2) And indeed, when I edit that line to read:
>     #include "../../../../lib/inflate.c"
> 
> my $EDITOR does correctly jump to lib/inflate.c. 
> 
> 3) This can be trivially fixed, and I'm happy to submit that trivial
> patch. But I do wonder what the compilers for cris know that my $EDITOR
> and x86 compiler doesn't. (I don't have a compiler for cris at hand.)
> Because, if I edit the comparable file for x86 to have a similar include
> look that way and try to build a kernel I get:
>
> [...]
>
>   CC      arch/x86/boot/compressed/misc.o
> arch/x86/boot/compressed/misc.c:131:51: fatal error: ../../../../../lib/decompress_inflate.c: No such file or directory
> compilation terminated.
> make[2]: *** [arch/x86/boot/compressed/misc.o] Error 1
> make[1]: *** [arch/x86/boot/compressed/vmlinux] Error 2
> make: *** [bzImage] Error 2
> 
> 4) What's going on here?

Heh, you're quite right, the path has been the same for a long time,
and the file has moved into this directory from one directory deeper,
so logically, we should get a compile error here.

However, the CRIS-port has a bunch of include paths, at different depths,
and it seems that one of them is used to pick up the relative path to
"lib/inflate.c".

I'll add the following to the CRIS-tree:


Correct include path for "lib/inflate.c"

The include path was one too deep to pick up the file from ".",
but some other include path obviously matched so there was no
compile error.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/boot/compressed/misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/cris/boot/compressed/misc.c b/arch/cris/boot/compressed/misc.c
index 548d886..5833d9f 100644
--- a/arch/cris/boot/compressed/misc.c
+++ b/arch/cris/boot/compressed/misc.c
@@ -120,7 +120,7 @@ extern int _end;
 static long free_mem_ptr = (long)&_end;
 static long free_mem_end_ptr;
 
-#include "../../../../../lib/inflate.c"
+#include "../../../../lib/inflate.c"
 
 /* decompressor info and error messages to serial console */
 
-- 
1.7.10


> Paul Bolle

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
