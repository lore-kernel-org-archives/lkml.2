Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352Ab2JKUtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:49:13 -0400
Received: from ozlabs.org ([203.10.76.45]:37246 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759263Ab2JKUtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:49:09 -0400
From: Rusty Russell <rusty@ozlabs.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Cc: KY Srinivasan <kys@microsoft.com>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel\@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf\@aepfle.de" <olaf@aepfle.de>,
        "apw\@canonical.com" <apw@canonical.com>,
        "andi\@firstfloor.org" <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] Drivers: hv: Add Hyper-V balloon driver
In-Reply-To: <20121010165616.ffb38603.akpm@linux-foundation.org>
References: <1349654347-18337-1-git-send-email-kys@microsoft.com> <1349654386-18378-1-git-send-email-kys@microsoft.com> <1349654386-18378-2-git-send-email-kys@microsoft.com> <20121009124449.f54bf8cb.akpm@linux-foundation.org> <426367E2313C2449837CD2DE46E7EAF930A33CC4@SN2PRD0310MB382.namprd03.prod.outlook.com> <20121009181458.e59e7094.akpm@linux-foundation.org> <5076060D.1030101@goop.org> <20121010165616.ffb38603.akpm@linux-foundation.org>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 11 Oct 2012 18:35:45 +1030
Message-ID: <87r4p577s6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
> On Wed, 10 Oct 2012 16:34:37 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>> On 10/09/2012 06:14 PM, Andrew Morton wrote:
>> > On Wed, 10 Oct 2012 00:09:12 +0000 KY Srinivasan <kys@microsoft.com> wrote:
>> >
>> >>>> +		if (!pg) {
>> >>>> +			*alloc_error = true;
>> >>>> +			return i * alloc_unit;
>> >>>> +		}
>> >>>> +
>> >>>> +		totalram_pages -= alloc_unit;
>> >>> Well, I'd consider totalram_pages to be an mm-private thing which drivers
>> >>> shouldn't muck with.  Why is this done?
>> >> By modifying the totalram_pages, the information presented in /proc/meminfo
>> >> correctly reflects what is currently assigned to the guest (MemTotal).
>> > eh?  /proc/meminfo:MemTotal tells you the total memory in the machine. 
>> > The only thing which should change it after boot is memory hotplug. 
>> [...]
>> > Why on earth do balloon drivers do this?  If the amount of memory which
>> > is consumed by balloons is interesting then it should be exported via a
>> > standalone metric, not by mucking with totalram_pages.
>> 
>> Balloon drivers are trying to fake a form of page-by-page memory
>> hotplug.  When they allocate memory from the kernel, they're actually
>> giving the pages back to the hypervisor to redistribute to other
>> guests.  They reduce totalram_pages to try and reflect that the memory
>> is no longer the kernel (in Xen, at least, the pfns will no longer have
>> any physical page underlying them).
>> 
>> I agree this is pretty ugly; it would be nice to have some better
>> interface to indicate what's going on.  At one point I tried to use the
>> memory hotplug interfaces for larger-scale dynamic transfers of memory
>> between a domain and the host, but when I last looked at it, it was too
>> coarse grained and heavyweight to replace the balloon mechanism.
>> 
>
> urgh.
>
> I suppose the least we can do here would be to stop directly dinking
> with totalram_pages and create some sort of interface for this
> operation.  That interface would run the memory hotplug notifier so
> that code which cares about changes in the amount of physical memory
> can take appropriate steps.  The implications would be that the balloon
> drivers would need to call this interface at low frequency (ie: batch
> the pages) and in some reasonably lock-free context.
>
> I guess that's solving a non-problem at this stage.

Yep.  drivers/virtio/virtio_balloon manipulates it too.  This, it's best
practice!

Cheers,
Rusty.
