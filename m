Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab2IVPQx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 11:16:53 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:42021 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab2IVPQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 11:16:50 -0400
Message-ID: <505DD65F.9080203@kernel.org>
Date: Sat, 22 Sep 2012 11:16:47 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: hpa@zytor.com, initramfs@vger.kernel.org, robert.moore@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        yinghai@kernel.org, eric.piel@tremplin-utc.net, vojcek@tlen.pl,
        Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH 2/2] ACPI: Override arbitrary ACPI tables via initrd for
 debugging
References: <1348234085-39220-1-git-send-email-trenn@suse.de> <1348234085-39220-3-git-send-email-trenn@suse.de>
In-Reply-To: <1348234085-39220-3-git-send-email-trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This isn't a NAK, but I'm at best, "like warm" on this.

I'm not convinced it is a good thing to have - enabled by default -
the ability for users to easily over-ride ACPI tables.

I am concerned this will result in users hacking their BIOS, and making themselves
unsupportable by both their HW and SW suppliers.

"But it is just a _debug_ capability", one counters, "we'd never have
to support somebody who actually uses it."

Even if you toss support (and security) out the window, there is a more insidious
problem.  When such a user latches onto a workaround that tickles their
itch, they are satisfied, and they have zero incentive to get
either their BIOS or Linux fixed for the benefit of other users.

Today we have 2 methods to override AML:
ACPI_CUSTOM_METHOD (default n) allows you to scribble on AML
on the current running system.
ACPI_CUSTOM_DSDT (default n) allows you to override the entire DSDT/SSDT,
but requires you to build that DSDT into the custom kernel itself.

Developers running on their own systems are not complaining about these.

But what if you want to debug something on a remote system
with a distro binary kernel, you say?  The user doesn't know how
to build a kernel, and the distro is too busy to do so.
Some distros ship the initrd hack to  address this problem,
even though it has been repeatedly rejected upstream.
But curiously, even larger distros do NOT ship that hack
and somehow they have survived the last decade of Linux/ACPI
deployment without it.  How is that possible?

Yes, convenience sounds like an improvement over inconvenience.
Yes, generality to override any table sounds like a good thing
over the limitation to override just AML tables.
But does that make it a good idea?

specific comments in-line below...


On 09/21/2012 09:28 AM, Thomas Renninger wrote:
> Details can be found in:
> Documentation/acpi/initrd_table_override.txt
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> CC: eric.piel@tremplin-utc.net
> CC: vojcek@tlen.pl
> CC: Lin Ming <ming.m.lin@intel.com>
> CC: lenb@kernel.org
> CC: robert.moore@intel.com
> CC: hpa@zytor.com
> CC: yinghai@kernel.org
> ---
>  Documentation/acpi/initrd_table_override.txt |  122 +++++++++++++++
>  arch/x86/kernel/setup.c                      |    4 +
>  drivers/acpi/Kconfig                         |    9 +
>  drivers/acpi/osl.c                           |  203 ++++++++++++++++++++++++--
>  include/linux/acpi.h                         |    4 +
>  5 files changed, 331 insertions(+), 11 deletions(-)
>  create mode 100644 Documentation/acpi/initrd_table_override.txt
> 
> diff --git a/Documentation/acpi/initrd_table_override.txt b/Documentation/acpi/initrd_table_override.txt
> new file mode 100644
> index 0000000..b550831
> --- /dev/null
> +++ b/Documentation/acpi/initrd_table_override.txt
> @@ -0,0 +1,122 @@
> +Overriding ACPI tables via initrd
> +=================================
> +
> +1) Introduction (What is this about)
> +2) What is this for
> +3) How does it work
> +4) References (Where to retrieve userspace tools)
> +
> +1) What is this about
> +---------------------
> +
> +If ACPI_INITRD_TABLE_OVERRIDE compile option is true, it is possible to

If "the" ACPI_...

> +override nearly any ACPI table provided by the BIOS with an instrumented,
> +modified one.
> +
> +For a full list of ACPI tables that can be overridden, take a look at
> +the char *table_sigs[MAX_ACPI_SIGNATURE]; definition in drivers/acpi/osl.c
> +All ACPI tables iasl (Intel's ACPI compiler and disassembler) knows should
> +be overridable, except:
> +   - ACPI_SIG_RSDP (has a signature of 6 bytes)
> +   - ACPI_SIG_FACS (does not have an ordinary ACPI table header)
> +Both could get implemented as well.
> +
> +
> +2) What is this for
> +-------------------
> +
> +Please keep in mind that this is a debug option.
> +ACPI tables should not get overridden for productive use.
> +If BIOS ACPI tables are overridden the kernel will get tainted with the
> +TAINT_OVERRIDDEN_ACPI_TABLE flag.
> +Complain to your platform/BIOS vendor if you find a bug which is that sever

