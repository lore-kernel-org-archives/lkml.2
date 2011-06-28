Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab1F1Vlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 17:41:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37853 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab1F1Vlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 17:41:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ming Lei <tom.leiming@gmail.com>, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 3/3] PM: Limit race conditions between runtime PM and system sleep
Date: Tue, 28 Jun 2011 23:42:24 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        linux-scsi@vger.kernel.org
References: <201106260054.20578.rjw@sisk.pl> <201106260056.32221.rjw@sisk.pl> <20110628235643.4cf7cff0@tom-ThinkPad-T410>
In-Reply-To: <20110628235643.4cf7cff0@tom-ThinkPad-T410>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106282342.25003.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 28, 2011, Ming Lei wrote:
> 
> Hi Rafael,
> 
> On Sun, 26 Jun 2011 00:56:31 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Index: linux-2.6/Documentation/power/runtime_pm.txt
> > ===================================================================
> > --- linux-2.6.orig/Documentation/power/runtime_pm.txt
> > +++ linux-2.6/Documentation/power/runtime_pm.txt
> > @@ -567,6 +567,11 @@ this is:
> >  	pm_runtime_set_active(dev);
> >  	pm_runtime_enable(dev);
> >  
> > +The PM core always increments the run-time usage counter before calling the
> > +->suspend() callback and decrements it after calling the ->resume() callback.
> > +Hence disabling run-time PM temporarily like this will not cause any run-time
> > +suspend callbacks to be lost.
> 
> Could you explain why the above is that "this will not cause any run-time suspend
> callbacks to be lost"? 
> 
> Looks like it should be "this will not cause any run-time suspend callbacks to
> be called", but not sure.

You're right the wording is not perfect.  The problem is that if it's done
this way without incrementing the usage counter beforehand, the status may
change to "suspended" right before the pm_runtime_set_active() and then the
new status will not reflect the actual state of the device.

So, it may be better to say "Hence disabling runtime PM temporarily like this
will not cause the runtime PM status of the device to conflict with the actual
device state".

Alan, what do you think?

Rafael
