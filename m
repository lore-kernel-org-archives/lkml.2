Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab0LDGw2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 01:52:28 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41867 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab0LDGw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 01:52:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OzqkoQpkoAvu/2fgL3mg6pFrfJ1re5YTWbxbfd8OpiOhXBhmcgfDcKgD3qWhOOHWxW
         SS5WT4uq+e4s8S+6gIvlAcWW6Y7UJ70kO7IjYxM4lUqhxeZvi2akolFGNJEC8AS6ZvwM
         P+66Tu8oaDi1tZiVF6sel0ThgREmD+pFrQMV0=
MIME-Version: 1.0
In-Reply-To: <201011261224.59490.arnd@arndb.de>
References: <F45880696056844FA6A73F415B568C6953604E802E@EXDCVYMBSTM006.EQ1STM.local>
	<201011251747.48365.arnd@arndb.de>
	<C832F8F5D375BD43BFA11E82E0FE9FE0082586F430@EXDCVYMBSTM005.EQ1STM.local>
	<201011261224.59490.arnd@arndb.de>
Date: Sat, 4 Dec 2010 16:52:25 +1000
Message-ID: <AANLkTik1oVf6Xdt43csTByTu3uLOimd8zTBzwTrFFBDd@mail.gmail.com>
Subject: Re: [PATCH 09/10] MCDE: Add build files and bus
From: Dave Airlie <airlied@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Marcus LORENTZON <marcus.xm.lorentzon@stericsson.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jimmy RUBIN <jimmy.rubin@stericsson.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Dan JOHANSSON <dan.johansson@stericsson.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>> > Having the kms/fb/v4l2 drivers on top definitely makes sense, so
>> > these should all be able to be standalone loadable modules.
>> > I do not understand why you have a v4l2 driver at all, or why
>> > you need both fb and kms drivers, but that is probably because
>> > of my ignorance of display device drivers.
>>
>> All APIs have to be provided, these are user space API requirements.
>> KMS has a generic FB implementation. But most of KMS is modeled by
>> desktop/PC graphics cards. And while we might squeeze MCDE in to look
>> like a PC card, it might also just make things more complex and
>> restrict us to do things not possible in PC architecture.
>
> Ok, so you have identified a flaw with the existing KMS code. You should
> most certainly not try to make your driver fit into the flawed model by
> making it look like a PC. Instead, you are encouraged to fix the problems
> with KMS to make sure it can also meet your requirements. The reason
> why it doesn't do that today is that all the existing users are PC
> hardware and we don't build infrastructure that we expect to be used
> in the future but don't need yet. It would be incorrect anyway.
>
> Can you describe the shortcomings of the KSM code? I've added the dri-devel
> list to Cc, to get the attention of the right people.

I'm not sure I've a full understanding of what this bus is all about,
but I can't see
why it can't fit inside KMS, with maybe a V4L bolted on. The whole
point of KMS is to provide a consistent userspace
interface for describing the graphics hardware in enough detail that
userspace can use it, but without giving it all the gorey details.

So we've reduced the interface to crtc/encoder/connectors as the base
level objects at the interface, internally drivers can and do have
extra layers, but usually no need to show this to userspace.

KMS at the moment doesn't really handle dynamic hotplug of new crtcs
connectors etc, but I'm not sure that is needed here.

It sounds like you just have some embedded building blocks you want to
put together on a design by design basis, please correct me if I'm
wrong.

Dave.


