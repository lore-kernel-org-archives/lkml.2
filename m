Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161824Ab2CPAUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 20:20:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40115 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161102Ab2CPAUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 20:20:09 -0400
MIME-Version: 1.0
In-Reply-To: <87lin18l7o.fsf@ti.com>
References: <1331749794-8056-1-git-send-email-ccross@android.com>
	<1331749794-8056-4-git-send-email-ccross@android.com>
	<87lin18l7o.fsf@ti.com>
Date: Thu, 15 Mar 2012 17:20:08 -0700
X-Google-Sender-Auth: NPQQIKlRKaKoKbSrV7weipKEdHo
Message-ID: <CAMbhsRS3J2vruru8i4r1-cB9aJLYW9y1bP0vv7=L3q1JP77ttg@mail.gmail.com>
Subject: Re: [PATCHv2 3/5] cpuidle: add support for states that affect
 multiple cpus
From: Colin Cross <ccross@android.com>
To: Kevin Hilman <khilman@ti.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-pm@lists.linux-foundation.org,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 5:04 PM, Kevin Hilman <khilman@ti.com> wrote:
> Colin Cross <ccross@android.com> writes:
>
>> +/**
>> + * cpuidle_coupled_cpu_set_alive - adjust alive_count during hotplug transitions
>> + * @cpu: target cpu number
>> + * @alive: whether the target cpu is going up or down
>> + *
>> + * Run on the cpu that is bringing up the target cpu, before the target cpu
>> + * has been booted, or after the target cpu is completely dead.
>> + */
>> +static void cpuidle_coupled_cpu_set_alive(int cpu, bool alive)
>> +{
>> +     struct cpuidle_device *dev;
>> +     struct cpuidle_coupled *coupled;
>> +
>> +     mutex_lock(&cpuidle_lock);
>> +
>> +     dev = per_cpu(cpuidle_devices, cpu);
>> +     if (!dev->coupled)
>> +             goto out;
>> +
>> +     coupled = dev->coupled;
>> +
>> +     /*
>> +      * waiting_count must be at least 1 less than alive_count, because
>> +      * this cpu is not waiting.  Spin until all cpus have noticed this cpu
>> +      * is not idle and exited the ready loop before changing alive_count.
>> +      */
>> +     while (atomic_read(&coupled->ready_count))
>> +             cpu_relax();
>> +
>> +     smp_mb__before_atomic_inc();
>> +     atomic_inc(&coupled->alive_count);
>
> This doesn't look quite right.  alive_count is incrmented whether the
> CPU is going up or down?
>
> Maybe I misunderstood something, but I don't see anywhere where
> alive_count is decrmemented after a CPU is removed.

Oops, dropped the atomic_dec when I merged from two separate functions
for up and down to a single function that takes a bool.

>> +     smp_mb__after_atomic_inc();
>> +
>> +     if (alive)
>> +             coupled->requested_state[dev->cpu] = CPUIDLE_COUPLED_NOT_IDLE;
>> +     else
>> +             coupled->requested_state[dev->cpu] = CPUIDLE_COUPLED_DEAD;
>> +
>> +out:
>> +     mutex_unlock(&cpuidle_lock);
>> +}
>> +
