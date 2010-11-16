Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934204Ab0KPKPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 05:15:19 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:40474 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934183Ab0KPKPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 05:15:16 -0500
X-Auth-Info: 4Y+gNTiQV62SAbW/PIL/0mF+AkzUZw628UefvUMirD4=
Message-ID: <4CE259FB.5090402@grandegger.com>
Date: Tue, 16 Nov 2010 11:16:27 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        Barry Song <21cnbao@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew.chih.howe.khor@intel.com,
        qi.wang@intel.com, margie.foster@intel.com, yong.y.wang@intel.com,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>, kok.howg.ewe@intel.com,
        joel.clark@intel.com
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Add Flow
 control,
References: <4CE0EFA7.9020007@dsn.okisemi.com> <4CE141EA.5070702@grandegger.com> <001501cb8567$c7a38820$66f8800a@maildom.okisemi.com>
In-Reply-To: <001501cb8567$c7a38820$66f8800a@maildom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomoya,

On 11/16/2010 09:25 AM, Tomoya MORINAGA wrote:
> On Monday, November 15, 2010 11:21 PM, Wolfgang Grandegger wrote:
> 
>>
>> More comments to the lec handling below.
>>
>>> + cf->data[6] = ioread32(&priv->regs->errc) & PCH_TEC;
>>> + cf->data[7] = (ioread32(&priv->regs->errc) & PCH_REC) >> 8;
>>
>> Could be handle with just *one* register access.
> 
> I will modify.
> 
>>   if (reg_stat & PCH_BUS_OFF ||
>>     (reg_stat & PCH_LEC_ALL) != PCH_LEC_ALL) {
>>
>> Your lec handling is still not correc, 
> 
> I will modify like above.
> 
>> I believe. The driver needs to
>> write PCH_LEC_ALL to the "stat" register once in the initialization code
> This is NOT true.
> I heard even if CAN driver detects PCH_LEC_ALL, the driver doesn't have to
> write PCH_LEC_ALL to LEC.
> "PCH_LEC_ALL" means there is no error event.

OK, but...

> In case error is occurred, lec value is updated automatically.

... I doubt that it's updated automatically. At least I understand
chapter "13.4.2.2 CAN Status Register (CANSTAT)" and "Table 507. Last
Error Code (LEC) Details of Operation" differently. Please *check* the
real behavior by adding debugging code.

>> and then after each error observed (lec != PCH_LEC_ALL). I still do not
>> find such code. Could you show us the output of
>>
>>   "# candump any,0:0,#FFFFFFFF"
>>
>> when yo send CAN messages *without* a cable connected?.
> 
> 
> [root@localhost can-utils]# ./candump any,0:0,#FFFFFFFF
>   can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
>   can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
>   can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
>   can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
>   can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
>   can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
>   can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
>   can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
>   can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
>   can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
>   can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
>   can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
>   can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
>   can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
>   can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
>   can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
>   can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
>   can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
>   can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME

To inteprete the error messages, please have a look to
http://lxr.linux.no/#linux/include/linux/can/error.h

The id is "CAN_EFF_FLAG | CAN_ERR_ACK | CAN_ERR_CRTL" and data[1] is
"CAN_ERR_CRTL_TX_PASSIVE | CAN_ERR_CRTL_TX_WARNING".

Which is *not* 100% OK.

> ......It seems the same line continues forever.

Yes, it will continue until you connect the cable, that's normal
behavior. But that's not the full sequence. Could you please repeat the
test as shown below:

  First start the following command in a *separate* session.
  # candump any,0:0,#FFFFFFFF"

  Then setup and start the CAN controller:
  # ip link set can0 up type can bitrate 125000
  # cansend can0 123#deadbeef

Wolfgang.
