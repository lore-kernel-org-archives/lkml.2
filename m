Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589Ab1CaQKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:10:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61747 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab1CaQKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:10:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=aQw8Va6E5Je2KULX6oBGBh4QGQkoRvyI4kMGORD5nXnFQlCF7s02nOWQk5yMZdEtz1
         JKubIeAL90rTBAON3ETuaWCcwsyg39Vj2XUFrszqxqbViQGMNtA1HFZOX7fDvceSzrSE
         fMu7HVMuUkRLfcnmHvwy3C+tArW3cuqpA66RU=
Message-ID: <4D94A781.6060904@suse.cz>
Date: Thu, 31 Mar 2011 18:10:41 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Russell King <rmk@arm.linux.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>, Arend van Spriel <arend@broadcom.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        devel@linuxdriverproject.org, gregkh@suse.de,
        linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] drivers: brcmaxi: provide amba axi functionality
 in separate module
References: <1301391619-4499-1-git-send-email-arend@broadcom.com> <1301391619-4499-2-git-send-email-arend@broadcom.com> <4D91B856.8040302@suse.cz> <201103301453.48607.arnd@arndb.de> <4D948624.3040605@suse.cz> <20110331135126.GC19540@flint.arm.linux.org.uk> <4D948B1C.7080806@suse.cz> <20110331141424.GD19540@flint.arm.linux.org.uk>
In-Reply-To: <20110331141424.GD19540@flint.arm.linux.org.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2011 04:14 PM, Russell King wrote:
> On Thu, Mar 31, 2011 at 04:09:32PM +0200, Jiri Slaby wrote:
>> On 03/31/2011 03:51 PM, Russell King wrote:
>>> On Thu, Mar 31, 2011 at 03:48:20PM +0200, Jiri Slaby wrote:
>>>> How it can? Packed only tells the compiler to have one byte alignment
>>>> steps. And it should not matter here as all the members are 32-bit long.
>>>
>>> It also tells the compiler that it may be misaligned, so to avoid
>>> alignment faults it will use byte loads/stores.
>>
>> No, it should not (if offsetof % sizeof == 0). Otherwise it's a bug in
>> the compiler.
>>
>> Am I missing something?
> 
> $ cat t1.c
> struct foo {
>         unsigned long bar;
> } __attribute__((packed));
> 
> unsigned long baz(struct foo *f)
> {
>         return f->bar;
> }
> $ arm-linux-gcc -O2 -S -o - t1.c
> ...
>         .global baz
>         .type   baz, %function
> baz:
>         @ args = 0, pretend = 0, frame = 0
>         @ frame_needed = 0, uses_anonymous_args = 0
>         @ link register save eliminated.
>         ldrb    r3, [r0, #0]    @ zero_extendqisi2
>         ldrb    r2, [r0, #1]    @ zero_extendqisi2
>         ldrb    r1, [r0, #2]    @ zero_extendqisi2
>         orr     r3, r3, r2, asl #8
>         ldrb    r0, [r0, #3]    @ zero_extendqisi2
>         orr     r3, r3, r1, asl #16
>         orr     r0, r3, r0, asl #24
>         mov     pc, lr
>         .size   baz, .-baz
>         .ident  "GCC: (GNU) 4.3.5"
>         .section        .note.GNU-stack,"",%progbits
> 
> It does this because with the packed attribute, it can't make assumptions
> about the alignment of 'f'.

I don't see why it couldn't like without the packed attribute. (The
manual says packed attribute for a struct is equivalent to specifying
packed to each member of that struct. It doesn't say anything about the
structure alignment itself.)

Ok, not that I'm fully convinced, but it doesn't matter.

So let's NOT mark it packed.

Anyway the info you sent was useful for me.

thanks,
-- 
js
suse labs
