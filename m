Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab2E3MWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 08:22:34 -0400
Received: from mx2.parallels.com ([64.131.90.16]:40345 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab2E3MWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 08:22:33 -0400
Message-ID: <4FC6107F.9020802@parallels.com>
Date: Wed, 30 May 2012 16:20:15 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <devel@openvz.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tejun Heo <tj@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
        <handai.szj@gmail.com>, <Andrew.Phillips@lmax.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v3 3/6] expose fine-grained per-cpu data for cpuacct stats
References: <1338371317-5980-1-git-send-email-glommer@parallels.com> <1338371317-5980-4-git-send-email-glommer@parallels.com> <CAPM31RJanAvDB+pZ+h5J3W6KXvAwPgbbeXgw6C_56tx_Mc+cgA@mail.gmail.com>
In-Reply-To: <CAPM31RJanAvDB+pZ+h5J3W6KXvAwPgbbeXgw6C_56tx_Mc+cgA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 03:24 PM, Paul Turner wrote:
>> +static int cpuacct_stats_percpu_show(struct cgroup *cgrp, struct cftype *cft,
>> >  +                                    struct cgroup_map_cb *cb)
>> >  +{
>> >  +       struct cpuacct *ca = cgroup_ca(cgrp);
>> >  +       int cpu;
>> >  +
>> >  +       for_each_online_cpu(cpu) {
>> >  +               do_fill_cb(cb, ca, "user", cpu, CPUTIME_USER);
>> >  +               do_fill_cb(cb, ca, "nice", cpu, CPUTIME_NICE);
>> >  +               do_fill_cb(cb, ca, "system", cpu, CPUTIME_SYSTEM);
>> >  +               do_fill_cb(cb, ca, "irq", cpu, CPUTIME_IRQ);
>> >  +               do_fill_cb(cb, ca, "softirq", cpu, CPUTIME_SOFTIRQ);
>> >  +               do_fill_cb(cb, ca, "guest", cpu, CPUTIME_GUEST);
>> >  +               do_fill_cb(cb, ca, "guest_nice", cpu, CPUTIME_GUEST_NICE);
>> >  +       }
>> >  +
> I don't know if there's much that can be trivially done about it but I
> suspect these are a bit of a memory allocation time-bomb on a many-CPU
> machine.  The cgroup:seq_file mating (via read_map) treats everything
> as/one/  record.  This means that seq_printf is going to end up
> eventually allocating a buffer that can fit_everything_  (as well as
> every power-of-2 on the way there).  Adding insult to injury is that
> that the backing buffer is kmalloc() not vmalloc().
>
> 200+ bytes per-cpu above really is not unreasonable (46 bytes just for
> the text, plus a byte per base 10 digit we end up reporting), but that
> then  leaves us looking at order-12/13 allocations just to print this
> thing when there are O(many) cpus.
>

And how's /proc/stat different ?
It will suffer from the very same problems, since it also have this very 
same information (actually more, since I am skipping some), per-cpu.

Now, if you guys are okay with a file per-cpu, I can do it as well.
It pollutes the filesystem, but at least protects against the fact that 
this is kmalloc-backed.

