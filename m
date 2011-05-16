Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab1EPJfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 05:35:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45118 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab1EPJfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 05:35:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VwrF9nlF9a6m7rcReWk3ohQaEMMl+4gINAdLc0p0VWtsjHZN3YHtSOL5MqmCXsiZ08
         K1hKnuzEFkpvOF48hMX18bO5N9eFVzRtdobHmO/nlSz4A/wn6fEUi/Jf6Freez7zcW0L
         l20TYpWOjvz0OX0TI3s+bidFv+cdWAaNVsfoQ=
Subject: Re: [patch V3] percpu_counter: scalability works
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <1305534857.2375.55.camel@sli10-conroe>
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
	 <20110511092848.GE1661@htj.dyndns.org>
	 <1305168493.2373.15.camel@sli10-conroe>
	 <20110512082159.GB1030@htj.dyndns.org>
	 <1305190520.2373.18.camel@sli10-conroe>
	 <20110512085922.GD1030@htj.dyndns.org>
	 <1305190936.3795.1.camel@edumazet-laptop>
	 <20110512090534.GE1030@htj.dyndns.org>
	 <1305261477.2373.45.camel@sli10-conroe>
	 <1305264007.2831.14.camel@edumazet-laptop>
	 <20110513052859.GA11088@sli10-conroe.sh.intel.com>
	 <1305268456.2831.38.camel@edumazet-laptop>
	 <1305298300.3866.22.camel@edumazet-laptop>
	 <1305301151.3866.39.camel@edumazet-laptop>
	 <1305304532.3866.54.camel@edumazet-laptop>
	 <1305305190.3866.57.camel@edumazet-laptop>
	 <1305324187.3120.30.camel@edumazet-laptop>
	 <1305507517.2375.10.camel@sli10-conroe>
	 <1305526296.3120.204.camel@edumazet-laptop>
	 <1305527828.2375.28.camel@sli10-conroe>
	 <1305528912.3120.213.camel@edumazet-laptop>
	 <1305530143.2375.42.camel@sli10-conroe>
	 <1305531877.3120.230.camel@edumazet-laptop>
	 <1305534857.2375.55.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 11:35:03 +0200
Message-ID: <1305538504.2898.33.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 16 mai 2011 à 16:34 +0800, Shaohua Li a écrit :

> let's not argue the batch size anymore. If we can make percpu_counter
> faster, why we don't (even your patch mentioned this).
> 

I actually changed my mind, after trying to solve the problem and spend
a few hours on it. This is not worth it and counterproductive.

Whole point of percpu_counter is being able to avoid the false sharing
in _most_ cases. I would even make the false sharing case even more
expensive just to pinpoint a bad user, thanks to profiling.

Trying to make it fast in pathological case is throwing a brown paper
bag.

An interesting move would be to make percpu_counter hierarchical,
because we might need it for 4096 cpus machines.

Given that vm_committed has one percent resolution need
(sysctl_overcommit_ratio is expressed with percent resolution), it
should be used with an appropriate batch value, something like :

vm_committed_as_batch = max(percpu_counter_batch,
			    total_ram_pages/(num_possible_cpus()*100));

Instead of the default percpu_counter_batch, more aimed for 
_add(1)/_add(-1) uses.

Note : This wont solve your mmap(128M)/munmap() problem, unless your
machine has a _lot_ of memory. Still, this will be a win on many real
workloads.



