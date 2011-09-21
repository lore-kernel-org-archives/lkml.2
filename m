Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463Ab1IUO2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 10:28:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab1IUO2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 10:28:36 -0400
Message-ID: <4E79F477.2050102@redhat.com>
Date: Wed, 21 Sep 2011 17:28:07 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: percpu crash on NetBurst
References: <4E3EB013.5000001@redhat.com> <20110808095517.GH23937@htj.dyndns.org>
In-Reply-To: <20110808095517.GH23937@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2011 12:55 PM, Tejun Heo wrote:
> Hello, Avi.
>
> On Sun, Aug 07, 2011 at 06:32:35PM +0300, Avi Kivity wrote:
> >  qemu, under some conditions (-cpu host or -cpu kvm64), erroneously
> >  passes family=15 as the virtual cpuid.  This causes a BUG() in
> >  percpu code during late boot:
> >
> >  ------------[ cut here ]------------
> >  kernel BUG at mm/percpu.c:577!
>

<snip>

> >  All this applies to v3.0; current upstream (c2f340a69ca) fails even
> >  worse, haven't yet determined exactly why.
> >
> >  I'm surprised this hasn't been reported before; Ingo, don't you have
> >  family=15 hosts in your test farm?
>
> Hmmm... I can't trigger the problem w/ kvm64 (I tried mounting and
> unmounting filesystems but it worked okay) and am quite skeptical this
> is a wide spread problem given that the percpu core code is used very
> widely and hasn't seen a lot of changes lately.  Is there anything
> specific you need to do to trigger the condition?  Can you try to
> print out the s_files addresses being allocated and freed?
>

Coming back to this, the trigger if cpuid family=6 and model>=13 (model 
12 works).  Looks like the code disables rep_good is some MSR doesn't 
have the expected value.  While we should configure the MSR correctly, 
it looks like the fallback code for !rep_good is broken.  Will look further.

-- 
error compiling committee.c: too many arguments to function

