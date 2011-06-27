Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab1F0QF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 12:05:27 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:53733 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab1F0QFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 12:05:23 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: coretemp: Support for Intel Atom E6XX CPU (TunnelCreek)?
Date: Mon, 27 Jun 2011 18:05:20 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; x86_64; ; )
Cc: Fenghua Yu <fenghua.yu@intel.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
References: <201106271220.51953.alexander.stein@systec-electronic.com> <20110627164108.777c2e28@endymion.delvare>
In-Reply-To: <20110627164108.777c2e28@endymion.delvare>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106271805.21000.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 June 2011 16:41:08 Jean Delvare wrote:
> Hi Alexander,
> 
> On Mon, 27 Jun 2011 12:20:51 +0200, Alexander Stein wrote:
> > I have a patch (for v2.6.39) which adds support for Intel Atom E6XX
> > (TunnelCreek) to coretemp. It's merely only adding x86_model 0x26.
> 
> You have a patch, great for you. What do you expect if you don't share
> it with us?

If you insist on seeing that patch (for 2.6.39 btw):

diff --git a/Documentation/hwmon/coretemp b/Documentation/hwmon/coretemp
index 25568f8..8fc82b6 100644
--- a/Documentation/hwmon/coretemp
+++ b/Documentation/hwmon/coretemp
@@ -6,7 +6,8 @@ Supported chips:
     Prefix: 'coretemp'
     CPUID: family 0x6, models 0xe (Pentium M DC), 0xf (Core 2 DC 65nm),
                               0x16 (Core 2 SC 65nm), 0x17 (Penryn 45nm),
-                              0x1a (Nehalem), 0x1c (Atom), 0x1e (Lynnfield)
+                              0x1a (Nehalem), 0x1c (Atom), 0x1e (Lynnfield),
+                              0x26 (Tunnelcreek)
     Datasheet: Intel 64 and IA-32 Architectures Software Developer's Manual
                Volume 3A: System Programming Guide
                http://softwarecommunity.intel.com/Wiki/Mobility/720.htm
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 194ca0a..55f0fda 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -173,9 +173,9 @@ static int __devinit adjust_tjmax(struct cpuinfo_x86 *c, 
u32 id, struct device *
 		usemsr_ee = 0;
 	}
 
-	/* Atom CPUs */
+	/* Atom and TunnelCreek CPUs */
 
-	if (c->x86_model == 0x1c) {
+	if ((c->x86_model == 0x1c) || (c->x86_model == 0x26)) {
 		usemsr_ee = 0;
 
 		host_bridge = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
@@ -283,6 +283,7 @@ static int __devinit get_tjmax(struct cpuinfo_x86 *c, u32 
id,
 		return 100000;
 	case 0x17:
 	case 0x1c:		/* Atom CPUs */
+	case 0x26:		/* TunnelCreek CPU */
 		return adjust_tjmax(c, id, dev);
 	default:
 		dev_warn(dev, "CPU (model=0x%x) is not supported yet,"
@@ -361,7 +362,8 @@ static int __devinit coretemp_probe(struct platform_device 
*pdev)
 	 * Atoms don't have it either.
 	 */
 
-	if ((c->x86_model > 0xe) && (c->x86_model != 0x1c)) {
+	if ((c->x86_model > 0xe) && (c->x86_model != 0x1c)
+	&& (c->x86_model != 0x26)) {
 		err = rdmsr_safe_on_cpu(data->id, MSR_IA32_TEMPERATURE_TARGET,
 		    &eax, &edx);
 		if (err) {

The patch without hunk 2 still stays valid to me for current git master.

> I'm not quite sure what your patch would be doing anyway. Since kernel
> 2.6.35, supported CPU models are detected using the DTS feature flag
> rather than the family and model numbers, so your Atom E6XX should be
> detected just fine.

Those 3 output lines don't seem like the mode is detected.
coretemp coretemp.0: Unable to read TjMax from CPU.
coretemp coretemp.0: CPU (model=0x26) is not supported yet, using default 
TjMax of 100C.
coretemp coretemp.0: Unable to read IA32_TEMPERATURE_TARGET MSR

> Note that there was a bug in kernels 2.6.35 to 2.6.39 with regards to
> TjMax guessing, which was fixed by Gunter Roeck with:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h
> =4f5f71a7abe329bdad81ee6a8e4545054a7cc30a You'll have to update to kernel
> version 2.6.39.2 to get this fix.

Cherry-picking this patch, only reduces the output to those two lines:
coretemp coretemp.0: Unable to read TjMax from CPU.
coretemp coretemp.0: Unable to read IA32_TEMPERATURE_TARGET MSR

> Do you happen to know what CPUs model number 0x26 covers? Do you know
> if this model supports MSR_IA32_TEMPERATURE_TARGET or not? The original
> Atom (model 0x1c) did not.

Both the linux kernel (see above) and the bootloader can't use 
MSR_IA32_TEMPERATURE_TARGET, so I guess this model does not support this 
feature.
I don't know which models have number 0x26, despite the E6xx.

> > But there are models (e.g. E660 and E660T) with different TjMax, namely
> > 90 degrees C and 110 degrees C. But these different model can't be
> > detected by reading from hardware.
> 
> I would appreciate a patch to Documentation/hwmon/coretemp adding the
> known TjMax for these new Atom models.
> 
> BTW, is it really impossible to identify these models with a different
> TjMax? Don't the strings "E660" and "E660T" appear in the respective
> "model name" entries in /proc/cpuinfo?

Here's the cpuinfo output. I didnt find anything which would allow this 
distinction.

# cat /proc/cpuinfo 
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 38
model name      : Genuine Intel(R) CPU        @ 1.30GHz
stepping        : 1
cpu MHz         : 1299.936
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
apicid          : 0
initial apicid  : 0
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc 
arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 
cx16 xtpr pdcm movbe lahf_lm dts tpr_shadow vnmi
bogomips        : 2599.87
clflush size    : 64
cache_alignment : 64
address sizes   : 32 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 38
model name      : Genuine Intel(R) CPU        @ 1.30GHz
stepping        : 1
cpu MHz         : 1299.936
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
apicid          : 1
initial apicid  : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc 
arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 
cx16 xtpr pdcm movbe lahf_lm dts tpr_shadow vnmi
bogomips        : 2599.54
clflush size    : 64
cache_alignment : 64
address sizes   : 32 bits physical, 48 bits virtual
power management:

> > IMO there should be some support to adjust the temperature from
> > userspace. Reading Documentation/hwmon/sysfs-interface only temp1_offset
> > seems to be useable. But I think it is somewhat misleading (especially
> > on multicores), because there must only be one offset.
> 
> No, tempN_offset isn't suitable for this case, as it would only shift the
> current temperature and not the limits.
> 
> Instead, we could detect the specific CPUs using the model name string
> and adjust TjMax accordingly. And/or we could let the user override
> TjMax through a module parameter (I doubt anyone runs a system with
> CPUs with different TjMax values.)

As there seem to be no model string to distinct, only the module parameter 
seems valid to do this change.

Regards,
Alexander
