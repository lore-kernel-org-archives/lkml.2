Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab1DLI6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 04:58:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34792 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788Ab1DLI6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 04:58:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=nZvmX0Jxd7/PX+jTkT/x6LIM0/p2CUQQU/X90Y8GOPGJ81wSfuFi3/XQxkAANCD8+c
         83JkUMPkCitU8Vgns78U43MKNRj7EuFRPUC0pLliiETH5h4k/J6w9H4pRsEpwz3ahOIz
         8T1QCYS1oi3m9hkJNQfujVVichhS0ftC2Ekus=
Message-ID: <4DA41440.8060703@suse.cz>
Date: Tue, 12 Apr 2011 10:58:40 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Robert Hancock <hancockrwd@gmail.com>, mjg59@srcf.ucam.org,
        lenb@kernel.org, linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
        yakui.zhao@intel.com
Subject: Re: [RFC 1/1] ACPI: pci_irq, add PRT_ quirk for IBM Bartolo
References: <4C87A62E.30108@gmail.com> <1302598086-3622-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1302598086-3622-1-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2011 10:48 AM, Jiri Slaby wrote:
> On IBM Bartolo machines, cards in 00:09.0 are defunct (if use
> interrupts). DSDT says that this slot (with function 0, i.e. pin A) is
> routed to \_SB_.PCI0.PIB_.LNKB. But it's not, it's wired to LNKC, so
> interrupts are misrouted. Add a quirk for this to workaround the
> issue.
> 
> References: https://bugzilla.novell.com/show_bug.cgi?id=595683
> References: https://bugzilla.kernel.org/show_bug.cgi?id=18092
> 
> ---
> Hi,
> 
> as Robert Hancock suggested at:
> http://lkml.org/lkml/2010/9/7/206
> 
> I reported this in bugzilla (the link above). But I got only replies
> requesting another infos which I provided.

BTW. the info is (w/ and w/o acpi=noirq):
acpidump: https://bugzilla.kernel.org/attachment.cgi?id=29332
dmesg w/:  https://bugzilla.kernel.org/attachment.cgi?id=29322
dmesg w/o: https://bugzilla.kernel.org/attachment.cgi?id=29312
lspci w/:  https://bugzilla.kernel.org/attachment.cgi?id=29712
lspci w/o: https://bugzilla.kernel.org/attachment.cgi?id=29902
BIOS PRT w/:  https://bugzilla.kernel.org/attachment.cgi?id=43192
BIOS PRT w/o: https://bugzilla.kernel.org/attachment.cgi?id=43182

> Could anybody look into
> the bug and confirm whether this patch is correct or not. And if yes,
> could you apply that?
> 
> ---
> 
> Not-signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---
>  drivers/acpi/pci_irq.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
> index f907cfb..e8fb00d 100644
> --- a/drivers/acpi/pci_irq.c
> +++ b/drivers/acpi/pci_irq.c
> @@ -124,6 +124,18 @@ static const struct dmi_system_id hp_t5710[] = {
>  	{ }
>  };
>  
> +/* https://bugzilla.novell.com/show_bug.cgi?id=595683 */
> +static const struct dmi_system_id ibm_bartolo[] = {
> +	{
> +		.ident = "IBM Bartolo",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "IBM CORPORATION"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "4810320"),
> +		},
> +	},
> +	{ }
> +};
> +
>  struct prt_quirk {
>  	const struct dmi_system_id *system;
>  	unsigned int		segment;
> @@ -151,6 +163,9 @@ static const struct prt_quirk prt_quirks[] = {
>  	{ hp_t5710, 0, 0, 1, PCI_INTX_PIN('A'),
>  		"\\_SB_.PCI0.LNK1",
>  		"\\_SB_.PCI0.LNK3"},
> +	{ ibm_bartolo, 0, 0, 9, PCI_INTX_PIN('A'),
> +		"\\_SB_.PCI0.PIB_.LNKB",
> +		"\\_SB_.PCI0.PIB_.LNKC"},
>  };
>  
>  static void do_prt_fixups(struct acpi_prt_entry *entry,

thanks,
-- 
js
suse labs
