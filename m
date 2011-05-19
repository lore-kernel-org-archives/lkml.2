Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934434Ab1ESXxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:53:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:38013 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934374Ab1ESXxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:53:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,239,1304319600"; 
   d="scan'208";a="1235200"
Subject: Re: [patch 1/5] x84_64, apic: Use probe routines to simplify apic
 selection
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "steiner@sgi.com" <steiner@sgi.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gorcunov@openvz.org" <gorcunov@openvz.org>
In-Reply-To: <1305589908.13584.3.camel@sbsiddha-MOBL3.sc.intel.com>
References: <20110513180449.562138524@sbsiddha-MOBL3.sc.intel.com>
	 <20110513181008.859892593@sbsiddha-MOBL3.sc.intel.com>
	 <20110516080844.GC27635@elte.hu>
	 <1305589908.13584.3.camel@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 19 May 2011 16:54:05 -0700
Message-Id: <1305849245.13584.3232.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Thomas:

On Mon, 2011-05-16 at 16:51 -0700, Suresh Siddha wrote:
> +
> +/*
> + * We need to check for Physflat first, so don't change this order!
> + */
> +apicdriver(apic_physflat);
> +apicdriver(apic_flat);

For the couple of files (one in 32-bit arch and another in 64-bit arch)
that were listing two apic drivers (which were sharing most of the code)
in the same file, the above ordering didn't do the trick to enforce the
order.

So I ended up defining one more macro for this case and it looks like
this below.

/*
 * APIC drivers are probed based on how they are listed in the .apicdrivers
 * section. So the order is important and enforced by the ordering
 * of different apic driver files in the Makefile.
 *
 * For the files having two apic drivers, we use apic_drivers()
 * to enforce the order with in them.
 */
#define apic_driver(sym)                                        \
        static struct apic *__apicdrivers_##sym __used          \
        __aligned(sizeof(struct apic *))                        \
        __section(.apicdrivers) = { &sym }

#define apic_drivers(sym1, sym2)                                        \
        static struct apic *__apicdrivers_##sym1##sym2[2] __used        \
        __aligned(sizeof(struct apic *))                                \
        __section(.apicdrivers) = { &sym1, &sym2 }

Posted the refreshed patchset.

thanks,
suresh

