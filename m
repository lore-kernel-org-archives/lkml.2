Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab0KLSog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:44:36 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62942 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab0KLSof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:44:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=TasZ2F775RMtPhPmXlG1EtSJdK8PV1TNWRspOjgqutRijxSZW0eN5sf4RlYAldCQMt
         VkQs0G5NW1SJg2JoLhpTQ0VbdHk/pQQBp3einQoi1ufJxUwM69AuRZ/FacVTYE3xVJM8
         3rhJqGzKmwIOUcSbOT/DSWCBWFxhyAGxi5yuo=
Date: Fri, 12 Nov 2010 10:44:24 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Greg KH <greg@kroah.com>, Vladislav Bolkhovitin <vst@vlnb.net>,
        Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        scst-devel <scst-devel@lists.sourceforge.net>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Message-ID: <20101112184424.GD1224@core.coreip.homeip.net>
References: <20101022185437.GA9103@kroah.com>
 <4CD8566D.1020202@vlnb.net>
 <20101109002829.GA22633@kroah.com>
 <4CD9A9B8.70708@vlnb.net>
 <4CDA6CD4.3010308@panasas.com>
 <4CDAFE6E.7050200@vlnb.net>
 <4CDBBE80.40908@panasas.com>
 <4CDC56F9.9040601@vlnb.net>
 <20101112012315.GE17097@core.coreip.homeip.net>
 <AANLkTikA7GRDR2Y3nUfQYxLHCWVLfzVPJmZED_whuCWD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikA7GRDR2Y3nUfQYxLHCWVLfzVPJmZED_whuCWD@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 01:09:48PM +0100, Bart Van Assche wrote:
> On Fri, Nov 12, 2010 at 2:23 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Thu, Nov 11, 2010 at 11:50:01PM +0300, Vladislav Bolkhovitin wrote:
> > > [ ... ]
> > >
> > > This is the last internal put. All other references are from outsiders.
> > > So, we are waiting for all them to put before we go on.
> >
> > The question is why do you need to wait here? I presume it is module
> > unloading path, but then it is quite bad - you can easily wedge your
> > subsystem if you make something to take a reference to your kobject
> > while module is trying to be unloaded. Back when sysfs attributes tied
> > kobjects the easiest thing was to do:
> >
> >        rmmod <module> < / sys/devices/..../attribute
> >
> > If you are done with the kobject - just proceed with what you were doing
> > and let it die its own peaceful death some time later. You just need to
> > make sure release code sticks around to free it and your subsystem core
> > can be tasked with this. Use module counter to prevent unloading of the
> > subsystem core until all kobjects belonging to the subsystem are
> > destroyed.
> 
> Do you mean keeping a kref object in the kernel module, invoking
> kref_get() every time a kobject has been created and invoking
> kref_put() from the kobject/ktype release method ? That would help to
> reduce the race window but would not eliminate all races: as soon as
> the last kref_put() has been invoked from the release method, the
> module can get unloaded. And module unloading involves freeing all
> module code sections, including the section that contains the
> implementation of the release method. Which is a race condition.

No, you do not add a kref, but rather manipulate module use counter:

static void blah_blah_release(struct kobject *kobj)
{
	struct blah_blah *b = to_blah_blah(kobj);

	...
	kfree(kobj);

	module_put(THIS_MODULE);
}

int blah_blah_register(struct blah_blah *blah)
{
	...

	__module_get(THIS_MODULE);

	...

	return 0;
}

The above should reside in subsystem _core_ and it will pin the core
module until last kobject belonging to the subsystem is released.
Once all users are gone module counter will go to 0 and rmmod will
allow core to unload. Note that no new kobjects will be created while
module usage count is 0 because there are no users of the core - all of
them have to be unloaded already, otherwise module loader would have
bumped up usage count as well.

> 
> I'm not sure that it is even possible with the current kobject
> implementation to solve this race.

It is possible and it is solved in most (all?) mainline subsystems.

> I haven't found any information
> about this race in Documentation/kobject.txt. And it seems to me that
> the code in samples/kobject/kobject-example.c is vulnerable to this
> race: methods like foo_show() and foo_store() can access statically
> allocated memory ("static int foo") after the module has been
> unloaded. Although the race window is small, this makes me wonder
> whether module unloading been overlooked at the time the kobject
> subsystem has been designed and implemented ?
> 
> Bart.

-- 
Dmitry
