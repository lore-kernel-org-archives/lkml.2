Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760Ab1FVXp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 19:45:26 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:52683 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758158Ab1FVXpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 19:45:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=VnP+jd7m7pjGA7Oe+qPIwivTsA+LKPh2Rw+LVMYNsgc4Mm6ajxVtst0aSKoozfDn2r14oPZjtF+mFhhbtqMZI4yaf3B2lNTqNFS1L3GF5O2zsCo3DdkdKuvGl38iFV8M;
Date: Wed, 22 Jun 2011 16:45:02 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Deep Debroy <ddebroy@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, kraxel@redhat.com
Subject: Re: code sections beyond .text skipped from
 alternatives_smp_module_add
Message-Id: <20110622164502.b5b19e6d.rdunlap@xenotime.net>
In-Reply-To: <BANLkTi=DagQzcXQnHsVWjR0SeDDPnizVfQ@mail.gmail.com>
References: <BANLkTi=H17HC29bCTncSbXXm+RjwOCP49g@mail.gmail.com>
	<BANLkTikyjzQ-VZMn2_ZobEmHMLRafki9YQ@mail.gmail.com>
	<20110622132114.GA8656@dumpdata.com>
	<BANLkTi=v7i04JhXRaf18_=nXKSgwHMDJjg@mail.gmail.com>
	<BANLkTi=DagQzcXQnHsVWjR0SeDDPnizVfQ@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011 14:58:12 -0700 Deep Debroy wrote:

> On Wed, Jun 22, 2011 at 10:27 AM, Deep Debroy <ddebroy@gmail.com> wrote:
> > On Wed, Jun 22, 2011 at 6:21 AM, Konrad Rzeszutek Wilk
> > <konrad.wilk@oracle.com> wrote:
> >>> > Looking at the code, in module_finalize for x86, only .text seems to
> >>> > be getting picked for the patching of lock prefixes while other
> >>> > sections such as .exit.text or .init.text are not. Is there a reason
> >>> > we skip the other *.text code sections from the lock patches? Would
> >>> + Gerd Hoffmann who introduced the SMP patching code below back in Jan
> >>> 2006 as part of 2.6.15.
> >>
> >> Whoa, long time ago.
> >>
> >>>
> >>> Any comments on why patching of smp_lock prefixes should be restricted
> >>> to .text and not other *.text code sections?
> >>
> >> It could be that at that time the .exit.text or .init.text did not exist.
> >>
> >> As in, the patching code just hasn't kept up. One way of checking that
> >> is just finding the ancient 2.6.15 code and seeing if there is any
> >> mention of those extra segments.
> >>
> >
> > Thanks Konrad. One slight correction: after rechecking the kernel
> > sources, it appears the smp lock prefix code first made it's
> > appearance in the official trees during 2.6.18. In any case, going
> > back even to 2.6.16 sources, layout_sections in module.c specially
> > handled .init prefixed sections from the rest i.e. core sections.
> > Further, the module struct in include/module/linux.h seems to have had
> > members such as init_text_size which suggests atleast .init.text did
> > exit back then as well. While I didn't find any crumbs in the code
> > that point to the existence of a .exit.text (besides a function
> > pointer called exit which most likely ended up in the .exit.text), the
> > ELF headers for Centos 5.6 kernel objects (which uses the 2.6.18
> > kernel) typically have a .exit.text.
> >
> >> Do you have a patch to fix this?
> >>
> >
> > I can work on that. Just wanted to first make sure that there wasn't
> > any specific reason to avoid patching non .text sections.
> >
> > Thanks,
> > Deep
> >
> 
> Some further digging through messages revealed a patch from Randy
> Dunlap in June 2006: "[PATCH] ignore smp_locks section warnings from
> init/exit code." Given this patch came in after the smp locking
> hotpatching mechanism was introduced, there may have been an
> assumption that instructions that results in entries in smp_locks
> relocations in the object file should not exist in the init/exit.text
> sections.

I don't quite see how this patch (below) would affect your problem
description...


commit 35899c57516be6eaa42cc27151767c52d75b2979
Author: Randy Dunlap <rdunlap@xenotime.net>
Date:   Wed Jun 7 16:23:26 2006 -0700

    kbuild: ignore smp_locks section warnings from init/exit code
    
    Add ".smp_locks" section to whitelist as being safe from
    init and exit sections.

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index d0f86ed..94047bc 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -821,6 +821,7 @@ static int init_section_ref_ok(const char *name)
                ".pci_fixup_final",
                ".pdr",
                "__param",
+               ".smp_locks",
                NULL
        };
        /* Start of section names */
@@ -892,6 +893,7 @@ static int exit_section_ref_ok(const char *name)
                ".exitcall.exit",
                ".eh_frame",
                ".stab",
+               ".smp_locks",
                NULL
        };
        /* Start of section names */

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
