Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab0GKICU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 04:02:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49481 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab0GKICR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 04:02:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FIDnmBuEUHtSFBJEofQSXrhHRAsuso2yxoRxUsN5tek3RtYIornkWLoReLkkTVT8fR
         1e7Jj4T+cV/1rzIG5EFDPfgxZSfDkuE5mXYZ5eOPrJluVtsTc0FDCWy1HjS6Itnpwa28
         2gr7CWsZpBmS5W1V9Nl+L6+Cj8r24MmoQsNjo=
Subject: Re: [PATCH] tproxy: nf_tproxy_assign_sock() can handle tw sockets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Felipe W Damasio <felipewd@gmail.com>, David Miller <davem@davemloft.net>,
       Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
       netdev <netdev@vger.kernel.org>
In-Reply-To: <4C395459.6080407@redhat.com>
References: <AANLkTimn8A0cYZmwNZYitRkBHKKFe4HQ5GU626DLugkk@mail.gmail.com>
	 <AANLkTil49m6Ul2bauiH4Pwn-6ykrYTFmSO6_SxqQgD_e@mail.gmail.com>
	 <1278626921.2435.73.camel@edumazet-laptop>
	 <AANLkTiliBClahTfb41M5BDi1etg5pgkqEz_VfGrn_mK4@mail.gmail.com>
	 <1278695580.2696.55.camel@edumazet-laptop>
	 <AANLkTil39xHOhcdAo4h_jWtx_UuYdFHGdQVAdwPMd7QJ@mail.gmail.com>
	 <1278742649.2538.17.camel@edumazet-laptop>  <4C395459.6080407@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Jul 2010 10:02:12 +0200
Message-ID: <1278835332.2538.51.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 11 juillet 2010 à 08:19 +0300, Avi Kivity a écrit :
> On 07/10/2010 09:17 AM, Eric Dumazet wrote:
> >
> > Strange thing with your crash report is CR2 value, with unexpected value
> > of 000000000b388000 while RAX value is dce8dce85d415d41
> >
> > Faulting instruction is :
> >
> > 48 83 b8 b0 00 00 00 00   cmpq   $0x0,0xb0(%rax)
> >
> > So I would have expected CR2 being RAX+0xb0, but its not.
> >    
> 
> Nothing strange about it.  You only get page faults and valid cr2 for 
> canonical addresses (17 high order bits all equal).  In this case 
> rax+0xb0 is not a canonical address, so you got a general protection 
> fault instead, with cr2 unchanged.
> 

OK, thanks Avi for this information, as I was not aware of this.

So something overwrote sk->sk_prot pointer (or skb->sk pointer) with
some data.

tcp sockets are allocated from a dedicated kmem_cache (because of
SLAB_DESTROY_RCU attribute). Their sk->sk_prot should never change in
normal operation, since underlying memory cannot be reused by another
object type in kernel. It should be NULL or &tcp_prot

Felipe, please describe your configuration as much as possible.
It might be a driver bug with with special kind of network frames.

lsmod
lspci -v
ethtool -k eth0
ethtool -k eth1 (if applicable)



