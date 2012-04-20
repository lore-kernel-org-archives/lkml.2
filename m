Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab2DTWfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:35:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51810 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab2DTWfv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:35:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120420221315.GN6871@ZenIV.linux.org.uk>
References: <alpine.LRH.2.02.1204190101380.30151@tundra.namei.org>
 <1334772473.2137.22.camel@falcor> <20120418183938.GH6589@ZenIV.linux.org.uk>
 <1334865448.2429.35.camel@falcor> <20120420004303.GB6871@ZenIV.linux.org.uk>
 <alpine.LSU.2.00.1204201133340.1450@eggly.anvils> <20120420190418.GK6871@ZenIV.linux.org.uk>
 <CA+55aFwVJ7SFbb3ZVxnon-Vv19pbNvUN4oungH479q7DUjBtwQ@mail.gmail.com>
 <20120420195833.GM6871@ZenIV.linux.org.uk> <CA+55aFzaC8YfN_q1TxPbNgpD7AnoAVac2Bqa+ysEji3u7ZQ18A@mail.gmail.com>
 <20120420221315.GN6871@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 20 Apr 2012 15:35:29 -0700
X-Google-Sender-Auth: 7LTFhqGnO6QHZCHmEBcz1Qlatqs
Message-ID: <CA+55aFzEwsW1kdLo2hpgW2PUCRkyaRxS_KB40iwmuk1FDgV+cg@mail.gmail.com>
Subject: Re: [RFC] situation with fput() locking (was Re: [PULL REQUEST] :
 ima-appraisal patches)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 3:13 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Kinda-sorta.  I agree that such helpers make sense, but you are too
> optimistic about the number of such places.  And clusterfuck around
> mremap() is fairly deep, so propagating all way back to up_write()
> wont' be fun.

Fair enough.

I'll do the helpers and see how much they get rid of, just because
looking at all the callers, those helpers seem to be obviously the
right thing anyway. So even if we don't do anything else, we can
improve things regardless.

For do_brk(), for example, it looks like do_brk() itself should
actually be entirely static to mm/mmap.c, because every single caller
from the outside actually wants the self-locking version.

So plan right now: do "vm_xyzzy()" helper functions that do
"do_xyzzy()" and take the lock (and do not take the "mm" argument,
because it had better always be the current one - keep the calling
convention as simple as possible).

                   Linus
