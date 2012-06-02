Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618Ab2FBSHA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 14:07:00 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:45266 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933556Ab2FBSG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 14:06:58 -0400
Message-ID: <4FCA5608.2010404@linux.vnet.ibm.com>
Date: Sat, 02 Jun 2012 23:36:00 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Russell King <linux@arm.linux.org.uk>, yong.zhang0@gmail.com,
        Jeremy Fitzhardinge <jeremy@goop.org>, peterz@infradead.org,
        mingo@kernel.org, x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        akpm@linux-foundation.org, nikunj@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@redhat.com>, rusty@rustcorp.com.au, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Keir Fraser <keir@xen.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH 05/27] xen, cpu hotplug: Don't call cpu_bringup()
 in xen_play_dead()
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091124.31979.91984.stgit@srivatsabhat.in.ibm.com> <4FC8D8E30200007800087D2B@nat28.tlf.novell.com> <4FC8DC19.4000007@linux.vnet.ibm.com> <4FC8FD9C0200007800087DF5@nat28.tlf.novell.com>
In-Reply-To: <4FC8FD9C0200007800087DF5@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12060218-4790-0000-0000-0000030E0D84
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2012 09:06 PM, Jan Beulich wrote:

>>>> On 01.06.12 at 17:13, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
> wrote:
>> On 06/01/2012 06:29 PM, Jan Beulich wrote:
>>
>>>>>> On 01.06.12 at 11:11, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
>>> wrote:
>>>> xen_play_dead calls cpu_bringup() which looks weird, because xen_play_dead()
>>>> is invoked in the cpu down path, whereas cpu_bringup() (as the name 
>>>> suggests) is useful in the cpu bringup path.
>>>
>>> This might not be correct - the code as it is without this change is
>>> safe even when the vCPU gets onlined back later by an external
>>> entity (e.g. the Xen tool stack), and it would in that case resume
>>> at the return point of the VCPUOP_down hypercall. That might
>>> be a heritage from the original XenoLinux tree though, and be
>>> meaningless in pv-ops context - Jeremy, Konrad?
>>>
>>> Possibly it was bogus/unused even in that original tree - Keir?
>>>
>>
>>
>> Thanks for your comments Jan!
>>
>> In case this change is wrong, the other method I had in mind was to call
>> cpu_bringup_and_idle() in xen_play_dead(). (Even ARM does something similar,
>> in the sense that it runs the cpu bringup code including cpu_idle(), in the
>> cpu offline path, namely the cpu_die() function). Would that approach work
>> for xen as well? If yes, then we wouldn't have any issues to convert xen to
>> generic code.
> 
> No, that wouldn't work either afaict - the function is expected
> to return.
> 


Ok.. So, I would love to hear a confirmation about whether this patch (which
removes cpu_bringup() in xen_play_dead()) will break things or it is good as is.

If its not correct, then we can probably make __cpu_post_online() return an int,
with the meaning:

0 => success, go ahead and call cpu_idle()
non-zero => stop here, thanks for your services so far.. now leave the rest to me.

So all other archs will return 0, Xen will return non-zero, and it will handle
when to call cpu_idle() and when not to do so.

Might sound a bit ugly, but I don't see much other option. Suggestions are
appreciated!

Regards,
Srivatsa S. Bhat

