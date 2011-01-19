Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab1ASGcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 01:32:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58559
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751733Ab1ASGcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 01:32:13 -0500
Date: Tue, 18 Jan 2011 22:32:47 -0800 (PST)
Message-Id: <20110118.223247.241909079.davem@davemloft.net>
To: mathieu.desnoyers@efficios.com
Cc: rostedt@goodmis.org, richm@oldelvet.org.uk, 609371@bugs.debian.org,
        ben@decadent.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110119050844.GA8776@Krystal>
References: <20110118201323.GA14930@Krystal>
	<1295382144.12215.123.camel@gandalf.stny.rr.com>
	<20110119050844.GA8776@Krystal>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Wed, 19 Jan 2011 00:08:45 -0500

> - No aligned() type attribute nor variable attribute. I get a crash on x86_64
>   (NULL pointer exception when executing __trace_add_event_call, the 5th call).
>   __alignof__(struct ftrace_event_call) is worth 8.

I think I figured it out.

It's the static vs. non-static thing, or some other crazyness wrt.
how x86-64 implements it's alignment rules.

GCC on x86-64 uses a completely different policy for aligning local
(ie. "static") data objects vs. globally visible ones, for one thing.
It also has different alignment policies for objects that are part
of an array vs. those which are not.

On both counts, we're lying to the compiler, so maybe it's sort of our
fault.

As far as GCC can see, the object is static and also not part of an
array or any other C construct for which things like this could matter
as long as the alignment it chooses meets the minimum alignment
requirements of the ABI.

So it doesn't let us do this trick where we put the individual event
markers into a special section, yet mark it __used and static, then
later access them as if they were part of a globally visible array.

If you look these static objects, they are emitted with a leading
".align 32" directive.  This is what screws everything up.

When the linker sees this, it aligns the start of every individual
"_ftrace_events" section, and that's where the "gaps" come from and
the crashes.

