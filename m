Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab0GNXCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 19:02:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753187Ab0GNXCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 19:02:47 -0400
MIME-Version: 1.0
In-Reply-To: <4C3E3F77.1090109@goop.org>
References: <20100714154923.947138065@efficios.com>
	<20100714155804.049012415@efficios.com>
	<AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>
	<20100714170617.GB4955@Krystal>
	<AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
	<20100714203940.GC22096@Krystal>
	<AANLkTinM0eFnreNB5l_6f20oSGBchqAtYPb57tM01kUB@mail.gmail.com>
	<20100714222115.GA30122@Krystal>
	<AANLkTikLG4xVYfvuMtbuzsqcnzo1ut4dFAm6piqy2Lh7@mail.gmail.com>
	<4C3E3F77.1090109@goop.org>
Date: Wed, 14 Jul 2010 16:02:10 -0700
Message-ID: <AANLkTinIJGHYtxWXGEN_pBxoIy0lhl_eRW0QSbuSuMQQ@mail.gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 3:51 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
> We screw around with iret because there's a separate interrupt mask flag
> which can't be set atomically with respect to a stack/ring change (well,
> there's more to it, but I won't confuse matters).

Umm, I know. It's what this whole discussion (non-paravirtualized) is
all about. And I have a suggestion that should fix the
non-paravirtualized case _without_ actually touching anything but the
NMI code itself.

What I tried to say is that the paravirtualized people should take a
look at my suggestion, and see if they can apply the logic to their
NMI handling too. And in the process totally remove the need for
paravirtualizing iret, exactly because the approach handles the magic
NMI lock logic entirely in the NMI handler itself.

Because I think the same thing that would make us not need to worry
about nested page faults _during_ NMI (because we could make the NMI
code do the right thing even when the hardware doesn't lock out NMI's
for us) is also the exact same logic that the paravirt monitor could
do for its own NMI handling.

Wouldn't it be nice to be able to remove the need to paravirtualize iret?

                  Linus
