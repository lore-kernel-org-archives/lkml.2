Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab0KJTVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:21:53 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38473 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab0KJTVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:21:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ePa9+0iS+tee5mwwmgX4hVnxgox+IV88ed8JYkza/CZHPG5o9ZAJN11GaOezHsKf2y
         8vpSkKYN8QRjJRU7CAJdU2tBFBOTumLhrqDXoRilJmyIhXFlwrdtGuZbv8klFLp81vbD
         eBxL7k/6Ac5Wrtk1nh/cJ2TvMaVIwrDKQsYeY=
MIME-Version: 1.0
In-Reply-To: <AANLkTinQK_9qp-8jJ5j3-ChUjwhGiGzAmCu5cBtHX75g@mail.gmail.com>
References: <AANLkTinOeby9P847gJFn_t0h5nDY7cfi3cW9hEaUrS1v@mail.gmail.com>
	<20101106050721.GA2194@kroah.com>
	<AANLkTinQK_9qp-8jJ5j3-ChUjwhGiGzAmCu5cBtHX75g@mail.gmail.com>
Date: Wed, 10 Nov 2010 11:21:49 -0800
Message-ID: <AANLkTikdr=nJF45QUCKAOY8NSh9GNtv8c9K_oNdJeJfc@mail.gmail.com>
Subject: Re: [RFC] rbd sysfs interface
From: Yehuda Sadeh Weinraub <yehudasa@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: ceph-devel@vger.kernel.org, Sage Weil <sage@newdream.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 5, 2010 at 10:51 PM, Yehuda Sadeh Weinraub
<yehudasa@gmail.com> wrote:
> On Fri, Nov 5, 2010 at 10:07 PM, Greg KH <greg@kroah.com> wrote:
>> On Fri, Nov 05, 2010 at 04:09:31PM -0700, Yehuda Sadeh Weinraub wrote:
>>>
>>> Does this seem sane? Any comments would be greatly appreciated.
>>
>> It sounds like you need to use configfs instead of sysfs, as your model
>> was the reason it was created.
>>
>> Have you tried that?
>
> Oh, will look at it now. With ceph (although for a different purpose)
> we went through proc -> sysfs -> debugfs, however, it seems that we've
> missed at least one userspace-kernel channel.
>

Well, we looked a bit at what configfs does, and from what we see it
doesn't really fit our needs. Configfs would be more suitable to
configuring a static system than to control a dynamic one. The main
problem is that items creation is only driven by userspace. That would
be ok if we had a static mapping of the images and snapshots, however,
we don't. We need the system to reflect any state change with the
running configuration (e.g., a new snapshot was created by a different
client), and it doesn't seem possible with configfs as long as items
creation is only driven by userspace operations. We need a system that
would be able to reflect changes that happened due to some external
operation, and this doesn't seem to be the case here.

There is second issue and that's committable items are not implemented
there yet. So the interface itself would be a bit weird. E.g., had
committable items been implemented we would have done something like
the following:

 /config/rbd# mkdir pending/myimage
 /config/rbd# echo foo > pending/myimage/name
 /config/rbd# cat ~/mykey > pending/myimge/key
 /config/rbd# echo 10.0.0.1 > pending/myimage/addr
...
 /config/rbd# mv pending/myimage live/

and that would do what we need in terms of initial configuration.
However, as this is not really implemented yet, there is no
distinction between images that are pending and images that are live,
so configuration would look something like:
 /config/rbd# mkdir myimage
 /config/rbd# echo foo > myimage/name
 /config/rbd# cat ~/mykey > myimge/key
 /config/rbd# echo 10.0.0.1 > myimage/addr
...
 /config/rbd# echo 1 > myimage/go

And having that, the myimage/ directory will still hold all those
config options that are moot after the image went live. It doesn't
seem to offer a significant improvement over the current sysfs one
liner configuration and with sysfs we can have it reflect any dynamic
change that occurred within the system. So we tend to opt for an
improved sysfs solution, similar to the one I described before.

Any thoughts? Am I completely off the tracks?

Thanks,
Yehuda
