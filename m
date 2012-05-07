Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab2EGVvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 17:51:54 -0400
Received: from netrider.rowland.org ([192.131.102.5]:43620 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756334Ab2EGVvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 17:51:53 -0400
Date: Mon, 7 May 2012 17:51:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep false positive in sysfs
In-Reply-To: <20120507194658.GH19417@google.com>
Message-ID: <Pine.LNX.4.44L0.1205071740420.23176-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2012, Tejun Heo wrote:

> Hello, Alan.

Hi.

> On Fri, May 04, 2012 at 03:08:53PM -0400, Alan Stern wrote:
> > @@ -588,10 +591,15 @@ static ssize_t usb_dev_authorized_store(
> >  	result = sscanf(buf, "%u\n", &val);
> >  	if (result != 1)
> >  		result = -EINVAL;
> > -	else if (val == 0)
> > +	else if (val == 0) {
> > +		void *cookie;
> > +
> > +		cookie = device_start_attribute_infanticide(dev, attr, NULL);
> >  		result = usb_deauthorize_device(usb_dev);
> > -	else
> > +		device_end_attribute_infanticide(cookie);
> > +	} else {
> >  		result = usb_authorize_device(usb_dev);
> > +	}
> 
> I *think* it looks way too huge as lockdep workaround.  We're adding a

Well, it's not _terribly_ huge.  As far as the driver is concerned, 
it's just a start and an end call.  The lookup interface isn't even 
EXPORTed, because its only user is the device core.

> whole separate lookup interface for this.  If looking up afterwards is
> difficult, can't we get away with adding a field in struct attribute?

You mean, an "ignore this attribute for lockdep purposes" flag?  Yes, 
that would work just as well.

I guess in the end it's a question of balance.  Which has more 
overhead, adding a few function calls here and there, or adding a new 
flags field to every struct attribute?

Alan Stern

