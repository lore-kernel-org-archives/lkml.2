Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886Ab2IUU4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 16:56:22 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41348 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab2IUU4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 16:56:17 -0400
MIME-Version: 1.0
In-Reply-To: <1348234085-39220-3-git-send-email-trenn@suse.de>
References: <1348234085-39220-1-git-send-email-trenn@suse.de>
	<1348234085-39220-3-git-send-email-trenn@suse.de>
Date: Fri, 21 Sep 2012 13:56:15 -0700
X-Google-Sender-Auth: 5NCjnm_rYkn7MhmqhFqI5WQsZNk
Message-ID: <CAE9FiQX64iRo9QjhEPYtEOhbEweKSmTssQ50VfPznWtHA345CQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ACPI: Override arbitrary ACPI tables via initrd for debugging
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Renninger <trenn@suse.de>
Cc: hpa@zytor.com, initramfs@vger.kernel.org, robert.moore@intel.com,
        lenb@kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, eric.piel@tremplin-utc.net, vojcek@tlen.pl,
        Lin Ming <ming.m.lin@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 6:28 AM, Thomas Renninger <trenn@suse.de> wrote:
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
> +that a workaround is not accepted in the Linus kernel.
> +
> +Still, it can and should be enabled in any kernel, because:
> +  - There is no functional change with not instrumented initrds
> +  - It provides a powerful feature to easily debug and test ACPI BIOS table
> +    compatibility with the Linux kernel.
> +
> +Until now it was only possible to override the DSDT by compiling it into
> +the kernel. This is a nightmare when trying to work on ACPI related bugs
> +and a lot bugs got stuck because of that.
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
>         reserve_initrd();
>
> +#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
> +       acpi_initrd_override((void *)initrd_start, initrd_end - initrd_start);
> +#endif
> +

could use
#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
void acpi_initrd_override(void *data, size_t size);
#else
static inline void acpi_initrd_override(void *data, size_t size)
{
}
#endif

in one header file to avoid MACRO in setup.c

