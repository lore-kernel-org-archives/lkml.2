Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab1HDVPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 17:15:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039Ab1HDVPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 17:15:02 -0400
Date: Thu, 4 Aug 2011 17:14:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [patch v2 04/10] kdump: Trigger kdump via panic notifier chain
 on s390
Message-ID: <20110804211432.GE429@redhat.com>
References: <20110727125504.491183728@linux.vnet.ibm.com>
 <20110727125808.028895659@linux.vnet.ibm.com>
 <20110801204114.GJ3805@redhat.com>
 <1312274279.4881.18.camel@br98xy6r>
 <20110802192147.GJ6399@redhat.com>
 <1312365039.3783.36.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312365039.3783.36.camel@br98xy6r>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 11:50:39AM +0200, Michael Holzheu wrote:
> Hello Vivek,
> 
> On Tue, 2011-08-02 at 15:21 -0400, Vivek Goyal wrote:
> > > We have added the panic notifier in the past in order to be able to
> > > configure the action that should be done in case of panic using our
> > > shutdown actions infrastructure. We can configure the action using sysfs
> > > and we are able to configure that a stand-alone dump should be started
> > > as action for panic.
> > > 
> > > Now with the two stage dump approach we would like to keep the
> > > possibility to trigger a stand-alone dump even if kdump is installed.
> > > The stand-alone dumper will be started in case of a kernel panic and
> > > then the procedure we discussed will happen: Jump into kdump and if
> > > program check occurs do stand-alone dump as backup.
> > 
> > Frankly speaking this jumping to stand alone kernel by default is not
> > making any sense to me. Once you have already determined from /sys that
> > in case of crash a user has set the action to kdump, then we should
> > simply call crash_kexec()
> 
> If the user has set the panic action to kdump, we jump directly to
> crash_kexec(). This then works like on all other architectures.

Ok, that's good to know that you will define panic action as kdump also
and in that case we will not jump to dump tools and directly call
crash_kexec()

> 
> Only if the user has specified panic action stand-alone dump, we do the
> detour via the stand-alone dump tools.

If a user decides to load kdump kernel to capture dump, then why does it
still make sense to set panic action as "stand-alone dump tools". One
could argue that user loaded kdump kernel but not necessarily wants
that mechanism to use, in that case dump-tools does not have to jump
to kdump kernel at all. 

> 
> > like other architectures and jump to stand
> > alone kernel only if some piece of code is corrupted and that action
> > failed.
> > 
> > What's the point of jumping to stand alone kenrel in case of panic()
> > and then re-enter it back to original kernel using crash_kexec(). Sound
> > like a very odd design choice to me.
> > 
> > I am now I am repeating this question umpteen time simply because
> > I never got a good answer except "we have to do it this way".
> 
> Sometimes communication is really hard and frustrating.
> ... but at least we are still communicating.
> 
> Ok very last try:
> 
> * We can use the same mechanism for manual dump and automatic dump on
> panic: IPL the stand-alone dump tools.

So manual dump/intervention is only required if automatic dump failed?

> kdump check and backup
> stand-alone dump is implemented only in the stand-alone dump code.

My argument is that why stand alone dump is trying to trigger kdump
at all? Shouldn't it all be part of loading kdump kernel and user
setting panic() action to kdump?

The only valid argument to try to load kdump kernel from dump tools is
the hard hang situation where we never made to panic(). Then either
that hypervisor timer or manual intervention will come into picture
and one might argue that we still will kdump a try.

Fox x86 it is relatively easy as NMI detects hard hang in the context
of first kernel and can easily call crash_kexec() without any additional
information passing.

So if it is about hard hang, i can still understand the need to jump
to crash_kexec() from dump tools. I don't know if it is possible to 
invoke crash_kexec() directly from hypervisor timer without ipling
dump tools or not.

> If we
> would do it like you suggested, we would have to do it twice - in the
> kernel and in the stand-alone dump tools:
> - kernel: Try kdump and if kdump fails trigger standalone dump tool
> - Stand-alone dump tool: Try kdump and if kdump fails do full dump

Are we not already doing above two steps? You just mentioned that 
if user specified "kdump" as panic() action, then you will call
crash_kexec() directly. Will we not jump to dump tools if kdump
fails?

Also if user specified "dump-tools" as action, then your way of things
anyway will try to execute kdump (if kernel is loaded) and if that fails
then we come back to dump tools.

So I think in current scheme of things, you already have both implemented.
> 
> * Still the panic action is configured via sysfs as the user is already
> used to on s390.

I asked the question above why it makes sense to configure panic action
as dump tools if kdump kernel is loaded.

> 
> * It fits much better into our whole s390 infrastructure. Believe me, we
> have discussed that here a long time. I think you do not have a full
> overview here. Perhaps you just have to believe that.

That's what I am talking about. So many times the answer has been "We have
to do it this way".

Sure I do not have full overview here but little explanation sometimes
help in understanding things.

Thanks
Vivek
