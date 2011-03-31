Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab1CaWhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 18:37:19 -0400
Received: from claw.goop.org ([74.207.240.146]:49841 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664Ab1CaWhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 18:37:17 -0400
Message-ID: <4D95020A.30807@goop.org>
Date: Thu, 31 Mar 2011 15:36:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, venki@google.com,
        ak@linux.intel.com, suresh.b.siddha@intel.com, sfr@canb.auug.org.au,
        peterz@infradead.org, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        arjan@linux.intel.com, Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] Re: [RFC PATCH V4 4/5] cpuidle: driver for xen
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com> <20110322123324.28725.3131.stgit@tringupt.in.ibm.com> <20110322145054.GB26952@dumpdata.com> <4D89C40B.4020809@linux.vnet.ibm.com> <alpine.LFD.2.02.1103231659210.12911@x980> <20110324120522.GB29294@dumpdata.com> <4D8CA902.7090907@goop.org> <alpine.LFD.2.02.1103302159010.1920@x980> <alpine.LFD.2.02.1103311724100.9662@x980>
In-Reply-To: <alpine.LFD.2.02.1103311724100.9662@x980>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2011 02:26 PM, Len Brown wrote:
>>>>> xen_arch_setup() does this:
>>>>>
>>>>>         pm_idle = default_idle;
>>>>>         boot_option_idle_override = IDLE_HALT;
> What happens on a Xen kernel if these lines are not there?
> Does Xen export the C-states tables to Dom0 kernel, and the Dom0
> kernel has an acpi processor driver, and thus it would try to
> use all the C-states?

If they're no there it tries to use the Intel cpuidle driver, which
fails (just hangs forever in idle, I think).

> If yes, must Xen show those tables to Dom?
> If it did not, then the lines above would not be necessary,
> as in the absence of any C-states, the kernel should
> use halt by default.

The dom0 kernel gets all the ACPI state so it can get all the juicy
goodness from it.  It does extract the C state info, but passes it back
to Xen rather than use it itself.  We don't generally try to filter the
ACPI state before letting dom0 see it (DMAR being the exception, since
dom0 really has no business knowing about that).

(We have this basic problem that neither Xen nor dom0 are the ideal
owners of ACPI.  In principle Xen should own ACPI as the most privileged
"OS", but it really only cares about things like power states, interrupt
routing, system topology, busses, etc.  But dom0 cares about lid
switches, magic keyboard keys, volume controls, video output switching,
etc, etc.  At the moment it seems to work best if dom0 do all ACPI
processing then pass Xen the parts it needs, which are generally
fixed-at-startup config info items.)

    J
