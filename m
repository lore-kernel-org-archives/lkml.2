Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab1EPOWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:22:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43134 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab1EPOWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:22:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tDibIJ052MOP+NUDTPHbnfRDGz+wGBjDBnO5xzsiS7+Exzt3Qca5wiXhYQ0fjTuAyB
         rqJLSV08VRlfAx3m3VVSFo1S+N2ewqclfHZRSbuvPfcAFnMXBVJUQAwsfq0NtdKhuOn0
         Fqnls9wmSDYpxHbEoW+x8+pfdi+47CmEdQ41U=
Subject: Re: [patch V3] percpu_counter: scalability works
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <1305538504.2898.33.camel@edumazet-laptop>
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
	 <1305538504.2898.33.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 16:22:16 +0200
Message-ID: <1305555736.2898.46.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 16 mai 2011 à 11:35 +0200, Eric Dumazet a écrit :

> Given that vm_committed has one percent resolution need
> (sysctl_overcommit_ratio is expressed with percent resolution), it
> should be used with an appropriate batch value, something like :
> 
> vm_committed_as_batch = max(percpu_counter_batch,
> 			    total_ram_pages/(num_possible_cpus()*100));
> 


Funny thing with vm_committed_as is we dont even read its value with
default vm configuration 

(sysctl_overcommit_memory == OVERCOMMIT_ALWAYS or OVERCOMMIT_GUESS)

[ In this case, we read it only for /proc/meminfo output ]

Ideally, we could dynamically change vm_committed_as_batch when
sysctl_overcommit_memory or other param is changed. This would need a
mechanism to ask all cpus to transfert/clear their local s32 into global
fbc->count [when lowering vm_committed_as_batch]

Another idea would be to use an atomic when manipulating the percpu s32,
so that __percpu_counter_sum() is able to make this operation itself :
At the end of __percpu_counter_sum(), fbc->count would be the final
result, and all s32 would be zero, unless some cpus called _add()
meanwhile.



