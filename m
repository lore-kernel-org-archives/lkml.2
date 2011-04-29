Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731Ab1D2NtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 09:49:24 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:40319 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924Ab1D2NtW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 09:49:22 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>
Subject: RE: [PATCH 08/25] Staging: hv: vmbus_driver cannot be unloaded;
 cleanup accordingly
Thread-Topic: [PATCH 08/25] Staging: hv: vmbus_driver cannot be unloaded;
 cleanup accordingly
Thread-Index: AQHMBCwlOahkyDWQA0Cj/4uI6AAO6ZRxNFuA///EzKCAAef0AIAB4skA
Date: Fri, 29 Apr 2011 13:49:21 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481DD55F@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-8-git-send-email-kys@microsoft.com>
 <20110426224545.GC31974@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DD1C9@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110428002018.GC14294@kroah.com>
In-Reply-To: <20110428002018.GC14294@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.35]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Wednesday, April 27, 2011 8:20 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang;
> Abhishek Kane (Mindtree Consulting PVT LTD)
> Subject: Re: [PATCH 08/25] Staging: hv: vmbus_driver cannot be unloaded;
> cleanup accordingly
> 
> On Wed, Apr 27, 2011 at 02:31:18AM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:greg@kroah.com]
> > > Sent: Tuesday, April 26, 2011 6:46 PM
> > > To: KY Srinivasan
> > > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang;
> > > Abhishek Kane (Mindtree Consulting PVT LTD)
> > > Subject: Re: [PATCH 08/25] Staging: hv: vmbus_driver cannot be unloaded;
> > > cleanup accordingly
> > >
> > > On Tue, Apr 26, 2011 at 09:20:25AM -0700, K. Y. Srinivasan wrote:
> > > > The vmbus driver cannot be unloaded; the windows host does not
> > > > permit this. Cleanup accordingly.
> > >
> > > Woah, you just prevented this driver from ever being able to be
> > > unloaded.
> >
> > It was never unloadable; while the driver defined an exit routine,
> > there were couple of issues unloading the vmbus driver:
> >
> > 1) All guest resources given to the host could not be recovered.
> 
> Is this a problem in the Linux side?  If so, that could easily be fixed.

This is not an issue on the Linux side. From what I remember, this was
Guest/Host protocol related. Once I confirmed the second issue, I did 
not pursue this issue further.

> 
> > 2) Windows host would not permit reloading the driver without
> > rebooting the guest.
> 
> That's a different issue, and one that I am very surprised to hear.
> That kind of invalidates ever being able to update the driver in a guest
> for a long-running system that you want to migrate and not reboot.  That
> sounds like a major bug in hyper-v, don't you agree?

In practical terms, I am not sure this is a major problem. If the root device
Is managed by a Hyper-V driver, then you cannot unload that driver and 
drivers it depends on anyway.
 
> 
> > All I did was acknowledge the current state and cleanup
> > accordingly. This is not unique to Hyper-V; for what it is worth,
> > the Xen platform_pci  driver which is equivalent to the vmbus driver
> > is also not unlodable (the last time I checked).
> 
> Why isn't that allowed to be unloaded?  What happens if it does?

On the Xen side, from as long as I can remember, the platform_pci 
has been unlodable (does not define an exit routiune). I don't recall 
what the issues have been.

> 
> I would like to see the following be possible from Linux:
> 	- running Linux guest on hyperv
> 	- need to migrate to a newer version of hyper-v
> 	- pause long-running userspace processes.
> 	- unload hyperv modules
> 	- migrate guest to newer hyperv version (possible different host
> 	  machine)
> 	- load newer hyperv modules
> 	- resume long-running guest processes

Many hyper-V modules are un-lodable; it is just the vmbus_driver module 
has this issue. Also, since vmbus_driver happens to be the foundational
driver for most of  the hyper-v drivers,  and since ultimately, we do 
want to handle the root device via hyper-v block driver, vmbus_driver will
become unlodable for other reasons.

> 
> If this isn't possible due to hyper-v bugs, then I guess we need to be
> able to live with it, but we had better advertise it pretty well as I
> know people will want to be able to do the above sequence for their
> guest instances.
> 
> If so, can you expand this patch to say more in the changelog entry, and
> resend the remaining patches that I didn't apply as they are now gone
> from my pending-patch queue.

Will do.
> 
> > > That's not a "cleanup" that's a major change in how things work.  I'm
> > > sure, if you want to continue down this line, there are more things you
> > > can remove from the code, right?
> > >
> > > What is the real issue here?  What happens if you unload the bus?  What
> > > goes wrong?  Can it be fixed?
> >
> > This needs to be fixed on the host side. I have notified them of the issue.
> 
> Ok, so if this is going to be fixed, why do we need to prevent this from
> ever being possible to have happen on our side?

While I have notified the windows team about this issue, I do not know
If/or when this issue may be fixed. As, I noted earlier, having an exit function
gives the impression that the module is unloadable while it is not - today because
of the issue on the host side. Even if the host side issue is fixed, we may not be 
able to unload the vmbus driver for other dependency related issues.
All I did was get rid of the exit function so there 
would be no confusion as to the state of this module. We could easily add the exit 
function, if and when the host side issues are fixed. Even then, this module may
be unlodable if we are driving the root device with the hyper-v block driver.

Greg, I am open to either approach here: 1) I could drop this patch and restore the 
exit function. 2) I could keep the patch as is, but add additional comments to
capture this discussion. Let me know what you prefer and I will send the remaining 
patch-set with the agreed upon changes.

Regards,

K. Y


