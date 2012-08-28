Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab2H1QBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 12:01:23 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60390 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab2H1QBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 12:01:21 -0400
From: Anthony Liguori <anthony@codemonkey.ws>
To: Avi Kivity <avi@redhat.com>, mjw@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peterz@infradead.org,
        mtosatti@redhat.com, glommer@parallels.com, mingo@redhat.com
Subject: Re: [PATCH RFC 0/3] Add guest cpu_entitlement reporting
In-Reply-To: <503BEC0D.9090409@redhat.com>
References: <20120823231346.11681.1502.stgit@lambeau> <503BC298.3080306@redhat.com> <1346098984.8623.23.camel@lambeau> <503BD920.20603@redhat.com> <1346102820.8623.32.camel@lambeau> <503BEC0D.9090409@redhat.com>
User-Agent: Notmuch/0.13.2+93~ged93d79 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 28 Aug 2012 11:01:16 -0500
Message-ID: <87ipc3uhtf.fsf@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@redhat.com> writes:

> On 08/27/2012 02:27 PM, Michael Wolf wrote:
>> On Mon, 2012-08-27 at 13:31 -0700, Avi Kivity wrote:
>> > On 08/27/2012 01:23 PM, Michael Wolf wrote:
>> > > > 
>> > > > How would a guest know what its entitlement is?
>> > > > 
>> > > > 
>> > >
>> > > Currently the Admin/management tool setting up the guests will put it on
>> > > the qemu commandline.  From this it is passed via an ioctl to the host.
>> > > The guest will get the value from the host via a hypercall.
>> > >
>> > > In the future the host could try and do some of it automatically in some
>> > > cases. 
>> > 
>> > Seems to me it's a meaningless value for the guest.  Suppose it is
>> > migrated to a host that is more powerful, and as a result its relative
>> > entitlement is reduced.  The value needs to be adjusted.
>>
>> This is why I chose to manage the value from the sysctl interface rather
>> than just have it stored as a value in /proc.  Whatever tool was used to
>> migrate the vm could hopefully adjust the sysctl value on the guest.
>
> We usually try to avoid this type of coupling.  What if the guest is
> rebooting while this is happening?  What if it's not running Linux at
> all?

The guest shouldn't need to know it's entitlement.  Or at least, it's up
to a management tool to report that in a way that's meaningful for the
guest.

For instance, with a hosting provider, you may have 3 service levels
(small, medium, large).  How you present whether the guest is small,
medium, or large to the guest is up to the hosting provider.

>
>> > 
>> > This is best taken care of from the host side.
>>
>> Not sure what you are getting at here.  If you are running in a cloud
>> environment, you purchase a VM with the understanding that you are
>> getting certain resources.  As this type of user I don't believe you
>> have any access to the host to see this type of information.  So the
>> user still wouldnt have a way to confirm that they are receiving what
>> they should be in the way of processor resources.
>>
>> Would you please elaborate a little more on this?
>
> I meant not reporting this time as steal time.  But that cripples steal
> time reporting.
>
> Looks like for each quanta we need to report how much real time has
> passed, how much the guest was actually using, and how much the guest
> was not using due to overcommit (with the reminder being unallocated
> time).  The guest could then present it any way it wanted to.

What I had previously suggested what splitting entitlement loss out of
steal time and reporting it as a separate metric (but not reporting a
fixed notion of entitlement).

You're missing the entitlement loss bit above.  But you need to call
out entitlement loss in order to report idle time correctly.

I think changing steal time (as this patch does) is wrong.

Regards,

Anthony Liguori

>
> -- 
> I have a truly marvellous patch that fixes the bug which this
> signature is too narrow to contain.
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
