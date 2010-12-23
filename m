Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab0LWLAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 06:00:36 -0500
Received: from isilmar-3.linta.de ([188.40.101.200]:56065 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752455Ab0LWLAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 06:00:34 -0500
Date: Thu, 23 Dec 2010 12:00:20 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Youquan Song <youquan.song@intel.com>
Cc: davej@redhat.com, cpufreq@vger.kernel.org, venki@google.com,
        arjan@linux.intel.com, lenb@kernel.org, suresh.b.siddha@intel.com,
        kent.liu@intel.com, chaohong.guo@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH 0/6] cpufreq: Add sampling window to enhance ondemand
 governor power efficiency
Message-ID: <20101223110020.GC18363@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Youquan Song <youquan.song@intel.com>, davej@redhat.com,
	cpufreq@vger.kernel.org, venki@google.com, arjan@linux.intel.com,
	lenb@kernel.org, suresh.b.siddha@intel.com, kent.liu@intel.com,
	chaohong.guo@intel.com, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	Youquan Song <youquan.song@linux.intel.com>
References: <1293085424-18212-1-git-send-email-youquan.song@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293085424-18212-1-git-send-email-youquan.song@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Thu, Dec 23, 2010 at 02:23:38PM +0800, Youquan Song wrote:
> Running a well-known power performance benchmark, current ondemand governor is
> not power efficiency. Even when workload is at 10%~20% of full capability, the
> CPU will also run much of time at highest frequency. In fact, in this situation,
> the lowest frequency often can meet user requirement. When running this
> benchmark on turbo mode enable machine, I compare the result of different
> governors, the results of ondemand and performance governors are the closest.
> There is no much power saving between ondemand and performance governor. If we
> can ignore the little power saving, the perfomance governor even better than 
> ondemand governor, at leaset for better performance. 
> 
> One potential reason for ondemand governor is not power efficiency is that
> ondemand governor decide the next target frequency by instant requirement during
> sampling interval (10ms or possible a little longer for deferrable timer in idle
> tickless). The instant requirement can response quickly to workload change, but
> it does not usually reflect workload real CPU usage requirement in a small 
> longer time and it possibly causes frequently change between highest and lowest
> frequency.     
> 
> This patchset add a sampling window for percpu ondemand thread. Each sampling
> window with max 150 record items which slide every sampling interval and use to
> track the workload requirement during latest sampling window timeframe. 
> The average of workload during latest sample windows will be used to decide next
> target frequency. The sampling window targets to be more truly reflects workload
> requirement of CPU usage. 
> 
> The sampling window size can be set by user and default max sampling window
> is one second. When it is set to default sampling rate, the sampling window will
> roll back to original behaviour.
> 
> The sampling window size also can be dynamicly changed in according to current
> system workload busy situation. The more idle, the smaller sampling window; the
> more busy, the larger sampling window. It will increase the respnose speed by
> decrease sampling window, while it will keep CPU working at high speed when busy
> by increase sampling window and also avoid unefficiently dangle between highest
> and lowest frequency in original ondemand.
> 
> We set to up_threshold to 80 and down_differential to 20, so when workload reach
>  80% of current frequency, it will increase to highest frequency. When workload
> decrease to below (up_threshold - down_differential)60% of current frequency
> capability, it will decrease the frequency, which ensure that CPU work above 60%
> of its current capability, otherwise lowest frequency will be used. 

Interesting approach, but seems to be quite different from what "ondemand"
does at the moment. And, as David Niemi pointed out, it seems to be more
Intel-specific. Therefore, what do you think about adding this different
algorithm as a different governor, and keep the "ondemand" algorithm more or
less as it is?

Best,
	Dominik
