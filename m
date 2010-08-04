Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab0HDEAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:00:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:59987 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab0HDEAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:00:50 -0400
Subject: Re: [linux-pm] Attempted summary of suspend-blockers LKML thread
From: James Bottomley <James.Bottomley@suse.de>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: paulmck@linux.vnet.ibm.com, peterz@infradead.org, swetland@google.com,
        linux-kernel@vger.kernel.org, florian@mickler.org,
        linux-pm@lists.linux-foundation.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
In-Reply-To: <AANLkTinJ2jy18bAS-=abtDLaQWVmQdK1Oq105FcNDNyJ@mail.gmail.com>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	 <AANLkTi=hoGF7egpyB9sLKJoXv5aiGrxfa9_5iH-96SA=@mail.gmail.com>
	 <1280851338.2774.30.camel@mulgrave.site>
	 <AANLkTinJ2jy18bAS-=abtDLaQWVmQdK1Oq105FcNDNyJ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 00:00:27 -0400
Message-ID: <1280894427.11045.293.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-03 at 15:08 -0700, Arve Hjønnevåg wrote:
> 2010/8/3 James Bottomley <James.Bottomley@suse.de>:
> > On Mon, 2010-08-02 at 21:18 -0700, Arve Hjønnevåg wrote:
> >> > o       A power-aware application must be able to efficiently communicate
> >> >        its needs to the system, so that such communication can be
> >> >        performed on hot code paths.  Communication via open() and
> >> >        close() is considered too slow, but communication via ioctl()
> >> >        is acceptable.
> >> >
> >>
> >> The problem with using open and close to prevent an allow suspend is
> >> not that it is too slow but that it interferes with collecting stats.
> >
> > Please elaborate on this.  I expect the pm-qos stats interface will
> > collect stats across user open/close because that's how it currently
> > works.  What's the problem?
> >
> 
> The pm-qos interface creates the request object in open and destroys
> it in release just like the suspend blocker interface. We need stats
> for each client which is lost if you free the object every time you
> unblock suspend.

? right at the moment it doesn't do stats.  I don't see why adding a per
pid or per name stat count on the long lived object won't work here.

> Or are you talking about user space opening and closing the stats
> interface (which does not cause any problems)?

There is no stat interface yet; it's for us to define.

> >> The wakelock code has a sysfs interface that allow you to use a
> >> open/write/close sequence to block or unblock suspend. There is no
> >> limit to the amount of kernel memory that a process can consume with
> >> this interface, so the suspend blocker patchset uses a /dev interface
> >> with ioctls to block or unblock suspend and it destroys the kernel
> >> object when the file descriptor is closed.
> >
> > This is an implementation detail only.
> 
> There is no way fix it without changing the user space visible
> behavior of the API. The kernel does not know when it is safe to free
> the objects.

They're freed on destruction of the long lived kernel object or on user
space clear request.  Surely that's definitive enough?

> > The pm-qos objects are long
> > lived, so their stats would be too.  I would guess that explicit stat
> > clearing might be a useful option.
> >
> 
> Which pm-qos objects are you referring to? The struct pm_qos_object
> that backs each pm-qos class is long lived (I don't know why this is
> named pm_qos_object), but we need stats in struct pm_qos_request_list.

Actually, why not two separate lists?  one for the request and one for
the stats?

OK, so I'm tired and I've had a long flight to get to where I am, so I
may be a bit jaded, but this isn't fucking rocket science the question
is how do we implement what you want on what we have ... there looks to
be multiple useful solutions ... we just have to pick one and agree on
it (that's standard open source).

James


