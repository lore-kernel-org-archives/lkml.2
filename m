Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab1EXVqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:46:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58467 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab1EXVqw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:46:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nslZsgWCS2FlgMwBlZoh1gbt2z1XTObvRqW21G6INS0tp98A/jv5w4aRZ6ByUAJ413
         7SaZ8Bwva/E4M+r0A296b3sgAWE/HJaEsLMNdFigdAdokytu8phCY6HGXmpSpMWnNQ8m
         S82+rN1/DiEfJ6bbIqa9zspd2X/VCvWqYrROk=
MIME-Version: 1.0
In-Reply-To: <1306269105.21443.20.camel@dan>
References: <1306269105.21443.20.camel@dan>
Date: Tue, 24 May 2011 17:46:51 -0400
Message-ID: <BANLkTik7w0w_RFxVONwRx9zw48mk_E8N8Q@mail.gmail.com>
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
From: Brian Gerst <brgerst@gmail.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        davej@redhat.com, kees.cook@canonical.com, davem@davemloft.net,
        eranian@google.com, torvalds@linux-foundation.org, adobriyan@gmail.com,
        penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Ingo Molnar <mingo@elte.hu>, pageexec@freemail.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 4:31 PM, Dan Rosenberg <drosenberg@vsecurity.com> wrote:
> This introduces CONFIG_RANDOMIZE_BASE, which randomizes the address at
> which the kernel is decompressed at boot as a security feature that
> deters exploit attempts relying on knowledge of the location of kernel
> internals.  The default values of the kptr_restrict and dmesg_restrict
> sysctls are set to (1) when this is enabled, since hiding kernel
> pointers is necessary to preserve the secrecy of the randomized base
> address.
>
> This feature also uses a fixed mapping to move the IDT (if not already
> done as a fix for the F00F bug), to avoid exposing the location of
> kernel internals relative to the original IDT.  This has the additional
> security benefit of marking the new virtual address of the IDT
> read-only.
>
> Entropy is generated using the RDRAND instruction if it is supported. If
> not, then RDTSC is used, if supported. If neither RDRAND nor RDTSC are
> supported, then no randomness is introduced. Support for the CPUID
> instruction is required to check for the availability of these two
> instructions.
>
> Thanks to everyone who contributed helpful suggestions and feedback so
> far.
>
> Comments/Questions:
>
> * Since RDRAND is relatively new, only the most recent version of
> binutils supports assembling it.  To avoid breaking builds for people
> who use older toolchains but want this feature, I hardcoded the opcodes.
> If anyone has a better approach, please let me know.
>
> * I chose to mimic the F00F bugfix behavior for moving the IDT, since it
> required very little code and has the additional benefit of making the
> IDT read-only. Ingo Molnar's suggestion of allocating per-cpu IDTs
> instead is still on the table, and I'd like to get feedback on this.
>
> * In order to increase the entropy for the randomized base, I changed
> the default value of CONFIG_PHYSICAL_ALIGN back to 2mb.  It had
> previously been raised to 16mb as a hack so that relocatable kernels
> wouldn't load below that minimum.  I address this by changing the
> meaning of CONFIG_PHYSICAL_START such that it now represents a minimum
> address that relocatable kernels can be loaded at (rather than being
> ignored by relocatable kernels).  So, if a relocatable kernel determines
> it should be loaded at an address below CONFIG_PHYSICAL_START (which
> defaults to 16mb), I just bump it up.
>
> * I would appreciate guidance on safe values for the highest addresses
> we can safely load the kernel at, on both 32-bit and 64-bit. This
> version uses 64mb (0x4000000) for 32-bit, and worked well in testing.
>
> * CONFIG_RANDOMIZE_BASE automatically sets the default value of
> kptr_restrict and dmesg_restrict to 1, since it's nonsensical to use
> this without the other two.  I considered removing
> CONFIG_SECURITY_DMESG_RESTRICT altogether (it currently sets the default
> value for dmesg_restrict), but just in case distros want to keep the
> CONFIG as a toggle switch but don't want to use CONFIG_RANDOMIZE_BASE, I
> kept it around.  So, now CONFIG_RANDOMIZE_BASE sets the default value
> for CONFIG_SECURITY_DMESG_RESTRICT.
>
> * x86-64 is still "to-do". Because it calculates the kernel text address
> twice, this may be a little trickier.

This trick doesn't work as you may expect on 64-bit.  You are
relocating the physical image of the kernel, but the kernel actually
runs from a fixed virtual mapping.  This would require adding the
relocation code that 32-bit uses, so the virtual address can be
changed.

--
Brian Gerst
