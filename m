Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab0KSI4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 03:56:33 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:45623 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab0KSI4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 03:56:31 -0500
X-Auth-Info: Vs42wgnJilFnqXpydemLuFGcHHBvDRH9yfnY2MuC0VQ=
Message-ID: <4CE63C05.6060101@grandegger.com>
Date: Fri, 19 Nov 2010 09:57:41 +0100
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
References: <4CE0EFA7.9020007@dsn.okisemi.com> <4CE141EA.5070702@grandegger.com> <001501cb8567$c7a38820$66f8800a@maildom.okisemi.com> <4CE259FB.5090402@grandegger.com> <00bf01cb87bc$8ed6e300$66f8800a@maildom.okisemi.com>
In-Reply-To: <00bf01cb87bc$8ed6e300$66f8800a@maildom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomoya,

On 11/19/2010 08:36 AM, Tomoya MORINAGA wrote:
> On Tuesday, November 16, 2010 7:16 PM, Wolfgang Grandegger wrote :
> 
>>> ......It seems the same line continues forever.
>>
>> Yes, it will continue until you connect the cable, that's normal
>> behavior. But that's not the full sequence. Could you please repeat the
>> test as shown below:
>>
>>   First start the following command in a *separate* session.
>>   # candump any,0:0,#FFFFFFFF"
>>
>>   Then setup and start the CAN controller:
>>   # ip link set can0 up type can bitrate 125000
>>   # cansend can0 123#deadbeef
>>
> 
> I show the result of the above command below,
> 
> [root@localhost can-utils]# candump any,0:0,#FFFFFFFF
>   can0  20000020  [8] 00 00 00 00 00 00 08 00   ERRORFRAME
>   can0  20000020  [8] 00 00 00 00 00 00 10 00   ERRORFRAME
>   can0  20000020  [8] 00 00 00 00 00 00 18 00   ERRORFRAME
>   can0  20000020  [8] 00 00 00 00 00 00 20 00   ERRORFRAME
>   can0  20000020  [8] 00 00 00 00 00 00 28 00   ERRORFRAME
>   can0  20000020  [8] 00 00 00 00 00 00 30 00   ERRORFRAME
>   can0  20000020  [8] 00 00 00 00 00 00 38 00   ERRORFRAME
>   can0  20000020  [8] 00 00 00 00 00 00 40 00   ERRORFRAME
>   can0  20000020  [8] 00 00 00 00 00 00 48 00   ERRORFRAME
>   can0  20000020  [8] 00 00 00 00 00 00 50 00   ERRORFRAME
>   can0  20000020  [8] 00 00 00 00 00 00 58 00   ERRORFRAME

The above lines describe bus errors. Therefore it should be

    can0  20000088  [8] 00 00 80 19 00 00 58 00   ERRORFRAME

>   can0  20000024  [8] 00 00 00 00 00 00 60 00   ERRORFRAME

The TX error counter has reached 96 signaling a can error state change
to "error warning".

>   can0  20000024  [8] 00 08 00 00 00 00 68 00   ERRORFRAME

CAN_ERR_CRTL in the id and CAN_ERR_CRTL_TX_WARNING in data[1], but ...

>   can0  20000024  [8] 00 08 00 00 00 00 70 00   ERRORFRAME

the state change should be signaled only *once*.

>   can0  20000024  [8] 00 08 00 00 00 00 78 00   ERRORFRAME
>   can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME

"Error passive" state is reached and CAN_ERR_CRTL_TX_PASSIVE sould be
set in data[1], but CAN_ERR_CRTL_TX_WARNING should be removed.

>   can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME
>   can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME
>   can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME

Sounds magic, well, I'm going to prepare a patch as soon as your pending
patch series is applied.

Could you please do the same testing while triggering a bus-off? After
the test, the output of "ip -d -s link" would be interesting as well.

Thanks,

Wolfgang.
