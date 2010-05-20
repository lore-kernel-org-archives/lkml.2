Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab0ETRou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 13:44:50 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53515 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab0ETRos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 13:44:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=gsLtyZ5fwqtp50mBTw05XQioF3p9nnPGocjBIjzWcsYtVrt8ZU5bKzfSKDN2qtYxkH
         QEVmKWwBNDP0K0/rNthUSNUK2ABsxKnW6wd1IfqqN03wy8foRLzQGFw2ygJZlvArR7qA
         euWyB+vbEIm3EESeNeekoJjfnKGRkaHM/MwhQ=
Message-ID: <4BF57515.6030404@gmail.com>
Date: Thu, 20 May 2010 10:44:53 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jens.Kuenzer@fpga.homeip.net, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][bisected]pcmcia:yenta_socket.c fix broken wireless cards.
References: <1274303284-21529-1-git-send-email-justinmattock@gmail.com> <20100520145434.GA12166@comet.dominikbrodowski.net> <4BF55AC9.4000905@gmail.com> <20100520163419.GA16522@comet.dominikbrodowski.net>
In-Reply-To: <20100520163419.GA16522@comet.dominikbrodowski.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2010 09:34 AM, Dominik Brodowski wrote:
> Jens, Justin,
>
> could both of you test this patch on top of 2.6.34, please?
>
> pcmcia: only keep saved I365_CSCING flag if there is no PCI irq
>
> Signed-off-by: Dominik Brodowski<linux@dominikbrodowski.net>
>
> diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
> index 424e576..151ca43 100644
> --- a/drivers/pcmcia/yenta_socket.c
> +++ b/drivers/pcmcia/yenta_socket.c
> @@ -371,8 +371,11 @@ static int yenta_set_socket(struct pcmcia_socket *sock, socket_state_t *state)
>   			exca_writeb(socket, I365_POWER, reg);
>
>   		/* CSC interrupt: no ISA irq for CSC */
> -		reg = exca_readb(socket, I365_CSCINT);
> -		reg&= I365_CSC_IRQ_MASK;
> +		reg = 0;
> +		if (!socket->dev->irq) {
> +			reg = exca_readb(socket, I365_CSCINT);
> +			reg&= I365_CSC_IRQ_MASK;
> +		}
>   		reg |= I365_CSC_DETECT;
>   		if (state->flags&  SS_IOCARD) {
>   			if (state->csc_mask&  SS_STSCHG)
>



o.k. finally built the kernel
with this machine..
with the current head, there is
no fix, after applying your patch
to the current, seems this thing is still
broken. here is some info from dmesg
with the current head with your patch on top:


agpgart-intel 0000:00:00.0: Intel 915GM Chipset
[    9.700307] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[    9.773503] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    9.824628] yenta_cardbus 0000:02:01.0: CardBus bridge found [1028:01a6]
[    9.824657] yenta_cardbus 0000:02:01.0: Using CSCINT to route CSC 
interrupts to PCI
[    9.824661] yenta_cardbus 0000:02:01.0: Routing CardBus interrupts to PCI
[    9.824669] yenta_cardbus 0000:02:01.0: TI: mfunc 0x00001002, devctl 0x64
[    9.914482] input: Video Bus as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/LNXVIDEO:00/input/input2
[    9.914614] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    9.914658] [Firmware Bug]: Duplicate ACPI video bus devices for the 
same VGA controller, please try module parameter 
"video.allow_duplicates=1"if the current driver doesn't work.
[   10.286343] yenta_cardbus 0000:02:01.0: TI: probing PCI interrupt 
failed, trying to fix
[   10.387050] yenta_cardbus 0000:02:01.0: Yenta TI: no PCI interrupts. 
Fish. Please report.
[   10.387062] yenta_cardbus 0000:02:01.0: no PCI IRQ, CardBus support 
disabled for this socket.
[   10.387066] yenta_cardbus 0000:02:01.0: check your BIOS CardBus, BIOS 
IRQ or ACPI settings.
[   10.490080] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x8fa0b1, 
caps: 0xa04713/0x200000/0x0
[   10.531380] input: SynPS/2 Synaptics TouchPad as 
/devices/platform/i8042/serio1/input/input3
power_supply BAT0: prop SERIAL_NUMBER=4211
[   10.696902] yenta_cardbus 0000:02:01.0: ISA IRQ mask 0x0cf8, PCI irq 0
[   10.696910] yenta_cardbus 0000:02:01.0: Socket status: 30000020
[   10.696916] pci_bus 0000:02: Raising subordinate bus# of parent bus 
(#02) from #03 to #06
[   10.696935] yenta_cardbus 0000:02:01.0: pcmcia: parent PCI bridge 
window: [io  0xd000-0xdfff]
[   10.696941] yenta_cardbus 0000:02:01.0: pcmcia: parent PCI bridge 
window: [mem 0xdfd00000-0xdfdfffff]
[   10.696948] pcmcia_socket pcmcia_socket0: cs: memory probe 
0xdfd00000-0xdfdfffff: excluding 0xdfd00000-0xdfd0ffff 0xdfdf0000-0xdfdfffff
[   10.697033] yenta_cardbus 0000:02:01.0: pcmcia: parent PCI bridge 
window: [mem 0x20000000-0x23ffffff pref]
[   10.697039] pcmcia_socket pcmcia_socket0: cs: memory probe 
0x20000000-0x23ffffff: excluding 0x20000000-0x23ffffff
[   10.727273] pcmcia_socket pcmcia_socket0: cs: memory probe 
0x0c0000-0x0fffff: excluding 0xc0000-0xc7fff 0xcc000-0xcffff 0xf0000-0xfffff
[   10.727541] pcmcia_socket pcmcia_socket0: cs: memory probe 
0xa0000000-0xa0ffffff: clean.
[   10.727801] pcmcia_socket pcmcia_socket0: cs: memory probe 
0x60000000-0x60ffffff: clean.
[   10.823429] Intel ICH 0000:00:1e.2: PCI INT A -> GSI 16 (level, low) 
-> IRQ 16
[   10.823487] Intel ICH 0000:00:1e.2: setting latency timer to 64
[   11.070034] pcmcia_socket pcmcia_socket0: cardbus cards are not 
supported.
[   11.134038] intel8x0_measure_ac97_clock: measured 50713 usecs (2444 
samples)
[   11.134044] intel8x0: clocking to 48000

this is all the info I see in dmesg on this machine
(if you need full log let me know).

Justin P. Mattock