>
>> Alex Deucher noted in a previous post that we also have the option of
>> implementing the KMS ioctls. We are looking at both options. And having
>> our own framebuffer driver might make sense since it is a very basic
>> driver, and it will allow us to easily extend support for things like
>> partial updates for display panels with on board memory. These panels
>> with memory (like DSI command mode displays) is one of the reasons why
>> KMS is not the perfect match. Since we want to expose features available
>> for these types of displays.
>
> Ok.
>
>> > > > From what I understood so far, you have a single multi-channel
>> > display
>> > > > controller (mcde_hw.c) that drives the hardware.
>> > > > Each controller can have multiple frame buffers attached to it,
>> > which
>> > > > in turn can have multiple displays attached to each of them, but
>> > your
>> > > > current configuration only has one of each, right?
>> > >
>> > > Correct, channels A/B (crtcs) can have two blended "framebuffers"
>> > plus
>> > > background color, channels C0/C1 can have one framebuffer.
>> >
>> > We might still be talking about different things here, not sure.
>>
>> In short,
>> KMS connector = MCDE port
>> KMS encoder = MCDE channel
>> KMS crtc = MCDE overlay
>
> Any chance you could change the identifiers in the code for this
> without confusing other people?
>
>> > Looking at the representation in sysfs, you should probably aim
>> > for something like
>> >
>> > /sys/devices/axi/axi0/mcde_controller
>> >                               /chnlA
>> >                                       /dspl_crtc0
>> >                                               /fb0
>> >                                               /fb1
>> >                                               /v4l_0
>> >                                       /dspl_dbi0
>> >                                               /fb2
>> >                                               /v4l_1
>> >                               /chnlB
>> >                                       /dspl_ctrc1
>> >                                               /fb3
>> >                               /chnlC
>> >                                       /dspl_lcd0
>> >                                               /fb4
>> >                                               /v4l_2
>> >
>> > Not sure if that is close to what your hardware would really
>> > look like. My point is that all the objects that you are
>> > dealing with as a device driver should be represented hierarchically
>> > according to how you probe them.
>>
>> Yes, mcde_bus should be connected to mcde, this is a bug. The display
>> drivers will placed in this bus, since this is where they are probed
>> like platform devices, by name (unless driver can do MIPI standard
>> probing or something). Framebuffers/V4L2 overlay devices can't be
>> put in same hierarchy, since they have multiple "parents" in case
>> the same framebuffer is cloned to multiple displays for example.
>> But I think I understand your more general point of sysfs representing
>> the "real" probe hierarchy. And this is something we will look at.
>
> Ok. If your frame buffers are not children of the displays, they should
> however be children of the controller:
>
> .../mcde_controller/
>        /chnlA/
>                /displ_crtc0
>                /displ_dbi0
>        /chnlB/
>                dspl_crtc1
>        /fb0
>        /fb1
>        /fb2
>        /v4l_0
>        /v4l_1
>
> Does this fit better?
>
>> > Assuming the structure above is correct and you cannot probe
>> > any of this by looking at registers, you would put a description
>> > of it into the a data structure (ideally a flattened device tree
>> > or a section of one) and let the probing happen:
>> >
>> > * The axi core registers an mcde controller as device axi0.
>> > * udev matches the device and loads the mcde hw driver from
>> >   user space
>>
>> We are trying to avoid dynamic driver loading and udev for platform
>> devices to be able to show application graphics within a few seconds
>> after boot.
>
> That is fine, you don't need to do that for products. However, it
> is valuable to be able to do it and to think of it in this way.
> When you are able to have everything modular, it is much easier to
> spot layering violations and you can much easier define the object
> life time rules.
>
> Also, for the general case of building a cross-platform kernel,
> you want to be able to use modules for everything. Remember that
> we are targetting a single kernel binary that can run on multiple
> SoC families, potentially with hundreds of different boards.
>
>> > * the hw driver creates a device for each channel, and passes
>> >   the channel specific configuration data to the channel device
>>
>> We have to migrate displays in runtime between different channels
>> (different use cases and different channel features), we don't want
>> to model displays as probed beneath the channel. Maybe the
>> port/connector could be a device. But that code is so small, so it
>> might just add complexity to visualize sysfs hierarchy.
>> What do you think?
>
> This makes it pretty obvious that the channel should not be a
> device, but rather something internal to the dss or hw module.
>
> What is the relation between a port/connector and a display?
> If it's 1:1, it should be the same device.
>
>> > * the dss driver gets loaded through udev and matches all the
>> >   channels
>> > * the dss driver creates the display devices below each channel,
>> >   according to the configuration data it got passed.
>>
>> "All" display devices need static platform_data from
>> mach-ux500/board-xx.c. This is why we have the bus,
>> to bind display dev and driver.
>
> You don't need to instantiate the device from the board though,
> just provide the data. When you add the display specific data
> to the dss data, the dss can create the display devices:
>
> static struct mcde_display_data mcde_displays[2] = {
> {
>        ...
> }, {
>        ...
> },
> };
>
> static struct mcde_dss_data {
>        int num_displays;
>        struct mcde_display_data *displays;
> } my_dss = {
>        .num_displays = 2,
>        .displays = &mcde_displays;
> };
>
> The mcde_dss probe function then takes the dss_data and iterates
> the displays, creating a new child device for each.
>
>> > * The various display drivers get loaded through udev as needed
>> >   and match the display devices
>> > * Each display device driver initializes the display and creates
>> >   the high-level devices (fb and v4l) as needed.
>>
>> This is setup by board/product specific code. Display drivers
>> just enable use of the HW, not defining how the displays are
>> used from user space.
>
> Right, this also gets obsolete, since as you said an fb cannot be
> the child of a display.
>
>> > * Your fb and v4l highlevel drivers get loaded through udev and
>> >   bind to the devices, creating the user space device nodes
>> >   through their subsystems.
>> >
>> > Now this would be the most complex scenerio that hopefully is
>> > not really needed, but I guess it illustrates the concept.
>> > I would guess that you can actually reduce this significantly
>> > if you do not actually need all the indirections.
>> >
>> > Some parts could also get simpler if you change the layering,
>> > e.g. by making the v4l and fb drivers library code and having
>> > the display drivers call them, rather than have the display
>> > drivers create the devices that get passed to upper drivers.
>>
>> Devices are static from mach-ux500/board-xx. And v4l2/fb setup
>> is board/product specific and could change dynamically.
>
> Not sure how the fb setup can be both board specific and dynamic.
> If it's statically defined per board, it should be part of the
> dss data, and dss can then create the fb devices. If it's completely
> dynamic, it gets created through user space interaction anyway.
>
>> > > > The frame buffer device also looks weird. Right now you only seem
>> > > > to have a single frame buffer registered to a driver in the same
>> > > > module. Is that frame buffer not dependent on a controller?
>> > >
>> > > MCDE framebuffers are only depending on MCDE DSS. DSS is the API that
>> > > will be used by all user space APIs so that we don't have to
>> > duplicate
>> > > the common code. We are planning mcde_kms and mcde_v4l2 drivers on
>> > top
>> > > of MCDE DSS(=Display Sub System).
>> >
>> > My impression was that you don't need a frame buffer driver if you have
>> > a kms driver, is this wrong?
>>
>> No, see above. Just that we have mcde dss to support multiple user
>> space apis by customer request. Then doing our own fb on top of
>> that is very simple and adds flexibility.
>
> This sounds like an odd thing for a customer to ask for ;-)
>
> In my experience customers want to solve specific problems like
> everyone else, they have little interest in adding complexity
> for the sake of it. Is there something wrong with one of the
> interfaces? If so, it would be better to fix that than to add
> an indirection to allow more of them!
>
>> > What does the v4l2 driver do? In my simple world, displays are for
>> > output
>> > and v4l is for input, so I must have missed something here.
>>
>> Currently nothing, since it is not finished. But the idea (and
>> requirement) is that normal graphics will use framebuffer and
>> video/camera overlays will use v4l2 overlays. Both using same
>> mcde channel and display. Some users might also configure their
>> board to use two framebuffers instead. Or maybe only use KMS etc ...
>
> I still don't understand, sorry for being slow. Why does a camera
> use a display?
>
>        Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
