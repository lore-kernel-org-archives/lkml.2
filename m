Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab2JRNZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:25:01 -0400
Received: from mail.x86-64.org ([217.9.48.20]:56627 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064Ab2JRNZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:25:00 -0400
Date: Thu, 18 Oct 2012 15:24:56 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lcm@us.ibm.com" <lcm@us.ibm.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Subject: Re: [PATCH v3] x86/mce: Honour bios-set CMCI threshold
Message-ID: <20121018132456.GB6951@aftab.osrc.amd.com>
References: <CA+8MBbKVa0=qUpG-rjV5ieKkponZo77mzk_y_dF4qA2gVG++6A@mail.gmail.com>
 <20120912122516.3825.87838.stgit@localhost.localdomain>
 <505C51D8.6070402@linux.vnet.ibm.com>
 <20121017105940.GA14590@x1.osrc.amd.com>
 <507E9622.6090606@linux.vnet.ibm.com>
 <20121017130934.GB14590@x1.osrc.amd.com>
 <507ED31B.7010402@linux.vnet.ibm.com>
 <20121017164006.GA14596@x1.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F19D517FF@ORSMSX108.amr.corp.intel.com>
 <507F96F2.9050305@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507F96F2.9050305@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 11:13:14AM +0530, Naveen N. Rao wrote:
> On 10/17/2012 10:58 PM, Luck, Tony wrote:
> >BUT (squared) do you even really need to know that thresholds were set? You
> >could look at bits {52:38} in the MCi_STATUS information for the bank to see
> >how many corrected errors had been logged.
> 
> Ah, nice. I think we should be able to use this instead of the sysfs
> attribute.

Ok, patch below removes it.

@Tony: I'll send it upwards soonish in case there are no objections.
This way no stable backport will be needed.

Thanks.

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Thu, 18 Oct 2012 15:10:56 +0200
Subject: [PATCH] x86, MCE: Remove bios_cmci_threshold sysfs attribute

450cc201038f3 ("x86/mce: Provide boot argument to honour bios-set CMCI
threshold") added the bios_cmci_threshold attribute which was supposed
to communicate to userspace tools that BIOS CMCI threshold has been
honoured.

However, this info is not of any importance to userspace - rather it
can get the actual error count it has been thresholded already from
MCi_STATUS[38:52].

So drop this before it becomes a used interface (good thing is we caught
this early in 3.7-rc1, right after the merge window closed).

Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/20121017105940.GA14590@x1.osrc.amd.com
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 29e87d3b2843..46cbf8689692 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2209,11 +2209,6 @@ static struct dev_ext_attribute dev_attr_cmci_disabled = {
 	&mce_cmci_disabled
 };
 
-static struct dev_ext_attribute dev_attr_bios_cmci_threshold = {
-	__ATTR(bios_cmci_threshold, 0444, device_show_int, NULL),
-	&mce_bios_cmci_threshold
-};
-
 static struct device_attribute *mce_device_attrs[] = {
 	&dev_attr_tolerant.attr,
 	&dev_attr_check_interval.attr,
@@ -2222,7 +2217,6 @@ static struct device_attribute *mce_device_attrs[] = {
 	&dev_attr_dont_log_ce.attr,
 	&dev_attr_ignore_ce.attr,
 	&dev_attr_cmci_disabled.attr,
-	&dev_attr_bios_cmci_threshold.attr,
 	NULL
 };
 
-- 
1.8.0.rc2.4.g42e55a5

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