>         reserve_crashkernel();
>
>         vsmp_init();
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 8099895..a508f77 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -261,6 +261,15 @@ config ACPI_CUSTOM_DSDT
>         bool
>         default ACPI_CUSTOM_DSDT_FILE != ""
>
> +config ACPI_INITRD_TABLE_OVERRIDE
> +       bool
> +       default y
> +       help
> +         This option provides functionality to override arbitrary ACPI tables
> +         via initrd. No functional change if no ACPI tables are passed via
> +         initrd, therefore it's safe to say Y.
> +         See Documentation/acpi/initrd_table_override.txt for details
> +
>  config ACPI_BLACKLIST_YEAR
>         int "Disable ACPI for systems before Jan 1st this year" if X86_32
>         default 0
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 9eaf708..ba7560f 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -534,6 +534,137 @@ acpi_os_predefined_override(const struct acpi_predefined_names *init_val,
>         return AE_OK;
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
> +       u8 sum = 0;
> +       u8 *end = buffer + length;
> +
> +       while (buffer < end)
> +               sum = (u8) (sum + *(buffer++));
> +       return sum;
> +}
> +
> +/* All but ACPI_SIG_RSDP and ACPI_SIG_FACS: */
> +static const char * const table_sigs[] = {
> +       ACPI_SIG_BERT, ACPI_SIG_CPEP, ACPI_SIG_ECDT, ACPI_SIG_EINJ,
> +       ACPI_SIG_ERST, ACPI_SIG_HEST, ACPI_SIG_MADT, ACPI_SIG_MSCT,
> +       ACPI_SIG_SBST, ACPI_SIG_SLIT, ACPI_SIG_SRAT, ACPI_SIG_ASF,
> +       ACPI_SIG_BOOT, ACPI_SIG_DBGP, ACPI_SIG_DMAR, ACPI_SIG_HPET,
> +       ACPI_SIG_IBFT, ACPI_SIG_IVRS, ACPI_SIG_MCFG, ACPI_SIG_MCHI,
> +       ACPI_SIG_SLIC, ACPI_SIG_SPCR, ACPI_SIG_SPMI, ACPI_SIG_TCPA,
> +       ACPI_SIG_UEFI, ACPI_SIG_WAET, ACPI_SIG_WDAT, ACPI_SIG_WDDT,
> +       ACPI_SIG_WDRT, ACPI_SIG_DSDT, ACPI_SIG_FADT, ACPI_SIG_PSDT,
> +       ACPI_SIG_RSDT, ACPI_SIG_XSDT, ACPI_SIG_SSDT, NULL };
> +
> +/* Non-fatal errors: Affected tables/files are ignored */
> +#define INVALID_TABLE(x, path, name)                                   \
> +       { pr_err("ACPI OVERRIDE: " x " [%s%s]\n", path, name); continue; }
> +
> +#define ACPI_HEADER_SIZE sizeof(struct acpi_table_header)
> +
> +/* Must not increase 10 or needs code modifcation below */
> +#define ACPI_OVERRIDE_TABLES 10
> +
> +void __init acpi_initrd_override(void *data, size_t size)
> +{
> +       int sig, no, table_nr = 0, total_offset = 0;
> +       long offset = 0;
> +       struct acpi_table_header *table;
> +       char cpio_path[32] = "kernel/firmware/acpi/";
> +       struct cpio_data file;
> +       struct cpio_data early_initrd_files[ACPI_OVERRIDE_TABLES];
> +       char *p;
> +
> +       if (data == NULL || size == 0)
> +               return;
> +
> +       for (no = 0; no < ACPI_OVERRIDE_TABLES; no++) {
> +               file = find_cpio_data(cpio_path, data, size, &offset);
> +               if (!file.data)
> +                       break;
> +
> +               data += offset;
> +               size -= offset;
> +
> +               if (file.size < sizeof(struct acpi_table_header))
> +                       INVALID_TABLE("Table smaller than ACPI header",
> +                                     cpio_path, file.name);
> +
> +               table = file.data;
> +
> +               for (sig = 0; table_sigs[sig]; sig++)
> +                       if (!memcmp(table->signature, table_sigs[sig], 4))
> +                               break;
> +
> +               if (!table_sigs[sig])
> +                       INVALID_TABLE("Unknown signature",
> +                                     cpio_path, file.name);
> +               if (file.size != table->length)
> +                       INVALID_TABLE("File length does not match table length",
> +                                     cpio_path, file.name);
> +               if (acpi_table_checksum(file.data, table->length))
> +                       INVALID_TABLE("Bad table checksum",
> +                                     cpio_path, file.name);
> +
> +               pr_info("%4.4s ACPI table found in initrd [%s%s][0x%x]\n",
> +                       table->signature, cpio_path, file.name, table->length);
> +
> +               all_tables_size += table->length;
> +               early_initrd_files[table_nr].data = file.data;
> +               early_initrd_files[table_nr].size = file.size;
> +               table_nr++;
> +       }
> +       if (table_nr == 0)
> +               return;
> +
> +       acpi_tables_addr =
> +               memblock_find_in_range(0, max_low_pfn_mapped << PAGE_SHIFT,
> +                                      all_tables_size, PAGE_SIZE);
> +       if (!acpi_tables_addr) {
> +               WARN_ON(1);
> +               return;
> +       }
> +       /*
> +        * Only calling e820_add_reserve does not work and the
> +        * tables are invalid (memory got used) later.
> +        * memblock_x86_reserve_range works as expected and the tables
> +        * won't get modified. But it's not enough because ioremap will
> +        * complain later (used by acpi_os_map_memory) that the pages
> +        * that should get mapped are not marked "reserved".
> +        * Both memblock_x86_reserve_range and e820_add_region works fine.
> +        */
> +       memblock_reserve(acpi_tables_addr, acpi_tables_addr + all_tables_size);
> +       e820_add_region(acpi_tables_addr, all_tables_size, E820_ACPI);
> +       update_e820();

need to move those arch related to arch/x86

> +       p = early_ioremap(acpi_tables_addr, all_tables_size);
> +
> +       for (no = 0; no < table_nr; no++) {
> +               memcpy(p + total_offset, early_initrd_files[no].data,
> +                      early_initrd_files[no].size);
> +               total_offset += early_initrd_files[no].size;
> +       }

You may use one loop function, and it could take one call back.
callback 1 will get item and size.
callback 2 will do the copy...

so you can remove hard limit of ACPI_OVERRIDE_TABLES.

> +       early_iounmap(p, all_tables_size);
> +}
> +#endif /* CONFIG_ACPI_INITRD_TABLE_OVERRIDE */
> +
> +static void acpi_table_taint(struct acpi_table_header *table)
> +{
> +       pr_warn(PREFIX
> +               "Override [%4.4s-%8.8s], this is unsafe: tainting kernel\n",
> +               table->signature, table->oem_table_id);
> +       add_taint(TAINT_OVERRIDDEN_ACPI_TABLE);
> +}
> +

