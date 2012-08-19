Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab2HSIhi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 04:37:38 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:58946 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab2HSIhb convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:2>);
	Sun, 19 Aug 2012 04:37:31 -0400
Message-Id: <5030B3D7020000780008A217@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Sun, 19 Aug 2012 09:37:27 +0100
From: "Jan Beulich" <jbeulich@suse.com>
To: <andi@firstfloor.org>, <ak@linux.intel.com>,
        <linux-kernel@vger.kernel.org>
Cc: <x86@kernel.org>, <akpm@linux-foundation.org>, <mmarek@suse.cz>,
        <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 48/74] x86, lto: Use inline assembler instead of
 global register variable to get sp
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
 <1345345030-22211-49-git-send-email-andi@firstfloor.org>
In-Reply-To: <1345345030-22211-49-git-send-email-andi@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <andi@firstfloor.org> 08/19/12 4:59 AM >>>
>I verified this generates the same binary (on 64bit) as the original
>register variable.

This isn't very surprising given that the modified code is inside a
CONFIG_X86_32 conditional (as ought to be obvious from the code using
%%esp). Given that it's being used as operand to a binary &, the resulting
code - if the compiler handles this only half way sensibly - can hardly be
expected to be identical.

>-register unsigned long current_stack_pointer asm("esp") __used;
>+#define current_stack_pointer ({         \
>+    unsigned long sp;            \
>+    asm("mov %%esp,%0" : "=r" (sp));    \
>+    sp;                    \
>+})
 
It would get closer to the original if you used "=g" (I noticed in a few
earlier patches already that you like to use "=r" in places where a register
is not strictly required, thus reducing the flexibility the compiler has).

Also, given that this is more a workaround for a compiler deficiency,
shouldn't this be conditional upon use of LTO?

Jan

