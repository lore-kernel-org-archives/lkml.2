Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab1LALFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 06:05:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab1LALE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 06:04:58 -0500
Message-ID: <4ED75F53.30709@redhat.com>
Date: Thu, 01 Dec 2011 09:04:51 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: HoP <jpetrous@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <4ED6C5B8.8040803@linuxtv.org>
In-Reply-To: <4ED6C5B8.8040803@linuxtv.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-11-2011 22:09, Andreas Oberritter wrote:
> On 30.11.2011 22:38, HoP wrote:
>> Hi folks.
>>
>> I need to warn you that my mail is a bit little longer then I would like
>> to be.But I'm not able to ask my question without some
>> background information.
>>
>> On June 19th, I was sending the driver to the Linux-media
>> mailing list. Original announcement is there:
>>
>> http://www.spinics.net/lists/linux-media/msg34240.html
>>
>> One would say that the code describes very well what it does = adds
>> virtual DVB device. To be more clear on it I have even done some
>> small picture:
>>
>> http://www.nessiedvb.org/wiki/doku.php?id=vtuner_bigpicture
>>
>> I was hoping to get any feedback regarding code implementation.
>> It was my first code for the kernel and I felt very well that some
>> part can be done better or even simpler.
>>
>> What really surprised me badly was that when I read all 54 responses
>> I have counted only two real technical answers!!! All rest were about
>> POLITICAL issues - code was NACKed w/o any technical discussion.
>> Because of fear of possible abusing of driver.
>>
>> I didn't know that there existed very big movement against such
>> code in dvb-core subsystem before.
>>
>> I have one big problem with it. I can even imagine that some "bad guys"
>> could abuse virtual driver to use it for distribution close-source drivers
>> in the binary blobs. But is it that - worrying about bad boys abusing -
>> the sufficient reason for such aggressive NACK which I did? Then would
>> be better to remove loadable module API fully from kernel. Is it the right way?
>>
>> Please confirm me that worrying about abusive act is enough to NACK
>> particular driver. Then I may be definitely understand I'm doing something
>> wrong and will stay (with such enemy driver) out of tree.
>>
>> I can't understand that because I see very similar drivers in kernel for ages
>> (nbd, or even more similar is usbip) and seems they don't hamper to anybody.
>>
>> I would like to note that I don't want to start any flame-war, so very short
>> answer would be enough for me.,
>
> Hello Honza,
>
> I still support the inclusion of your virtual DVB device driver, once
> the technical issues[1] are solved (design clean interface based on
> DVBv5 etc.). Mauro promised to consider it for inclusion then[2].

What I said on that time is that  a virtual driver to run at the OS on a
VM machine (kvm or xen) that would export the DVB devices that are available
at the OS at the local host or on a remote host running the spice client
could be an interesting contribution, and would fit into kernelspace.

I'm not sure about such need nowadays, as very recent patches added on kvm
are now allowing to use USB 2.0 video devices on it (I tested and used it
a few days ago - it seems to be working at least with the devices I tested),
and PCI passthrough is already there also. Yet, a DVB-optimized passthrough
module there would likely perform better than just exporting the physical
device to the VM.

The driver, as proposed, is not really a driver, as it doesn't support any
hardware. The kernel driver would be used to just copy data from one userspace
application to the other. The same result could be obtained in userspace,
by implementing a library. Such library could even use LD_PRELOAD to support
binary only applications, like what libv4l does. In terms of performance,
such library would probably perform better than a kernel driver, as there's
no need to do context switching for each call, and no need to talk with a
device (where kernel outperforms userspace). Also, depending on how such library
is implemented, double buffering might be avoided.

So, from architectural POV, this code should be written as an userspace library.
BTW, alsa also came with the same results, years ago, as audio remote
streaming is supported via userspace tools, like pulseaudio.

> A quick view at your code indicates that this clean-up hasn't happened
> yet, e.g. there are hacks to support DVB-S2 over DVBv3 which aren't
> necessary anymore with v5.
>
> Regarding the kernellabs.com people[3] lobbying against your
> contribution: Don't give up! If all attempts of merging your work
> through the media subsystem are failing, try convincing some major
> distributions to include your work. This would make their arguments
> meaningless. On the long run, good code is likely to win over politics.
>
> Regards,
> Andreas
>
> [1] http://www.spinics.net/lists/linux-media/msg34349.html
> [2] http://www.spinics.net/lists/linux-media/msg34352.html

> [3] http://www.kernellabs.com/blog/?page_id=6
> [4]
> http://code.google.com/p/vtuner/source/browse/vtunerc_proxyfe.c?repo=linux-driver#177
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

