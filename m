Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab2K1R16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:27:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab2K1R14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:27:56 -0500
Message-ID: <50B64996.1010709@redhat.com>
Date: Wed, 28 Nov 2012 18:27:50 +0100
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Acpi deadlocks with 3.7.0-rc4
References: <50A513A8.9010404@redhat.com> <CA+55aFyLMmKuEvY6T2=vSHp_R4=ndqFEFNJsc3Axze2vYknKhg@mail.gmail.com> <50B63A04.9010901@redhat.com> <CA+55aFy7hxayPzr3MiV1xc0bvLcd+-7b52iA3CYhbPZuWXr9yA@mail.gmail.com>
In-Reply-To: <CA+55aFy7hxayPzr3MiV1xc0bvLcd+-7b52iA3CYhbPZuWXr9yA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 28.11.2012 18:02, Linus Torvalds napsal(a):
> On Wed, Nov 28, 2012 at 8:21 AM, Zdenek Kabelac <zkabelac@redhat.com> wrote:
>>
>> I've opened  https://bugzilla.kernel.org/show_bug.cgi?id=51071
>> and attached picture there which is all I have.
>>
>> I'll try to decode exact code line.
>
> Uhhuh. It's missing much of the relevant parts of the code line, in
> particular the actual oopsing instruction. But what is there decodes
> to
>
>          41 b8 10 00 00 00       mov    $0x10,%r8d
>          48 c7 c1 88 52 64 81    mov    $0xffffffff81645288,%rcx
>          31 c0                   xor    %eax,%eax
>          48 c7 c2 98 52 64 81    mov    $0xffffffff81645298,%rdx
>          bf 00 04 00 0.          mov    $0x0.00400,%edi
>
>      .. oops in here ..
>
>          74 33                   je     0x50
>          48 89 df                mov    %rbx,%rdi
>          e8 4d c9 00 00          callq  ? <offset 0xc972>
>          48 89 d9                mov    %rbx,%rcx
>          48 c7 c2 0a .. .. ..    mov    $0x......0a,%rdx
>
> which isn't really very obvious. Do you have that kernel around (or at
> least the same compiler and configuration)? Doing a
>
>    objdump --disassemble  drivers/acpi/acpica/nsaccess.o

I've attached bigger disasfun script output to BZ 51071.
https://bugzilla.kernel.org/show_bug.cgi?id=51071#c1


         if (ACPI_GET_DESCRIPTOR_TYPE(prefix_node) !=
00000000000000a1 <acpi_ns_lookup+0xa1> cmpb   $0xf,0x8(%rbx)
00000000000000a5 <acpi_ns_lookup+0xa5> je   0da  <acpi_ns_lookup+0xda>

seems to be going out of bounds.

Zdenek

