Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353Ab1J2Ors (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 10:47:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933035Ab1J2Orq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 10:47:46 -0400
Date: Sat, 29 Oct 2011 16:43:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Neil Horman <nhorman@tuxdriver.com>, Earl Chew <earl_chew@agilent.com>,
        Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] exec: log when wait_for_dump_helpers aborts due to a
	signal
Message-ID: <20111029144315.GB7036@redhat.com>
References: <1319591228-20397-1-git-send-email-msb@chromium.org> <20111028162631.294c1f8a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111028162631.294c1f8a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28, Andrew Morton wrote:
>
> Well.  Neil's changelog for 61be228a06dc6e8662 is quite nice and tells
> us everything we could possibly want to know, except for why it tests
> sgnal_pending() :(

In short, signal_pending() should not be here. It only reflects the
fact that do_coredump() needs the fixes (and can't resist, I sent the
patch several years ago, but it was ignored ;)

There are 2 reasons. if signal_pending() == T then:

	- pipe_wait() is pointless, it won't block. We do not want
	  a busywait loop.

	- And probably even wait_for_dump_helpers() is pointless,
	  it is quite possible that pipe_write() already failed
	  before and the reader doesn't know this.

What I think we should do:

	- Fix this code, it should not react to signals.

	- But! at the same time the explicit SIGKILL should stop
	  the coredump. It can take a lot of time/resources.

	  This also makes it oom-killable, and this is important.

	- If we dump to the pipe, then perhaps it makes sense to
	  send a signal to the pipe reader in the latter case, but
	  this is a bit offtopic.

I'll try to redo my old patches for 3.2 once I have the time. There
are some nasty problems which I forgot, _iirc_ this is not that
trivial.

Oleg.

