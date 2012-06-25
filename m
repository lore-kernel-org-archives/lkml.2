Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab2FYWiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 18:38:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53696 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757658Ab2FYWiC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 18:38:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo4oE8nHmu1KBXSX=YjQGfD89v2fqL=96THz98uZ4Va_rQ@mail.gmail.com>
References: <1340650789-3326-1-git-send-email-yinghai@kernel.org>
	<CAErSpo4oE8nHmu1KBXSX=YjQGfD89v2fqL=96THz98uZ4Va_rQ@mail.gmail.com>
Date: Mon, 25 Jun 2012 15:38:02 -0700
X-Google-Sender-Auth: xJhlHcfPnwiiG7G_unTx7LZHCGo
Message-ID: <CAE9FiQXhGLwSH4gq7L9DrhVAXcDu_NbjLA5QkCDOEqaFO09m7w@mail.gmail.com>
Subject: Re: [PATCH] PCI, X86: busnum/node boot command line for pci dev node setting.
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, lenb@kernel.org, x86@kernel.org,
        Ulrich Drepper <drepper@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 1:59 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Mon, Jun 25, 2012 at 12:59 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> Some intel new sandybridge or newer two sockets system do support support numa
>> for pci devices. But BIOS does not provide _PXM under those root bus in DSDT.
>>
>> Add boot command line, so user could have chance to input node info before
>> BIOS guys figure out to add _PXM.
>>
>> Fold fix from Ulrich to use ";" instead of ",".
>> | The problem is the pci= parameter
>> | handling uses ',' to separate parameters and therefore the second PCI
>> | root information, separated by a comma, is interpreted as a new pci=
>> | parameter.
>>
>> -v3: According to Bjorn and Ingo, change to use "user input first" policy
>>     so it could cover wrong _PXM case.
>> -v4: Folded change from Ulrich to record pointer of busnum_node string.
>>
>> Reported-by: Ulrich Drepper <drepper@gmail.com>
>> Tested-by: Ulrich Drepper <drepper@gmail.com>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  Documentation/kernel-parameters.txt |    5 +++++
>>  arch/x86/include/asm/pci_x86.h      |    3 +++
>>  arch/x86/pci/acpi.c                 |   22 +++++++++++++---------
>>  arch/x86/pci/common.c               |   36 ++++++++++++++++++++++++++++++++++++
>>  4 files changed, 57 insertions(+), 9 deletions(-)
>>
>> Index: linux-2.6/Documentation/kernel-parameters.txt
>> ===================================================================
>> --- linux-2.6.orig/Documentation/kernel-parameters.txt
>> +++ linux-2.6/Documentation/kernel-parameters.txt
>> @@ -2068,6 +2068,11 @@ bytes respectively. Such letter suffixes
>>                                hardware access methods are allowed. Use this
>>                                if you experience crashes upon bootup and you
>>                                suspect they are caused by the BIOS.
>> +               busnum_node=    [X86] Set node for root bus.
>> +                               Format:
>> +                               <bus>:<node>[;...]
>> +                               Specifies node for bus, will override bios _PXM
>> +                               or probed value from hostbridge.
>
> I liked the previous argument format that included "pci".  Now we're
> assuming the only bus type important enough to care about NUMA
> information is PCI.

which one?

>
> This should also work on ia64, which also uses ACPI.  For that matter,
> it'd be nice if it worked on *any* NUMA architecture, though I don't
> see any  PCI NUMA support at all for anything but x86 and ia64.

ia64 platform should be well tested with Linux?

