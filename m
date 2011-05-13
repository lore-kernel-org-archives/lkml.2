Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab1EMPqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:46:20 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33242 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab1EMPqS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:46:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XSLUrMrhhgBRdAW05+OgP/C8dHCmQ6vTnYWGJMUzk5FV1XpqCVvZPzLvKyaXyCWPjc
         opSCjpwShnD4QY6mVGJKOnv9SypiZlPylwLIp0p6XBwcoG9XcU1xN00HqQoxJX5xEivd
         mrgSwLLe+E6e4pIi7Pl2H2r++rD8wXWedPalM=
MIME-Version: 1.0
In-Reply-To: <20110513150707.GA26389@linux-mips.org>
References: <7aa38c32b7748a95e814e5bb0583f967@localhost>
	<20110513150707.GA26389@linux-mips.org>
Date: Fri, 13 May 2011 08:46:18 -0700
Message-ID: <BANLkTikcyEzjOWt9pWToE=89dySSEYbw_g@mail.gmail.com>
Subject: Re: [PATCH 1/4] MIPS: Replace _PAGE_READ with _PAGE_NO_READ
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 8:07 AM, Ralf Baechle <ralf@linux-mips.org> wrote:
>> Reuse more of the same definitions for the non-RIXI and RIXI cases.  This
>> avoids having special cases for kernel_uses_smartmips_rixi cluttering up
>> the pgtable*.h files.
>>
>> On hardware that does not support RI/XI, EntryLo bits 31:30 / 63:62 will
>> remain unset and RI/XI permissions will not be enforced.
>
> Nice idea but it breaks on 64-bit hardware running 32-bit kernels.  On
> those the RI/XI bits written to c0_entrylo0/1 31:30 will be interpreted as
> physical address bits 37:36.

Hmm, are you sure?  (Unfortunately I do not have a 64-bit machine to
test it on.)

I did not touch David's existing build_update_entries(), which makes a
point not to set the RI/XI bits when the RIXI feature is disabled:

        if (kernel_uses_smartmips_rixi) {
                UASM_i_SRL(p, tmp, tmp, ilog2(_PAGE_NO_EXEC));
                UASM_i_SRL(p, ptep, ptep, ilog2(_PAGE_NO_EXEC));
                UASM_i_ROTR(p, tmp, tmp, ilog2(_PAGE_GLOBAL) -
ilog2(_PAGE_NO_EXEC));
                if (r4k_250MHZhwbug())
                        UASM_i_MTC0(p, 0, C0_ENTRYLO0);
                UASM_i_MTC0(p, tmp, C0_ENTRYLO0); /* load it */
                UASM_i_ROTR(p, ptep, ptep, ilog2(_PAGE_GLOBAL) -
ilog2(_PAGE_NO_EXEC));
        } else {
                UASM_i_SRL(p, tmp, tmp, ilog2(_PAGE_GLOBAL)); /*
convert to entrylo0 */
                if (r4k_250MHZhwbug())
                        UASM_i_MTC0(p, 0, C0_ENTRYLO0);
                UASM_i_MTC0(p, tmp, C0_ENTRYLO0); /* load it */
                UASM_i_SRL(p, ptep, ptep, ilog2(_PAGE_GLOBAL)); /*
convert to entrylo1 */
                if (r45k_bvahwbug())
                        uasm_i_mfc0(p, tmp, C0_INDEX);
        }

If RIXI is enabled, it shifts the SW bits off the end of the register,
then rotates the RI/XI bits into place.

If RIXI is disabled, it shifts the SW bits + RI/XI bits off the end of
the register.  It should not be setting bits 31:30 or 63:62, ever.

(A side issue here is that ROTR is a MIPS R2 instruction, so we could
never remove the old handler and use the RIXI version of the TLB
handler on an R1 machine.)

If setting EntryLo bits 31:30 for RI/XI is illegal on a 64-bit system
running a 32-bit kernel, I suspect we will have a problem with the
existing RIXI TLB update code, regardless of whether my changes are
applied.
