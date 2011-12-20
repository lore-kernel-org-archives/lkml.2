Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab1LTE4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 23:56:32 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:34858 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1LTE4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 23:56:25 -0500
Message-ID: <4EF01565.2000700@linux.vnet.ibm.com>
Date: Tue, 20 Dec 2011 10:26:05 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Stephen Boyd <sboyd@codeaurora.org>, mc@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, david@fromorbit.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
References: <1324265775.25089.20.camel@mengcong> <4EEEE866.2000203@linux.vnet.ibm.com> <4EEF0003.3010800@codeaurora.org> <4EEF1A13.4000801@linux.vnet.ibm.com> <20111219121100.GI2203@ZenIV.linux.org.uk> <4EEF9D4E.1000008@linux.vnet.ibm.com> <20111219205251.GK2203@ZenIV.linux.org.uk>
In-Reply-To: <20111219205251.GK2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11121918-6102-0000-0000-00000071E34A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2011 02:22 AM, Al Viro wrote:

> On Tue, Dec 20, 2011 at 01:53:42AM +0530, Srivatsa S. Bhat wrote:
>> If this new definition of our requirement is acceptable (correct me if I am
>> wrong), then we can do something like the following patch, while still
>> retaining br locks as non-blocking.
>>
>> We make a copy of the current cpu_online_mask, and lock the per-cpu locks of
>> all those cpus. Then while unlocking, we unlock the per-cpu locks of these cpus
>> (by using that temporary copy of cpu_online_mask we created earlier), without
>> caring about the cpus actually online at that moment.
>> IOW, we do lock-unlock on the same set of cpus, and that too, without missing
>> the complete lock-unlock sequence in any of them. Guaranteed.
> 
> 	And what's to stop a process on a newly added CPU from _not_
> spinning in br_read_lock(), even though br_write_unlock() hadn't been
> done yet?
> 


Oh, right, that has to be handled as well...

Hmmm... How about registering a CPU hotplug notifier callback during lock init
time, and then for every cpu that gets onlined (after we took a copy of the
cpu_online_mask to work with), we see if that cpu is different from the ones
we have already locked, and if it is, we lock it in the callback handler and
update the locked_cpu_mask appropriately (so that we release the locks properly
during the unlock operation).

Handling the newly introduced race between the callback handler and lock-unlock
code must not be difficult, I believe..

Any loopholes in this approach? Or is the additional complexity just not worth
it here?

Regards,
Srivatsa S. Bhat

