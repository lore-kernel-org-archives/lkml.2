Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab1HJUc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 16:32:27 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36335 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab1HJUc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 16:32:26 -0400
Subject: Re: [RFC PATCH]vhost-blk: In-kernel accelerator for virtio block
	device
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Liu Yuan <namei.unix@gmail.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Khoa Huynh <khoa@us.ibm.com>
In-Reply-To: <4E41EAC5.8060001@gmail.com>
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>
	 <CAJSP0QUKz7LFuARF_n2LcBi_uuSzfmkjrWsHAWrXXkEaQJKkEA@mail.gmail.com>
	 <4E325F98.5090308@gmail.com> <4E32F7F2.4080607@us.ibm.com>
	 <4E363DB9.70801@gmail.com> <1312495132.9603.4.camel@badari-desktop>
	 <4E3BCE4D.7090809@gmail.com> <4E3C302A.3040500@us.ibm.com>
	 <4E3F3D4E.70104@gmail.com> <4E3F6E72.1000907@us.ibm.com>
	 <4E3F90E3.9080600@gmail.com> <4E4019E1.2090508@us.ibm.com>
	 <4E41EAC5.8060001@gmail.com>
Content-Type: text/plain
Date: Wed, 10 Aug 2011 13:37:47 -0700
Message-Id: <1313008667.9603.14.camel@badari-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 10:19 +0800, Liu Yuan wrote:
> On 08/09/2011 01:16 AM, Badari Pulavarty wrote:
> > On 8/8/2011 12:31 AM, Liu Yuan wrote:
> >> On 08/08/2011 01:04 PM, Badari Pulavarty wrote:
> >>> On 8/7/2011 6:35 PM, Liu Yuan wrote:
> >>>> On 08/06/2011 02:02 AM, Badari Pulavarty wrote:
> >>>>> On 8/5/2011 4:04 AM, Liu Yuan wrote:
> >>>>>> On 08/05/2011 05:58 AM, Badari Pulavarty wrote:
> >>>>>>> Hi Liu Yuan,
> >>>>>>>
> >>>>>>> I started testing your patches. I applied your kernel patch to 3.0
> >>>>>>> and applied QEMU to latest git.
> >>>>>>>
> >>>>>>> I passed 6 blockdevices from the host to guest (4 vcpu, 4GB RAM).
> >>>>>>> I ran simple "dd" read tests from the guest on all block devices
> >>>>>>> (with various blocksizes, iflag=direct).
> >>>>>>>
> >>>>>>> Unfortunately, system doesn't stay up. I immediately get into
> >>>>>>> panic on the host. I didn't get time to debug the problem. 
> >>>>>>> Wondering
> >>>>>>> if you have seen this issue before and/or you have new patchset
> >>>>>>> to try ?
> >>>>>>>
> >>>>>>> Let me know.
> >>>>>>>
> >>>>>>> Thanks,
> >>>>>>> Badari
> >>>>>>>
> >>>>>>
> >>>>>> Okay, it is actually a bug pointed out by MST on the other 
> >>>>>> thread, that it needs a mutex for completion thread.
> >>>>>>
> >>>>>> Now would you please this attachment?This patch only applies to 
> >>>>>> kernel part, on top of v1 kernel patch.
> >>>>>>
> >>>>>> This patch mainly moves completion thread into vhost thread as a 
> >>>>>> function. As a result, both requests submitting and completion 
> >>>>>> signalling is in the same thread.
> >>>>>>
> >>>>>> Yuan
> >>>>>
> >>>>> Unfortunately, "dd" tests (4 out of 6) in the guest hung. I see 
> >>>>> following messages
> >>>>>
> >>>>> virtio_blk virtio2: requests: id 0 is not a head !
> >>>>> virtio_blk virtio3: requests: id 1 is not a head !
> >>>>> virtio_blk virtio5: requests: id 1 is not a head !
> >>>>> virtio_blk virtio1: requests: id 1 is not a head !
> >>>>>
> >>>>> I still see host panics. I will collect the host panic and see if 
> >>>>> its still same or not.
> >>>>>
> >>>>> Thanks,
> >>>>> Badari
> >>>>>
> >>>>>
> >>>> Would you please show me how to reproduce it step by step? I tried 
> >>>> dd with two block device attached, but didn't get hung nor panic.
> >>>>
> >>>> Yuan
> >>>
> >>> I did 6 "dd"s on 6 block devices..
> >>>
> >>> dd if=/dev/vdb of=/dev/null bs=1M iflag=direct &
> >>> dd if=/dev/vdc of=/dev/null bs=1M iflag=direct &
> >>> dd if=/dev/vdd of=/dev/null bs=1M iflag=direct &
> >>> dd if=/dev/vde of=/dev/null bs=1M iflag=direct &
> >>> dd if=/dev/vdf of=/dev/null bs=1M iflag=direct &
> >>> dd if=/dev/vdg of=/dev/null bs=1M iflag=direct &
> >>>
> >>> I can reproduce the problem with in 3 minutes :(
> >>>
> >>> Thanks,
> >>> Badari
> >>>
> >>>
> >> Ah...I made an embarrassing mistake that I tried to 'free()' an 
> >> kmem_cache object.
> >>
> >> Would you please revert the vblk-for-kernel-2 patch and apply the new 
> >> one attached in this letter?
> >>
> > Hmm.. My version of the code seems to have kzalloc() for used_info. I 
> > don't have a version
> > that is using kmem_cache_alloc(). Would it be possible for you to send 
> > out complete patch
> > (with all the fixes applied) for me to try ? This will avoid all the 
> > confusion ..
> >
> > Thanks,
> > Badari
> >
>
> Okay, please apply the attached patch to the vanilla kernel. :)


It looks like the patch wouldn't work for testing multiple devices.

vhost_blk_open() does
+       used_info_cachep = KMEM_CACHE(used_info, SLAB_HWCACHE_ALIGN |
SLAB_PANIC);

When opening second device, we get panic since used_info_cachep is
already created. Just to make progress I moved this call to
vhost_blk_init().

I don't see any host panics now. With single block device (dd),
it seems to work fine. But when I start testing multiple block
devices I quickly run into hangs in the guest. I see following
messages in the guest from virtio_ring.c:

virtio_blk virtio2: requests: id 0 is not a head !
virtio_blk virtio1: requests: id 0 is not a head !
virtio_blk virtio4: requests: id 1 is not a head !
virtio_blk virtio3: requests: id 39 is not a head !

Thanks,
Badari



