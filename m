Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab3ADFTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 00:19:14 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:47779 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3ADFTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 00:19:11 -0500
MIME-Version: 1.0
In-Reply-To: <50E594F2.4000800@linux.vnet.ibm.com>
References: <98330b2deb910453a356404b8cf774c94326bc42.1355636864.git.viresh.kumar@linaro.org>
	<1fe21314c2e17585e22c546e2cac12544f8f9733.1355636864.git.viresh.kumar@linaro.org>
	<50E594F2.4000800@linux.vnet.ibm.com>
Date: Fri, 4 Jan 2013 10:49:10 +0530
Message-ID: <CAKohpo=Z=nA2Mr23ior8c0Qmt75+bOVLvZwNdc7OXq-+rH1dWQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] cpufreq: Don't use cpu removed during cpufreq_driver_unregister
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, rafael.j.wysocki@intel.com, linaro-dev@lists.linaro.org,
        nicolas.pitre@linaro.org, amit.kucheria@linaro.org,
        mathieu.poirier@linaro.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, pdsw-power-team@arm.com,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 January 2013 19:55, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> I took a quick look at the problem you described above, and the cpufreq code..
> If we cannot avoid calling cpufreq_add_dev() from cpufreq_remove_dev(), then I can't
> think of anything better than what your patch does.

Good :)

> BTW, off-topic, while going through that path, I think I found a memory leak
> in __cpufreq_remove_dev():
>
>         if (unlikely(cpumask_weight(data->cpus) > 1)) {
>                 for_each_cpu(j, data->cpus) {
>                         if (j == cpu)
>                                 continue;
>                         per_cpu(cpufreq_cpu_data, j) = NULL;
>                 }
>         }
>
> We are assigning NULL without freeing that memory.

Not really. All cpus in affected_cpus (data->cpus), share the same
policy structure.
We have already taken backup of cpufreq_cpu_data for the first cpu in "data" and
are freeing it here:

	kfree(data);
