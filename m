Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab2JQK7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 06:59:45 -0400
Received: from mail.skyhub.de ([78.46.96.112]:32828 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab2JQK7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 06:59:43 -0400
Date: Wed, 17 Oct 2012 12:59:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, tony.luck@intel.com
Cc: gong.chen@linux.intel.com, ananth@in.ibm.com, masbock@linux.vnet.ibm.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, bp@amd64.org,
        lcm@us.ibm.com, andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, gregkh@suse.de, linux-edac@vger.kernel.org
Subject: Re: [PATCH v3] x86/mce: Honour bios-set CMCI threshold
Message-ID: <20121017105940.GA14590@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
	tony.luck@intel.com, gong.chen@linux.intel.com, ananth@in.ibm.com,
	masbock@linux.vnet.ibm.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, bp@amd64.org, lcm@us.ibm.com,
	andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de,
	mingo@redhat.com, gregkh@suse.de, linux-edac@vger.kernel.org
References: <CA+8MBbKVa0=qUpG-rjV5ieKkponZo77mzk_y_dF4qA2gVG++6A@mail.gmail.com>
 <20120912122516.3825.87838.stgit@localhost.localdomain>
 <505C51D8.6070402@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <505C51D8.6070402@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 05:09:04PM +0530, Naveen N. Rao wrote:
> Hi Tony,
> Can you kindly take in this patch if there are no further comments?
> 
> Thanks,
> Naveen
> 
> On 09/12/2012 05:55 PM, Naveen N. Rao wrote:
> >The ACPI spec doesn't provide for a way for the bios to pass down
> >recommended thresholds to the OS on a _per-bank_ basis. This patch adds
> >a new boot option, which if passed, allows bios to initialize the CMCI
> >threshold. In such a case, we simply skip programming any threshold
> >value.
> >
> >As fail-safe, we initialize threshold to 1 if some banks have not been
> >initialized by the bios and warn the user.
> >
> >v3: Updated messages as per Tony's inputs.
> >v2: Just separating out the patch. I will send a separate patch for
> >consolidating the MCE boot flags.
> >
> >Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> >---
> >  Documentation/x86/x86_64/boot-options.txt |    5 ++++
> >  arch/x86/include/asm/mce.h                |    1 +
> >  arch/x86/kernel/cpu/mcheck/mce.c          |   10 ++++++++
> >  arch/x86/kernel/cpu/mcheck/mce_intel.c    |   35 +++++++++++++++++++++++++++--
> >  4 files changed, 48 insertions(+), 3 deletions(-)
> >
> >diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
> >index c54b4f5..ec92540 100644
> >--- a/Documentation/x86/x86_64/boot-options.txt
> >+++ b/Documentation/x86/x86_64/boot-options.txt
> >@@ -50,6 +50,11 @@ Machine check
> >  		monarchtimeout:
> >  		Sets the time in us to wait for other CPUs on machine checks. 0
> >  		to disable.
> >+   mce=bios_cmci_threshold
> >+		Don't overwrite the bios-set CMCI threshold. This boot option
> >+		prevents Linux from overwriting the CMCI threshold set by the
> >+		bios. Without this option, Linux always sets the CMCI
> >+		threshold to 1.
> >
> >     nomce (for compatibility with i386): same as mce=off
> >
> >diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
> >index a3ac52b..8ad5078 100644
> >--- a/arch/x86/include/asm/mce.h
> >+++ b/arch/x86/include/asm/mce.h
> >@@ -171,6 +171,7 @@ DECLARE_PER_CPU(struct device *, mce_device);
> >  #ifdef CONFIG_X86_MCE_INTEL
> >  extern int mce_cmci_disabled;
> >  extern int mce_ignore_ce;
> >+extern int mce_bios_cmci_threshold;
> >  void mce_intel_feature_init(struct cpuinfo_x86 *c);
> >  void cmci_clear(void);
> >  void cmci_reenable(void);
> >diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> >index c311122..29e87d3 100644
> >--- a/arch/x86/kernel/cpu/mcheck/mce.c
> >+++ b/arch/x86/kernel/cpu/mcheck/mce.c
> >@@ -83,6 +83,7 @@ static int			mce_dont_log_ce		__read_mostly;
> >  int				mce_cmci_disabled	__read_mostly;
> >  int				mce_ignore_ce		__read_mostly;
> >  int				mce_ser			__read_mostly;
> >+int				mce_bios_cmci_threshold	__read_mostly;
> >
> >  struct mce_bank                *mce_banks		__read_mostly;
> >
> >@@ -1946,6 +1947,7 @@ static struct miscdevice mce_chrdev_device = {
> >   *	check, or 0 to not wait
> >   * mce=bootlog Log MCEs from before booting. Disabled by default on AMD.
> >   * mce=nobootlog Don't log MCEs from before booting.
> >+ * mce=bios_cmci_threshold Don't program the CMCI threshold
> >   */
> >  static int __init mcheck_enable(char *str)
> >  {
> >@@ -1965,6 +1967,8 @@ static int __init mcheck_enable(char *str)
> >  		mce_ignore_ce = 1;
> >  	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
> >  		mce_bootlog = (str[0] == 'b');
> >+	else if (!strcmp(str, "bios_cmci_threshold"))
> >+		mce_bios_cmci_threshold = 1;
> >  	else if (isdigit(str[0])) {
> >  		get_option(&str, &tolerant);
> >  		if (*str == ',') {
> >@@ -2205,6 +2209,11 @@ static struct dev_ext_attribute dev_attr_cmci_disabled = {
> >  	&mce_cmci_disabled
> >  };
> >
> >+static struct dev_ext_attribute dev_attr_bios_cmci_threshold = {
> >+	__ATTR(bios_cmci_threshold, 0444, device_show_int, NULL),
> >+	&mce_bios_cmci_threshold

Ok, I just noticed this (we must've missed it during review) but why is
this read-only? If it has to be read-only, why do we have a node for
this in sysfs instead of simply issuing the printk statements below and
people who are interested in this, can grep dmesg?

If there's no apparent reason, I'll remove this chunk adding the sysfs
attribute.

Thanks.

-- 
Regards/Gruss,
Boris.
