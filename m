Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab1EQMUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 08:20:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64457 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab1EQMUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 08:20:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cnaRg5SdBK0LXc7bpl/JKX+U+V6K/tPxdu3Ix8eLIcqnGLYztWfuCBVoETbsMK8CSK
         VJwFFS5PFikpubqJ6YVCyeSEaFs6DwHne2QL8ikkkeO0ueA0e63V6W4sLIgJJuVvJM46
         hmrHwjaKOq1NJcI5yU9ngGZr0ik/se9JBspos=
Subject: Re: [patch V3] percpu_counter: scalability works
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Shaohua Li <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <20110517095001.GF20624@htj.dyndns.org>
References: <1305531877.3120.230.camel@edumazet-laptop>
	 <1305534857.2375.55.camel@sli10-conroe>
	 <1305538504.2898.33.camel@edumazet-laptop>
	 <1305555736.2898.46.camel@edumazet-laptop>
	 <1305593751.2375.69.camel@sli10-conroe>
	 <1305608212.9466.45.camel@edumazet-laptop>
	 <1305609768.2375.84.camel@sli10-conroe>
	 <1305622861.2850.21.camel@edumazet-laptop>
	 <20110517091102.GE20624@htj.dyndns.org>
	 <1305625541.2850.29.camel@edumazet-laptop>
	 <20110517095001.GF20624@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 14:20:07 +0200
Message-ID: <1305634807.2850.89.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 17 mai 2011 à 11:50 +0200, Tejun Heo a écrit :

> I'm not asking to make it more accurate but the initial patches from
> Shaohua made the _sum() result to deviate by @batch even when only one
> thread is doing _inc() due to the race window between adding to the
> main counter and resetting the local one.  All I'm asking is closing
> that hole and I'll be completely happy with it.  The lglock does that
> but it's ummm.... not a very nice way to do it.
> 
> Please forget about deviations from concurrent activities.  I don't
> care and nobody should.  All I'm asking is removing that any update
> having the possibility of that unnecessary spike and I don't think
> that would be too hard.
> 

Spikes are expected and have no effect by design.

batch value is chosen so that granularity of the percpu_counter
(batch*num_online_cpus()) is the spike factor, and thats pretty
difficult when number of cpus is high.

In Shaohua workload, 'amount' for a 128Mbyte mapping is 32768, while the
batch value is 48. 48*24 = 1152.
So the percpu s32 being in [-47 .. 47] range would not change the
accuracy of the _sum() function [ if it was eventually called, but its
not ]

No drift in the counter is the only thing we care - and _read() being
not too far away from the _sum() value, in particular if the
percpu_counter is used to check a limit that happens to be low (against
granularity of the percpu_counter : batch*num_online_cpus()).

I claim extra care is not needed. This might give the false impression
to reader/user that percpu_counter object can replace a plain
atomic64_t.

For example, I feel vm_committed_as could be a plain atomic_long_t



