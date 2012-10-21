Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab2JUUHe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 16:07:34 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52086 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab2JUUHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 16:07:32 -0400
From: Lekensteyn <lekensteyn@gmail.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>, Heinz Diehl <htd@fritha.org>,
        Martin Peres <martin.peres@labri.fr>,
        Heinz Diehl <htd@fancy-poultry.org>, David Airlie <airlied@linux.ie>,
        Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
Subject: Re: Linux 3.7-rc1 (nouveau_bios_score oops).
Date: Sun, 21 Oct 2012 22:07:27 +0200
Message-ID: <2998525.z8RPfWksxL@al>
User-Agent: KMail/4.9.2 (Linux/3.6.1-1-custom; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121021144908.GC22587@joi.lan>
References: <1724445.dN2yMEzN6d@localhost> <CA+55aFzYDY0FLGhVevqv9Gk0bnJnM4r13=JzWDO9hdySi8zFoA@mail.gmail.com> <20121021144908.GC22587@joi.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 October 2012 16:49:08 Marcin Slusarz wrote:
> On Sun, Oct 21, 2012 at 07:38:58AM -0700, Linus Torvalds wrote:
> > On Sun, Oct 21, 2012 at 5:09 AM, Marcin Slusarz
> > 
> > <marcin.slusarz@gmail.com> wrote:
> > > This looks like ACPI bug...
> >
> > I'm shocked to hear that firmware would be fragile.
> >
> > Anyway, here's the #1 thing to keep in mind about firmware:
> > 
> >  - firmware is always buggy.
> 
> I know. But this bug is not about broken firmware. It's about Linux kernel
> ACPI implementation, which (I think) wrongly interprets ACPI script.

The ACPI implementation is fine, it is just the fw engineers that suck. I see I 
have not cc'd the linux-vger ml when replying to a previous mail. I'll paste 
it below:

Since commit 9a334cd "drm/nouveau/bios: fix shadowing of ACPI ROMs larger than 
64KiB" chunks are not always read in multiples of 4KiB anymore (less is 
possible). That is the only obvious thing I can think of atm (besides the 
kmalloc(0) bug for which Martin submitted a patch in the previous mail).

Do you still still have an Asus laptop with the same BIOS as in 
https://bugzilla.kernel.org/show_bug.cgi?id=19702? (if yes, then the acpidump 
from that bug still applies).

This is the ACPI _ROM method that is being called:
Method (_ROM, 2, NotSerialized)  // _ROM: Read-Only Memory
{
    Add (Arg0, RBUF, Local0)
    ShiftLeft (Arg1, 0x03, Local1) // times 8, bytes to bits?
    Name (VBUF, Buffer (Arg1) {}) 
    OperationRegion (VROM, SystemMemory, Local0, Local1)
    Field (VROM, ByteAcc, NoLock, Preserve)
    {   
        ROMI,   65536
    }   

    Store (ROMI, VBUF)
    Return (VBUF)
}

Arg0 is the offset (0 when first reading the size), Arg1 is the number of read 
bytes (3). Note the use of Local1 in OperationRegion. The meaning there is 
bytes, but a multiple of the requested bytes is passed. So if we request 4096 
bytes, we end up with a VROM of size 32KiB. ROMI is 65536 bits (or 8192 
bytes), hence reading 4096 does not give errors. But reading only 3 bytes will 
fail. Martin, I saw your second patch (https://lkml.org/lkml/2012/10/20/150) 
which takes care of the first case, but it skips the case where the ROM is of 
an odd size (does that even happen, something like 64KiB+1 bytes? No idea.)

Addition: Conclusion: this means that the request must have a length must be 
at least 1 KiB or it will fail with the ACPI error that you have seen before. 
This AML snippet suck.

Regards,
Peter
