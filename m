Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab0FEEBe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 00:01:34 -0400
Received: from ozlabs.org ([203.10.76.45]:40895 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab0FEEBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 00:01:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: Tree for June 3
Date: Sat, 5 Jun 2010 13:31:25 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: "Luck, Tony" <tony.luck@intel.com>, Dave Young <hidave.darkstar@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20100603134753.710a64b3.sfr@canb.auug.org.au> <201006051209.51664.rusty@rustcorp.com.au> <201006051221.38088.rusty@rustcorp.com.au>
In-Reply-To: <201006051221.38088.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006051331.26359.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jun 2010 12:21:37 pm Rusty Russell wrote:
> On Sat, 5 Jun 2010 12:09:51 pm Rusty Russell wrote:
> > Here's a tree with all current fixes: still no module load?
> 
> Erk, terminally broken tree.  Will re-xmit once fixed...

I'd introduced a bug with MODVERSIONS=y in "module: refactor out section
header rewriting".  Not doing too well on this...

Fixed that, too (see below for fix if curious).

This time for sure!
	git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6.git module

Subject: module: refactor out section header rewriting: FIX modversions

We can't do the find_sec after removing the SHF_ALLOC flags; it won't
find the sections.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2217,11 +2217,13 @@ static int rewrite_section_headers(struc
 		if (strstarts(info->secstrings+shdr->sh_name, ".exit"))
 			shdr->sh_flags &= ~(unsigned long)SHF_ALLOC;
 #endif
-		/* Don't keep modinfo and version sections. */
-		if (!strcmp(info->secstrings+shdr->sh_name, "__versions")
-		    || !strcmp(info->secstrings+shdr->sh_name, ".modinfo"))
-			shdr->sh_flags &= ~(unsigned long)SHF_ALLOC;
 	}
+
+	/* Track but don't keep modinfo and version sections. */
+	info->index.vers = find_sec(info->hdr, info->sechdrs, info->secstrings, "__versions");
+	info->index.info = find_sec(info->hdr, info->sechdrs, info->secstrings, ".modinfo");
+	info->sechdrs[info->index.info].sh_flags &= ~(unsigned long)SHF_ALLOC;
+	info->sechdrs[info->index.vers].sh_flags &= ~(unsigned long)SHF_ALLOC;
 	return 0;
 }
 
@@ -2274,8 +2276,6 @@ static struct module *setup_load_info(st
 		return ERR_PTR(-ENOEXEC);
 	}
 
-	info->index.vers = find_sec(info->hdr, info->sechdrs, info->secstrings, "__versions");
-	info->index.info = find_sec(info->hdr, info->sechdrs, info->secstrings, ".modinfo");
 	info->index.pcpu = find_pcpusec(info->hdr, info->sechdrs, info->secstrings);
 
 	/* Check module struct version now, before we try to use module. */