can you split acpi_table_taint split change to another patch?

>  acpi_status
>  acpi_os_table_override(struct acpi_table_header * existing_table,
>                        struct acpi_table_header ** new_table)
> @@ -547,24 +678,74 @@ acpi_os_table_override(struct acpi_table_header * existing_table,
>         if (strncmp(existing_table->signature, "DSDT", 4) == 0)
>                 *new_table = (struct acpi_table_header *)AmlCode;
>  #endif
> -       if (*new_table != NULL) {
> -               printk(KERN_WARNING PREFIX "Override [%4.4s-%8.8s], "
> -                          "this is unsafe: tainting kernel\n",
> -                      existing_table->signature,
> -                      existing_table->oem_table_id);
> -               add_taint(TAINT_OVERRIDDEN_ACPI_TABLE);
> -       }
> +       if (*new_table != NULL)
> +               acpi_table_taint(existing_table);
>         return AE_OK;
>  }
>
>  acpi_status
>  acpi_os_physical_table_override(struct acpi_table_header *existing_table,
> -                               acpi_physical_address * new_address,
> -                               u32 *new_table_length)
> +                               acpi_physical_address *address,
> +                               u32 *table_length)
>  {
> -       return AE_SUPPORT;
> -}
> +#ifndef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
> +       *table_length = 0;
> +       *address = 0;
> +       return AE_OK;
> +#else

also could hide macro in header file.

> +       int table_offset = 0;
> +       struct acpi_table_header *table;
> +
> +       *table_length = 0;
> +       *address = 0;
> +
> +       if (!acpi_tables_addr)
> +               return AE_OK;
> +
> +       do {
> +               if (table_offset + ACPI_HEADER_SIZE > all_tables_size) {
> +                       WARN_ON(1);
> +                       return AE_OK;
> +               }
> +
> +               table = acpi_os_map_memory(acpi_tables_addr + table_offset,
> +                                          ACPI_HEADER_SIZE);
>
> +               if (table_offset + table->length > all_tables_size) {
> +                       acpi_os_unmap_memory(table, ACPI_HEADER_SIZE);
> +                       WARN_ON(1);
> +                       return AE_OK;
> +               }
> +
> +               table_offset += table->length;
> +
> +               if (memcmp(existing_table->signature, table->signature, 4)) {
> +                       acpi_os_unmap_memory(table,
> +                                    ACPI_HEADER_SIZE);
> +                       continue;
> +               }
> +
> +               /* Only override tables with matching oem id */
> +               if (memcmp(table->oem_table_id, existing_table->oem_table_id,
> +                          ACPI_OEM_TABLE_ID_SIZE)) {
> +                       acpi_os_unmap_memory(table,
> +                                    ACPI_HEADER_SIZE);
> +                       continue;
> +               }
> +
> +               table_offset -= table->length;
> +               *table_length = table->length;
> +               acpi_os_unmap_memory(table, ACPI_HEADER_SIZE);
> +               *address = acpi_tables_addr + table_offset;
> +               add_taint(TAINT_OVERRIDDEN_ACPI_TABLE);
> +               break;
> +       } while (table_offset + ACPI_HEADER_SIZE < all_tables_size);
> +
> +       if (*address != 0)
> +               acpi_table_taint(existing_table);
> +       return AE_OK;
> +#endif
> +}

could be split to another patch too.


>
>  static irqreturn_t acpi_irq(int irq, void *dev_id)
>  {
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index 4f2a762..87e2c9e 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -76,6 +76,10 @@ typedef int (*acpi_table_handler) (struct acpi_table_header *table);
>
>  typedef int (*acpi_table_entry_handler) (struct acpi_subtable_header *header, const unsigned long end);
>
> +#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
> +void __init acpi_initrd_override(void *data, size_t size);

could drop __init declaration in header file.

> +#endif
> +
>  char * __acpi_map_table (unsigned long phys_addr, unsigned long size);
>  void __acpi_unmap_table(char *map, unsigned long size);
>  int early_acpi_boot_init(void);
> --
> 1.7.6.1
>
