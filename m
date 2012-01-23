Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab2AWT2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:28:51 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63197 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab2AWT2u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:28:50 -0500
MIME-Version: 1.0
In-Reply-To: <4F1CEEA3.9050009@linux.vnet.ibm.com>
References: <4F171B6B.2040303@gmail.com>
	<1327003271-11730-1-git-send-email-venki@google.com>
	<4F18805F.8060901@linux.vnet.ibm.com>
	<CABeCy1YcP1u65CU8n8ug4g7haUq8Vyi55ABZr3hNHFxu429x+w@mail.gmail.com>
	<CAHGf_=o4PcPh3bJU8gFzGXtKeXCkdmrvfOZ2nUDc_epf1tnNyA@mail.gmail.com>
	<CABeCy1aWv1DmqrkbBJ=JmAK7UkSLH+yPK-EG+58_573yG3jsHg@mail.gmail.com>
	<4F1CEEA3.9050009@linux.vnet.ibm.com>
Date: Mon, 23 Jan 2012 11:28:49 -0800
Message-ID: <CABeCy1bgRe8=KKimBtB39F9KaJko=aD7xqYfAT0t6YcS6CMLZA@mail.gmail.com>
Subject: Re: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus
From: Venki Pallipadi <venki@google.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Travis <travis@sgi.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 22, 2012 at 9:22 PM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 01/21/2012 05:25 AM, Venki Pallipadi wrote:
>
>> On Fri, Jan 20, 2012 at 3:45 PM, KOSAKI Motohiro
>> <kosaki.motohiro@gmail.com> wrote:
>>>>>> +int nr_online_cpus __read_mostly;
>>>>>> +EXPORT_SYMBOL(nr_online_cpus);
>>>>>> +
>>>>>>  void set_cpu_possible(unsigned int cpu, bool possible)
>>>>>>  {
>>>>>>       if (possible)
>>>>>
>>>>>
>>>>> Did you forget to add:
>>>>>
>>>>>        nr_possible_cpus = cpumask_weight(cpu_possible_mask);
>>>>>
>>>>> inside set_cpu_possible() ?
>>>>
>>>> No. That was intentional as I have that coupled with nr_cpu_ids and
>>>> set once after all the bits are set in setup_nr_cpu_ids() instead of
>>>> doing for each bit set.
>>>
>>> But, Srivatsa's way seems more safer, no? Is there any advantage to make couple
>>> with nr_cpu_ids?
>>
>> I think it is a tradeoff between safer and cleaner :). infact, that's
>> how I had coded the patch first. But, then I changed it to be in sync
>> with nr_cpu_ids as it seemed a bit cleaner (and also to make sure 2048
>> CPU guys won't come after me for doing the mask calculation 2048 times
>> during the boot).
>>
>
>
> I knew you were trying to optimize further when I saw your patch. That's
> precisely the reason I cross-checked the code to ensure that the optimization
> didn't go beyond correctness :)
>
> And this is what I found:
>
> start_kernel()
>  setup_nr_cpu_ids() // This is not the end of setting up cpu_possible_mask
>  rest_init()
>    kernel_init()
>      smp_prepare_cpus();
>
> And on x86, this becomes:
>      native_smp_prepare_cpus();
>        smp_sanity_check(); // cpu_possible_mask & nr_cpu_ids can change here!
>           ^^^^^^^^^
>

Ack. Thanks for pointing this out. I missed this in my testing as this is under
if !defined(CONFIG_X86_BIGSMP) && defined(CONFIG_X86_32)

Proper way to handle this would be to call
setup_nr_cpu_ids();
After set_cpu_possible() loop.

I did a grep for any other place where nr_cpu_ids may be getting
written. And only other place I find
arch/powerpc/platforms/iseries/setup.c: nr_cpu_ids = max(nr_cpu_ids, 64);
but it does not have a accompanying set_cpu_possible(). So, the change
here should not affect this.

-Venki

> And there is another place where things can change:
> prefill_possible_map(). But this is called in setup_arch(), which is called
> before setup_nr_cpu_ids(). So we need not worry about this.
>
> (Btw, I checked only the x86 arch. Not sure how other architectures handle
> things.)
>
> Regards,
> Srivatsa S. Bhat
> IBM Linux Technology Center
>
