Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab2DJA7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 20:59:50 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:19930
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932102Ab2DJA7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 20:59:46 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2dI1432N98dK4015Izz1202hzz8275bh8275dhz2fh668h839hd25h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F8385D7.3060701@am.sony.com>
Date: Mon, 9 Apr 2012 17:59:03 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Jan Beulich <jbeulich@novell.com>,
        Kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Bird, Tim" <Tim.Bird@am.sony.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Arnaud Lacombe <lacombar@gmail.com>, <sam@ravnborg.org>
Subject: Re: [PATCH] modpost: Fix modpost's license checking V3
References: <CACqU3MUXAOMGQ1nzUrtYPEQAC3U-nuq3YurtNJJLS1hft4ROGA@mail.gmail.com> <1310626276-4541-1-git-send-email-abogani@kernel.org> <4F6D2BC5.9070200@am.sony.com> <4F711EC0.3080708@am.sony.com> <87hax8yqcz.fsf@rustcorp.com.au>
In-Reply-To: <87hax8yqcz.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/12 21:37, Rusty Russell wrote:
> On Mon, 26 Mar 2012 18:58:24 -0700, Frank Rowand <frank.rowand@am.sony.com> wrote:
>> The attached patch modifies your patch to also use export_from_secname()
>> for vmlinux and vmlinux.o.
> 
> OK, today is my last day online for six weeks, so Alessio, please come
> up with a fix and push straight to Linus once consensus is reached.
> 
> If that's impossible, I'll review when I get back.
> 
> Thanks,
> Rusty.

Linus,

Alessio asked me to send this directly to you.

-Frank


The commit f02e8a6 sorts symbols placing each of them in its own elf section.
The sorting and merging into the canonical sections are done by the linker.
Unfortunately modpost to generate Module.symvers file parses vmlinux.o (which
is not linked yet) and all modules object files (which aren't linked yet).
These aren't sanitized by the linker yet. That breaks modpost that can't
detect license properly for modules.

This patch makes modpost aware of the new exported symbols structure.

The above is a slightly corrected version of the explanation of the problem,
copied from commit 62a26356.  That commit fixed the problem for module object
files, but not for vmlinux.o.  This patch fixes modpost for vmlinux.o.

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
---
 scripts/mod/modpost.c |    7 	5 +	2 -	0 !
 scripts/mod/modpost.h |    1 	1 +	0 -	0 !
 2 files changed, 6 insertions(+), 2 deletions(-)

Index: b/scripts/mod/modpost.c
===================================================================
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -132,8 +132,10 @@ static struct module *new_module(char *m
 	/* strip trailing .o */
 	s = strrchr(p, '.');
 	if (s != NULL)
-		if (strcmp(s, ".o") == 0)
+		if (strcmp(s, ".o") == 0) {
 			*s = '\0';
+			mod->is_dot_o = 1;
+		}
 
 	/* add to list */
 	mod->name = p;
@@ -587,7 +589,8 @@ static void handle_modversions(struct mo
 	unsigned int crc;
 	enum export export;
 
-	if (!is_vmlinux(mod->name) && strncmp(symname, "__ksymtab", 9) == 0)
+	if ((!is_vmlinux(mod->name) || mod->is_dot_o) &&
+	    strncmp(symname, "__ksymtab", 9) == 0)
 		export = export_from_secname(info, get_secindex(info, sym));
 	else
 		export = export_from_sec(info, get_secindex(info, sym));
Index: b/scripts/mod/modpost.h
===================================================================
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -113,6 +113,7 @@ struct module {
 	int has_cleanup;
 	struct buffer dev_table_buf;
 	char	     srcversion[25];
+	int is_dot_o;
 };
 
 struct elf_info {

