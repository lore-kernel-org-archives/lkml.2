Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab0KCHbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 03:31:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44314 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab0KCHbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 03:31:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=u+Wik2Y/c2Jlg8kH6y2uDAZ6sPShxOieOpcwcMxwATdf+3H2AmrwXrqdHAphtepp6/
         kLT2buiovOiygal9j3VNCtwM4KqjWvbIiTdb9Cm5obKk7gv0fmMKLcFrNofuvl9yanEb
         BSjRnF5j6gjS+FVu1zXzpQwmdswqPOushw+vs=
Subject: Re: [RFC 4/4]x86: avoid tlbstate lock if no enough cpus
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, "hpa@zytor.com" <hpa@zytor.com>
In-Reply-To: <1288769123.2467.681.camel@edumazet-laptop>
References: <1288766668.23014.117.camel@sli10-conroe>
	 <1288767580.2467.636.camel@edumazet-laptop>
	 <1288767995.23014.120.camel@sli10-conroe>
	 <1288768330.2467.660.camel@edumazet-laptop>
	 <1288768795.23014.123.camel@sli10-conroe>
	 <1288769123.2467.681.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 08:31:26 +0100
Message-ID: <1288769486.2467.690.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 03 novembre 2010 à 08:25 +0100, Eric Dumazet a écrit :
> Le mercredi 03 novembre 2010 à 15:19 +0800, Shaohua Li a écrit :
> > On Wed, 2010-11-03 at 15:12 +0800, Eric Dumazet wrote:
> > > Le mercredi 03 novembre 2010 à 15:06 +0800, Shaohua Li a écrit :
> > > > just don't want to include the non-present cpus here. I wonder why we
> > > > haven't a variable to record online cpu number.
> > > 
> > > What prevents a 256 cpus machine, to have 8 online cpus that all use the
> > > same TLB vector ?
> > > 
> > > (Max 32 vectors, so 8 cpus share each vector, settled at boot time)
> > > 
> > > Forget about 'online', and think 'possible' ;)
> > Hmm, the spread vectors to node already merged, how could the 8 cpus
> > share a vector?
> > 
> 
> You boot a machine with 256 cpu.
> 
> They are online and very well.
> 
> Each vector is shared by at least 8 cpus, because 256/32 = 8. OK ?
> 
> Now you off-line 256-8 cpus, because you have HOTPLUG capability in your
> kernel and you have some policy to bring them up later if needed.
> 
> What happens ? Do you rebalance TLB vectors to make sure each cpu has
> its own vector ?
> 
> 

It seems you do that since commit 932967202182743 in
calculate_tlb_offset()

So just add in this function some logic to tell if each tlb vector is
used by one or several cpu.

We can avoid the lock for each TLB vector used by exactly one cpu.



