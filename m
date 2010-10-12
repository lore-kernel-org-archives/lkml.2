Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab0JLHlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 03:41:55 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:56464 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab0JLHly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 03:41:54 -0400
X-Auth-Info: 1nUIGYP2yq63wcYiYK/q8fFuPgjWhgVN4rehvuK72fw=
Message-ID: <4CB4117C.4070207@grandegger.com>
Date: Tue, 12 Oct 2010 09:42:52 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
CC: David Miller <davem@davemloft.net>, andrew.chih.howe.khor@intel.com,
        sameo@linux.intel.com, margie.foster@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yong.y.wang@intel.com,
        socketcan-core@lists.berlios.de, mkl@pengutronix.de,
        joel.clark@intel.com, morinaga526@dsn.okisemi.com,
        kok.howg.ewe@intel.com, chripell@fsfe.org, qi.wang@intel.com
Subject: Re: [MeeGo-Dev][PATCH v3] Topcliff: Update PCH_CAN driver to 2.6.35
References: <002e01cb6486$2ed72cc0$66f8800a@maildom.okisemi.com>	<20101005.114506.184852374.davem@davemloft.net>	<000b01cb6503$962bc7f0$66f8800a@maildom.okisemi.com>	<20101005.200904.71120150.davem@davemloft.net>	<4CAC3D94.9010408@grandegger.com> <000c01cb69dc$5d2aaab0$66f8800a@maildom.okisemi.com>
In-Reply-To: <000c01cb69dc$5d2aaab0$66f8800a@maildom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohtake,

On 10/12/2010 09:09 AM, Masayuki Ohtake wrote:
> Hi Wolfgang,
> 
> We have implemented our CAN driver with FIFO mode, and
> We are testing our CAN driver with FIFO mode.
> However, we have found Our CAN hardware spec is different from our anticipated.
> Our CAN HW FIFO is not common FIFO.
> Using  FIFO mode, there is possibility received packets are out-of-order.
> 
> e.g.
> Recv packet-A from NW and set to FIFO.
>   |A|
> 
> Recv packet-B from NW and set to FIFO.
>   |A|B|
> 
> Recv packet-C is about to set to FIFO
>   |A|B|(C)|
> 
> Userspace Copies A from Driver

OK, let's say the CPU or software starts processing the message FIFO.

> Userspace Copies B from Driver
>   |   |   |(C)|
> 
> packet-C set to FIFO (C is not head.)
> Recv packet-D from NW(Next packet is set to head)
>   |D|   |C|
> 
> Userspace Copies D from Driver

The software could continues searching the FIFO for valid messages. Then
it would find C first.

> Userspace Copies C from Driver
> Userspace raceived packet order is like below
> A-B-D-C

I'm still optimistic that it could be handled properly by software, it
might be tricky though.

> So, I think normal-mode is better than FIFO-mode.

To be clear. Out-of-order reception is not allowed!

> I will revert like the following spec.
>   Rx 1 Message Object
>   Tx 1 Message Object
> 
> Could you agree the above ?

See above. I agree if the software cannot assure in-order reception. But
it's not yet obvious to me that it cannot be achieved. I will have a
closer look to the manual. Just one RX message object without any
further buffering is really bad as message losses are likely to happen.

Wolfgang.
