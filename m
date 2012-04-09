Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab2DIR5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:57:38 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:51350 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2DIR5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:57:36 -0400
Message-ID: <4F8322D7.6080704@linaro.org>
Date: Mon, 09 Apr 2012 10:56:39 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2] [RFC] Volatile Ranges (v6)
References: <1333757338-6854-1-git-send-email-john.stultz@linaro.org> <CAO6Zf6C618gt4uLaw=MYgAq519d3UrW7zLf78Q1HOryxzRpkKA@mail.gmail.com>
In-Reply-To: <CAO6Zf6C618gt4uLaw=MYgAq519d3UrW7zLf78Q1HOryxzRpkKA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040917-6148-0000-0000-000004E92C9E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2012 01:14 AM, Dmitry Adamushko wrote:
> On 7 April 2012 02:08, John Stultz<john.stultz@linaro.org>  wrote:
>> Another detail is that by hanging the volatile ranges off of the
>> address_space, the volatility for tmpfs files persists even when no one
>> has an open fd on the file. This could cause some surprises if application
>> A marked some pages volatile and died, then application B opened the file
>> and had pages dropped out underneith it while it was being used. I suspect
>> I need to clean up the volatility when all fds are dropped.
> And how do you handle the regions that have already been purged by
> this moment? Unless B has some specific mechanism to verify the
> consistency of the content, a sensible way would be to always mark off
> the regions as non-volatile before accessing them and verify the
> return code to see if there are holes.
>
> More generally, what if B opens the file while A is still working with
> it? Besides the use of normal synchronization mechanisms, B should not
> make any assumption on the current state of the regions (unless there
> is a high-level protocol between A and B to share this info). So an
> explicit mark-off-as-non_volatile could be a simple generic mechanism.
>

So yes, marking as non-volatile before you use pages would be a way to 
avoid the issue.  But it still rubs me the wrong way.

I think the main issue I have with it is that it makes volatility the 
assumed state. So unless you mark it non-volatile to begin with, the 
file could be volatile somewhere.  I feel like volatility should be the 
special state, not the assumed one, so normal applications that don't 
think about volatility are less-likely to be surprised.

Now, when you have concurrent users of a file, you have to coordinate, 
and things can change under you. That's an expectation people already 
have.  But if volatile ranges persist, its sort of introducing a form of 
concurrency to non-concurrent access.  Where a killed application can 
reach from the grave and zap a page in file someone else is using.  I 
think this is too unexpected.

The case that bit me in particular was in testing this patch, I had an 
application (call it A) that had a bug and was marking a larger range 
volatile then it re-set to non-volatile.   Then when using the same file 
later with a different test application (call it B), I was seeing those 
further pages be zapped unexpectedly.  It took me a while to realize 
that it wasn't a problem with the B application, or the patch itself, 
but was a persistent range that was set much earlier by A.

So I suspect it would be better if the volatile ranges should be 
something that are cleared out when the last fd is closed.

thanks
-john




