Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154Ab2AWFWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 00:22:54 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:53490 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab2AWFWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 00:22:53 -0500
Message-ID: <4F1CEEA3.9050009@linux.vnet.ibm.com>
Date: Mon, 23 Jan 2012 10:52:43 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Venki Pallipadi <venki@google.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Travis <travis@sgi.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus
References: <4F171B6B.2040303@gmail.com> <1327003271-11730-1-git-send-email-venki@google.com> <4F18805F.8060901@linux.vnet.ibm.com> <CABeCy1YcP1u65CU8n8ug4g7haUq8Vyi55ABZr3hNHFxu429x+w@mail.gmail.com> <CAHGf_=o4PcPh3bJU8gFzGXtKeXCkdmrvfOZ2nUDc_epf1tnNyA@mail.gmail.com> <CABeCy1aWv1DmqrkbBJ=JmAK7UkSLH+yPK-EG+58_573yG3jsHg@mail.gmail.com>
In-Reply-To: <CABeCy1aWv1DmqrkbBJ=JmAK7UkSLH+yPK-EG+58_573yG3jsHg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12012219-9264-0000-0000-000000AE6D41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2012 05:25 AM, Venki Pallipadi wrote:

> On Fri, Jan 20, 2012 at 3:45 PM, KOSAKI Motohiro
> <kosaki.motohiro@gmail.com> wrote:
>>>>> +int nr_online_cpus __read_mostly;
>>>>> +EXPORT_SYMBOL(nr_online_cpus);
>>>>> +
>>>>>  void set_cpu_possible(unsigned int cpu, bool possible)
>>>>>  {
>>>>>       if (possible)
>>>>
>>>>
>>>> Did you forget to add:
>>>>
>>>>        nr_possible_cpus = cpumask_weight(cpu_possible_mask);
>>>>
>>>> inside set_cpu_possible() ?
>>>
>>> No. That was intentional as I have that coupled with nr_cpu_ids and
>>> set once after all the bits are set in setup_nr_cpu_ids() instead of
>>> doing for each bit set.
>>
>> But, Srivatsa's way seems more safer, no? Is there any advantage to make couple
>> with nr_cpu_ids?
> 
> I think it is a tradeoff between safer and cleaner :). infact, that's
> how I had coded the patch first. But, then I changed it to be in sync
> with nr_cpu_ids as it seemed a bit cleaner (and also to make sure 2048
> CPU guys won't come after me for doing the mask calculation 2048 times
> during the boot).
> 


I knew you were trying to optimize further when I saw your patch. That's
precisely the reason I cross-checked the code to ensure that the optimization
didn't go beyond correctness :)

And this is what I found:

start_kernel()
  setup_nr_cpu_ids() // This is not the end of setting up cpu_possible_mask
  rest_init()
    kernel_init()
      smp_prepare_cpus();

And on x86, this becomes:
      native_smp_prepare_cpus();
        smp_sanity_check(); // cpu_possible_mask & nr_cpu_ids can change here!
           ^^^^^^^^^

And there is another place where things can change:
prefill_possible_map(). But this is called in setup_arch(), which is called
before setup_nr_cpu_ids(). So we need not worry about this.

(Btw, I checked only the x86 arch. Not sure how other architectures handle
things.)

Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

