Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888Ab2ECWPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 18:15:37 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:52339 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756469Ab2ECWPf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 18:15:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [RFC][PATCH 6/8] PM / Sleep: Implement opportunistic sleep
Date: Fri, 4 May 2012 00:20:23 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: NeilBrown <neilb@suse.de>, Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
References: <201202070200.55505.rjw@sisk.pl> <201205031528.12743.rjw@sisk.pl> <CAMP5XgeXGWcWwQ77DctoWQy0BEPLAQdbSjHANbHu76M+xZzR-w@mail.gmail.com>
In-Reply-To: <CAMP5XgeXGWcWwQ77DctoWQy0BEPLAQdbSjHANbHu76M+xZzR-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201205040020.23460.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 03, 2012, Arve Hjønnevåg wrote:
> On Thu, May 3, 2012 at 6:28 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Thursday, May 03, 2012, Arve Hjønnevåg wrote:
> >> On Thu, Apr 26, 2012 at 2:52 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> ...
> >> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >> > Subject: PM / Sleep: Implement opportunistic sleep, v2
> >> >
> >> > Introduce a mechanism by which the kernel can trigger global
> >> > transitions to a sleep state chosen by user space if there are no
> >> > active wakeup sources.
> >> >
> >> > It consists of a new sysfs attribute, /sys/power/autosleep, that
> >> > can be written one of the strings returned by reads from
> >> > /sys/power/state, an ordered workqueue and a work item carrying out
> >> > the "suspend" operations.  If a string representing the system's
> >> > sleep state is written to /sys/power/autosleep, the work item
> >> > triggering transitions to that state is queued up and it requeues
> >> > itself after every execution until user space writes "off" to
> >> > /sys/power/autosleep.
> >> >
> >>
> >> This does not work. Writing something other than "off" disabled auto
> >> suspend for me.
> >
> > My bad, sorry about that.
> >
> >> ...
> >> > +static ssize_t autosleep_store(struct kobject *kobj,
> >> > +                              struct kobj_attribute *attr,
> >> > +                              const char *buf, size_t n)
> >> > +{
> >> > +       suspend_state_t state = decode_state(buf, n);
> >> > +       int error;
> >> > +
> >> > +       if (state == PM_SUSPEND_ON
> >> > +           && !(strncmp(buf, "off", 3) && strncmp(buf, "off\n", 4)))
> >> > +               return -EINVAL;
> >>
> >> Did you mean:
> >>       if (state == PM_SUSPEND_ON
> >>           && strcmp(buf, "off") && strcmp(buf, "off\n"))
> >>               return -EINVAL;
> >
> >
> > Yes, I did.
> >
> > I'll add the following as an incremental patch on top of the series.
> >
> > Thanks,
> > Rafael
> >
> > ---
> >  kernel/power/main.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > Index: linux/kernel/power/main.c
> > ===================================================================
> > --- linux.orig/kernel/power/main.c
> > +++ linux/kernel/power/main.c
> > @@ -422,7 +422,7 @@ static ssize_t autosleep_store(struct ko
> >        int error;
> >
> >        if (state == PM_SUSPEND_ON
> > -           && !(strncmp(buf, "off", 3) && strncmp(buf, "off\n", 4)))
> > +           && strncmp(buf, "off", 3) && strncmp(buf, "off\n", 4))
> >                return -EINVAL;
> >
> >        error = pm_autosleep_set_state(state);
> 
> You still use strncmp here, so anything that starts with "off" is
> allowed (and the second strncmp is redundant).

Good point.  So I'm going to add the patch below after all.
OK to add your sign-off to it?

Rafael


---
 kernel/power/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/kernel/power/main.c
===================================================================
--- linux.orig/kernel/power/main.c
+++ linux/kernel/power/main.c
@@ -422,7 +422,7 @@ static ssize_t autosleep_store(struct ko
 	int error;
 
 	if (state == PM_SUSPEND_ON
-	    && !(strncmp(buf, "off", 3) && strncmp(buf, "off\n", 4)))
+	    && strcmp(buf, "off") && strcmp(buf, "off\n"))
 		return -EINVAL;
 
 	error = pm_autosleep_set_state(state);
