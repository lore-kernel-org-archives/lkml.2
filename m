Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab2GESuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 14:50:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62200 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab2GESuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 14:50:05 -0400
MIME-Version: 1.0
In-Reply-To: <1341511933-11169-7-git-send-email-tytso@mit.edu>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu> <1341511933-11169-7-git-send-email-tytso@mit.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Jul 2012 11:49:44 -0700
X-Google-Sender-Auth: MWbSwynCvgsXkNggtWtStMHJSsw
Message-ID: <CA+55aFxF6xnCoMbK1nQPAdvR=j6Actp_VSW5vE-90sVffErrqQ@mail.gmail.com>
Subject: Re: [PATCH 06/10] random: use the arch-specific rng in xfer_secondary_pool
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>, w@1wt.eu,
        ewust@umich.edu, zakir@umich.edu, greg@kroah.com, mpm@selenic.com,
        nadiah@cs.ucsd.edu, jhalderm@umich.edu, tglx@linutronix.de,
        davem@davemloft.net, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 11:12 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> If the CPU supports a hardware random number generator, use it in
> xfer_secondary_pool(), where it will significantly improve things and
> where we can afford it.

Ok, this makes the other patch look much better, in that hopefully
"get_random_bytes()" at least is guaranteed to use the hw randomness.

HOWEVER, it does look a bit bogus. Why use "arch_get_random_int()",
when "arch_get_random_long()" gives you potentially twice the amount
at the same cost? Also, you already have a 128-byte array on the stack
(tmp[]), please don't make the stack cost of this thing even bigger.
Use a "union" to hold both tmp[] and hwrand[] without growing the
stack unnecessarily.

Also, you should not use "cycle_t cycles" - your changes to the struct
are not an improvement. The high bits of "cycles" have no actual
randomness in them, and you're just making things more expensive for
no reason.  At least on x86, the low 32 bits of the cycles are cheaper
than the whole 64-bit value. So using more bits guys you nothing, and
only makes the code slower.

                    Linus
