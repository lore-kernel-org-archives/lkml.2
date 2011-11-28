Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab1K1S0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 13:26:49 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52013 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab1K1S0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 13:26:47 -0500
Message-ID: <1322504800.2970.5.camel@edumazet-laptop>
Subject: Re: [PATCH 21/62] net: remove the second argument of
 k[un]map_atomic()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dean Nelson <dnelson@redhat.com>,
        Ian Campbell <ian.campbell@citrix.com>, Jiri Pirko <jpirko@redhat.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org
Date: Mon, 28 Nov 2011 19:26:40 +0100
In-Reply-To: <4ED3CD8B.5060000@intel.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
	  <1322371662-26166-22-git-send-email-amwang@redhat.com>
	 <1322381248.2826.1.camel@edumazet-laptop> <4ED3CD8B.5060000@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 28 novembre 2011 à 10:06 -0800, Alexander Duyck a écrit :
> On 11/27/2011 12:07 AM, Eric Dumazet wrote:
> > But why are these drivers using kmap_atomic() in first place, since
> > their fragments are allocated in regular zone (GFP_ATOMIC or
> > GFP_KERNEL) ?
> 
> I was asking the same thing myself recently when I started working on
> some copy-break like code for the ixgbe driver.  I believe the main
> reason is a lack of documentation.  This code is based loosely on the
> skb_copy_bits code which will use kmap_skb_frag over all of the paged
> portions of the sk_buff.  As such it was decided to map things via
> kmap_atomic in order to guarantee the pages had a valid virtual address.
> 
> If I understand things correctly, what you are brining up is that pages
> allocated with either GFP_ATOMIC or GFP_KERNEL will always be allocated
> from the lowmem pool and as such page_address should always succeed.  Is
> that correct?
> 

Yes.

Either you could :

A) allocate high memory pages to lower pressure on LOWMEM area on 32bit
kernels.

B) avoid using kmap_atomic() & kunmap_atomic() and be faster on 32bit
kernels.

	skb_put(skb, length);
	memcpy(skb->data, page_address(buffer_info->page), length);

 



