Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260Ab0HEXfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 19:35:48 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47469 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754782Ab0HEXfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 19:35:44 -0400
Date: Thu, 5 Aug 2010 16:35:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Brian Swetland <swetland@google.com>
Cc: david@lang.hm, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, arve@android.com, mjg59@srcf.ucam.org,
        pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, peterz@infradead.org
Subject: Re: Attempted summary of suspend-blockers LKML thread, take two
Message-ID: <20100805233541.GV2447@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100731175841.GA9367@linux.vnet.ibm.com>
 <20100804195704.GA23681@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008050616340.25170@asgard.lang.hm>
 <AANLkTi=wyD-K35vQdhTr7kt4wHeEDkbvzkXHAOyMtzZJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=wyD-K35vQdhTr7kt4wHeEDkbvzkXHAOyMtzZJ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 06:37:15AM -0700, Brian Swetland wrote:
> On Thu, Aug 5, 2010 at 6:18 AM,  <david@lang.hm> wrote:
> > On Wed, 4 Aug 2010, Paul E. McKenney wrote:
> >
> >> Continuing to rush in where angels fear to tread...
> >
> > here here :-)
> >
> >> o       "PM-driving application" are applications that are permitted
> >>        to acquire suspend blockers on Android.  Verion 8 of the
> >>        suspend-blocker patch seems to use group permissions to determine
> >>        which applications are classified as power aware.  More generally,
> >>        PM-driving applications seem to be those that have permission
> >>        to exert some control over the system's sleep state.
> >>
> >>        Note that an application might be power-oblivious on one Android
> >>        device and PM-driving on another, depending on whether the user
> >>        allows that application to acquire suspend blockers.  The
> >>        classification might even change over time.  For example, a
> >>        user might give an application PM-driving status initially,
> >>        but change his or her mind after some experience with that
> >>        application.
> >
> > One thing that I think it's important to document here is theinformation
> > that Brian provided in response to your question about how many (or actually
> > how few) applications fall into this catefory
> 
> I think I need to clarify here.  When I say "app" in the context of
> Android, I mean "an application running under the Android app model --
> sandboxed under a per-app or app-group uid", not "a process".  The
> vast majority of processes on an Android device are "apps" in this
> sense, but some (usually low level services or daemons) are not.  Also
> I use "wakelock" as a place holder for "suspend blocker" or whatever
> exact API we're trying to hash out here, because it's shorter and I'm
> lazy.
> 
> Any app may obtain a wakelock through the standard Android APIs,
> provided it has permission to do so.  In the current implementation,
> apps obtain wakelocks via making a binder RPC call to the power
> manager service which tracks high level wakelocks (for apps!) and
> backs them by a single kernel wakelock.  Access control is at the RPC
> level.  This implementation could be changed to have the app API
> simply open /dev/suspendblock or whatnot, with access control enforced
> by unix permissions (the framework would arrange for apps with the
> android "can block sleep" permission to be in a unix group that has
> access to the device).
> 
> For native services (native daemons that run "underneath" the android
> app framework -- for example the media service, the radio interface,
> etc), the kernel interface is used directly (ok, usually via a very
> thin C convenience wrapper).

Thank you for the added detail on Android user-space operation!!!

							Thanx, Paul

> Brian
> 
> 
> > Quote:
> >
> >> I should have asked this earlier...  What exactly are the apps'
> >> compatibility constraints?  Source-level APIs?  Byte-code class-library
> >> invocations?  C/C++ dynamic linking?  C/C++ static linking (in other
> >> words, syscall)?
> >
> > For Java/Dalvik apps, the wakelock API is pertty high level -- it
> > talks to a service via RPC (Binder) that actually interacts with the
> > kernel.  Changing the basic kernel<->userspace interface (within
> > reason) is not unthinkable.  For example, Arve's suspend_blocker patch
> > provides a device interface rather than the proc interface the older
> > wakelock patches use.  We'd have to make some userspace changes to
> > support that but they're pretty low level and minor.
> >
> > In the current model, only a few processes need to specifically
> > interact with the kernel (the power management service in the
> > system_server, possibly the media_server and the radio interface
> > glue).  A model where every process needs to have a bunch of
> > instrumentation is not very desirable from our point of view.  We
> > definitely do need reasonable statistics in order to enable debugging
> > and to enable reporting to endusers (through the Battery Usage UI)
> > what's keeping the device awake.
> >
> > Brian
> >
> >
