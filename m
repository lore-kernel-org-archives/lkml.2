Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684Ab2LTVqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 16:46:35 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:53375 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab2LTVq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 16:46:27 -0500
MIME-Version: 1.0
In-Reply-To: <20121219215005.17785.47831.stgit@amt.stowe>
References: <20121219215005.17785.47831.stgit@amt.stowe>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 20 Dec 2012 14:46:06 -0700
Message-ID: <CAErSpo4nf0K0w0xZ+m--iUjmW91Mv4y+9PHWY5Uo9=mt4ZOQuw@mail.gmail.com>
Subject: Re: [PATCH] PCI: Work around Stratus ftServer broken PCIe hierarchy
To: Myron Stowe <myron.stowe@redhat.com>
Cc: linux-pci@vger.kernel.org, astarta@rat.ru, ddutile@redhat.com,
        james.paradis@stratus.com, matthew.r.wilcox@intel.com,
        prarit@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 2:50 PM, Myron Stowe <myron.stowe@redhat.com> wrote:
> Recently, another report surfaced indicating Stratus ftServer platforms
> were exhibiting similar failures as has occurred in the past [1].
>
>   In late 2011 we started seeing issues with Stratus ftServer systems.
>   The typical failure was that USB and network devices were not being
>   seen.  Research uncovered that the failure was due to the platform's PCI
>   Express hierarchy  not conforming to the PCI Express specification [2]
>   which commit f07852d exposed.
>
>   The following are known Stratus ftServer platforms whose PCI hierarchies
>   are broken:
>
>   Stratus ftServer ????
>   +-07.0-[01-76]--+-00.0-[02-76]--+-00.0-[03-3c]--+-00.0-[04-09]..
>                                                   \-01.0-[0a-0d]--+-[USB]
>                                                                   +-[NIC]
>                                                                   +-..
>
>   Stratus ftServer 6400
>   [0000:00]-+-...-00.0-[03]-00.0-[04]-+-00.0-[05]---00.0-[06]..
>             |  |                      |
>             |  |                      \-01.0-[2c]-+-00.0 [USB]
>             |  |                                  +-00.1 [USB]
>             |  |                                  \-1f.0 [ISA]
>
>   Stratus ftServer 4500
>   Stratus ftServer 6310
>
>   As a solution, commit 284f5f9 was introduced.
>
> Looking into this again it looks as if the quirk introduced in 284f5f9 is
> not making the correct DMI based check.  This patch fixes the DMI 'vendor'
> based check to match "Stratus", not "ftServer".  It also augments the
> checking to include matching the DMI based 'product name' to "ftServer".
> This quirk should now trigger for all Stratus ftServer platforms which I
> was able to confirm by testing on a Stratus ftServer 6400 system with the
> following 'dmidecode' output:
>   System Information
>         Manufacturer: Stratus
>         Product Name: ftServer 6400
>
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=51331
> [2] PCI Express specification, r3.0, Section 7.3.1
>
> Reported-by: Fadeeva Marina <astarta@rat.ru>
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> ---
>
>  arch/x86/pci/common.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
> index 720e973..487d9f3 100644
> --- a/arch/x86/pci/common.c
> +++ b/arch/x86/pci/common.c
> @@ -433,7 +433,8 @@ static const struct dmi_system_id __devinitconst pciprobe_dmi_table[] = {
>                 .callback = set_scan_all,
>                 .ident = "Stratus/NEC ftServer",
>                 .matches = {
> -                       DMI_MATCH(DMI_SYS_VENDOR, "ftServer"),
> +                       DMI_MATCH(DMI_SYS_VENDOR, "Stratus"),
> +                       DMI_MATCH(DMI_PRODUCT_NAME, "ftServer"),
>                 },
>         },
>         {}
>

I added this to my pci/for-3.8 branch, which I'll ask Linus to pull
soon after v3.8-rc1.  Thanks!

Bjorn
