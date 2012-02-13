Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100Ab2BMUpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 15:45:08 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:49028 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab2BMUpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 15:45:06 -0500
Message-ID: <4F39763D.3070609@linux.vnet.ibm.com>
Date: Tue, 14 Feb 2012 02:14:45 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus
 -v5
References: <CABeCy1aPp4=v90v_wAsw-KWDwNs59CwwYSJ-36+4t8kMuCaK0w@mail.gmail.com> <1328055439-9441-1-git-send-email-venki@google.com> <20120201140125.c656df41.akpm@linux-foundation.org> <87d39xj955.fsf@rustcorp.com.au> <CA+8MBbJcTgj7X-7RZAgWk8a3Qyaz1FxFzu3ZLk-8LHKD7M8h-Q@mail.gmail.com> <4F3971A1.5010305@linux.vnet.ibm.com>
In-Reply-To: <4F3971A1.5010305@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12021310-7014-0000-0000-00000091621A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2012 01:55 AM, Srivatsa S. Bhat wrote:

> On 02/14/2012 01:24 AM, Tony Luck wrote:
> 
>> On Thu, Feb 2, 2012 at 12:03 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>> IIRC playing with 3 archs boot code seemed like a recipe for disaster.
>>> Feel free to try to fix this in -next though, and see what breaks...
>>
>> ia64 is what breaks ... well not actually broken ... but some very
>> weird delays that
>> show up in different places depending on whether this patch is present.
>>
>> First linux-next kernel to be blessed with this patch was
>> next-20120210. Booting it
>> I see:
>> [    7.164233] Switching to clocksource itc
>> [  146.077315] pnp: PnP ACPI init
>>
>> An ugly 138.913 second delay.  Digging in the code showed that the bad bits
>> happened inside stop_machine()
>>
>> Reverting just this patch makes this big delay disappear:
>>
>> [   32.780232] Switching to clocksource itc
>> [   32.832100] pnp: PnP ACPI init
>>
>> but notice that it takes 25 extra seconds to get to this point in the
>> boot (and while
>> we expect to save some time by not re-computing num_online_cpus each time we
>> need it ... this looks to be a lot more than I'd expect!)
>>
> 
> 
> Oh no!! ia64 directly uses cpu_set() and cpu_clear() on cpu_online_map!!
> Grr.. It means num_online_cpus can be different from the actual number of
> online cpus because it doesn't go through the set_cpu_online() path.. I haven't
> yet pin-pointed the exact problem, but this definitely doesn't look good...
>  


Hmm.. interesting.. The only calls that ia64 uses which updates the
num_online_cpus macro seem to be init_cpu_online(cpumask_of(0)); Atleast this
is what the mainline code tells me (haven't checked linux-next).

So, if I am not mistaken, is the value of num_online_cpus() always 1 when
Venki's patch is applied?

IOW, what output do you see from the following printk from
arch/ia64/kernel/smpboot.c?

printk(KERN_INFO "Total of %d processors activated (%lu.%02lu BogoMIPS).\n",
         (int)num_online_cpus(), bogosum/(500000/HZ), (bogosum/(5000/HZ))%100);


Regards,
Srivatsa S. Bhat

