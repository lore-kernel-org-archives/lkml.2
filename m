Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab0IGWOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 18:14:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756049Ab0IGWOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 18:14:42 -0400
Message-ID: <4C86B948.9050000@redhat.com>
Date: Tue, 07 Sep 2010 12:14:32 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: "Dong, Eddie" <eddie.dong@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [KVM timekeeping 26/35] Catchup slower TSC to guest rate
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com> <1282291669-25709-27-git-send-email-zamsden@redhat.com> <1A42CE6F5F474C41B63392A5F80372B22A8253C5@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <1A42CE6F5F474C41B63392A5F80372B22A8253C5@shsmsx501.ccr.corp.intel.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2010 05:44 PM, Dong, Eddie wrote:
> Zachary:
> 	Will you extend the logic to cover the situation when the guest runs at higher than the guest rate but the PCPU is over committed. In that case, likely we can use the time spent when the VCPU is scheduled out to catch up as well. Of course if the VCPU scheduled out time is not enough to compensate the cycles caused by fast host TSC (exceeding a threahold), we will eventually have to fall back to trap and emulation mode.
>   

It is possible to do this, but it is rather dangerous. We can't let the
guest clock accelerate without bounds. We could put a limit on the
maximum overrun the TSC is allowed to reach, and then switch into
trapping mode, but this pre-supposes we will actually get an interrupt
in time. A CPU heavy guest with little host activity could easily
overrun much further than we would like unless we have a way to reliably
trigger interrupts near the time of maximum allowed overrun.

So, first, we must have a way to get such interrupts; this is needed
anyway, for the catchup case, we have a similar problem with underrun
which must be addressed. It's quite possible to add the mode you
describe once that feature is in, but it also adds even more complexity
to an already intricate clock system (which is one of the problem with
the latter part of this patch series).

Second, this mode of operation is incompatible with SMP guests under all
circumstances. SMP guests with mismatched clock speeds must always run
in trapping mode, as it is not possible to synchronize the catchup /
trap switching without extremely heavyweight measures (use IPI wakeup).
Those mechanisms will not only cost more than the trapping overhead
(future, faster systems, and larger, more parallel systems), but they
will also damage host performance (unneeded wakeups when other VCPUs are
not scheduled). Unless, of course, we gang-schedule... but that is a
difficult change and a very different mode of operation. Getting rid of
TSC trap overhead on systems with non-constant TSC isn't a sufficient
motivation for that kind of design change.

Zach
