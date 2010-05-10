Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab0EJNfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 09:35:03 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45468 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab0EJNe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 09:34:58 -0400
MIME-Version: 1.0
In-Reply-To: <20100510131519.GB7796@n2100.arm.linux.org.uk>
References: <AANLkTikIbI6hKoYSZlo6QDlyi2Qjxg287i-ilHpz1FF9@mail.gmail.com>
	 <20100510131519.GB7796@n2100.arm.linux.org.uk>
Date: Mon, 10 May 2010 16:34:57 +0300
Message-ID: <AANLkTint0f2Ow2FM3jVAqGfPjolHvF-oBTGCmY7Jx7_d@mail.gmail.com>
Subject: Re: [PATCH] Handle instruction cache maintenance fault properly
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Siarhei Siamashka <siarhei.siamashka@nokia.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Aaro Koskinen <aaro.koskinen@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 4:15 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, May 10, 2010 at 04:07:57PM +0300, Kirill A. Shutemov wrote:
>> Between "clean D line..." and "invalidate I line" operations in
>> v7_coherent_user_range(), the memory page may get swapped out.
>> And the fault on "invalidate I line" could not be properly handled
>> causing the oops.
>
> You have to be very careful when doing this kind of change - you need to
> review the behaviour of previous ARMs to ensure that you don't throw the
> CPU into an infinite loop when an "external abort on linefetch" occurs.
>
> With older CPUs, an "external abort on linefetch" is most probably fatal
> to the process and can never be recovered.

It looks like cache maintenance fault was introduced in ARMv6.

So, what is the right way to fix it? Something like:

#if __LINUX_ARM_ARCH__ < 6
        { do_bad,               SIGBUS,  0,             "external
abort on linefetch"      },
#else
        { do_translation_fault, SIGSEGV, SEGV_MAPERR,   "I-cache
maintenance fault"        },
#endif
