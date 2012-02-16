Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab2BPNWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:22:55 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:48425 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2BPNWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:22:54 -0500
Message-ID: <4F3D032B.6090700@monstr.eu>
Date: Thu, 16 Feb 2012 14:22:51 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: monstr@monstr.eu
CC: Ohad Ben-Cohen <ohad@wizery.com>, LKML <linux-kernel@vger.kernel.org>,
        John Williams <john.williams@petalogix.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "Grosen, Mark" <mgrosen@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: remoteproc: Load coprocessor code to the specific main memory
 location
References: <4F1EE861.4030405@monstr.eu> <CAK=Wgba5kT8AwLtuHyosucYnWf-EA+xpE1kzmssfhSC7ZXQA=g@mail.gmail.com> <4F1FF870.3000105@monstr.eu> <CAK=WgbZwaxMPsMiNcq5yFvBLrcODqGgDT6b=mmQ91JBVtTEyXA@mail.gmail.com> <4F200F64.9060203@monstr.eu> <CAK=WgbZDADRf1OF=uWbbsF+t2dx36tqj=kRftn5nd4RA7DtEnA@mail.gmail.com> <4F212E9E.9060807@monstr.eu> <CAK=WgbYMBDp3Qm8TErNrnDwn2ZTFt62+OuyyQvVE-jrnNsL6kg@mail.gmail.com> <4F391C1D.9020402@monstr.eu> <CAK=WgbYn6hrS4YLEdfp=0jSEfEwy-HkJmt5S06_j6gZFf0UTmQ@mail.gmail.com> <4F3BA962.9040109@monstr.eu> <4F3BC30A.4030301@monstr.eu> <4F3CC899.4070302@monstr.eu> <CAK=WgbaRF-L7M3VMZQdqFLUFOJuwFVkBH1hUNuJ51kSrzkaVjA@mail.gmail.com> <4F3CFFAD.9030402@monstr.eu>
In-Reply-To: <4F3CFFAD.9030402@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Simek wrote:
> Ohad Ben-Cohen wrote:
>> On Thu, Feb 16, 2012 at 10:12 AM, Michal Simek <monstr@monstr.eu> wrote:
>>> I should be more specific. Can you point me to remoteproc code which 
>>> publish
>>> remote service based on them Linux rpmsg driver will be probed? It is 
>>> rtos
>>> part of code.
>>> In your ELCE presentation is called rpmsg-client-sample service.
>>
>> Sorry for the late response (I'm in ELC).
>>
>> Yes, use the client sample (which is part of the submitted patch set)
>> and not the omx/server samples (which are public, but were never
>> submitted nor cleaned up).
> 
> Client sample is clear because it is probed when services are published.
> 
>>
>> The channels are created dynamically: the rpmsg bus designates address
>> 53 for a name service, which listens to channel creation/removal
>> announcements coming from the remote processor. Take a look in
>> virtio_rpmsg_bus.c and you'll immediately see it.
> 
> I see that values but I can't see how rtos should send that messages.
> 
> Have checked both vrings - one for rx and one for tx. They are
> initialized correctly on addresses I like.
> 
> (gdb) x /80x 0xe1100000
> 0xe1100000:     0x31140000      0x00000000      0x00000200      0x00010002
> 0xe1100010:     0x31140200      0x00000000      0x00000200      0x00020002
> 0xe1100020:     0x31140400      0x00000000      0x00000200      0x00030002
> 0xe1100030:     0x31140600      0x00000000      0x00000200      0x00040002
> 0xe1100040:     0x31140800      0x00000000      0x00000200      0x00050002
> 
> (gdb) x /80x 0xe1104000
> 0xe1104000:     0x00000000      0x00000000      0x00000000      0x00010000
> 0xe1104010:     0x00000000      0x00000000      0x00000000      0x00020000
> 0xe1104020:     0x00000000      0x00000000      0x00000000      0x00030000
> 0xe1104030:     0x00000000      0x00000000      0x00000000      0x00040000
> 0xe1104040:     0x00000000      0x00000000      0x00000000      0x00050000
> 0xe1104050:     0x00000000      0x00000000      0x00000000      0x00060000
> 0xe1104060:     0x00000000      0x00000000      0x00000000      0x00070000
> 
> 
> 
> rtos can handle kick from Linux
> Linux is able to catch kick from freertos and run rproc_vg_interrupt
> 
>  From code I see that in rpmsg_probe function is virtqueue_kick which 
> means sending
> kick to rtos. Then rtos can send the message.
> 
> 
> Above is condition "if (virtio_has_feature(vdev, VIRTIO_RPMSG_F_NS))" 
> which is failing for me.
> Not sure if is correct.
> 
> I am still not sure how to propagate that messages from rtos side.
> In TI software it is in NameMap.c file which calls MessageQCopy_send 
> function with address 53(which fits).
> If I look at that function you copy data to msg->payload, setup data 
> length, dstAddr is 53, srcAddr is don't know yet,
> flag is 0, reserverd is 0 then you call VirtQueue_addUsedBuf and kick.
> 
> How does look like that structure for vring channels? It is probably 
> mapped any structure. Can you point me which one?
> Channel description is rpmsg_channel_info struct.

ok on that addresses above is mapped vring_desc structure. I expect that
addr is address to any memory location when data are places. Next is filled
by init because of ring buffer. What flags should be used? And what is data structure?

struct vring_desc {
	/* Address (guest-physical). */
	__u64 addr;
	/* Length. */
	__u32 len;
	/* The flags as indicated above. */
	__u16 flags;
	/* We chain unused descriptors via this, too */
	__u16 next;
};

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