"bug, which is so severe"

> +that a workaround is not accepted in the Linus kernel.

"Linux kernel"

> +
> +Still, it can and should be enabled in any kernel, because:
> +  - There is no functional change with not instrumented initrds
> +  - It provides a powerful feature to easily debug and test ACPI BIOS table
> +    compatibility with the Linux kernel.
> +
> +Until now it was only possible to override the DSDT by compiling it into
> +the kernel. This is a nightmare when trying to work on ACPI related bugs
> +and a lot bugs got stuck because of that.
> +
> +Even for people with enough kernel knowledge, building a kernel to try out
> +things is very time consuming. Also people may have to browse and modify the
> +ACPI interpreter code to find a possible BIOS bug. With this feature, people
> +can correct the ACPI tables and try out quickly whether this is the root cause
> +that needs to get addressed in the kernel.
> +
> +This could even ease up testing for BIOS providers who could flush their BIOS
> +to test, but overriding table via initrd is much easier and quicker.
> +For example one could prepare different initrds overriding NUMA tables with
> +different affinity settings. Set up a script, let the machine reboot and
> +run tests over night and one can get a picture how these settings influence
> +the Linux kernel and which values are best.
> +
> +People can instrument the dynamic ACPI (ASL) code (for example with debug
> +statements showing up in syslog when the ACPI code is processed, etc.),
> +to better understand BIOS to OS interfaces, to hunt down ACPI BIOS code related
> +bugs quickly or to easier develop ACPI based drivers.
> +
> +Intstrumenting ACPI code in SSDTs is now much easier. Before, one had to copy
> +all SSDTs into the DSDT to compile it into the kernel for testing
> +(because only DSDT could get overridden). That's what the acpi_no_auto_ssdt
> +boot param is for: the BIOS provided SSDTs are ignored and all have to get
> +copied into the DSDT, complicated and time consuming.
> +
> +Much more use cases, depending on which ACPI parts you are working on...

The above 6 paragraphs are appropriate for the mailing list,
but don't belong in the README file.  Presumably this capability
is present in the kernel being run, so you don't have to sell it
over alternative debug methods.

> +
> +
> +3) How does it work
> +-------------------
> +
> +# Extract the machine's ACPI tables:
> +cd /tmp
> +acpidump >acpidump
> +acpixtract -a acpidump
> +# Disassemble, modify and recompile them:
> +iasl -d *.dat
> +# For example add this statement into a _PRT (PCI Routing Table) function
> +# of the DSDT:
> +Store("HELLO WORLD", debug)
> +iasl -sa dsdt.dsl
> +# Add the raw ACPI tables to an uncompressed cpio archive.
> +# They must be put into a /kernel/firmware/acpi directory inside the
> +# cpio archive.
> +# The uncompressed cpio archive must be the first.
> +# Other, typically compressed cpio archives, must be
> +# concatenated on top of the uncompressed one.
> +mkdir -p kernel/firmware/acpi
> +cp dsdt.aml kernel/firmware/acpi
> +# A maximum of: #define ACPI_OVERRIDE_TABLES 10
> +# tables are  currently allowed (see osl.c):
> +iasl -sa facp.dsl
> +iasl -sa ssdt1.dsl
> +cp facp.aml kernel/firmware/acpi
> +cp ssdt1.aml kernel/firmware/acpi
> +# Create the uncompressed cpio archive and concatenate the orginal initrd

"original"

