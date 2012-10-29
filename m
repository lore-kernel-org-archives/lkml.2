Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab2J2RzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:55:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39102 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab2J2RzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:55:01 -0400
Message-ID: <1351533280.24721.46.camel@twins>
Subject: Re: [PATCH V2 RFC 3/3] kvm: Check system load and handle different
 commit cases accordingly
From: Peter Zijlstra <peterz@infradead.org>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Date: Mon, 29 Oct 2012 18:54:40 +0100
In-Reply-To: <20121029140717.15448.83182.sendpatchset@codeblue>
References: <20121029140621.15448.92083.sendpatchset@codeblue>
	 <20121029140717.15448.83182.sendpatchset@codeblue>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 19:37 +0530, Raghavendra K T wrote:
> +/*
> + * A load of 2048 corresponds to 1:1 overcommit
> + * undercommit threshold is half the 1:1 overcommit
> + * overcommit threshold is 1.75 times of 1:1 overcommit threshold
> + */
> +#define COMMIT_THRESHOLD (FIXED_1)
> +#define UNDERCOMMIT_THRESHOLD (COMMIT_THRESHOLD >> 1)
> +#define OVERCOMMIT_THRESHOLD ((COMMIT_THRESHOLD << 1) -
> (COMMIT_THRESHOLD >> 2))
> +
> +unsigned long kvm_system_load(void)
> +{
> +       unsigned long load;
> +
> +       load = avenrun[0] + FIXED_1/200;
> +       load = load / num_online_cpus();
> +
> +       return load;
> +} 

ARGH.. no that's wrong.. very wrong.

 1) avenrun[] EXPORT_SYMBOL says it should be removed, that's not a
joke.

 2) avenrun[] is a global load, do not ever use a global load measure

 3) avenrun[] has nothing what so ever to do with runqueue lengths,
someone with a gazillion tasks in D state will get a huge load but the
cpu is very idle.


