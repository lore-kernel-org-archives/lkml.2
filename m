Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab0KCQOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 12:14:41 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:51727 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab0KCQOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 12:14:38 -0400
X-Auth-Info: S5e7wL7RpD3dlL99brAU9S+V6wEXWBOp2GBRSf3Exkc=
Message-ID: <4CD18AAE.9040300@grandegger.com>
Date: Wed, 03 Nov 2010 17:15:42 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: andrew.chih.howe.khor@intel.com,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>,
        Samuel Ortiz <sameo@linux.intel.com>, margie.foster@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        socketcan-core@lists.berlios.de, yong.y.wang@intel.com,
        kok.howg.ewe@intel.com, joel.clark@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Christian Pellegrin <chripell@fsfe.org>, qi.wang@intel.com
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Fix build
 warnings
References: <4CCAA3D4.8070408@dsn.okisemi.com>	<4CCAC4CD.7000503@pengutronix.de> <4CCAF517.2000409@pengutronix.de>	<4CCB213A.2020206@grandegger.com> <4CCE9F0B.1000901@pengutronix.de>
In-Reply-To: <4CCE9F0B.1000901@pengutronix.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2010 12:05 PM, Marc Kleine-Budde wrote:
> Hello,
> 
> On 10/29/2010 09:32 PM, Wolfgang Grandegger wrote:
> 
> some comments inline.
> 
> [...]
...
>>>> +	if (status & PCH_LEC_ALL) {
>>>> +		priv->can.can_stats.bus_error++;
>>>> +		stats->rx_errors++;
>>>> +		switch (status & PCH_LEC_ALL) {
>>>
>>> I suggest to convert to a if-bit-set because there might be more than
>>> one bit set.
>>
>> Marc, what do you mean here. It's an enumeraton. Maybe the following
>> code is more clear:
> 
> Oh, I haven't looked this one up in the datasheet.
>>
>> 	lec = status & PCH_LEC_ALL;
>> 	if (lec > 0) {
> 
> or "if (lec)", YMMV
> 
>> 		switch (lec) {
>>
>>>> +		case PCH_STUF_ERR:
>>>> +			cf->data[2] |= CAN_ERR_PROT_STUFF;
>>>> +			break;
>>>> +		case PCH_FORM_ERR:
>>>> +			cf->data[2] |= CAN_ERR_PROT_FORM;
>>>> +			break;
>>>> +		case PCH_ACK_ERR:
>>>> +			cf->data[2] |= CAN_ERR_PROT_LOC_ACK |
>>>> +				       CAN_ERR_PROT_LOC_ACK_DEL;
>>
>> Could you check what that type of bus error that is? Usually it's a ack
>> lost error.
>>
>>>> +			break;
>>>> +		case PCH_BIT1_ERR:
>>>> +		case PCH_BIT0_ERR:
>>>> +			cf->data[2] |= CAN_ERR_PROT_BIT;
>>>> +			break;
>>>> +		case PCH_CRC_ERR:
>>>> +			cf->data[2] |= CAN_ERR_PROT_LOC_CRC_SEQ |
>>>> +				       CAN_ERR_PROT_LOC_CRC_DEL;
>>>> +			break;
>>>> +		default:
>>>> +			iowrite32(status | PCH_LEC_ALL, &priv->regs->stat);
>>>> +			break;
>>>> +		}
>>>> +
>>>> +	}

At a closer look, I doubt that the above LEC handling is correct.
According to the manual: "when the LEC shows the value “7,” this value
was written to the LEC by the CPU; thus, no CAN bus event was detected"
Therefore the LEC bits should be properly *initialized* and *reset* to
0x7, which I do not find in the code.

Wolfgang.

