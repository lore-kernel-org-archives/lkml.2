Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab1ASVkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:40:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43372
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753400Ab1ASVkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:40:13 -0500
Date: Wed, 19 Jan 2011 13:40:47 -0800 (PST)
Message-Id: <20110119.134047.232915743.davem@davemloft.net>
To: mathieu.desnoyers@efficios.com
Cc: rostedt@goodmis.org, richm@oldelvet.org.uk, 609371@bugs.debian.org,
        ben@decadent.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110119153326.GC11022@Krystal>
References: <20110118.223247.241909079.davem@davemloft.net>
	<20110118.232045.58440904.davem@davemloft.net>
	<20110119153326.GC11022@Krystal>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Wed, 19 Jan 2011 10:33:26 -0500

> I'm still unsure that __long_long_aligned is needed over __long_aligned though.
> AFAIK, the only requirement we have for, e.g. tracepoints, is to align on the
> pointer size (sizeof(long)), so RCU pointer updates are performed atomically.
> Aligning on the pointer size also allows the architecture to efficiently read
> the field content. What does aligning on sizeof(long long) bring to us ? Is it
> that you are concerned about the fact that the "aligned" type attribute, when
> applied to a structure, is only used as a lower-bound by the compiler ? In that
> case, we might want to consider using "packed" too:

My concern is that if there is ever a u64 or similarly "long long"
typed member in these tracing structures, it will not be aligned
sufficiently to avoid unaligned access traps on 32-bit systems.

If your suggestion defines the lowest possible alignment and GCC will
do the right thing and "up-align" the structure if necessary, then
fine.

If you add "packed" it is going to screw everything up and we'll
essentially be back to square one.

On RISC like sparc64, "packed" causes even 16-bit words to be read and
written a byte at a time.

Never use "packed" under any circumstances unless absolutely
unavoidable.
