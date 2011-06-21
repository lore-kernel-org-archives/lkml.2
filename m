Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab1FUSIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 14:08:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61122 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab1FUSI3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 14:08:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=d1/2FyorE1peqwt3NiUYgVMhPz9JCViOE8xQ09JCAnnfZ6Racy7wtMFxlglBogH8Qy
         6uvMLQaDuB+zupH2KG0VDPSyEHZVuJKvCtbpFY80MewAZ0l7jnAmCR7jYPzLhSsJamIc
         1Oa651XC81I8ahPUMJxkxXx/QjGk7W0XGK7JQ=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=H17HC29bCTncSbXXm+RjwOCP49g@mail.gmail.com>
References: <BANLkTi=H17HC29bCTncSbXXm+RjwOCP49g@mail.gmail.com>
Date: Tue, 21 Jun 2011 11:08:28 -0700
Message-ID: <BANLkTikyjzQ-VZMn2_ZobEmHMLRafki9YQ@mail.gmail.com>
Subject: Re: code sections beyond .text skipped from alternatives_smp_module_add
From: Deep Debroy <ddebroy@gmail.com>
To: linux-kernel@vger.kernel.org, kraxel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 1:10 AM, Deep Debroy <ddebroy@gmail.com> wrote:
> In x86-64, I am running into a scenario with certain kernel modules
> where the patching of lock prefix instructions in sections other than
> .text (e.g. .exit.text) is not occurring even though the .smp_locks
> relocations in the .ko file specify instructions in sections other
> than .text for patching. For example (down in the bottom), in
> net/bluetooth/rfcomm.ko, we have a couple of entries in .exit.text for
> patching. However, when I look in the memory page containing the
> .exit.text section in a uni processor system, it doesn't appear the
> lock prefix instructions in .exit.text were patched with NOPs the same
> way other instructions from the .text section in the same page
> underwent patching. This creates a subtle inconsistency where a page
> contains the end of the .text section along with the .exit.text
> section - lock prefixes in instructions from the former section gets
> patched per .smp_locks entries while that doesn't happen for the
> latter within the same page.
>
> Looking at the code, in module_finalize for x86, only .text seems to
> be getting picked for the patching of lock prefixes while other
> sections such as .exit.text or .init.text are not. Is there a reason
> we skip the other *.text code sections from the lock patches? Would
> making the application of the patching of lock prefixes generic across
> all code sections (rather than just .text) make sense?
>
> Thanks,
> Deep
>
>            for (s = sechdrs; s < sechdrs + hdr->e_shnum; s++) {
>                    if (!strcmp(".text", secstrings + s->sh_name))
>                            text = s;
>                    ...
>                    if (!strcmp(".smp_locks", secstrings + s->sh_name))
>                            locks = s;
>                    ...
>            }
>
>            if (locks && text) {
>                    void *lseg = (void *)locks->sh_addr;
>                    void *tseg = (void *)text->sh_addr;
>                    alternatives_smp_module_add(me, me->name,
>                                                lseg, lseg + locks->sh_size,
>                                                tseg, tseg + text->sh_size);
>            }
>
>
>
>> objdump -r kernel/net/bluetooth/rfcomm/rfcomm.ko
>
> RELOCATION RECORDS FOR [.smp_locks]:
> OFFSET           TYPE              VALUE
> 0000000000000000 R_X86_64_64       .text+0x00000000000000ac
> 0000000000000008 R_X86_64_64       .exit.text+0x0000000000000023
> 0000000000000010 R_X86_64_64       .exit.text+0x0000000000000034
> 0000000000000018 R_X86_64_64       .text+0x0000000000000619
> 0000000000000020 R_X86_64_64       .text+0x000000000000061d
>

+ Gerd Hoffmann who introduced the SMP patching code below back in Jan
2006 as part of 2.6.15.

Any comments on why patching of smp_lock prefixes should be restricted
to .text and not other *.text code sections?

Thanks,
Deep
