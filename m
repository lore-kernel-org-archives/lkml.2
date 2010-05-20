Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab0ETPwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 11:52:37 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46972 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab0ETPwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 11:52:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=az0NWJuf06SSM/VM5V2QwLNjnqXIR3xTsWNlfF3kjvjfZMOiT4tjAjfZc4I9fFOFJk
         htTqteY9GMUsZ2VYsUX5fHbE3Bhg4/tzvY8I4VxFUQS98asUVWDShBgkV5LfdgafRIof
         oLK4wcQ9uHGfV2HVPmXWSp/f9ke/YaMb+R5gw=
Message-ID: <4BF55AC9.4000905@gmail.com>
Date: Thu, 20 May 2010 08:52:41 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][bisected]pcmcia:yenta_socket.c fix broken wireless cards.
References: <1274303284-21529-1-git-send-email-justinmattock@gmail.com> <20100520145434.GA12166@comet.dominikbrodowski.net>
In-Reply-To: <20100520145434.GA12166@comet.dominikbrodowski.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2010 07:54 AM, Dominik Brodowski wrote:
> Justin,
>
> On Wed, May 19, 2010 at 02:08:04PM -0700, Justin P. Mattock wrote:
>> I've an old dell inspiron 1200(amazingly still works), that use's
>> a D-Link DWL-G650, and/or a Dell Wireless 1350 for it's wireless
>> connection.
>>
>> With using opensuse11.2(kernel:2.6.32*), the card(s) work fine, but as soon
>> as I pulled the latest HEAD, all hell broke loose. So after doing a
>> days worth of bisecting with this machine(painfully slow), it finally
>> came down to this commit:
>>
>> commit 28ca8dd71fc170090edca62cb8129625d01b7760
>> Author: Jens K<C3><BC>nzer<Jens.Kuenzer@fpga.homeip.net>
>> Date:   Sat Mar 6 07:46:16 2010 +0100
>>
>>      pcmcia: honor saved flags in yenta_socket's I365_CSCINT register
>>
>>      Instead of overwriting the I365_CSCINT register, save the old value and
>>      merely change the bits we care about.
>>
>>      Part 1 of a series to allow the ISA irq to be used for Cardbus devices
>>      if the socket's PCI irq is unusable.
>>
>>      [linux@dominikbrodowski.net: split up the original patch, commit message]
>>
>>      Signed-off-by: Jens Kuenzer<Jens.Kuenzer@fpga.homeip.net>
>>      Signed-off-by: Dominik Brodowski<linux@dominikbrodowski.net>
>>
>> so after fussing around with this commit, and yenta_socket.c
>> I come up with something, that does get my cards
>> powered up, and all good(hopefully).
>>
>> Anyways please have a look, if you need me to test something
>> different let me know.
>>
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>
> Thanks for tracking this issue down! Could you check what "reg" returned
> before you applied your patch, and what it is after you applied your patch?
>

your welcome!! I went and filed a bug report for this
(cause I didn't know if Id receive a response or not:
https://bugzilla.kernel.org/show_bug.cgi?id=16015(and yes I had a hissy 
fit).

>> diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
>> index 83ace27..7d6f43b 100644
>> --- a/drivers/pcmcia/yenta_socket.c
>> +++ b/drivers/pcmcia/yenta_socket.c
>> @@ -989,7 +989,7 @@ static int yenta_probe_cb_irq(struct yenta_socket *socket)
>>   	}
>>
>>   	/* generate interrupt, wait */
>> -	reg = exca_readb(socket, I365_CSCINT);
>> +	reg = exca_readb(socket, I365_CSCINT | I365_CSC_ANY);
>
> the second parameter to exca_readb() is the address which we read from.
> I365_CSCINT is the register at offset 0x05; CSC_ANY isn't a register offset,
> but 0x0f ... so you're reading now from a register at offset 0x0f.
>

yeah I wasn't sure what to really do, I ended up replacing(as a test)
I365_CSCINT with I365_GENCTL, I365_INTCTL and I365_STATUS(only 
I365_STATUS worked out of these as well as I365_CSC_ANY, so I figured
as a temporary fix just to use I365_CSC_ANY).

