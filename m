Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab2D0Xub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 19:50:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48640 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757451Ab2D0Xu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 19:50:29 -0400
Date: Sat, 28 Apr 2012 00:50:23 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120427235023.GR6871@ZenIV.linux.org.uk>
References: <20120423180150.GA6871@ZenIV.linux.org.uk>
 <20120424072617.GB6871@ZenIV.linux.org.uk>
 <20120426183742.GA324@redhat.com>
 <20120426231942.GJ6871@ZenIV.linux.org.uk>
 <20120427172444.GA30267@redhat.com>
 <20120427184528.GL6871@ZenIV.linux.org.uk>
 <20120427202002.8ED632C0BF@topped-with-meat.com>
 <20120427211244.GO6871@ZenIV.linux.org.uk>
 <20120427212729.652542C0AF@topped-with-meat.com>
 <20120427231526.GP6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427231526.GP6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 12:15:26AM +0100, Al Viro wrote:

> I think all such architectures need that check lifted to do_notify_resume()
> (and the rest needs it killed, of course).  Including x86, by the look
> of it - we _probably_ can't get there with TIF_NOTIFY_RESUME and
> !user_mode(regs), but I'm not entirely sure of that.  arm is in about the
> same situation; alpha, ppc{32,64}, sparc{32,64} and m68k really can't get
> there like that (they all check it in the asm glue).  mips probably might,
> unless I'm misreading their ret_from_fork()...  Fun.

I'm completely unfamiliar with tile assembler, so I might be missing something
there, but AFAICS the following sequence can lead to do_signal() being
called for a kernel thread:
	kernel_thread()
		ret_from_fork() in child
			.Lresume_userspace
				do_work_pending()
					do_signal()
and unlike many other, tile does _not_ check for !user_mode() anywhere
relevant...  Broken?
