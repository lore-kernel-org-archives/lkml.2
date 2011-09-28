Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933296Ab1I1Wsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:48:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54815 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933280Ab1I1Wsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:48:31 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:47 2011
Message-Id: <20110928220147.073126763@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric B Munson <emunson@mgebm.net>, Anton Blanchard <anton@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [206/244] perf symbols: Fix ppc64 SEGV in dso__load_sym with debuginfo files
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Blanchard <anton@samba.org>

commit adb091846318f86e4f46c7d6a7b40d2f478abdbe upstream.

64bit PowerPC debuginfo files have an empty function descriptor section.
I hit a SEGV when perf tried to use this section for symbol resolution.

To fix this we need to check the section is valid and we can do this by
checking for type SHT_PROGBITS.

Cc: <stable@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Eric B Munson <emunson@mgebm.net>
Link: http://lkml.kernel.org/r/20110824065242.895239970@samba.org
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 tools/perf/util/symbol.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1111,6 +1111,8 @@ static int dso__load_sym(struct dso *dso
 	}
 
 	opdsec = elf_section_by_name(elf, &ehdr, &opdshdr, ".opd", &opdidx);
+	if (opdshdr.sh_type != SHT_PROGBITS)
+		opdsec = NULL;
 	if (opdsec)
 		opddata = elf_rawdata(opdsec, NULL);
 


