Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab2EESvS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 14:51:18 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:55228 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab2EESvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 14:51:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH v2 0/7] CPU hotplug, cpusets: Fix issues with cpusets handling upon CPU hotplug
Date: Sat, 5 May 2012 20:56:03 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        mingo@kernel.org, pjt@google.com, paul@paulmenage.org,
        akpm@linux-foundation.org, nacc@us.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, rob@landley.net, tj@kernel.org,
        mschmidt@redhat.com, berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pm@vger.kernel.org
References: <1336167852.6509.90.camel@twins> <Pine.LNX.4.44L0.1205051108470.3737-100000@netrider.rowland.org> <20120505174406.GD2470@linux.vnet.ibm.com>
In-Reply-To: <20120505174406.GD2470@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205052056.04144.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 05, 2012, Paul E. McKenney wrote:
> On Sat, May 05, 2012 at 11:24:55AM -0400, Alan Stern wrote:
> > On Fri, 4 May 2012, Peter Zijlstra wrote:
> > 
> > > That said, the whole suspend/resume 'problem' does seem worth fixing and
> > > is a very special case where we absolutely know we're going to get back
> > > in the state we are in and userspace isn't actually running. So ideally
> > > we'd go with the bhat's patch that skips the sched_domain rebuilds
> > > entirely +- some bug-fixes ;-).
> > 
> > Just as an interesting side comment...
> > 
> > The USB subsystem faced this same problem years ago.  The question was:  
> > When a USB device (especially a mass-storage device) is unplugged and
> > then reconnected, is the new device instance the same as the old one?  
> > Linus stepped in and firmly assured us that it was not.  That's very
> > much like the situation you're describing: If CPU 4 is hot-unplugged
> > and then a new CPU appears in slot 4, is it the same CPU as before (and 
> > does it therefore belong to the same cpusets as before)?
> > 
> > But this led to problems during suspend, because not all systems could
> > maintain bus connectivity while the system was asleep, and almost none
> > can during hibernation.  As a result, mounted filesystems would become
> > unavailable after resume even though the USB storage device had been
> > plugged in the whole time.  To the kernel, it appeared that the device 
> > had been unplugged during suspend and then replugged during resume.
> > 
> > We ended up adopting a special-purpose solution just to handle that
> > case.  It's described in Documentation/usb/persist.txt if you want the
> > full details.  In brief, when the system resumes it checks to see if a
> > device appears to be present at the same port where a device used to
> > be.  If it is, and if its descriptors match the values remembered for
> > the former device, then we accept the new device as being the same as
> > the old one, even though the hardware indicates that the connection was
> > not maintained during the system sleep.
> > 
> > >From my point of view, this suggests that CPU hot-unplug is not quite
> > the right tool to use during suspend.  The CPU doesn't actually go
> > away; it merely becomes unusable for a while.  In other words, this
> > approach applies an incorrect abstraction.  What's really needed is
> > something a little different: a way to avoid running any tasks on that
> > CPU while not removing it from the system.  If this means some tasks
> > can no longer run on any CPUs, so be it -- this happens only during
> > suspend, after all.  Then during resume, when the CPU is brought back 
> > up, tasks are allowed to run on it again.
> 
> If I understand correctly, Thomas Gleixner is pushing in this direction,
> allowing CPUs to be brought down partially (preventing anything from
> running on it) or completely.  The big obstacle in current kernel
> is lack of organized way of bringing CPUs down.

Yet, this is the only viable way to go, IMHO.

Thanks,
Rafael
