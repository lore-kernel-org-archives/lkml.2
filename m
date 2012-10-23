Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014Ab2JWNuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:50:54 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59574 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032Ab2JWNuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:50:50 -0400
Subject: Re: [Pv-drivers] 3.7-rc2 regression : file copied to CIFS-mounted
 directory corrupted
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shreyas Bhatewara <sbhatewara@vmware.com>
Cc: "VMware, Inc." <pv-drivers@vmware.com>, netdev@vger.kernel.org,
        edumazet@google.com, linux-kernel@vger.kernel.org,
        jongman heo <jongman.heo@samsung.com>
In-Reply-To: <1103939870.6550404.1350986530909.JavaMail.root@vmware.com>
References: <1103939870.6550404.1350986530909.JavaMail.root@vmware.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Oct 2012 15:50:46 +0200
Message-ID: <1351000246.8609.1926.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 03:02 -0700, Shreyas Bhatewara wrote:

Please dont top post on netdev or lkml

> Well, actually the driver does split large frags into frags of VMXNET3_MAX_TX_BUF_SIZE bytes each.
> 
> vmxnet3_drv.c
>  711         while (len) {
>  712                 u32 buf_size;
>  713
>  714                 if (len < VMXNET3_MAX_TX_BUF_SIZE) {
>  715                         buf_size = len;
>  716                         dw2 |= len;
>  717                 } else {
>  718                         buf_size = VMXNET3_MAX_TX_BUF_SIZE;
>  719                         /* spec says that for TxDesc.len, 0 == 2^14 */
>  720                 }
>  721
> ....
>  743
>  744                 len -= buf_size;
>  745                 buf_offset += buf_size;
>  746         }

Only the skb head is handled in the code you copy/pasted.

You need to generalize that to code in lines ~754


Then, the number of estimated descriptors is bad :

/* conservatively estimate # of descriptors to use */
count = VMXNET3_TXD_NEEDED(skb_headlen(skb)) +
	skb_shinfo(skb)->nr_frags + 1;


Yes, you need a more precise estimation and vmxnet3_map_pkt() should
eventually split too big frags.



