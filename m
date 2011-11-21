Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab1KUXrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 18:47:37 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43657 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab1KUXre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:47:34 -0500
Message-ID: <4ECAE314.9060209@gmail.com>
Date: Mon, 21 Nov 2011 15:47:32 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>, linux-arch@vger.kernel.org,
        Robin Holt <holt@sgi.com>
Subject: Re: [patch] hugetlb: remove dummy definitions of HPAGE_MASK and HPAGE_SIZE
References: <1321567050-13197-1-git-send-email-ddaney.cavm@gmail.com> <alpine.DEB.2.00.1111171520130.20133@chino.kir.corp.google.com> <alpine.DEB.2.00.1111171522131.20133@chino.kir.corp.google.com> <4ECACF68.3020701@gmail.com> <CA+55aFwZxqHfEOemj+OJNKCj2toqGf3rkK-9iuS39L7iZsoH1Q@mail.gmail.com>
In-Reply-To: <CA+55aFwZxqHfEOemj+OJNKCj2toqGf3rkK-9iuS39L7iZsoH1Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to expand on this lovely topic...

On 11/21/2011 02:43 PM, Linus Torvalds wrote:
> On Mon, Nov 21, 2011 at 2:23 PM, David Daney<ddaney.cavm@gmail.com>  wrote:
>>
>> This whole comment strikes me as somewhat dishonest, as at the time David
>> Rientjes wrote it, he knew that there were dependencies on these symbols in
>> the linux-next tree.
>>
>> Now we can add these:
>> +#define HPAGE_SHIFT    ({ BUG(); 0; })
>> +#define HPAGE_SIZE     ({ BUG(); 0; })
>> +#define HPAGE_MASK     ({ BUG(); 0; })
>
> Hell no.
>
> We don't do run-time BUG() things. No way, no how.
>

These symbols are on dead code paths, so they are eliminated by the 
compiler's Dead Code Elimination (DCE) optimizations, and the BUG() code 
never gets emitted to the final executable.

I agree that it is not the best thing to do, but given the current state 
of the art in build bug macros, it is the best we could have done.

What I think we need instead, and for which I will send a patch soon, is 
something like this:

extern void you_are_screwed() __attribute__ ((error("BUILD_BUG_ON_USED 
failed")));
#define BUILD_BUG_ON_USED() you_are_screwed()
#define HPAGE_SHIFT    ({ BUILD_BUG_ON_USED(); 0; })

This allows us to use the symbols in straight line C code without a ton 
of ugly #ifdefery, but give us build time error checking.

Thanks,
David Daney


> If that #define cannot be used, then it damn well shouldn't be defined at all.
>
> David's patch is clearly the right thing to do. Don't try to send me
> the above kind of insane crap.
>
>                       Linus
>

