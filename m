Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab1LTOj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 09:39:29 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:56001 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab1LTOjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 09:39:21 -0500
Message-ID: <4EF09D34.1060607@linux.vnet.ibm.com>
Date: Tue, 20 Dec 2011 20:05:32 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: mc@linux.vnet.ibm.com, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, david@fromorbit.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
References: <20111219121100.GI2203@ZenIV.linux.org.uk> <4EEF9D4E.1000008@linux.vnet.ibm.com> <20111219205251.GK2203@ZenIV.linux.org.uk> <4EF01565.2000700@linux.vnet.ibm.com> <20111220062710.GC23916@ZenIV.linux.org.uk> <4EF03915.60902@linux.vnet.ibm.com> <1324373854.21588.16.camel@mengcong> <4EF0654B.4060904@linux.vnet.ibm.com> <4EF06C9B.4010703@linux.vnet.ibm.com> <4EF084A4.3000106@linux.vnet.ibm.com> <20111220140628.GD23916@ZenIV.linux.org.uk>
In-Reply-To: <20111220140628.GD23916@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11122014-2674-0000-0000-000002B2F72D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2011 07:36 PM, Al Viro wrote:

> On Tue, Dec 20, 2011 at 06:20:44PM +0530, Srivatsa S. Bhat wrote:
> 
>>> Hey, actually there is a simple solution: just nip it (or rather delay it)
>>> in the bud ;) That is, we watch out for CPU_UP_PREPARE event and lock it
>>> up there itself using our spinlock.. that way, that cpu will not come up
>>> until we are done executing br_write_unlock(). In fact, we can even fail
>>> the onlining of that cpu by returning appropriate value from our callback,
>>> but that would be too harsh.. so we can settle for delaying the cpu online
> 
> Eeeek...  Are you serious about leaving a spinlock grabbed by notifier
> callback and not released until another callback call?  That would be one
> hell of a constraint on what these notifiers can do - _nothing_ between
> these calls (including other notifier callbacks, etc.) would be allowed
> to block.
> 
> That sounds extremely brittle...
> 


Sorry but I didn't quite get your point...
No two cpu hotplug operations can race because of the cpu_hotplug lock they
use. Hence, if a cpu online operation begins, it has to succeed or fail
eventually. No other cpu hotplug operation can intervene. Ditto for cpu offline
operations.

Hence a CPU_UP_PREPARE event *will* be followed by a corresponding
CPU_UP_CANCELED or CPU_ONLINE event for the same cpu. (And we ignore the
CPU_STARTING event that comes in between, on purpose, so as to avoid the race
with cpu_online_mask). Similar is the story for offline operation.

And if the notifier grabs the spinlock and keeps it locked between these 2
points of a cpu hotplug operation, it ensures that our br locks will spin,
instead of block till the cpu hotplug operation is complete. Isn't this what
we desired all along? "A non-blocking way to sync br locks with cpu hotplug"?

Or am I missing something?

Regards,
Srivatsa S. Bhat

