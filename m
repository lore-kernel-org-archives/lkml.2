Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031324Ab2COXEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 19:04:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:42841 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031141Ab2COXEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 19:04:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="129543291"
Subject: Re: [PATCH] Use x2apic_supported() in the default_apic_id_valid()
 function.
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Steffen Persvold <sp@numascale.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Date: Thu, 15 Mar 2012 16:04:52 -0700
In-Reply-To: <4F626E6C.5010809@numascale.com>
References: <CAE9FiQXC7T7JQRfiry8nHaRYN3ggy9vfzc2jDUzar80hv6pEvw@mail.gmail.com>
	  <1331834583-16070-1-git-send-email-sp@numascale.com>
	  <CAE9FiQUh-kEcLLAZYiy90UJY8-WmXTKhYrjS7HQ40U+Ah2dwNg@mail.gmail.com>
	 <1331846504.16101.12.camel@sbsiddha-desk.sc.intel.com>
	 <4F626E6C.5010809@numascale.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1331852692.16101.30.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 23:34 +0100, Steffen Persvold wrote:
> Is my understanding of your suggestion correct that in 
> x2apic_phys/cluster.c we add the following apic_id_valid() function :
> 
> static int x2apic_apic_id_valid(int apicid)
> {
>   	return x2apic_mode || (apicid < 255);
> }

Steffen, We can have something like:

static int x2apic_apic_id_valid(int apicid)
{
   	return 1;
}

and

static int xapic_apic_id_valid(int apicid)
{
   	return apicid < 255;
}

If we have selected x2apic driver, then we know we are already in x2apic
mode. And also x2apic_uv_x need to use the x2apic version above.

> Considering that this function (apic->apic_id_valid()) is called already 
> in the acpi/boot.c::acpi_parse_x2apic() function is it sufficient enough 
> to test for x2apic_mode ? Yinghai indicated that x2apic_mode was not set 
> at this point, thus it was testing cpu_has_x2apic instead ?

If the bios has handed over to us in x2apic mode (or if it is a numachip
platform), then by this point apic driver is already set to the
corresponding x2apic/numachip driver etc. so we should be fine.

When we are in xapic mode, typically there should be no x2apic MADT
entries. And even if there are any (bios not following x2apic spec), the
above xapic_apic_id_valid() check will consider only those x2apic MADT
entries whose id's are less than 255. xapic mode can go into x2apic mode
later but that flow is not supposed to bring up any cpu with apic id >
255. So parsing only entries with apic id < 255 here should be fine.

Hope this clarifies.

thanks,
suresh

