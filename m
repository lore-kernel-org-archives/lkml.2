Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878Ab2DYUvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 16:51:05 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64550 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756557Ab2DYUvD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 16:51:03 -0400
MIME-Version: 1.0
In-Reply-To: <94F2FBAB4432B54E8AACC7DFDE6C92E346A77806@ORSMSX101.amr.corp.intel.com>
References: <CA+icZUWVwUr19xL0Dn5mHnZjQaVjj6VYD3BMMktEWO0vgoZEXw@mail.gmail.com>
 <CA+icZUUGFaz0c-tHa9EGUxZaxPj_M=zrE+kE0dv5UMoA6GyN3w@mail.gmail.com>
 <CAErSpo5vZSf_EZr6-XnAA8N2Luv6rA92YtZsidWZCZ8rarkPUQ@mail.gmail.com>
 <CA+icZUU+asnLWAevwqKBgnvrmKNitL8-0+8ijDii4pt9VsjspA@mail.gmail.com> <94F2FBAB4432B54E8AACC7DFDE6C92E346A77806@ORSMSX101.amr.corp.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 25 Apr 2012 14:50:40 -0600
Message-ID: <CAErSpo5E3E=A+EEAZjmkYc8x3B==9ZtYufNaG4t8xQegtOfxfA@mail.gmail.com>
Subject: Re: Warning: pnp 00:0b: can't evaluate _CRS: 12311
To: "Moore, Robert" <robert.moore@intel.com>
Cc: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lin, Ming M" <ming.m.lin@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 2:36 PM, Moore, Robert <robert.moore@intel.com> wrote:
>> >>> [    0.294037] pnp 00:0b: can't evaluate _CRS: 12311
>
> It sure would be nice if this error message would include the full pathname to the _CRS method. As it stands, it is rather difficult to determine just what caused this.

Agreed.

I extracted and disassembled the acpidump.  There were five
occurrences of PNP0C02:

DSDT.dsl  \_SB.PCI0.LPCB.LDRC (has a constant _CRS)
DSDT.dsl  \_SB.PCI0.LPCB.CWDT (has _HID INT3F0D and _CID PNP0C02, so
doesn't match message)
DSDT.dsl  \_SB.PCI0.PDRC
SSDT1.dsl  \_SB.PTID (has no _CRS and has _HID INT340E and _CID
PNP0C02, so doesn't match message)
SSDT4.dsl  \_SB.IFFS (has no _CRS)

So I think PDRC must be the one causing the trouble.  Its _CRS runs
some AML, but I'm not AML-savvy enough to figure it out:

    Scope (_SB.PCI0)
    {
        Device (PDRC)
        {
            Name (_HID, EisaId ("PNP0C02"))
            Name (_UID, One)
            Name (BUF0, ResourceTemplate ()
            {
                Memory32Fixed (ReadWrite,
                    0x00000000,         // Address Base
                    0x00004000,         // Address Length
                    )
                Memory32Fixed (ReadWrite,
                    0x00000000,         // Address Base
                    0x00008000,         // Address Length
                    )
                Memory32Fixed (ReadWrite,
                    0x00000000,         // Address Base
                    0x00001000,         // Address Length
                    )
                Memory32Fixed (ReadWrite,
                    0x00000000,         // Address Base
                    0x00001000,         // Address Length
                    )
                Memory32Fixed (ReadWrite,
                    0x00000000,         // Address Base
                    0x00000000,         // Address Length
                    )
                Memory32Fixed (ReadWrite,
                    0xFED20000,         // Address Base
                    0x00020000,         // Address Length
                    )
                Memory32Fixed (ReadOnly,
                    0xFED90000,         // Address Base
                    0x00004000,         // Address Length
                    )
                Memory32Fixed (ReadWrite,
                    0xFED45000,         // Address Base
                    0x0004B000,         // Address Length
                    )
                Memory32Fixed (ReadOnly,
                    0xFF000000,         // Address Base
                    0x01000000,         // Address Length
                    )
                Memory32Fixed (ReadOnly,
                    0xFEE00000,         // Address Base
                    0x00100000,         // Address Length
                    )
                Memory32Fixed (ReadWrite,
                    0x00000000,         // Address Base
                    0x00001000,         // Address Length
                    )
            })
            Method (_CRS, 0, Serialized)
            {
                CreateDWordField (BUF0, 0x04, RBR0)
                ShiftLeft (^^LPCB.RCBA, 0x0E, RBR0)
                CreateDWordField (BUF0, 0x7C, TBR0)
                Store (TBAB, TBR0)
                CreateDWordField (BUF0, 0x80, TBLN)
                If (LEqual (TBAB, Zero))
                {
                    Store (Zero, TBLN)
                }

                CreateDWordField (BUF0, 0x10, MBR0)
                ShiftLeft (MHBR, 0x0F, MBR0)
                CreateDWordField (BUF0, 0x1C, DBR0)
                ShiftLeft (DIBR, 0x0C, DBR0)
                CreateDWordField (BUF0, 0x28, EBR0)
                ShiftLeft (EPBR, 0x0C, EBR0)
                CreateDWordField (BUF0, 0x34, XBR0)
                ShiftLeft (PXBR, 0x1A, XBR0)
                CreateDWordField (BUF0, 0x38, XSZ0)
                ShiftRight (0x10000000, PXSZ, XSZ0)
                Return (BUF0)
            }
        }
    }
