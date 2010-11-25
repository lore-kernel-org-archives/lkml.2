Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab0KYMDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 07:03:49 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:34230 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752305Ab0KYMDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 07:03:48 -0500
Message-ID: <001b01cb8c98$d06aaa00$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Marc Kleine-Budde" <mkl@pengutronix.de>
Cc: <andrew.chih.howe.khor@intel.com>, <socketcan-core@lists.berlios.de>,
        "Samuel Ortiz" <sameo@linux.intel.com>, <margie.foster@intel.com>,
        <netdev@vger.kernel.org>, "Christian Pellegrin" <chripell@fsfe.org>,
        <linux-kernel@vger.kernel.org>, <yong.y.wang@intel.com>,
        <kok.howg.ewe@intel.com>, <joel.clark@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Wolfgang Grandegger" <wg@grandegger.com>, <qi.wang@intel.com>
References: <4CE2434B.5050701@dsn.okisemi.com>	<4CE27796.2000206@pengutronix.de>	<007401cb87b1$a773b3d0$66f8800a@maildom.okisemi.com>	<4CE64167.2030405@pengutronix.de> <003201cb8a02$f05b15e0$66f8800a@maildom.okisemi.com> <4CEA2986.4080607@pengutronix.de> <000b01cb8b6b$d7542a90$66f8800a@maildom.okisemi.com> <4CED0650.7030004@pengutronix.de>
Subject: Re: [PATCH net-next-2.6 v3] can: Topcliff: PCH_CAN driver: Add Flow control,
Date: Thu, 25 Nov 2010 21:03:45 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 24, 2010 9:34 PM, Marc Kleine-Budde wrote :
>On 11/24/2010 01:09 AM, Tomoya MORINAGA wrote:
>> On Monday, November 22, 2010 5:27 PM, Marc Kleine-Budde wrote:
>>>>>>> Still we have the busy waiting in the TX path. Maybe you can move the
>>>>>>> waiting before accessing the if[1] and remove the busy waiting here.
>>>>>> I can't understand your saying.
>>>>>> For transmitting data, calling pch_can_rw_msg_obj is mandatory.
>>>>> Yes, but the busy wait is not needed. It should be enough to do the
>>>>> busy-waiting _before_ accessing the if[1].
>>>>
>>>> Do you mean we should create other pch_can_rw_msg_obj which doesn't have busy wait ?
>>> ACK, and this non busy waiting is use in the TX path. But you add a busy
>>> wait only function before accessing the if[1] in the TX path.
>> 
>> The "busy waiting" of pch_can_rw_msg_obj is for next processing accesses to Message object.
>> If deleting this busy waiting, next processing can access to Message object, regardless previous transfer doesn't
>> complete yet.
>> Thus, I think, the "busy waiting" is necessary.
>
>Yes, it's necessary, but not where it is done currently.
>Let me outline how I think the TX path should look like:
>
>pch_xmit() {
> take_care_about_flow_control();
> prepare_can_frame_to_be_copied_to_tx_if();
>
> /* most likely we don't have to wait here */
> wait_until_tx_if_is_ready();
>
> copy_can_frame_to_tx_if();
>
> /* trigger tx in hardware */
> send_tx_if_but_dont_do_busywait();
>
> /* tx_if is busy now, but before we access it, we'll check tx_if is ready */
>}

This Tx path also has Read-Modify-Write for MessageRAM access.
Do you mean Tx path shouldn't have Read-Modify-Write ?


---
Thanks,

Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.
