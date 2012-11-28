Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab2K1RC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:02:59 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:46566 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab2K1RC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:02:56 -0500
MIME-Version: 1.0
In-Reply-To: <50B63A04.9010901@redhat.com>
References: <50A513A8.9010404@redhat.com> <CA+55aFyLMmKuEvY6T2=vSHp_R4=ndqFEFNJsc3Axze2vYknKhg@mail.gmail.com>
 <50B63A04.9010901@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Nov 2012 09:02:35 -0800
X-Google-Sender-Auth: vw_SRWJddLJUvzuI1RpxvvoHBUI
Message-ID: <CA+55aFy7hxayPzr3MiV1xc0bvLcd+-7b52iA3CYhbPZuWXr9yA@mail.gmail.com>
Subject: Re: Acpi deadlocks with 3.7.0-rc4
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 8:21 AM, Zdenek Kabelac <zkabelac@redhat.com> wrote:
>
> I've opened  https://bugzilla.kernel.org/show_bug.cgi?id=51071
> and attached picture there which is all I have.
>
> I'll try to decode exact code line.

Uhhuh. It's missing much of the relevant parts of the code line, in
particular the actual oopsing instruction. But what is there decodes
to

        41 b8 10 00 00 00       mov    $0x10,%r8d
        48 c7 c1 88 52 64 81    mov    $0xffffffff81645288,%rcx
        31 c0                   xor    %eax,%eax
        48 c7 c2 98 52 64 81    mov    $0xffffffff81645298,%rdx
        bf 00 04 00 0.          mov    $0x0.00400,%edi

    .. oops in here ..

        74 33                   je     0x50
        48 89 df                mov    %rbx,%rdi
        e8 4d c9 00 00          callq  ? <offset 0xc972>
        48 89 d9                mov    %rbx,%rcx
        48 c7 c2 0a .. .. ..    mov    $0x......0a,%rdx

which isn't really very obvious. Do you have that kernel around (or at
least the same compiler and configuration)? Doing a

  objdump --disassemble  drivers/acpi/acpica/nsaccess.o

might help pinpoint where that is..

> It's probably not a regression from 3.6 - since this problem was there for
> much longer - but now it has just become much more visible.

Ok.

           Linus
