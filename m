Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934103Ab0EDXlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 19:41:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43929 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755669Ab0EDXlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 19:41:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Date: Wed, 5 May 2010 01:42:41 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Brian Swetland <swetland@google.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
References: <1272667021-21312-1-git-send-email-arve@android.com> <201005042237.56844.rjw@sisk.pl> <87wrvjdztr.fsf@deeprootsystems.com>
In-Reply-To: <87wrvjdztr.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005050142.41537.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 May 2010, Kevin Hilman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Tuesday 04 May 2010, Mark Brown wrote:
> >> On Tue, May 04, 2010 at 11:06:39AM -0700, Kevin Hilman wrote:
> >> 
> >> > With opportunistic suspend, all of this flexibility is gone, and the
> >> > device/subsystem is told to go into the lowest power, highest latency
> >> > state, period.
> >> 
> >> Well, half the problem I have is that unfortunately it's not a case of
> >> doing that period.  The prime example I'm familiar with is that for
> >> understandable reasons users become irate when you power down the audio
> >> CODEC while they're in the middle of a call so if opportunistic PM is in
> >> use then the audio subsystem needs some additional help interpreting a
> >> suspend request so that it can figure out how to handle it.  Similar
> >> issues apply to PMICs, though less pressingly for various reasons.
> >> 
> >> Just to be clear, I do understand and mostly agree with the idea that
> >> opportunistic suspend presents a reasonable workaround for our current
> >> inability to deliver good power savings with runtime PM methods on many
> >> important platforms but I do think that if we're going to make this
> >> standard Linux PM functionality then we need to be clearer about how
> >> everything is intended to hang together.
> >
> > At the moment the rule of thumb is: if you don't need the opportunistic
> > suspend, don't use it.  It is not going to be enabled by default on anything
> > other than Android right now.
> 
> Sure, but there are driver authors and subsystem maintainers who care
> about optimal PM in "normal" Linux *and* in Android.
> 
> As a PM maintainer for an embedded platform (OMAP) used in both, I
> certainly care about both, so "disable it if you don't like it" is not
> really an option.
> 
> IMO, driver/subsystem authors should not have to care if the userspace
> is Android or not.  We should be working towards a world where Android
> is not a special case.

I agree, but "working on towards a world where ..." need not mean "be there
from day one" IMO.  Also, I guess you'll agree that using the same _binary_
kernel with Android and non-Android user spaces doesn't necessarily make sense
(regardless of the fact that Android kernels have hardware-specific board files
included), so probably you'll still disable opportunistic suspend building the
kernel for non-Android systems (at least for the time being).

It looks like you're thinking the opportunistic suspend somehow is (or can be
used as) a replacement for runtime PM, but this is not the case.  The reason
why it's not the case is that runtime PM works with the assumption that user
space is not frozen and it works on individual devices.

OTOH, generally, there is a limit on the amount of energy savings you can
achieve with runtime PM alone and something like the opportunistic suspend is
necessary to go beyond that limit.

Now, I can easily imagine using suspend blockers and runtime PM in the same
driver with the general rule that you'll probably want to call suspend_unblock()
whenever the device is suspended with the help of the runtime PM framework.
That really depends on the device and the driver in question, though.

Rafael
