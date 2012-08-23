Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab2HWASQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 20:18:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47825 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757811Ab2HWASO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 20:18:14 -0400
Message-ID: <503576AB.5030208@zytor.com>
Date: Wed, 22 Aug 2012 17:17:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, JBeulich@suse.com,
        akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 74/74] lto, workaround: Mark do_futex noinline to prevent
 clobbering ebp
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <1345345030-22211-75-git-send-email-andi@firstfloor.org>
In-Reply-To: <1345345030-22211-75-git-send-email-andi@firstfloor.org>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2012 07:57 PM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> On a 32bit build gcc 4.7 with LTO decides to clobber the 6th argument on the
> stack.  Unfortunately this corrupts the user EBP and leads to later crashes.
> For now mark do_futex noinline to prevent this.
> 
> I wish there was a generic way to handle this. Seems like a ticking time
> bomb problem.
> 

There is a generic way to handle this.  This is actually a bug in Linux
that has been known for at least 15 years and which we keep hacking around.

The right thing to do is to change head_32.S to not violate the i386
ABI.  Arguments pushed (by value) on the stack are property of the
callee, that is, they are volatile, so the hack of making them do double
duty as both being saved and passed as arguments is just plain bogus.
The problem is that it works "just well enough" that people (including
myself) keep hacking around it with hacks like this, with assembly
macros, and whatnot instead of fixing the root cause.

	-hpa
