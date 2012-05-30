Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab2E3MtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 08:49:14 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:36104 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab2E3MtN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 08:49:13 -0400
MIME-Version: 1.0
In-Reply-To: <4FC6107F.9020802@parallels.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>
 <1338371317-5980-4-git-send-email-glommer@parallels.com> <CAPM31RJanAvDB+pZ+h5J3W6KXvAwPgbbeXgw6C_56tx_Mc+cgA@mail.gmail.com>
 <4FC6107F.9020802@parallels.com>
From: Paul Turner <pjt@google.com>
Date: Wed, 30 May 2012 05:48:40 -0700
Message-ID: <CAPM31RJ7s+pNciOEnsfXRU9xCwnUano1k8CTEUuCjsSN5n0-1Q@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] expose fine-grained per-cpu data for cpuacct stats
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, devel@openvz.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, handai.szj@gmail.com,
        Andrew.Phillips@lmax.com, Serge Hallyn <serge.hallyn@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 5:20 AM, Glauber Costa <glommer@parallels.com> wrote:
> On 05/30/2012 03:24 PM, Paul Turner wrote:
>>>
>>> +static int cpuacct_stats_percpu_show(struct cgroup *cgrp, struct cftype
>>> *cft,
>>> >  +                                    struct cgroup_map_cb *cb)
>>> >  +{
>>> >  +       struct cpuacct *ca = cgroup_ca(cgrp);
>>> >  +       int cpu;
>>> >  +
>>> >  +       for_each_online_cpu(cpu) {
>>> >  +               do_fill_cb(cb, ca, "user", cpu, CPUTIME_USER);
>>> >  +               do_fill_cb(cb, ca, "nice", cpu, CPUTIME_NICE);
>>> >  +               do_fill_cb(cb, ca, "system", cpu, CPUTIME_SYSTEM);
>>> >  +               do_fill_cb(cb, ca, "irq", cpu, CPUTIME_IRQ);
>>> >  +               do_fill_cb(cb, ca, "softirq", cpu, CPUTIME_SOFTIRQ);
>>> >  +               do_fill_cb(cb, ca, "guest", cpu, CPUTIME_GUEST);
>>> >  +               do_fill_cb(cb, ca, "guest_nice", cpu,
>>> > CPUTIME_GUEST_NICE);
>>> >  +       }
>>> >  +
>>
>> I don't know if there's much that can be trivially done about it but I
>> suspect these are a bit of a memory allocation time-bomb on a many-CPU
>> machine.  The cgroup:seq_file mating (via read_map) treats everything
>> as/one/  record.  This means that seq_printf is going to end up
>> eventually allocating a buffer that can fit_everything_  (as well as
>>
>> every power-of-2 on the way there).  Adding insult to injury is that
>> that the backing buffer is kmalloc() not vmalloc().
>>
>> 200+ bytes per-cpu above really is not unreasonable (46 bytes just for
>> the text, plus a byte per base 10 digit we end up reporting), but that
>> then  leaves us looking at order-12/13 allocations just to print this
>> thing when there are O(many) cpus.
>>
>
> And how's /proc/stat different ?
> It will suffer from the very same problems, since it also have this very
> same information (actually more, since I am skipping some), per-cpu.

So,

a) the information in /proc/stat is actually much denser since it's
"cpu VAL VAL VAL VAL" as opposed to "cpuX.FIELD VAL"
b) If it became a problem the /proc/stat case is actually fairly
trivially fixable by defining each cpu as a record and "everything
else" as a magic im-out-of-cpus value.

>
> Now, if you guys are okay with a file per-cpu, I can do it as well.
> It pollutes the filesystem, but at least protects against the fact that this
> is kmalloc-backed.
>

As I prefaced, I'm not sure there's much that can be trivially done
about it.  This is really a fundamental limitation of how read_map()
works.

What we really need is a proper seq_file exposed through cftypes.
