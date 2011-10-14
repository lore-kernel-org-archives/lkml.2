Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415Ab1JNRUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:20:53 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64602 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933349Ab1JNRUv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:20:51 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1110141229450.2036-100000@iolanthe.rowland.org>
References: <CACxGe6vF6em0-PnJ7UuH0CQ0_StJTfmFKBsktvb9O+ccCx6E8A@mail.gmail.com>
 <Pine.LNX.4.44L0.1110141229450.2036-100000@iolanthe.rowland.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 14 Oct 2011 11:20:30 -0600
X-Google-Sender-Auth: Pt4STmdXdYSiAbonnnE2W1rCk1E
Message-ID: <CACxGe6t2Xu5B0AKZJe-6HEpxK6GfuNm0Y2Kb_bs8ZwaTz5XnRg@mail.gmail.com>
Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ming Lei <tom.leiming@gmail.com>, Andrei Warkentin <awarkentin@vmware.com>,
        Greg KH <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        "G, Manjunath Kondaiah" <manjugk@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, Manjunath@jasper.es,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linux PM List <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 10:33 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 14 Oct 2011, Grant Likely wrote:
>
>> > How can a device acquire children before it has a driver?
>>
>> There are a few potential situations in embedded systems (or at least
>> nothing currently prevents it) where platform setup code constructs a
>> device hierarchy without the aid of device drivers, and it is still
>> possible for a parent device to be attached to a driver.  IIUC, SPARC
>> creates an entire hierarchy of platform_devices from all the nodes in
>> the OpenFirmware device tree, and any of those devices can be bound to
>> a driver.  I don't like that approach, but at the very least it needs
>> to be guarded against.
>
> Do these devices ever require deferred probes?

Yes, they very well might.  However, I'm happy with the limitation
that only leaf devices can take advantage of probe deferral.

>> On Fri, Oct 14, 2011 at 9:39 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> > On Thu, 13 Oct 2011, Grant Likely wrote:
>> Yes, that does indeed simplify the issue considerably.  Let's do that.
>>  So, for this patch, there will be two bits added.  First, don't allow
>> deferral on devices with children, and second a successful probe
>> (deferred or otherwise) should always move a device to the end of the
>> dap_list if it doesn't have children to guarantee that the list order
>> satisfies both the hierarchical and probe order.  Manjunath, do you
>> think you can prototype this?
>
> I don't think the second part needs to be quite so invasive.
> Certainly drivers that never defer probes shouldn't require anything to
> be moved.

Think about that a minute.  Consider a dpm_list of devices:
        abcDefGh

Now assume that D has an implicit dependency on G.  If D gets probed
first, then it will be deferred until G gets probed and then D will
get retried and moved to the end of the list resulting in:
        abcefGhD
Everything is good now for the order that things need to be suspended in.

Now lets assume that the drivers get linked into the kernel in a
different order (or the modules get loaded in a different order) and G
gets probed first, followed by D.  No deferral occurred and so no
reordering occurs, resulting in:
        abcDefGh (unchanged)
But now suspend is broken because D depends on G, but G will be
suspended before D.  This looks and smells like a bug to me.  In fact,
even without using probe deferral it looks like a bug because the
dap_list isn't taking into account the fact that there are very likely
to be implicit dependencies between devices that are not represented
in the device hierarchy (maybe not common in PCs, but certainly is the
case for embedded).  But, it is also easy to solve by ensuring the
dap_list is also probe-order sorted.

> A deferred probe _should_ move the device to the end of the list.  But
> this needs to happen in the probe routine itself (after it has verified
> that all the other required devices are present and before it has
> registered any children) to prevent races.  It can't be done in a
> central location.

I'm really concerned about drivers having to implement this and not
getting it correct; particularly when moving a device to the end of
the list is cheap, and it shouldn't be a problem to do the move
unconditionally after a driver has been matches, but before probe() is
called.  We may be able to keep watch to make sure that drivers using
probe deferral are also reordering themselves, but that does nothing
for the cases described above where the link order of the drivers
determines probe order, not the dap_list order.

g.


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
