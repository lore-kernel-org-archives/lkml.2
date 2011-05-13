Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab1EMHTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 03:19:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36076 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077Ab1EMHSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 03:18:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=G1jhGU/KlAU3jUtz9JI6rtpV98nAZVRmL61MTIk0ITy2yUsoNMcBU/aYY3DlRQAuoh
         rPr1cRLr1dz8Blc2RgIZobopXAF5xpFMNdtZQ+MS+K/z5VaFEv+HJKDS3o09WiBKAZkt
         PP5ijNdAsPijXuvdcVowhjdkw0bBOE9WyAHac=
Message-ID: <4DCCDB57.70706@suse.cz>
Date: Fri, 13 May 2011 09:18:47 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Jiri Slaby <jirislaby@gmail.com>,
        Robert Hancock <hancockrwd@gmail.com>, lenb@kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] ACPI: pci_irq, add PRT_ quirk for IBM Bartolo
References: <4C87A62E.30108@gmail.com> <1302598086-3622-1-git-send-email-jslaby@suse.cz> <20110412085622.43488ed9@jbarnes-desktop> <20110412155921.GA531@srcf.ucam.org>
In-Reply-To: <20110412155921.GA531@srcf.ucam.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2011 05:59 PM, Matthew Garrett wrote:
> On Tue, Apr 12, 2011 at 08:56:22AM -0700, Jesse Barnes wrote:
>> I'll defer to the ACPI experts, Len or Matthew have you checked this
>> one out?
> 
> Windows appears to work without this, so it seems likely that we're 
> doing something wrong in some other sense, but I don't think we have a 
> good idea as to what we're doing wrong...

I changed the irq assignment like (to take the lowest
available/non-conflicting IRQ):
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -557,7 +557,7 @@ static int acpi_pci_link_allocate(struct
          * the use of IRQs 9, 10, 11, and >15.
          */
         for (i = (link->irq.possible_count - 1); i >= 0; i--) {
-            if (acpi_irq_penalty[irq] >
+            if (acpi_irq_penalty[irq] >=
                 acpi_irq_penalty[link->irq.possible[i]])
                 irq = link->irq.possible[i];
         }


And with this change it works _without_ acpi=noirq.

Does it help somehow?

dmesg then shows a difference like:
 serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
 00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
-ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
-PCI: setting IRQ 11 as level-triggered
-serial 0000:00:09.0: PCI INT A -> Link[LNKB] -> GSI 11 (level, low) ->
IRQ 11
-0000:00:09.0: ttyS4 at I/O 0x1898 (irq = 11) is a 16550A
-0000:00:09.0: ttyS5 at I/O 0x1890 (irq = 11) is a 16550A
+ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
+PCI: setting IRQ 10 as level-triggered
+serial 0000:00:09.0: PCI INT A -> Link[LNKB] -> GSI 10 (level, low) ->
IRQ 10
+0000:00:09.0: ttyS4 at I/O 0x1898 (irq = 10) is a 16550A
+0000:00:09.0: ttyS5 at I/O 0x1890 (irq = 10) is a 16550A
 ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
+PCI: setting IRQ 11 as level-triggered
 serial 0000:00:0b.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) ->
IRQ 11
 0000:00:0b.0: ttyS6 at I/O 0x18c0 (irq = 11) is a 16550A
 0000:00:0b.0: ttyS7 at I/O 0x18b8 (irq = 11) is a 16550A

thanks,
-- 
js
suse labs
