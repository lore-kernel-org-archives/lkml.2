Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab2C0B7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 21:59:13 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:15673
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755771Ab2C0B7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 21:59:05 -0400
X-SpamScore: -10
X-BigFish: VPS-10(zzbb2dI1432N98dKzz1202hzz8275bh8275dhz2fh668h839hd25h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F711EC0.3080708@am.sony.com>
Date: Mon, 26 Mar 2012 18:58:24 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alessio Igor Bogani <abogani@kernel.org>
CC: <frank.rowand@am.sony.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Jan Beulich <jbeulich@novell.com>,
        Kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Bird, Tim" <Tim.Bird@am.sony.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: Re: [PATCH] modpost: Fix modpost's license checking V3
References: <CACqU3MUXAOMGQ1nzUrtYPEQAC3U-nuq3YurtNJJLS1hft4ROGA@mail.gmail.com> <1310626276-4541-1-git-send-email-abogani@kernel.org> <4F6D2BC5.9070200@am.sony.com>
In-Reply-To: <4F6D2BC5.9070200@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/12 19:04, Frank Rowand wrote:
> On 07/13/11 23:51, Alessio Igor Bogani wrote:
>> The commit f02e8a6 sorts symbols placing each of them in its own elf section.
>> The sorting and merging into the canonical sections are done by the linker.
>> Unfortunately modpost to generate Module.symvers file parses vmlinux
> 
> Yet another unfortunately: modpost parses vmlinux.o instead of vmlinux (vmlinux
> does not yet exist at this point of the build).  vmlinux.o also does not have
> the many sections sorted and merged into the canonical sections.  As a result,
> the Module.symvers created my modpost incorrectly reports the license of all
> exports as "(unknown)".
> 
> Can you fix this also please?

The attached patch modifies your patch to also use export_from_secname()
for vmlinux and vmlinux.o.

This is a rather blind shot at fixing the problem, so please review
carefully.  After applying the patch, Module.symvers reports the license
correctly for exports from vmlinux.o.

> 
> 
>> (already linked) and all modules object files (which aren't linked yet).
>> These aren't sanitized by the linker yet. That breaks modpost that can't
>> detect license properly for modules. This patch makes modpost aware of
>> the new exported symbols structure.
>>
>> Thanks to Arnaud Lacombe <lacombar@gmail.com> and Anders Kaseorg
>> <andersk@ksplice.com> for providing useful suggestions about code.
>>
>> This work was supported by a hardware donation from the CE Linux Forum.
>>
>> Reported-by: Jan Beulich <jbeulich@novell.com>
>> Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
>> ---
>>  scripts/mod/modpost.c |   29 ++++++++++++++++++++++++++++-
>>  1 files changed, 28 insertions(+), 1 deletions(-)
> 
> < snip >
> 
> -Frank Rowand

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
---
 scripts/mod/modpost.c |    2 	1 +	1 -	0 !
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/scripts/mod/modpost.c
===================================================================
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -589,7 +589,7 @@ static void handle_modversions(struct mo
 	unsigned int crc;
 	enum export export;
 
-	if (!is_vmlinux(mod->name) && strncmp(symname, "__ksymtab", 9) == 0)
+	if (strncmp(symname, "__ksymtab", 9) == 0)
 		export = export_from_secname(info, get_secindex(info, sym));
 	else
 		export = export_from_sec(info, get_secindex(info, sym));

