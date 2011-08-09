Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab1HIHvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 03:51:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab1HIHvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 03:51:43 -0400
Message-ID: <4E40E74C.9060902@redhat.com>
Date: Tue, 09 Aug 2011 09:52:44 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Greg KH <greg@kroah.com>, Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, libusb-devel@lists.sourceforge.net,
        Alexander Graf <agraf@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
        hector@marcansoft.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, pbonzini@redhat.com,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
References: <20110610002103.GA7169@xanatos> <4E3B1B7B.2040501@infradead.org> <20110804225603.GA2557@kroah.com> <4E3B9FB4.30709@redhat.com> <20110808175837.GA6398@xanatos>
In-Reply-To: <20110808175837.GA6398@xanatos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/08/2011 07:58 PM, Sarah Sharp wrote:
> On Fri, Aug 05, 2011 at 09:45:56AM +0200, Hans de Goede wrote:
>> Hi,
>>
>> On 08/05/2011 12:56 AM, Greg KH wrote:
>>> On Thu, Aug 04, 2011 at 07:21:47PM -0300, Mauro Carvalho Chehab wrote:
>> I think it is important to separate oranges from apples here, there are
>> at least 3 different problem classes which all seem to have gotten thrown
>> onto a pile here:
>>
>> 1) The reason Mauro suggested having some discussion on this at the
>> USB summit is because of a discussion about dual mode cameras on the
>> linux media list.
> ...
>> 3) Re-direction of usb devices to virtual machines. This works by using
>> the userspace usbfs interface from qemu / vmware / virtualbox / whatever.
>> The basics of this work fine, but it lacks proper locking / safeguards
>> for when a vm takes over a usb device from the in kernel driver.
>
> Hi Hans and Mauro,
>
> We have do room in the schedule for the USB mini-summit for this
> discussion, since the schedule is still pretty flexible.  The
> preliminary schedule is up here:
>
> http://userweb.kernel.org/~sarah/linuxcon-usb-minisummit.html
>
> I think it's best to discuss the VM redirection in the afternoon when
> some of the KVM folks join us after Hans' talk on USB redirection over
> the network.
>

That seems best to me too. I'm available at both proposed time slots,
and I would like to join both discussions.

> It sounds like we need a separate topic for the dual mode cameras and TV
> tuners.  Mauro, do you want to lead that discussion in the early morning
> (in a 9:30 to 10:30 slot) or in the late afternoon (in a 15:30 to 16:30
> slot)?  I want to be sure we have all the video/media developers who are
> interested in this topic present, and I don't know if they will be going
> to the KVM forum.

I would really like to see the dual mode camera and TV tuner discussion
separated. They are 2 different issues AFAIK.

1) Dual mode cameras:

In the case of the dual mode camera we have 1 single device (both at
the hardware level and at the logical block level), which can do 2 things,
but not at the same time. It can stream live video data from a sensor,
or it can retrieve earlier taken pictures from some picture memory.

Unfortunately even though these 2 functions live in a single logical block,
historically we've developed 2 drivers for them. This leads to fighting
over device ownership (surprise surprise), and to me the solution is
very clear, 1 logical block == 1 driver.

2) Tv tuners:

Here we have a bunch of logical blocks, each with their own driver
(and not 2 drivers for one block), which together form not 1 but 2
video pipelines, typically one pipeline for analog TV, and one
for DVB. The problem here is some blocks are shared between the
2 pipelines.

The solution here, at least to me, is clear too, we need some way
of claiming/locking the pipeline blocks. If pipe1 starts streaming
video data it locks all the blocks it uses. If some app then tries
to use pipe2 (and thus for example tune the tuner to a different
frequency), it will fail with -EBUSY when pipe2 tries to take the
tuner lock and gets told it is in use.

Regards,

Hans
