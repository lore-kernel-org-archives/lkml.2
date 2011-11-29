Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab1K2V77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 16:59:59 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:35160 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1K2V75 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 16:59:57 -0500
Subject: Re: MFD: core assumes that all children are platform devices
References: <2F9D884C-6B95-4F81-8445-8056676B28D8@sonatest.com> <20111129185746.GA23986@ericsson.com>
From: =?utf-8?Q?Jean-Fran=C3=A7ois_Dagenais?= <jeff.dagenais@gmail.com>
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20111129185746.GA23986@ericsson.com>
Message-Id: <F9D1750C-7D71-46D1-BE90-6D44CA26CB4F@gmail.com>
Date: Tue, 29 Nov 2011 16:40:52 -0500
Cc: =?utf-8?Q?Jean-Fran=C3=A7ois_Dagenais?= <dagenaisj@sonatest.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Mime-Version: 1.0 (1.0)
X-Mailer: iPod Mail (9A405)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sent from my iPod

On 2011-11-29, at 1:57 PM, Guenter Roeck <guenter.roeck@ericsson.com> wrote:

> On Mon, Nov 28, 2011 at 11:23:00AM -0500, Jean-François Dagenais wrote:
>> Hi,
>> 
>> I have a pci driver that registers with UIO for it's operations. As a consequence, the pci device
>> instance has a child device of class uio.
>> 
>> My driver also declares a ds1wm instance that has it's register interface at an offset in BAR0
>> of the pci device, as an MFD cell.
>> 
>> When I call mfd_remove_devices, MFD proceeds to enumerate ALL the parent device's chilren
>> and assumes that they are MFD cells, and thus platform_device, which is not true in my case.
>> (...uio is a child of the parent pci device)
>> 
>> I had (luckily or unluckily) not seen signs of this broken assumption on certain setups I have
>> used, but in my current setup, this page-faults every time now.
>> 
>> This is a major thing and I have not found the assumption documented anywhere.
>> 
>> I could first declare a new child device on my pci device and then declare it as the parent to
>> the mfd cells...
>> 
> I had the same problem, with a Multi-function USB device. Took me a while to figure out that
> mfd_remove_devices() removed the USB child devices when I used the USB device as MFD parent device.
> 
> My solution was to do what you suggested - my MFD probe function now creates a platform device
> to be used as MFD parent device. Works nicely, it doesn't require much additional code,
> and I think it is cleaner than other possible solutions (at least the ones I came up with).
> We'll see how it flies with the MFD and USB maintainers once I submit the patch ;).
> 
>> Or, is there a way for the mfd-core, as it's doing the "for each child device", to recognize
>> non-MFD-cell children and skip them?
>> 
> Looking at your proposed patch, I personally prefer my solution.
I'd like to see your patch... You mean to say that you changed your driver, or the mfd core? If it's your driver's probe function, then the problem still exists out there and imposing an extra device alloc simply as a container is in my opinion both a hassle and a waste of resource. At the very least, this task should be done by the mfd core. It still seems pointless though, when you can filter out which children are the ones to remove, like what my patch does.
> Of course it would be nice
> if it was documented that MFD parent devices MUST be dedicated (platform) devices and must not
> have any non-MFD child devices. This would be a simple documentation patch and avoid making
> assumptions on MFD child device removal.
Well the patch uses already present assumptions, it just checks
for them.

What's good is that my patch doesn't prevent you from using a container platform device either.

We'll see what Samuel thinks...
> 
> Guenter 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Thanks for your response!