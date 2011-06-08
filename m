Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab1FHMO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 08:14:58 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57909 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab1FHMO5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 08:14:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aCnrH9NxqmjWyMqAvwVvr7UPJJIA6KLcdcq40T+sLUOkM3IRS0dleCoI9jbNS+qa5T
         oTtz04a03CMvaJHxz3Tmk03U29BNeLTaVHYruHiMM7j8Bf6grP35PGoqwYMiZyJK1S4m
         1L1l1AdXrtjSinqEwkokyyYRGLtr4oUujTsjY=
MIME-Version: 1.0
In-Reply-To: <20110608104727.GT11521@ZenIV.linux.org.uk>
References: <1306772228-1603-1-git-send-email-minipli@googlemail.com>
	<20110606161254.5f02d855.akpm@linux-foundation.org>
	<BANLkTinwMyVsR-pvimeVkcqQrCuNDK4zKw@mail.gmail.com>
	<20110608104727.GT11521@ZenIV.linux.org.uk>
Date: Wed, 8 Jun 2011 14:14:56 +0200
Message-ID: <BANLkTi=qBx0Mk=b2wsA3RZVKk0RUckeN6g@mail.gmail.com>
Subject: Re: [PATCH] init: use KERNEL_DS when trying to start init process
From: Mathias Krause <minipli@googlemail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Chris Zankel <chris@zankel.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 12:47 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Jun 07, 2011 at 07:00:24PM -0700, Linus Torvalds wrote:
>
>> That said, that commit (it's commit ID 4095b99c09e3d in tglx's tree)
>> predates the "real" BK history too: it's part of the (limited) 2.4.x
>> history that was imported from the release patches into BK at the
>> beginning of the use of BK. So at that point we didn't do indivual
>> commits, it's just the import of the v2.4.3.7 -> v2.4.3.8 patch.
>>
>> But yeah, it's old and crufty. And I agree that usually the correct
>> fix is to remove the set_fs() calls entirely.
>
> I think these days its job is done by start_thread(), which is where we
> switch to USER_DS; it's called by ->load_binary() when it decides it's past
> the point of no return.  However, it would be a good idea to verify that
> all architectures do it there properly and we are not exposing a hole by
> removal of this set_fs()...

I've checked all implementations of start_thread() and found some candidates:

SPARC, TILE and Xtensa don't call set_fs(USER_DS), albeit have
different definitions for USER_DS and KERNEL_DS. So those might need
fixing. I'm not familiar with those architectures, so someone else has
to answer this.

Score does not call set_fs(USER_DS) either but that's no problem
because USER_DS has the same value as KERNEL_DS on this architecture.

All others call set_fs(USER_DS) as almost the very first instruction
in start_thread(), or, as for MIPS, do it by setting addr_limit
directly.

Generally, I think, we should get Acks for the questionable arch
maintainers before commiting the patch that removes the call to
set_fs() in search_binary_handler().

I've also checked all binary format handlers if they all call
start_thread() and found a few that do not (binfmt_em86, binfmt_misc
and binfmt_script). But those are just interpreter warppers, i.e. call
search_binary_handler() in the end so should be safe.

Mathias