> +# on top:
> +find kernel | cpio -H newc --create > /boot/instrumented_initrd
> +cat /boot/initrd >>/boot/instrumented_initrd
> +# reboot with increased acpi debug level, e.g. boot params:
> +acpi.debug_level=0x2 acpi.debug_layer=0xFFFFFFFF
> +# and check your syslog:
> +[    1.268089] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> +[    1.272091] [ACPI Debug]  String [0x0B] "HELLO WORLD"
> +
> +iasl is able to disassemble and recompile quite a lot different,
> +also static ACPI tables.
> +
> +4) Where to retrieve userspace tools
> +------------------------------------
> +
> +iasl and acpixtract are part of Intel's ACPICA project:
> +http://acpica.org/
> +and should be packaged by distributions (for example in the acpica package
> +on SUSE).
> +
> +acpidump can be found in Len Browns pmtools:
> +ftp://kernel.org/pub/linux/kernel/people/lenb/acpi/utils/pmtools/acpidump
> +This tool is also part of the acpica package on SUSE.
> +Alternatively, used ACPI tables can be retrieved via sysfs in latest kernels:
> +/sys/firmware/acpi/tables
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index f4b9b80..6a91058 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -941,6 +941,10 @@ void __init setup_arch(char **cmdline_p)
>  
>  	reserve_initrd();
>  
> +#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
> +	acpi_initrd_override((void *)initrd_start, initrd_end - initrd_start);
> +#endif
> +
>  	reserve_crashkernel();
>  
>  	vsmp_init();
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 8099895..a508f77 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -261,6 +261,15 @@ config ACPI_CUSTOM_DSDT
>  	bool
>  	default ACPI_CUSTOM_DSDT_FILE != ""
>  
> +config ACPI_INITRD_TABLE_OVERRIDE
> +	bool
> +	default y
> +	help
> +	  This option provides functionality to override arbitrary ACPI tables
> +	  via initrd. No functional change if no ACPI tables are passed via
> +	  initrd, therefore it's safe to say Y.
> +	  See Documentation/acpi/initrd_table_override.txt for details
> +
>  config ACPI_BLACKLIST_YEAR
>  	int "Disable ACPI for systems before Jan 1st this year" if X86_32
>  	default 0
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 9eaf708..ba7560f 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -534,6 +534,137 @@ acpi_os_predefined_override(const struct acpi_predefined_names *init_val,
>  	return AE_OK;
>  }
>  
> +#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
> +#include <linux/earlycpio.h>
> +#include <linux/memblock.h>
> +
> +#include <asm/e820.h>
> +
> +static u64 acpi_tables_addr;
> +static int all_tables_size;
> +
> +/* Copied from acpica/tbutils.c:acpi_tb_checksum() */
> +u8 __init acpi_table_checksum(u8 *buffer, u32 length)
> +{
> +	u8 sum = 0;
> +	u8 *end = buffer + length;
> +
> +	while (buffer < end)
> +		sum = (u8) (sum + *(buffer++));
> +	return sum;
> +}
> +
> +/* All but ACPI_SIG_RSDP and ACPI_SIG_FACS: */
> +static const char * const table_sigs[] = {
> +	ACPI_SIG_BERT, ACPI_SIG_CPEP, ACPI_SIG_ECDT, ACPI_SIG_EINJ,
> +	ACPI_SIG_ERST, ACPI_SIG_HEST, ACPI_SIG_MADT, ACPI_SIG_MSCT,
> +	ACPI_SIG_SBST, ACPI_SIG_SLIT, ACPI_SIG_SRAT, ACPI_SIG_ASF,
> +	ACPI_SIG_BOOT, ACPI_SIG_DBGP, ACPI_SIG_DMAR, ACPI_SIG_HPET,
> +	ACPI_SIG_IBFT, ACPI_SIG_IVRS, ACPI_SIG_MCFG, ACPI_SIG_MCHI,
> +	ACPI_SIG_SLIC, ACPI_SIG_SPCR, ACPI_SIG_SPMI, ACPI_SIG_TCPA,
> +	ACPI_SIG_UEFI, ACPI_SIG_WAET, ACPI_SIG_WDAT, ACPI_SIG_WDDT,
> +	ACPI_SIG_WDRT, ACPI_SIG_DSDT, ACPI_SIG_FADT, ACPI_SIG_PSDT,
> +	ACPI_SIG_RSDT, ACPI_SIG_XSDT, ACPI_SIG_SSDT, NULL };
> +
> +/* Non-fatal errors: Affected tables/files are ignored */
> +#define INVALID_TABLE(x, path, name)					\
> +	{ pr_err("ACPI OVERRIDE: " x " [%s%s]\n", path, name); continue; }
> +
> +#define ACPI_HEADER_SIZE sizeof(struct acpi_table_header)
> +
> +/* Must not increase 10 or needs code modifcation below */

"modification"


