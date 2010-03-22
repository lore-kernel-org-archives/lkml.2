Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab0CVRnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 13:43:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42143 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab0CVRnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 13:43:11 -0400
To: Christoph Lameter <cl@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Add PGM protocol support to the IP stack
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.DEB.2.00.1003181245050.23010@router.home>
	<87tysccjrn.fsf@basil.nowhere.org>
	<alpine.DEB.2.00.1003220916170.15360@router.home>
	<20100322163609.GZ20695@one.firstfloor.org>
	<alpine.DEB.2.00.1003221146260.17230@router.home>
Date: Mon, 22 Mar 2010 18:43:06 +0100
In-Reply-To: <alpine.DEB.2.00.1003221146260.17230@router.home> (Christoph Lameter's message of "Mon, 22 Mar 2010 11:51:08 -0500 (CDT)")
Message-ID: <877hp4i76d.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <cl@linux-foundation.org> writes:

> On Mon, 22 Mar 2010, Andi Kleen wrote:
>
>> Multicast reliable kernel protocols are somewhat new, I guess one
>> would need to make sure to come up with a clean generic interface
>> for them first.
>
> It has been around for a long time in another OS. I wonder if I should use
> the socket API realized there as a model or come up with something new
> from scratch?

If the other API doesn't have a serious flaw I guess it's better
to aim for a sub/superset at least, to make porting applications easier.

>
> What I have right now is:
>
> 1. Opening a socket

>
>         A. Native PGM
>
>                 fd = socket(AF_INET, SOCK_RDM, IPPROTO_PGM)

RDM = Reliable ? Multicast ? 

>         B. PGM over UDP
>
>                 fd = socket(AF_INET, SOCK_RDM, IPPROTO_UDP)
>
>         C. PGM over SHM (?)
>
>                 fd = socket(AF_UNIX, SOCK_RDM, 0)

Not sure how that should work.

> 3. Sending and receiving
>
>         Use the usual socket read and write operations and the various flavors of waiting
>         for a packet via select, poll, epoll etc.
>
>         Packet sizes are determined by the number of  packets in a single sendmsg() unless

Number of bytes surely?

>         overridden by the RM_SET_MESSAGE_BOUNDARY socket option.

That's unusual to have such a option (except the MTU). What is it good for?

>
> 4.      Transmitter Socket Options
>
>
>         A. Setting the window size / rate.
>
>                 struct pgm_send_window x;
>                 x.RateKbitsPerSec = 56;
>                 x.WindowSizeInMsecs = 60000;
>                 x.WindowSizeinBytes = 10000000;
>
>                 setsockopt(fd, SOCK_RDM, RM_RATE_WINDOW_SIZE, &x, sizeof(x));
>
>                 Default is sending at 56Kbps with a buffer of 10 Megabytes and buffering for a minute.

That's a very large buffer for a socket. It would be better to use the usual
auto shrinking/increasing mechanisms.

>         B. FEC mode
>
>                 struct pgm_fec_info x;
>
>                 x.FECBlocksize = 255;
>                 x.FECProActivePackets = 0;
>                 x.FECGroupSize = 0;
>                 x.fFECOnDemandParityEnabled = 1;
>
>                 setsockopt(fd, SOCK_RDM, RM_FEC_MODE, &x, sizeof(x));

Is that mode really needed?

> /* Socket API structures (established by M$DN) */
> struct pgm_receiver_stats {
>         u64     NumODataPacketsReceived;        /* Number of ODATA (original) sequences */

It's difficult to maintain 64 bit counters on 32bit hosts on all targets.
But I guess it would be ok to only fill in 32bit in this case.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
