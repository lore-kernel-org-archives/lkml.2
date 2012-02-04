Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab2BDPYu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 10:24:50 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:55706 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751927Ab2BDPYt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 10:24:49 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyxbieV2-WpFNrEtwQ6gXbW7y_X9oW5N6FcEcxmQKA38g@mail.gmail.com>
References: <1327021265-22184-1-git-send-email-matthew.r.wilcox@intel.com>
	<CA+55aFwmDbDm5+12Nc0wnu7J8dsOKW0tCd_tVf-3pwQOq9MF3w@mail.gmail.com>
	<20120121082857.GC32134@elte.hu>
	<CAMO-S2hq0jGeUdAzMizDOhYJvPSQ=8+HVTUVqzsBOJotxOWrUg@mail.gmail.com>
	<20120121165830.GA9216@elte.hu>
	<CAMO-S2iegkRWGcnDt0SZqJT3Y3JHQZcHfMY=THKMN7n4Ae0Fyw@mail.gmail.com>
	<CA+55aFz=KcR5ji3TBHyfAYxFg8PCjXbdLOWf7aXULYHW4pp2kg@mail.gmail.com>
	<CAMO-S2iRT+uRzzsQRmhhCs4WRefsfFirteeKXtgX3h+kuWi+eQ@mail.gmail.com>
	<CA+55aFyxbieV2-WpFNrEtwQ6gXbW7y_X9oW5N6FcEcxmQKA38g@mail.gmail.com>
Date: Sun, 5 Feb 2012 00:24:48 +0900
Message-ID: <CAMO-S2gjOL_kv1Lka_tJw5yB-LrPG-4hiJ0EKpaFzVAgRGs59A@mail.gmail.com>
Subject: Re: [PATCH] NVMe: Fix compilation on architecturs without readq/writeq
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@parallels.com>,
        linux-kernel@vger.kernel.org, hpa@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 12:03, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Jan 29, 2012 at 12:02 AM, Hitoshi Mitake <h.mitake@gmail.com> wrote:
>>
>> I don't know about the minor architectures, but some of them,
>> like alpha, seems to do reordering of memory access agressively.
>>
>> Is the reordering is applied to io rw?
>> Should memory barriers be placed between two readl/writel?
>
> No need to place barriers - the "readl/writel()" functions are ordered
> in themselves. There are non-ordered versions in theory
> ("writel_relaxed()") for things like frame buffers etc that actively
> want the ordering, but that's a separate issue entirely.
>
> You do want to make sure that they aren't in the same C expression, so
> that the compiler doesn't re-order the expression. IOW, if you just do
>
>  return (readl(addr+4) << 32) | readl(addr);
>
> then that doesn't have any ordering at all simply because there is
> none at the C level. But
>
>  u64 val;
>  val = readl(addr);
>  val |= readl(addr+4) << 32;
>
> is well-defined and must read the low word first - both at the C level
> *and* at the CPU level. Anything else would be a bug in the
> architecture "readl()" implementation or the hardware.
>
> (On x86, for example, a "readl()" is just a memory access, but while
> x86 can re-order reads to regular memory in hardware, that is *not*
> true of IO memory accesses. On architectures like POWER, 'readl()'
> implies synchronization instructions)
>
>                   Linus

Thanks for your description.
Now I can understand the semantics of readl/writel of the kernel.

-- 
Hitoshi Mitake
h.mitake@gmail.com
