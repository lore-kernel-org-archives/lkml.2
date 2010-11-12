Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab0KLLof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 06:44:35 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:36698 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab0KLLoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 06:44:34 -0500
X-Auth-Info: iyMATTSGVdnuBx3K4KbdhPKs0wGaf9kDrHPQEX68GiI=
Message-ID: <4CDD28E6.9060006@grandegger.com>
Date: Fri, 12 Nov 2010 12:45:42 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: andrew.chih.howe.khor@intel.com,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>,
        Samuel Ortiz <sameo@linux.intel.com>, margie.foster@intel.com,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        socketcan-core@lists.berlios.de, yong.y.wang@intel.com,
        Marc Kleine-Budde <mkl@pengutronix.de>, joel.clark@intel.com,
        kok.howg.ewe@intel.com, "David S. Miller" <davem@davemloft.net>,
        Christian Pellegrin <chripell@fsfe.org>, qi.wang@intel.com
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Fix build
 warnings
References: <4CCAA3D4.8070408@dsn.okisemi.com>	<4CCAC4CD.7000503@pengutronix.de> <4CCAF517.2000409@pengutronix.de>	<4CCB213A.2020206@grandegger.com> <004a01cb825a$3a8bd060$66f8800a@maildom.okisemi.com>
In-Reply-To: <004a01cb825a$3a8bd060$66f8800a@maildom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2010 12:10 PM, Tomoya MORINAGA wrote:
> On Saturday, October 30, 2010 4:32 AM, Wolfgang Grandegger wrote :
> 
> Sorry, for my late.
> 
>>>> +
>>>> +#define PCH_RX_OK 0x00000010
>>>> +#define PCH_TX_OK 0x00000008
>>>> +#define PCH_BUS_OFF 0x00000080
>>>> +#define PCH_EWARN 0x00000040
>>>> +#define PCH_EPASSIV 0x00000020
>>>> +#define PCH_LEC0 0x00000001
>>>> +#define PCH_LEC1 0x00000002
>>>> +#define PCH_LEC2 0x00000004
>>>
>>> These are just single set bit, please use BIT()
>>> Consider adding the name of the corresponding register to the define's
>>> name.
> 
> I agree.
> 
>>>
>>>> +#define PCH_LEC_ALL (PCH_LEC0 | PCH_LEC1 | PCH_LEC2)
>>>> +#define PCH_STUF_ERR PCH_LEC0
>>>> +#define PCH_FORM_ERR PCH_LEC1
>>>> +#define PCH_ACK_ERR (PCH_LEC0 | PCH_LEC1)
>>>> +#define PCH_BIT1_ERR PCH_LEC2
>>>> +#define PCH_BIT0_ERR (PCH_LEC0 | PCH_LEC2)
>>>> +#define PCH_CRC_ERR (PCH_LEC1 | PCH_LEC2)
>>
>> This is an enumeration:
>>
>> enum {
>> PCH_STUF_ERR = 1,
>> PCH_FORM_ERR,
>> PCH_ACK_ERR,
>> PCH_BIT1_ERR;
>> PCH_BIT0_ERR,
>> PCH_CRC_ERR,
>> PCH_LEC_ALL;
>> }
> 
> No, 
> LEC is for bit assignment.
> Thus, "enum" can't be used.

Why? For me it's a classical enum because the value matters, and *not*
the individual bit. Do you agree?

>>> I suggest to convert to a if-bit-set because there might be more than
>>> one bit set.
>>
>> Marc, what do you mean here. It's an enumeraton. Maybe the following
>> code is more clear:
>>
>> lec = status & PCH_LEC_ALL;
>> if (lec > 0) {
>> switch (lec) {
> 
> No.
> LEC is not enum.

See also my sub-sequent comment here:

http://marc.info/?l=linux-netdev&m=128880088907148&w=2

>>>> + case PCH_STUF_ERR:
>>>> + cf->data[2] |= CAN_ERR_PROT_STUFF;
>>>> + break;
>>>> + case PCH_FORM_ERR:
>>>> + cf->data[2] |= CAN_ERR_PROT_FORM;
>>>> + break;
>>>> + case PCH_ACK_ERR:
>>>> + cf->data[2] |= CAN_ERR_PROT_LOC_ACK |
>>>> +        CAN_ERR_PROT_LOC_ACK_DEL;
>>
>> Could you check what that type of bus error that is? Usually it's a ack
>> lost error.
> 
> I will modify.
> BTW, I can see ti_hecc also has the above the same code.

Yes, also the AT91 driver uses a somehow incorrect error mask. I will
check and provide a patch a.s.a.p.

>>
>>>> + break;
>>>> + case PCH_BIT1_ERR:
>>>> + case PCH_BIT0_ERR:
>>>> + cf->data[2] |= CAN_ERR_PROT_BIT;
>>>> + break;
>>>> + case PCH_CRC_ERR:
>>>> + cf->data[2] |= CAN_ERR_PROT_LOC_CRC_SEQ |
>>>> +        CAN_ERR_PROT_LOC_CRC_DEL;
>>>> + break;
>>>> + default:
>>>> + iowrite32(status | PCH_LEC_ALL, &priv->regs->stat);
>>>> + break;
>>>> + }
>>>> +
>>>> + }
>>
>> Also, could you please add the TEC and REC:
>>
>> cf->data[6] = ioread32(&priv->regs->errc) & CAN_TEC;
>> cf->data[7] = (ioread32(&priv->regs->errc) & CAN_REC) >> 8;
> 
> I will add.

BTW: it could be done with one I/O call:

  errc = ioread32(&priv->regs->errc);
  cf->data[6] = errc & CAN_TEC;
  cf->data[7] = (errc & CAN_REC) >> 8;

> But I couldn't find 

Don't understand? It's also implemented for the SJA1000 driver:

http://lxr.linux.no/#linux+v2.6.36/drivers/net/can/sja1000/sja1000.c#L466

Wolfgang.
