Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab2JSLt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 07:49:26 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37502 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478Ab2JSLtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 07:49:25 -0400
MIME-Version: 1.0
In-Reply-To: <87ipa7p8h7.fsf@rustcorp.com.au>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
	<87txtso9xw.fsf@rustcorp.com.au>
	<CA+55aFxZdtD51AVKLtKK95ooh8VB8-5Tt8nHsxSUT67CBRrp2g@mail.gmail.com>
	<871ugwny1n.fsf@rustcorp.com.au>
	<CA+55aFwTz6xadNL37H6Qb8+rWNefn0cQ0URFPfD=Ea=J54xzGg@mail.gmail.com>
	<CA+5PVA4fE7uaxNobBMtUs7QUWA2XfM_2oKtLhb7DFRisJLy+4Q@mail.gmail.com>
	<87ipa7p8h7.fsf@rustcorp.com.au>
Date: Fri, 19 Oct 2012 07:49:24 -0400
Message-ID: <CA+5PVA6q67PYagXD7WmSHjqPs2eF-oLWHFEWoXiugMQW8_ZUdg@mail.gmail.com>
Subject: Re: RFC: sign the modules at install time
From: Josh Boyer <jwboyer@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 9:16 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Josh Boyer <jwboyer@gmail.com> writes:
>> On Thu, Oct 18, 2012 at 2:46 PM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>> On Wed, Oct 17, 2012 at 10:34 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>>>
>>>> Hacking the keyid and signer-name to be extracted every time by
>>>> sign-file takes my modules_install time from 18.6 seconds to 19.1.  We'd
>>>> get that back easily by making sign-file a perl script anyway; it calls
>>>> out to perl 3 times already.
>>>
>>> Ok, that tiny slowdown seems worth the cleanup, especially if we'd get
>>> it back from somebody re-writing it in perl.
>>>
>>> Want to sign off on the two patches, or put them in your git tree?
>>
>> I tested Rusty's version of the 'sign modules at module_install time'
>> patch in a Fedora kernel build today.  It seems to work well enough,
>> even if we wind up signing things twice.  A brief cleanup of my patch
>> to add a modules_sign target on top of that is below.
>
> I'm surprised.  Only the first signature (create on the unstripped
> module) will be used by the kernel; this should fail to verify the
> stripped module.  A quick and dirty check is:
>
> grep -abo '~Module' /tmp/mod/lib/modules/3.7.0-rc1+/kernel/sound/pci/snd-intel8x0.ko
> 39828:~Module
> 40432:~Module
>
> Perhaps eu-strip actually strips the appended signature?

Yes.  The abbreviated flow chart is:

build
install (signed at install time now)
find-debuginfo.sh (eu-strip) which strips off the signature from above
modules_sign to put it back

You are certainly correct in that if I am building outside of RPM and
run modules_install followed by modules_sign, it will append a second
signature.

A further check could be done in scripts/Makefile.modsign to see if each
module is already signed and skip it if so.  I can take a look at doing
that next week if people think it would be worthwhile.

josh
