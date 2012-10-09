Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab2JIQ6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:58:24 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46798 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab2JIQ6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:58:22 -0400
MIME-Version: 1.0
In-Reply-To: <20121009155613.GA3729@e103034-lin>
References: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
	<1348252345-5642-3-git-send-email-morten.rasmussen@arm.com>
	<CAKohponOWLNSUOtqC_TMfat-yQH=tGC_kg3yNTTQwOoRGH+U5g@mail.gmail.com>
	<20121009155613.GA3729@e103034-lin>
Date: Tue, 9 Oct 2012 22:28:21 +0530
Message-ID: <CAKohpo=TuEUAzbTsN6LSq1ffa_vdVEddS1qg7RvasqWkUegzJA@mail.gmail.com>
Subject: Re: [RFC PATCH 02/10] sched: Task placement for heterogeneous systems
 based on task load-tracking
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Morten Rasmussen <Morten.Rasmussen@arm.com>
Cc: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "pjt@google.com" <pjt@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "linaro-sched-sig@lists.linaro.org" 
	<linaro-sched-sig@lists.linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Robin Randhawa <Robin.Randhawa@arm.com>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 October 2012 21:26, Morten Rasmussen <Morten.Rasmussen@arm.com> wrote:
> On Thu, Oct 04, 2012 at 07:02:03AM +0100, Viresh Kumar wrote:
>> On 22 September 2012 00:02,  <morten.rasmussen@arm.com> wrote:

>> > SCHED_HMP requires that the platform implements arch_get_hmp_domains()
>> > which should set up the platform specific list of hmp_domains. It is
>> > also assumed that the platform disables SD_LOAD_BALANCE for the
>> > appropriate sched_domains.
>>
>> An explanation of this requirement would be helpful here.
>
> Yes. This is to prevent the load-balancer from moving tasks between
> hmp_domains. This will be done exclusively by SCHED_HMP instead to
> implement a strict task migration policy and avoid changing the
> load-balancer behaviour. The load-balancer will take care of
> load-balacing within each hmp_domain.

Honestly speaking i understood this point now and earlier it wasn't clear
to me :)

What would be ideal is to put this information in the comment just before
we re-define other SCHED_*** domains where we disable balancing.
And keep it in the commit log too.

>> > +struct hmp_domain {
>> > +       struct cpumask cpus;
>> > +       struct list_head hmp_domains;
>>
>> Probably need a better name here. domain_list?
>
> Yes. hmp_domain_list would be better and stick with the hmp_* naming
> convention.

IMHO hmp_ would be better for global names, but names of variables
enclosed within another hmp_*** data type don't actually need hmp_**,
as this is implicity.

i.e.
struct hmp_domain {
       struct cpumask cpus;
       struct list_head domain_list;
}

would be better than
       struct list_head hmp domain_list;

as the parent structure already have hmp_***. So whatever is inside the
struct is obviously hmp specific.

>> > +/* Setup hmp_domains */
>> > +static int __init hmp_cpu_mask_setup(void)
>>
>> How should we interpret its return value? Can you mention what does 0 & 1 mean
>> here?
>>
>
> Returns 0 if domain setup failed, i.e. the domain list is empty, and 1
> otherwise.

Helpful. Please mention this in function comment in your next revision.

>> > +{
>> > +       char buf[64];
>> > +       struct hmp_domain *domain;
>> > +       struct list_head *pos;
>> > +       int dc, cpu;

>> > +       /* Print hmp_domains */
>> > +       dc = 0;
>>
>> Should be done during definition of dc.

You missed this ??

>> > +               for_each_cpu_mask(cpu, domain->cpus) {
>> > +                       per_cpu(hmp_cpu_domain, cpu) = domain;
>> > +               }
>>
>> Should use hmp_cpu_domain(cpu) here. Also no need of {} for single
>> line loop.

??

>> > +               dc++;
>>
>> You aren't using it... Only for testing? Should we remove it from mainline
>> patchset and keep it locally?
>>
>
> I'm using it in the pr_debug line a little earlier. It is used for
> enumerating the hmp_domains.

My mistake :(

>> > +/* Check if cpu is in fastest hmp_domain */
>> > +static inline unsigned int hmp_cpu_is_fastest(int cpu)
>> > +{
>> > +       struct list_head *pos;
>> > +
>> > +       pos = &hmp_cpu_domain(cpu)->hmp_domains;
>> > +       return pos == hmp_domains.next;
>>
>> better create list_is_first() for this.
>
> I had the same thought, but I see that as a separate patch that should
> be submitted separately.

Correct. So better send it now, so that it is included before you send your
next version. :)

--
viresh
