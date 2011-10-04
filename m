Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab1JDNPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 09:15:23 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:52891 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab1JDNPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 09:15:21 -0400
Message-ID: <4E8B06E0.2090501@linux.vnet.ibm.com>
Date: Tue, 04 Oct 2011 18:45:12 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Borislav Petkov <bp@alien8.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        tigran@aivazian.fsnet.co.uk, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] Freezer, CPU hotplug, x86 Microcode: Fix task
 freezing failures
References: <4E88B5E0.6080503@linux.vnet.ibm.com> <20111002195023.GC31799@mtj.dyndns.org> <4E88C3D4.2020300@linux.vnet.ibm.com> <20111003004051.GD31799@mtj.dyndns.org> <4E894D75.808@linux.vnet.ibm.com> <20111003084754.GB4411@liondog.tnic> <20111004071508.GA15637@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20111004071508.GA15637@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2011 12:45 PM, Tejun Heo wrote:
> Hello,
> 
> On Mon, Oct 03, 2011 at 10:47:54AM +0200, Borislav Petkov wrote:
>> I think your patch makes sense because re-loading the ucode during
>> a suspend/resume cycle is unnecessary. If one wants to update the
>> microcode, it should happen later when the box is resumed again: you
>> simply put the new microcode image in /lib/firmware/... and on AMD
>> unload/reload the microcode module and on Intel you do either that or
>> use the deprecated microcode_ctl.
> 
> I don't think it changes anything for suspend/resume cycles.  They're
> different hooks.  The proposed patch changes actual cpu hotplug paths.
> 

Hi,
I agree with you that my patch modifies the actual cpu hotplug path, which is
not desirable if we are going to do physical cpu hotplug because, even when the
freezer is not active, my patch would prevent us from revising the microcode
even during a pure cpu hotplug operation.

I would like to propose a modified solution to the problem:

Taking a CPU offline:
* Upon a CPU_DEAD notification, just like the code originally did, we free
  the kernel's copy of the microcode and invalidate it. So no changes here.
 
Bringing a CPU online:
* When a CPU_ONLINE or CPU_ONLINE_FROZEN notification is received, 
  a. If the userspace is not frozen, we request microcode from userspace and
     apply it to the cpu.

  b. However if we find that the userspace is frozen at that moment, we defer
     applying microcode now and register a callback function to be executed
     immediately when the userspace gets thawed. This callback function would
     request microcode from userspace and apply it to the cpu.

The advantage of this approach over the previous idea I proposed is that we don't
prevent the kernel from invalidating the microcode, thereby ensuring that we
don't break any possible assumptions about microcode.
So, every cpu will get a fresh copy of microcode from userspace, either immediately
or after a while, depending on whether the userspace is frozen or not at that instant.
As a consequence, physical cpu hotplug would also work just fine with this approach.

How does this sound? I'll write up a patch for this and post it for review soon.

-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
