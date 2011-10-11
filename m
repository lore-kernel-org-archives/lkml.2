Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab1JKJhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 05:37:22 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:54423 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab1JKJhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 05:37:20 -0400
Message-ID: <4E940E46.5000600@linux.vnet.ibm.com>
Date: Tue, 11 Oct 2011 15:07:10 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Tejun Heo <tj@kernel.org>, rjw@sisk.pl, bp@amd64.org, pavel@ucw.cz,
        len.brown@intel.com, mingo@elte.hu, akpm@linux-foundation.org,
        suresh.b.siddha@intel.com, lucas.demarchi@profusion.mobi,
        rusty@rustcorp.com.au, rdunlap@xenotime.net, vatsa@linux.vnet.ibm.com,
        ashok.raj@intel.com, tigran@aivazian.fsnet.co.uk, tglx@linutronix.de,
        hpa@zytor.com, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 2/3] Mutually exclude cpu online and suspend/hibernate
References: <20111010123102.15067.23128.stgit@srivatsabhat.in.ibm.com> <20111010123242.15067.48238.stgit@srivatsabhat.in.ibm.com> <4E92E8E0.4090004@linux.vnet.ibm.com>  <20111010170027.GD8100@google.com> <1318324714.14400.74.camel@laptop>
In-Reply-To: <1318324714.14400.74.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2011 02:48 PM, Peter Zijlstra wrote:
> On Mon, 2011-10-10 at 10:00 -0700, Tejun Heo wrote:
> 
>> On Mon, Oct 10, 2011 at 06:15:20PM +0530, Srivatsa S. Bhat wrote:
>>> Would it be better to hook into the suspend/hibernate notifiers and
>>> use them to exclude cpu hotplug from suspend/hibernate, instead of
>>> trying to take pm_mutex lock like this?
>>
>> If this change is determined to be necessary, I think it would be
>> better to make it explicit.  Exclusion through callbacks often makes
>> the locking just more obscure.
> 
> Agreed.
> 

That change is not exactly necessary. I was only wondering if that would be
a cleaner way of dealing with this problem, in the sense that instead of
making this look like a workaround to some bug, we could make it look well-
designed - the PM notifies that its going to suspend/hibernate; so whoever
wants to take actions is free to do so - and it so happens that the cpu
hotplug wants to get mutually excluded from suspend/hibernate and it
implements that exclusion ie., disables further cpu hotplug from happening
till suspend/hibernate is complete and blocks suspend/hibernate till it is
done with an ongoing cpu hotplug operation. And then the suspend/hibernate
continues normally, after returning from the notification path...

But now I see that, apart from probably making the locking more obscure, it
has another disadvantage: the code will get bloated unnecessarily, considering:

    - defining a callback for suspend/hibernate notifier in the cpu hotplug
      code
    - registering/unregistering it with the PM code
    - then implementing the mutual exclusion in that callback

And this current patchset achieves the same end goal without bloating the
code and without obscuring the locking.

So, probably its not worth hooking into the notifiers after all...
Hence we can go with this patchset itself.

-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
