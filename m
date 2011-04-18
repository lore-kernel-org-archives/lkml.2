Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab1DRR2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 13:28:05 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52341 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110Ab1DRR15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 13:27:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Ai93AOg86KTdRC+MQKHQ3jGKbG8/56l6D7NYI+GZSKoux6PKl2Ujq3fajuaFQP/YCZ
         ru3XAk2OnSYHopaAJkNYCMY0b9dAAlJSwn1BmqVN0LEjNlJgTpAnknciRKFZ/AZR9jbs
         nLFIiUDVXMNNx0HVcDYgoHdsW5kePXnsvB820=
Message-ID: <4DAC7499.5000602@gmail.com>
Date: Mon, 18 Apr 2011 10:27:53 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>, Wu Zhangjin <wuzhangjin@gmail.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Squash pci_fixup_irqs() compiler warning
References: <cb01d61712b1374a8c62bc765094ea7e@localhost>
In-Reply-To: <cb01d61712b1374a8c62bc765094ea7e@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2011 12:01 PM, Kevin Cernekee wrote:
> MIPS Linux is unique in that it uses a "const struct pci_dev *" argument
> to discourage bad coding practices in pcibios_map_irq().  Add a cast so
> that this warning goes away:
>
> arch/mips/pci/pci.c: In function 'pcibios_init':
> arch/mips/pci/pci.c:165:45: warning: passing argument 2 of 'pci_fixup_irqs' from incompatible pointer type
> include/linux/pci.h:856:6: note: expected 'int (*)(struct pci_dev *, u8,  u8)' but argument is of type 'struct pci_dev *'
>
> Signed-off-by: Kevin Cernekee<cernekee@gmail.com>
> ---
>
> Reference:
>
> http://www.mail-archive.com/gnewsense-dev@nongnu.org/msg00706.html
>
> It's been two years since the original discussion, and the warning is
> still there.  It is now the only warning left in my kernel build.
>
> I was hoping we could get this resolved for good (one way or another).
>
>   arch/mips/pci/pci.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/arch/mips/pci/pci.c b/arch/mips/pci/pci.c
> index 33bba7b..9a35cd6 100644
> --- a/arch/mips/pci/pci.c
> +++ b/arch/mips/pci/pci.c
> @@ -157,7 +157,8 @@ static int __init pcibios_init(void)
>   	for (hose = hose_head; hose; hose = hose->next)
>   		pcibios_scanbus(hose);
>
> -	pci_fixup_irqs(pci_common_swizzle, pcibios_map_irq);
> +	pci_fixup_irqs(pci_common_swizzle,
> +		       (int (*)(struct pci_dev *, u8, u8))pcibios_map_irq);
>

NAK.

I think Ralf's idea in the e-mail you referenced is the proper approach.

Change pci_fixup_irqs(...) to take a 'const struct pci_dev *' instead. 
There is a lot of work going on in the kernel to constify things.  This 
should be fairly easy to get accepted.

The alternative is to change all the pcibios_map_irq to match what is 
expected by pci_fixup_irqs().

David Daney


>   	pci_initialized = 1;
>

