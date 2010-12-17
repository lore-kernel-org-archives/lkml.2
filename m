Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab0LQGM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 01:12:59 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:37805 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab0LQGM5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 01:12:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=K3tpUHeS8/b9LqYa7re4/2/qC+FYXxV468HnP9eSzONkletcCiuUWoEFG9m6Qu3Mn2
         283PtHhNHdY4c4pXo0c9BlT5iEsecZUysGXGZZj4Oro2PnljUor6UPMeynPgvx+G/5uR
         SLhxtG+es9BMOG59JGrnFJhqa7bjblT0boljQ=
MIME-Version: 1.0
In-Reply-To: <1292474660.2603.37.camel@edumazet-laptop>
References: <cover.1292405004.git.fenghua.yu@intel.com>
	<46a08278c2ba21737528eb4b77391a7e8bc88000.1292405004.git.fenghua.yu@intel.com>
	<1292446118.2603.11.camel@edumazet-laptop>
	<20101216011425.GA17446@linux-os.sc.intel.com>
	<1292474660.2603.37.camel@edumazet-laptop>
Date: Fri, 17 Dec 2010 14:12:56 +0800
Message-ID: <AANLkTi=VAi5p85aR4U3zu4i0qB5=E=5x766MUaQS-cu7@mail.gmail.com>
Subject: Re: [PATCH 1/3] Kernel interfaces for multiqueue aware socket
From: Junchang Wang <junchangwang@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, "David S. Miller" <davem@davemloft.net>,
        "Fastabend, John R" <john.r.fastabend@intel.com>,
        "Tang, Xinan" <xinan.tang@intel.com>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 12:44 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> We really need to be smarter than that, not adding raw API.
>
> Tom Herbert added RPS, RFS, XPS, in a way applications dont have to use
> special API, just run normal code.
>
> Please understand that using 8 AF_PACKET sockets bound to a given device
> is a total waste, because the way we loop on ptype_all before entering
> AF_PACKET code, and in 12% of the cases deliver the packet into a queue,
> and 77.5% of the case reject the packet.
>
> This is absolutely not scalable to say... 64 queues.
>
> I do believe we can handle that using one AF_PACKET socket for the RX
> side, in order to not slow down the loop we have in
> __netif_receive_skb()
>
> list_for_each_entry_rcu(ptype, &ptype_all, list) {
>        ...
>        deliver_skb(skb, pt_prev, orig_dev);
> }
>
> (Same problem with dev_queue_xmit_nit() by the way, even worse since we
> skb_clone() packet _before_ entering af_packet code)
>
> And we can change af_packet to split the load to N skb queues or N ring
> buffers, N not being necessarly number of NIC queues, but the number
> needed to handle the expected load.
>
> There is nothing preventing us changing af_packet/udp/tcp_listener to
> something more scalable in itself, using a set of receive queues, and
> NUMA friendly data set. We did multiqueue for a net_device like this,
> not adding N pseudo devices as we could have done.
>
Valuable comments. Thank you very much.

We'll cook a new version and resubmit it.


-- 
--Junchang
