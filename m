Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2INUe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 16:34:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46981 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab2INUeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 16:34:25 -0400
MIME-Version: 1.0
In-Reply-To: <1347571858.5586.44.camel@oc2024037011.ibm.com>
References: <504A37B0.7020605@linux.vnet.ibm.com>
	<1347046931.7332.51.camel@oc2024037011.ibm.com>
	<20120908084345.GU30238@linux.vnet.ibm.com>
	<1347283005.10325.55.camel@oc6622382223.ibm.com>
	<1347293035.2124.22.camel@twins>
	<20120910165653.GA28033@linux.vnet.ibm.com>
	<1347297124.2124.42.camel@twins>
	<1347307972.7332.78.camel@oc2024037011.ibm.com>
	<504ED54E.6040608@linux.vnet.ibm.com>
	<1347388061.19098.20.camel@oc2024037011.ibm.com>
	<20120913114813.GA11797@linux.vnet.ibm.com>
	<1347571858.5586.44.camel@oc2024037011.ibm.com>
Date: Fri, 14 Sep 2012 16:34:24 -0400
X-Google-Sender-Auth: AFGEnNeqRKhxPViqbNvdNk6OU_A
Message-ID: <CACJDEmqP7u0R_TmgZ2O=3vDS0DG5fOZLwBJ0pnviWiTehn92OA@mail.gmail.com>
Subject: Re: [RFC][PATCH] Improving directed yield scalability for PLE handler
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: habanero@linux.vnet.ibm.com
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The concern I have is that even though we have gone through changes to
> help reduce the candidate vcpus we yield to, we still have a very poor
> idea of which vcpu really needs to run.  The result is high cpu usage in
> the get_pid_task and still some contention in the double runqueue lock.
> To make this scalable, we either need to significantly reduce the
> occurrence of the lock-holder preemption, or do a much better job of
> knowing which vcpu needs to run (and not unnecessarily yielding to vcpus
> which do not need to run).

The patches that Raghavendra  has been posting do accomplish that.
>
> On reducing the occurrence:  The worst case for lock-holder preemption
> is having vcpus of same VM on the same runqueue.  This guarantees the
> situation of 1 vcpu running while another [of the same VM] is not.  To
> prove the point, I ran the same test, but with vcpus restricted to a
> range of host cpus, such that any single VM's vcpus can never be on the
> same runqueue.  In this case, all 10 VMs' vcpu-0's are on host cpus 0-4,
> vcpu-1's are on host cpus 5-9, and so on.  Here is the result:
>
> kvm_cpu_spin, and all
> yield_to changes, plus
> restricted vcpu placement:  8823 +/- 3.20%   much, much better
>
> On picking a better vcpu to yield to:  I really hesitate to rely on
> paravirt hint [telling us which vcpu is holding a lock], but I am not
> sure how else to reduce the candidate vcpus to yield to.  I suspect we
> are yielding to way more vcpus than are prempted lock-holders, and that
> IMO is just work accomplishing nothing.  Trying to think of way to
> further reduce candidate vcpus....

... the patches are posted -  you could try them out?
