Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab0JaVEt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 17:04:49 -0400
Received: from claw.goop.org ([74.207.240.146]:55866 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253Ab0JaVEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 17:04:47 -0400
Message-ID: <4CCD9935.50308@goop.org>
Date: Sun, 31 Oct 2010 09:28:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vasiliy G Tolstov <v.tolstov@selfip.ru>
Subject: Re: [GIT PULL] Small Xen bugfixes
References: <4CCB1906.4000608@goop.org>	 <AANLkTi=g5sdiWSaLUHAATQn-1=jPqtc=RL6SpYSMYn98@mail.gmail.com>	 <4CCB1E71.3060600@goop.org>  <4CCB292E.9090602@goop.org> <1288516429.16032.13.camel@localhost.localdomain>
In-Reply-To: <1288516429.16032.13.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/31/2010 02:13 AM, Ian Campbell wrote:
>> The 3rd is certainly simplest, at the cost of wasting a trivial amount
>> of memory.
> Doesn't Linux avoid using the lowest 1M anyway? (obviously apart from
> the start of day probing for firmware tables etc).

No, it tries to use most of it I think.  It will tend to avoid the low
64k (maybe more) to avoid BIOS bugs.

>>   Unfortunately it crashes early.  Sigh, will try and sort it
>> out this afternoon.
> Strange!

I didn't get a chance to poke at it again, but in retrospect, I think
there are various "must succeed" allocations in low memory.  We don't
need those allocations (things like AP boot trampoline, etc), but we
don't bother to stub them out or prevent them from happening.  Reducing
the system to one with *no* allocatable memory below 1M is just too
strange, and would be a continuous source of problems in the future.

Of the other two options, I think your original approach is going to be
simplest.  E820 gap filling wouldn't be too bad, but we'd end up having
to add a bit of gap-tracking logic to the E820 loop which isn't
currently there.  Ignoring sub-1M gaps is simpler (and it needn't be
conditional on xen_initial_domain(), because we would never expect to
see anything strange sub-1M in a domU, and if there is, we should still
be careful of it in case something odd is going on).

    J