> Still, something needs to be fixed -- and to do that, it'd be great if you
> could tell us the value of "reg" which works, and the value which doesn't.
> Then I'll prepare a patch for testing, so that it hopefully not only works
> on your system, but also on Jens'.
>
> Best,
> 	Dominik
>

you probably know more in this area than I(so please give me the right
commands(if need be), so we can get this thing fixed)

here is what pci looks like without anything on the current head:

   yenta_cardbus 0000:02:01.0: TI: probing PCI interrupt failed, trying 
to fix
  [   10.708049] yenta_cardbus 0000:02:01.0: Yenta TI: no PCI 
interrupts. Fish. Please report.
  [   10.708061] yenta_cardbus 0000:02:01.0: no PCI IRQ, CardBus support 
disabled for this socket.
  [   10.708066] yenta_cardbus 0000:02:01.0: check your BIOS CardBus, 
BIOS IRQ or ACPI settings.
  [   10.830872] yenta_cardbus 0000:02:01.0: ISA IRQ mask 0x0cf8, PCI irq 0
  [   10.830879] yenta_cardbus 0000:02:01.0: Socket status: 30000020
  [   10.830885] pci_bus 0000:02: Raising subordinate bus# of parent bus 
(#02) from #03 to #06
  [   10.830905] yenta_cardbus 0000:02:01.0: pcmcia: parent PCI bridge 
window: [io  0xd000-0xdfff]
  [   10.830911] yenta_cardbus 0000:02:01.0: pcmcia: parent PCI bridge 
window: [mem 0xdfd00000-0xdfdfffff]
  [   10.830918] pcmcia_socket pcmcia_socket0: cs: memory probe 
0xdfd00000-0xdfdfffff: excluding 0xdfd00000-0xdfd0ffff 0xdfdf0000-0xdfdfffff
  [   10.830990] yenta_cardbus 0000:02:01.0: pcmcia: parent PCI bridge 
window: [mem 0x20000000-0x23ffffff pref]
  [   10.830996] pcmcia_socket pcmcia_socket0: cs: memory probe 
0x20000000-0x23ffffff: excluding 0x20000000-0x23ffffff
  [   10.848538] pcmcia_socket pcmcia_socket0: cs: memory probe 
0x0c0000-0x0fffff: excluding 0xc0000-0xc7fff 0xcc000-0xcffff 0xf0000-0xfffff
  [   10.850120] pcmcia_socket pcmcia_socket0: cs: memory probe 
0xa0000000-0xa0ffffff: clean.
  [   10.850389] pcmcia_socket pcmcia_socket0: cs: memory probe 
0x60000000-0x60ffffff: clean.
  [   10.999905] Adding 2096124k swap on /dev/sda2.  Priority:-1 
extents:1 across:2096124k
  [   11.204044] pcmcia_socket pcmcia_socket0: cardbus cards are not 
supported.
  [   26.031710] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> 
IRQ 16
  [   26.031719] pci 0000:00:02.0: setting latency timer to 64



and with I365_CSC_ANY being used


  pcmcia_socket pcmcia_socket0: pccard: CardBus card inserted into slot 0
  [13915.161101] pci 0000:03:00.0: reg 10: [mem 0x00000000-0x0000ffff]
  [13915.161215] pci 0000:03:00.0: BAR 0: assigned [mem 
0x24000000-0x2400ffff]
  [13915.161225] pci 0000:03:00.0: BAR 0: set to [mem 
0x24000000-0x2400ffff] (PCI address [0x24000000-0x2400ffff]
  [13915.161437] ath5k 0000:03:00.0: enabling device (0000 -> 0002)
  [13915.161452] ath5k 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> 
IRQ 16
  [13915.161526] ath5k 0000:03:00.0: registered as 'phy1'
  [13916.030695] ath: EEPROM regdomain: 0x10
  [13916.030700] ath: EEPROM indicates we should expect a direct regpair map
  [13916.030705] ath: Country alpha2 being used: CO
  [13916.030708] ath: Regpair used: 0x10
  [13916.033628] phy1: Selected rate control algorithm 'minstrel'
  [13916.036604] ath5k phy1: Atheros AR2414 chip found (MAC: 0x79, PHY: 
0x45)
  [13916.036616] cfg80211: Calling CRDA for country: CO


seems the yenta_probe_irq reg is working fine
its the yenta_probe_cb_irq reg that is the only
trouble area(from what I see).


Justin P. Mattock






