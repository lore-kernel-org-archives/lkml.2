Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1JWRH6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 13:07:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab1JWRH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 13:07:57 -0400
Message-ID: <4EA449DD.1010801@redhat.com>
Date: Sun, 23 Oct 2011 10:07:41 -0700
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] x86: Fix compilation bug in kprobes' twobyte_is_boostable
References: <1319229182-32226-1-git-send-email-jistone@redhat.com> <CA+55aFzXHLrcP1idskKJXcxdPfjSCfgmtYzd7r4uA4ni1E+k+A@mail.gmail.com>
In-Reply-To: <CA+55aFzXHLrcP1idskKJXcxdPfjSCfgmtYzd7r4uA4ni1E+k+A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2011 05:25 PM, Linus Torvalds wrote:
> Hmm. I'd *much* rather do this in arch/x86/include/asm/bitops.h
> instead, methinks.

Agreed, that's why I tried that first.

> Also, rather than your
> 
>> See also my more general fix, https://lkml.org/lkml/2011/10/6/412
> 
> wouldn't the simple fix be just to add the volatile there to the cast
> we already do, ie something like the appended (cut-and-paste, so it's
> whitespace-damaged, but you get the idea).

Unfortunately, no.  Whatever const-propagation gcc is doing here
(somewhat wrongly per PR50571) is not affected by volatile on that cast.
 I also tried leaving it to the parameter type (no cast), no help.

Another historical note is that the parameter used to be void* until
commit 5136dea5, which I suppose is why the current cast exists at all.
 Reverting that still doesn't affect the immediate problem.

It may have gotten lost in the various messages I sent, but note that
this is only happening on i386, where the source u32 matches the size of
the casted long.  On x86_64, where long is of course bigger than u32,
the pointer aliasing seems to prevent the issue.  So yet another fix is
to make that asm cast something silly that will always alias, like
(*(char*)addr).  That might be even more magical/fragile though.

> And I don't mind volatile in code nearly as much as I mind volatile on
> the data structures (it's one of my "C typing was misdesigned" pet
> peeves: I think "volatile" is about the access, not about the data)

I just tried removing the const from twobyte_is_boostable[], and that
also does the trick.  Not sure why I didn't try that first -- I guess
because I saw all the volatiles in bitops.  Is that more palatable, or
would you still rather try to fix it in bitops.h directly?

>  - Long long ago, we had that "big array" approach for ADDR too. So
> we've wavered between the volatile and using a block memory op. But
> we've used the "volatile" for a long time now for the bit change ones,
> so I don't think we should mix concepts like your patch.

Do you recall why it settled on volatile?  That seems like the less
descriptive of the two approaches.  But "long long ago" appears to be
beyond recorded (git) history...

Thanks,
Josh
