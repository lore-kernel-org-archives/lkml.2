Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab2C1Uek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 16:34:40 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:21973 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758300Ab2C1Uej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 16:34:39 -0400
Date: Wed, 28 Mar 2012 16:29:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>, Pasi K?rkk?inen <pasik@iki.fi>,
        mjg@redhat.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] Stop the continuous flood of (XEN) traps.c:2432:d0
 Domain	attempted WRMSR ..
Message-ID: <20120328202907.GA1784@phenom.dumpdata.com>
References: <20120203180952.GP12984@reaktio.net>
 <20120203185527.GA9290@phenom.dumpdata.com>
 <20120205194413.GR12984@reaktio.net>
 <20120209212147.GE14007@andromeda.dapyr.net>
 <20120209132715.2d1c0c9f@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <20120209132715.2d1c0c9f@jbarnes-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090204.4F7375A4.0055,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 09, 2012 at 01:27:15PM -0800, Jesse Barnes wrote:
> On Thu, 9 Feb 2012 17:21:47 -0400
> Konrad Rzeszutek Wilk <konrad@darnok.org> wrote:
> 
> > On Sun, Feb 05, 2012 at 09:44:13PM +0200, Pasi K?rkk?inen wrote:
> > > On Fri, Feb 03, 2012 at 01:55:27PM -0500, Konrad Rzeszutek Wilk wrote:
> > > > On Fri, Feb 03, 2012 at 08:09:52PM +0200, Pasi K?rkk?inen wrote:
> > > > > Hello,
> > > > > 
> > > > > IIRC there was some discussion earlier about these messages in Xen's dmesg:
> > > > > 
> > > > > (XEN) traps.c:2432:d0 Domain attempted WRMSR 00000000000001ac from 0x0000000000c800c8 to 0x0000000080c880c8.
> > > > > (XEN) traps.c:2432:d0 Domain attempted WRMSR 00000000000001ac from 0x0000000000c800c8 to 0x0000000080c880c8.
> > > > > (XEN) traps.c:2432:d0 Domain attempted WRMSR 00000000000001ac from 0x0000000000c800c8 to 0x0000000080c880c8.
> > > > > (XEN) traps.c:2432:d0 Domain attempted WRMSR 00000000000001ac from 0x0000000000c800c8 to 0x0000000080c880c8.
> > > > > 
> > > > > At least on my systems there's continuous flood of those messages, so they will fill up the
> > > > > Xen dmesg log buffer and "xm dmesg" or "xl dmesg" won't show any valuable information, just those messages.
> > > > 
> > > > Is it always that MSR? That looks to be TURBO_POWER_CURRENT_LIMIT
> > > > which is the intel_ips driver doing.
> > > > 
> > > 
> > > Yeah, it's always the same..
> > > 
> > > > > 
> > > > > I seem to be getting those messages even when there's only dom0 running.
> > > > > Is the plan to drop those messages? What's causing them? 
> > > > 
> > > > Looks to be the intel-ips. If you rename it does the issue disappear?
> > > 
> > > I just did "rmmod intel_ips" and the flood stopped.. 
> > > 
> > > 
> > > Btw on baremetal I get this in dmesg:
> > > 
> > > [  745.033645] CPU1: Core temperature above threshold, cpu clock throttled (total events = 1)
> > > [  745.033652] CPU3: Core temperature above threshold, cpu clock throttled (total events = 1)
> > > [  745.034676] CPU1: Core temperature/speed normal
> > > [  745.034678] CPU3: Core temperature/speed normal
> > > [  849.678508] intel ips 0000:00:1f.6: MCP limit exceeded: Avg temp 9682, limit 9000
> > > [  899.614074] intel ips 0000:00:1f.6: MCP limit exceeded: Avg temp 9896, limit 9000
> > > [  899.722881] [Hardware Error]: Machine check events logged
> > > [ 1172.675987] CPU3: Core temperature above threshold, cpu clock throttled (total events = 78)
> > > [ 1172.675990] CPU1: Core temperature above threshold, cpu clock throttled (total events = 78)
> > > [ 1172.677038] CPU1: Core temperature/speed normal
> > > [ 1172.677042] CPU3: Core temperature/speed normal
> > > [ 1174.260050] intel ips 0000:00:1f.6: MCP limit exceeded: Avg temp 9676, limit 9000
> > > [ 1199.339634] [Hardware Error]: Machine check events logged
> > 
> > Jesse, and Matthew,
> > 
> > Is there a way to make the intel_ips.c driver be in a "low-power" state?
> > 
> > My first thought about fixing this was that we could allow the
> > hypervisor to allow those RDMSR but the Linux kernel has no power to
> > actually influence the power management (as the hypervisor is in charge
> > of that) - so would the driver be capable of just sitting back and
> > not influencing the CPU?
> 
> Yeah it's easy enough to turn off or disable.  But it doesn't currently
> export any knobs for controlling behavior.  I don't have any issue with
> exposing some though...

Pasi,

Could you test the two patches independetly of each other? Meaning
test the Linux one without the Xen one, and vice-versa.



--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="pasik-linux.patch"

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index 88a98cf..7276831 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -1407,6 +1407,10 @@ static struct ips_mcp_limits *ips_detect_cpu(struct ips_driver *ips)
 	}
 
 	rdmsrl(TURBO_POWER_CURRENT_LIMIT, turbo_power);
+	if (turbo_power == 0) {
+		ips->turbo_toggle_allowed = false;
+		return NULL;
+	}
 	tdp = turbo_power & TURBO_TDP_MASK;
 
 	/* Sanity check TDP against CPU */

--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="pasik-xen.patch"

diff -r 8e2690dbec49 xen/arch/x86/traps.c
--- a/xen/arch/x86/traps.c	Sat Mar 24 13:13:49 2012 -0400
+++ b/xen/arch/x86/traps.c	Wed Mar 28 16:27:31 2012 -0400
@@ -1746,7 +1746,8 @@ void (*pv_post_outb_hook)(unsigned int p
 static inline uint64_t guest_misc_enable(uint64_t val)
 {
     val &= ~(MSR_IA32_MISC_ENABLE_PERF_AVAIL |
-             MSR_IA32_MISC_ENABLE_MONITOR_ENABLE);
+             MSR_IA32_MISC_ENABLE_MONITOR_ENABLE |
+             MSR_IA32_MISC_ENABLE_TURBO);
     val |= MSR_IA32_MISC_ENABLE_BTS_UNAVAIL |
            MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL |
            MSR_IA32_MISC_ENABLE_XTPR_DISABLE;
diff -r 8e2690dbec49 xen/include/asm-x86/msr-index.h
--- a/xen/include/asm-x86/msr-index.h	Sat Mar 24 13:13:49 2012 -0400
+++ b/xen/include/asm-x86/msr-index.h	Wed Mar 28 16:27:31 2012 -0400
@@ -327,6 +327,7 @@
 #define MSR_IA32_MISC_ENABLE_MONITOR_ENABLE (1<<18)
 #define MSR_IA32_MISC_ENABLE_LIMIT_CPUID  (1<<22)
 #define MSR_IA32_MISC_ENABLE_XTPR_DISABLE (1<<23)
+#define MSR_IA32_MISC_ENABLE_TURBO        (1<<38)
 
 #define MSR_IA32_TSC_DEADLINE		0x000006E0
 #define MSR_IA32_ENERGY_PERF_BIAS	0x000001b0

--9jxsPFA5p3P2qPhR--
