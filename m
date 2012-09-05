Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab2IEPMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:12:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab2IEPMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:12:07 -0400
Message-ID: <50476BC4.4050807@redhat.com>
Date: Wed, 05 Sep 2012 18:12:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Alex Williamson <alex.williamson@redhat.com>, gleb@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 1/2] kvm: Use a reserved IRQ source ID for irqfd
References: <20120821190800.24958.74812.stgit@bling.home> <20120821192903.24958.90138.stgit@bling.home> <20120821195813.GD9027@redhat.com> <1345579579.29292.67.camel@ul30vt.home> <20120821204125.GF9027@redhat.com> <1345583694.29292.91.camel@ul30vt.home> <20120822004138.GM9027@redhat.com> <5047633F.9020405@redhat.com> <20120905145153.GA11048@redhat.com> <20120905150913.GB11058@redhat.com>
In-Reply-To: <20120905150913.GB11058@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2012 06:09 PM, Michael S. Tsirkin wrote:
> On Wed, Sep 05, 2012 at 05:51:53PM +0300, Michael S. Tsirkin wrote:
>> On Wed, Sep 05, 2012 at 05:35:43PM +0300, Avi Kivity wrote:
>> > On 08/22/2012 03:41 AM, Michael S. Tsirkin wrote:
>> > >> 
>> > >> I assumed you were pointing out the level vs edge interaction.  If we
>> > >> call that a userspace bug, I can just drop this.  Thanks,
>> > >> 
>> > >> Alex
>> > > 
>> > > level is userspace bug I think :)
>> > 
>> > I don't see how it's a bug.  Suppose we have a vfio device that shares a
>> > gsi with an emulated device.  The emulated device naturally uses
>> > KVM_IRQ_LINE (it has no need to re-sample on ADN), while vfio naturally
>> > has to use irqfd.
>> 
>> Absolutely. But vfio needs to use irqfd with the new flag.
>> Using existing irqfd for level is a bug.
>> 
>> > Note one would expect that each irqfd gets its own irq source id, since
>> > they are all independent level sources.  The reason they don't is that
>> > we shut them down anyway and let the sources re-trigger (it is more
>> > accurate to say that they have no irq source id, but that would just
>> > muddle the implementation).
>> > 
>> > Alex, if the conclusion is that we do need this patch, then please add a
>> > comment explaining why we can share the source id among all irqfd users.
> 
> Something along the lines of
> 
> /* 
>    For resample irqfds, level is a logical OR of all inputs;
>    to support this, track state for RESAMPLE irqfds separately
>    from userspace. We do not need to track state for each input since
>    they are all deasserted at the same time, before resampling.
>    */

Well the comment style is wrong.

To expand a little more, irqfd only sends assert events, so assigning
the level is equivalent to an OR.  Clearing an resampling simply builds
the state again.

btw, there can be other irq source IDs if the lines are shared with the
PIT or kvm assigned devices.

-- 
error compiling committee.c: too many arguments to function
