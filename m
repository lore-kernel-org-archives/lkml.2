Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab1HCJvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 05:51:06 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:42342 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab1HCJu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 05:50:57 -0400
Subject: Re: [patch v2 04/10] kdump: Trigger kdump via panic notifier chain
 on s390
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20110802192147.GJ6399@redhat.com>
References: <20110727125504.491183728@linux.vnet.ibm.com>
	 <20110727125808.028895659@linux.vnet.ibm.com>
	 <20110801204114.GJ3805@redhat.com> <1312274279.4881.18.camel@br98xy6r>
	 <20110802192147.GJ6399@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 03 Aug 2011 11:50:39 +0200
Message-ID: <1312365039.3783.36.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

On Tue, 2011-08-02 at 15:21 -0400, Vivek Goyal wrote:
> > We have added the panic notifier in the past in order to be able to
> > configure the action that should be done in case of panic using our
> > shutdown actions infrastructure. We can configure the action using sysfs
> > and we are able to configure that a stand-alone dump should be started
> > as action for panic.
> > 
> > Now with the two stage dump approach we would like to keep the
> > possibility to trigger a stand-alone dump even if kdump is installed.
> > The stand-alone dumper will be started in case of a kernel panic and
> > then the procedure we discussed will happen: Jump into kdump and if
> > program check occurs do stand-alone dump as backup.
> 
> Frankly speaking this jumping to stand alone kernel by default is not
> making any sense to me. Once you have already determined from /sys that
> in case of crash a user has set the action to kdump, then we should
> simply call crash_kexec()

If the user has set the panic action to kdump, we jump directly to
crash_kexec(). This then works like on all other architectures.

Only if the user has specified panic action stand-alone dump, we do the
detour via the stand-alone dump tools.

> like other architectures and jump to stand
> alone kernel only if some piece of code is corrupted and that action
> failed.
> 
> What's the point of jumping to stand alone kenrel in case of panic()
> and then re-enter it back to original kernel using crash_kexec(). Sound
> like a very odd design choice to me.
> 
> I am now I am repeating this question umpteen time simply because
> I never got a good answer except "we have to do it this way".

Sometimes communication is really hard and frustrating.
... but at least we are still communicating.

Ok very last try:

* We can use the same mechanism for manual dump and automatic dump on
panic: IPL the stand-alone dump tools. kdump check and backup
stand-alone dump is implemented only in the stand-alone dump code. If we
would do it like you suggested, we would have to do it twice - in the
kernel and in the stand-alone dump tools:
- kernel: Try kdump and if kdump fails trigger standalone dump tool
- Stand-alone dump tool: Try kdump and if kdump fails do full dump

* Still the panic action is configured via sysfs as the user is already
used to on s390.

* It fits much better into our whole s390 infrastructure. Believe me, we
have discussed that here a long time. I think you do not have a full
overview here. Perhaps you just have to believe that.

Michael


