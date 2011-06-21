Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab1FUILD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 04:11:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63639 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab1FUIK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 04:10:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=VyHOCo6T6eZrKO9tt43jz0GL0VBMTf0tynOzea3TdTYEiTdri00zlnqXcyJKoEcWAw
         3bXjYlGZ208pdM3Y5KzpZZf97D5dLOqSq4uLBAjO3R4rIBkbjE164Z5zXUwQAPCwU34Q
         zRT5Bb8W+VEw3tOamAhxXT0AKTYku/ghNPTAU=
MIME-Version: 1.0
Date: Tue, 21 Jun 2011 01:10:57 -0700
Message-ID: <BANLkTi=H17HC29bCTncSbXXm+RjwOCP49g@mail.gmail.com>
Subject: code sections beyond .text skipped from alternatives_smp_module_add
From: Deep Debroy <ddebroy@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In x86-64, I am running into a scenario with certain kernel modules
where the patching of lock prefix instructions in sections other than
.text (e.g. .exit.text) is not occurring even though the .smp_locks
relocations in the .ko file specify instructions in sections other
than .text for patching. For example (down in the bottom), in
net/bluetooth/rfcomm.ko, we have a couple of entries in .exit.text for
patching. However, when I look in the memory page containing the
.exit.text section in a uni processor system, it doesn't appear the
lock prefix instructions in .exit.text were patched with NOPs the same
way other instructions from the .text section in the same page
underwent patching. This creates a subtle inconsistency where a page
contains the end of the .text section along with the .exit.text
section - lock prefixes in instructions from the former section gets
patched per .smp_locks entries while that doesn't happen for the
latter within the same page.

Looking at the code, in module_finalize for x86, only .text seems to
be getting picked for the patching of lock prefixes while other
sections such as .exit.text or .init.text are not. Is there a reason
we skip the other *.text code sections from the lock patches? Would
making the application of the patching of lock prefixes generic across
all code sections (rather than just .text) make sense?

Thanks,
Deep

            for (s = sechdrs; s < sechdrs + hdr->e_shnum; s++) {
                    if (!strcmp(".text", secstrings + s->sh_name))
                            text = s;
                    ...
                    if (!strcmp(".smp_locks", secstrings + s->sh_name))
                            locks = s;
                    ...
            }

            if (locks && text) {
                    void *lseg = (void *)locks->sh_addr;
                    void *tseg = (void *)text->sh_addr;
                    alternatives_smp_module_add(me, me->name,
                                                lseg, lseg + locks->sh_size,
                                                tseg, tseg + text->sh_size);
            }



> objdump -r kernel/net/bluetooth/rfcomm/rfcomm.ko

RELOCATION RECORDS FOR [.smp_locks]:
OFFSET           TYPE              VALUE
0000000000000000 R_X86_64_64       .text+0x00000000000000ac
0000000000000008 R_X86_64_64       .exit.text+0x0000000000000023
0000000000000010 R_X86_64_64       .exit.text+0x0000000000000034
0000000000000018 R_X86_64_64       .text+0x0000000000000619
0000000000000020 R_X86_64_64       .text+0x000000000000061d
