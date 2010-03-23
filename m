Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab0CWUyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 16:54:05 -0400
Received: from p01c12o147.mxlogic.net ([208.65.145.70]:38661 "EHLO
	p01c12o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab0CWUyB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 16:54:01 -0400
X-MXL-Hash: 4ba92a6954a388ed-6220bd5ecae0647488696c77a828d24d17092c2a
X-MXL-Hash: 4ba92a60791465f5-3ff1f032732f930839256cffedb213915ef020a1
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ryan Mallon <ryan@bluewatersys.com>
CC: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Date: Tue, 23 Mar 2010 15:53:09 -0500
Subject: RE: [PATCH 0/2] arm: add a /proc/cpuinfo platform extension
Thread-Topic: [PATCH 0/2] arm: add a /proc/cpuinfo platform extension
Thread-Index: AcrKx5HXjJrkcR0UT1uADrCX3zUqMQAALCxg
Message-ID: <0D753D10438DA54287A00B02708426976368E58561@AUSP01VMBX24.collaborationhost.net>
References: <BD79186B4FD85F4B8E60E381CAEE19090200F377@mi8nycmail19.Mi8.com>
 <4BA924CD.1010201@bluewatersys.com>
In-Reply-To: <4BA924CD.1010201@bluewatersys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010031801)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.72]
X-AnalysisOut: [v=1.0 c=1 a=ivgDoJX_mgAA:10 a=VphdPIyG4kEA:10 a=8nJEP1OIZ-]
X-AnalysisOut: [IA:10 a=jM3uHZP82BWpxjlUuN2t4A==:17 a=i00gxMtYAAAA:8 a=Jfr]
X-AnalysisOut: [nYn6hAAAA:8 a=mJta1XlQE5LdOvf_nvQA:9 a=PY6I5bfvE5Rd-GyB3yI]
X-AnalysisOut: [A:7 a=euwS0hCQHlPkIaxNcx-96dBptM4A:4 a=wPNLvfGTeEIA:10 a=x]
X-AnalysisOut: [1WnkoZAwusA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 23, 2010 1:30 PM, Ryan Mallon wrote:
> H Hartley Sweeten wrote:
>> Add an optional platform specific extension to /proc/cpuinfo.
>> 
>> Many platforms have custom cpu information that could be exposed
>> to user space using /proc/cpuinfo.
>> 
>> Patch 1/2 adds the necessary core support to allow a platform
>> specific callback to dump this information.
>> 
>> Patch 2/2 adds a callback to mach-ep93xx and hooks up all the
>> edb93xx platforms.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> 
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
> I think this is unlikely to get merged in its current state. Russell has
> mentioned issues with breaking userspace by changing /proc/cpuinfo. 

I don't agree with this point.

On my Xeon based host running Debian, /proc/cpuinfo looks like this:

$ cat /proc/cpuinfo
Processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Xeon(R) CPU            5130  @ 2.00GHz
stepping        : 6
cpu MHz         : 1994.954
cache size      : 4096 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
Flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss nx lm constant_tsc up arch_perfmon pebs bts pni ssse3 cx16 lahf_lm
Bogomips        : 3998.17
clflush size    : 64
power management:

On my ep93xx system, /proc/cpuinfo normally looks like this:

Processor       : ARM920T rev 0 (v4l)
BogoMIPS        : 99.53
Features        : swp half thumb crunch
CPU implementer : 0x41
CPU architecture: 4T
CPU variant     : 0x1
CPU part        : 0x920
CPU revision    : 0

Hardware        : Vision Engraving Systems EP9307
Revision        : 0001
Serial          : 4943410027260017

Even something as trivial as the BogoMIPS is in a different place in
the two outputs and is spelled differently (due to caps).

The outputs are completely different.  Other architectures in
mainline also have very different outputs.

I can't see any reason why adding additional fields will break
user space, as long as an existing heading in the output is not
duplicated.  Even that "really" shouldn't break anything since
any application parsing this file has to do it sequentially and
the new headings are located at the end of the file.

> The other problem I see is that you have a single callback for registering
> the arch specific information. In you ep93xx example, each of the ep93xx
> boards must add:
>
>  .arch_cpuinfo = ep93xx_cpuinfo,
>
> If one of the boards has some additional information to make available,
> it would need to reimplement the entire callback, which gets messy.

Not necessarily.

If a board, such as the ts72xx, wanted to add additional information
it just has to register it's private callback then call the ep93xx core
supplied callback at the desired point in it's private one.

The ts72xx currently does this exact thing with the .map_io callback.
It supplies it's own private one to map the external FPGA.  It first calls
the ep93xx core to map the ahb/apb space then it does an iotable_init to
map the FPGA.

> I think a better approach would be to have a separate file (say
> /proc/archinfo) and use a list approach for displaying data. I'm
> guessing that the data displayed in the archinfo file would be
> immutable, so something like this (very rough, this would be
> kernel/archinfo.c, or arch/arm/kernel/archinfo.c, or whatever):
> 
> struct archinfo_entry {
> 	const char 		*name;
> 	const char 		*value;
> 	struct list_head 	list;
> };
> 
> static LIST_HEAD(archinfo_entries);
> 
> int archinfo_add_entry(const char *name, const char *value)
> {
> 	struct archinfo_entry *entry;
> 
> 	entry = kzalloc(sizeof(struct archinfo_entry), GFP_KERNEL);
> 	if (!entry)
> 		return -ENOMEM;
> 
> 	entry->name = kzalloc(strlen(name) + 1), GFP_KERNEL);
> 	if (!entry->name) {
> 		kfree(entry);
> 		return -ENOMEM;
> 	}
> 	strcpy(entry->name, name);
> 		
> 	entry->value = kzalloc(strlen(value) + 1, GFP_KERNEL);
> 	if (!entry->value) {
> 		kfree(entry->name);
> 		kfree(entry);
> 		return -ENOMEM;
> 	}
> 
> 	list_add(&entry->list, &archinfo_entries);
> 	return 0;	
> }
> 
> static int archinfo_show(struct seq_file *s, void *v)
> {
> 	struct archinfo_entry *entry;
> 
> 	list_for_each_entry(entry, &archinfo_entries, list)
> 		seq_printf(s, "%-20s: %s\n", entry->name, entry->value);
> 
> 	return 0;
> }
> 
> static int archinfo_open(struct inode *inode, struct file *file)
> {
> 	return single_open(file, archinfo_show, NULL);
> }
> 
> static const struct file_operations archinfo_ops = {
> 	.open		= archinfo_open,
> 	.read		= seq_read,
> 	.llseek		= seq_lseek,
> 	.release	= single_release,
> };
> 
> static int __init init_archinfo(void)
> {
> 	struct proc_dir_entry *proc;
> 
> 	if (list_empty(&archinfo_entries))
> 		return 0;
> 
> 	proc = proc_create("archinfo", 0444, NULL, &archinfo_ops);
> 	if (!proc)
> 		return -ENOMEM;
> 	return 0;
> }
> 
> lateinit_call(init_archinfo);
> 
> A given board/arch can then have something like the following in its
> init function:
> 
> static void __init myboard_init_archinfo(void)
> {
> 	char buffer[64];
> 
> 	snprintf(buffer, sizeof(buffer), "some stuff %d, %d\n",
> 		 val1, val2);
> 	archinfo_add_entry("stuff", buffer);
> }
> 
> That way, the arch core (eg arch/arm/mach-ep93xx/core.c) can create a
> base set of entries, and the individual platforms/board files can append
> additional information to it.

I agree this is probably another way to handle this but it seems like
overkill.

Regards,
Hartley