>
>>                conf1           [X86] Force use of PCI Configuration
>>                                Mechanism 1.
>>                conf2           [X86] Force use of PCI Configuration
>> Index: linux-2.6/arch/x86/pci/common.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/pci/common.c
>> +++ linux-2.6/arch/x86/pci/common.c
>> @@ -494,6 +494,39 @@ int __init pcibios_init(void)
>>        return 0;
>>  }
>>
>> +static const char *busnum_node_param;
>> +
>> +static void remember_busnum_node(const char *str)
>> +{
>> +       busnum_node_param = str;
>
> Can you convince me this is safe?  pci_setup() is an early_param, so
> it looks to me like we might be saving a pointer to initdata in this
> call path:
>
>    setup_arch
>      parse_early_param
>        strlcpy(tmp_cmdline, boot_command_line)
>        parse_early_options(__initdata tmp_cmdline)
>          parse_args
>            do_early_param
>              ...
>              pci_setup (early_param)
>                pcibios_setup
>                  remember_busnum_node
>
> And then we use that saved pointer to parse the string at host bridge
> add-time, which might be after initdata has been freed.

ok, that will need one separate buffer.

>
>> +}
>> +
>> +int get_user_busnum_node(int busnum)
>> +{
>> +       int bus, node, count;
>> +       const char *p = busnum_node_param;
>> +
>> +       if (!p)
>> +               return -1;
>> +
>> +       while (*p) {
>> +               count = 0;
>> +               if (sscanf(p, "%x:%x%n", &bus, &node, &count) != 2) {
>> +                       printk(KERN_ERR "PCI: Can't parse busnum_node input: %s\n",
>> +                                       p);
>> +                       break;
>> +               }
>> +               if (bus == busnum)
>> +                       return node;
>> +               p += count;
>> +               if (*p != ';')
>> +                       break;
>> +               p++;
>> +       }
>> +
>> +       return -1;
>> +}
>> +
>>  char * __devinit  pcibios_setup(char *str)
>>  {
>>        if (!strcmp(str, "off")) {
>> @@ -579,6 +612,9 @@ char * __devinit  pcibios_setup(char *st
>>        } else if (!strcmp(str, "nocrs")) {
>>                pci_probe |= PCI_ROOT_NO_CRS;
>>                return NULL;
>> +       } else if (!strncmp(str, "busnum_node=", 12)) {
>> +               remember_busnum_node(str + 12);
>> +               return NULL;
>>        } else if (!strcmp(str, "earlydump")) {
>>                pci_early_dump_regs = 1;
>>                return NULL;
>> Index: linux-2.6/arch/x86/include/asm/pci_x86.h
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/include/asm/pci_x86.h
>> +++ linux-2.6/arch/x86/include/asm/pci_x86.h
>> @@ -46,6 +46,9 @@ enum pci_bf_sort_state {
>>        pci_dmi_bf,
>>  };
>>
>> +/* pci-common.c */
>> +int get_user_busnum_node(int busnum);
>> +
>>  /* pci-i386.c */
>>
>>  void pcibios_resource_survey(void);
>> Index: linux-2.6/arch/x86/pci/acpi.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/pci/acpi.c
>> +++ linux-2.6/arch/x86/pci/acpi.c
>> @@ -453,7 +453,7 @@ struct pci_bus * __devinit pci_acpi_scan
>>        struct pci_sysdata *sd;
>>        int node;
>>  #ifdef CONFIG_ACPI_NUMA
>> -       int pxm;
>> +       int pxm = -1;
>>  #endif
>>
>>        if (domain && !pci_domains_supported) {
>> @@ -463,16 +463,20 @@ struct pci_bus * __devinit pci_acpi_scan
>>                return NULL;
>>        }
>>
>> -       node = -1;
>> +       node = get_user_busnum_node(busnum);
>> +       if (node == -1) {
>>  #ifdef CONFIG_ACPI_NUMA
>> -       pxm = acpi_get_pxm(device->handle);
>> -       if (pxm >= 0)
>> -               node = pxm_to_node(pxm);
>> -       if (node != -1)
>> -               set_mp_bus_to_node(busnum, node);
>> -       else
>> -#endif
>> +               pxm = acpi_get_pxm(device->handle);
>> +               if (pxm >= 0)
>> +                       node = pxm_to_node(pxm);
>
> The code above (everything except the calls to set_mp_bus_to_node()
> and get_mp_bus_to_node(), which are x86-specific) should be the same
> between x86 and ia64.  Can you rationalize them?  It'd be better if
> they used the same #ifdefs and the same code structure.

this patch does not change set_mp_bus_to_node/get_mp_bus_to_node...
only let user_busnum_node override them.

Yinghai
