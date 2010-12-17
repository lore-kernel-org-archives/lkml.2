Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab0LQLXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 06:23:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:53587 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab0LQLXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 06:23:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 09/10] MCDE: Add build files and bus
Date: Fri, 17 Dec 2010 12:22:54 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1+; KDE/4.5.1; x86_64; ; )
Cc: Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
        Jimmy RUBIN <jimmy.rubin@stericsson.com>,
        Dan JOHANSSON <dan.johansson@stericsson.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <F45880696056844FA6A73F415B568C6953604E802E@EXDCVYMBSTM006.EQ1STM.local> <201011261224.59490.arnd@arndb.de> <4D0A59DD.5060707@stericsson.com>
In-Reply-To: <4D0A59DD.5060707@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012171222.55444.arnd@arndb.de>
X-Provags-ID: V02:K0:O8180JJIhJrjlkE1FYsn1rR1Q+5dOhJ2dw9830lE1r1
 zYpOYAXbb3VKPodtbaObhli0iW1LdojdvdE7Us0Zzsn+bOCvqF
 ngfEznu6bRTXS5RVlZXTvbu7Exm9x/Qby00AGo+CtwbzyeCXzU
 ttg5hc7JZyqj3YaOF/hed7gr3zgGxOAQy5MX6cfm/iLhqWQoxS
 HogOG8JgWqZNmGS0eMPvg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 December 2010 19:26:37 Marcus Lorentzon wrote:
> On 11/26/2010 12:24 PM, Arnd Bergmann wrote:
> > [note: please configure your email client properly so it keeps
> > proper attribution of text and and does not rewrap the citations
> > incorrectly. Wrap your own text after 70 characters]
> >    
> I'm now using Thunderbird, please let me know if it's better than my 
> previous webmail client, neither have many features for reply formatting.

Much better now, just remember to leave empty lines around your replies
and to trim the lines that you are not replying to.

> > * When I talk about a bus, I mean 'struct bus_type', which identifies
> >    all devices with a uniform bus interface to their parent device
> >    (think: PCI, USB, I2C). You seem to think of a bus as a specific
> >    instance of that bus type, i.e. the device that is the parent of
> >    all the connected devices. If you have only one instance of a bus
> >    in any system, and they are all using the same driver, do not add
> >    a bus_type for it.
> >    A good reason to add a bus_type would be e.g. if the "display"
> >    driver uses interfaces to the dss that are common among multiple
> >    dss drivers from different vendors, but the actual display drivers
> >    are identical. This does not seem to be the case.
> >    
> Correct, I refer to the device, not type or driver. I used a bus type 
> since it allowed me to setup a default implementation for each driver 
> callback. So all drivers get generic implementation by default, and 
> override when that is not enough. Meybe you have a better way of getting 
> the same behavior.

One solution that I like is to write a module with the common code as
a library, exporting all the default actions. The specific drivers
can then fill their operations structure by listing the defaults
or by providing their own functions to replace them, which in turn
can call the default functions. This is e.g. what libata does.

> > * When you say that the devices are static, I hope you do not mean
> >    static in the C language sense. We used to allow devices to be
> >    declared as "static struct" and registered using
> >    platform_device_register (or other bus specific functions). This
> >    is no longer valid and we are removing the existing users, do not
> >    add new ones. When creating a platform device, use
> >    platform_device_register_simple or platform_device_register_resndata.
> >
> > I'm not sure what you mean with drivers being static. Predefining
> > the association between displays and drivers in per-machine files is
> > fine, but since this is really board specific, it would be better
> > to eventually do this through data passed from the boot loader, so
> > you don't have to have a machine file for every combination of displays
> > that is in the field.
> >    
> I guess you have read the ARM vs static platform_devices. But, yes, I 
> mean in the c-language static sense. I will adopt to whatever Russel 
> King says is The right way in ARM SoCs.

Fair enough. We will have to fix it some day so Greg can go on with
his plan to disallow static devices, but for now I'm not going to
stop you. I would use platform_device_register_simple anyway, but feel
free to do whatever fits your need here.

> We are now taking a step back and start "all over". We were almost as 
> fresh on this HW block as you are now when we started implementing the 
> driver earlier this year. I think all of us benefit from now having a 
> better understanding of customer requirements and the HW itself, there 
> are some nice quirks ;). Anyway, we will restart the patches and RFC 
> only the MCDE HW part of the driver, implementing basic fb support for 
> one display board as you suggested initially. It's a nice step towards 
> making the patches easier to review and give us some time to prepare the 
> DSS stuff. That remake was done today, so I think the patch will be sent 
> out soon. (I'm going on vacation for 3 weeks btw).

Ok, sounds great! I'm also starting a 3 week vacation, but will be at the
Linaro sprint in Dallas.

My feeling now, after understanding about it some more, is that it would
actually be better to start with a KMS implementation instead of a classic
frame buffer. Ideally you wouldn't even need the frame buffer driver or
the multiplexing between the two then, but still get all the benefits
from the new KMS infrastructure.

> > In the future, best plan for how you want to submit the code while
> > you're writing it, instead of as an afterthought. Quite often, the
> > first patch to submit is also one of the early stages of the driver,
> > so there is no need to wait for the big picture before you start
> > submitting. This way, we can work out conceptual mistakes early on,
> > saving a lot of your time, and the reviewer's time as well.
> >    
> This is how we will try to work now that we know how the HW works.

Ok, cool!

> >> DSS give access to all display devices probed on the virtual mcde
> >> dss bus, or platform bus with specific type of devices if you like.
> >> All calls to DSS operate on a display device, like create an
> >> overlay(=framebuffer), request an update, set power mode, etc.
> >> All calls to DSS related to display itself and not only framebuffer
> >> scanout, will be passed on to the display driver of the display
> >> device in question. All calls DSS only related to overlays, like
> >> buffer pointers, position, rotation etc is handled directly by DSS
> >> calling mcde_hw.
> >>
> >> You could see mcde_hw as a physical level driver and mcde_dss closer
> >> to a logical driver, delegating display specific decisions to the
> >> display driver. Another analogy is mcde_hw is host driver and display
> >> drivers are client device drivers. And DSS is a collection of logic
> >> to manage the interaction between host and client devices.
> >>      
> > The way you describe it, I would picture it differently:
> >
> > +----------+ +----+-----+-----+ +-------+
> > | mcde_hw  | | fb | kms | v4l | | displ |
> > +----+----------------------------------+
> > | HW |            mcde_dss              |
> > +----+----------------------------------+
> >
> > In this model, the dss is the core module that everything else
> > links to. The hw driver talks to the actual hardware and to the
> > dss. The three front-ends only talk to the dss, but not to the
> > individual display drivers or to the hw code directly (i.e. they
> > don't use their exported symbols or internal data structures.
> > The display drivers only talk to the dss, but not to the front-ends
> > or the hw drivers.
> >
> > Would this be a correct representation of your modules?
> >    
> Hmm, mcde_hw does not link to dss. It should be FB->DSS->Display 
> driver->MCDE_HW->HW IO (+ DSS->MCDE_HW). My picture is how code should 
> be used. Anything else you find in code is a violation of that layering.

I don't think it makes any sense to have the DSS sit on top of the
display drivers, since that means it has to know about all of them
and loading the DSS module would implicitly have to load all the
display modules below it, even for the displays that are not present.

Moreover, I don't yet see the reason for the split between mcde_hw and
dss. If dss is the only user of the hardware module (aside from stuff
using dss), and dss is written against the hw module as a low-level
implementation, they can simply be the same module.

> > Can you describe the shortcomings of the KSM code? I've added the dri-devel
> > list to Cc, to get the attention of the right people.
> >    
> I will start this work early next year. MCDE DSS refactoring will take 
> KMS into account. Some of the _possible_ short comings (I must say I 
> have not looked into this in any detail yet):
> - 3D HW is bundled with display HW. Makes it harder for us to use 
> different 3D HW with same display HW or the other way around. I would 
> like KMS and "DRM3D" to be more separated. We get DRM 3D drivers from IP 
> vendors, but we still have to expose our own KMS DRM device.

Ok. I'd have to look into this in more detail myself to see how
severe this is, or how to solve it. The problem seems obvious
enough that you should see no resistance to a patch for this.

> The other "issue" is the usual, 3D vendors don't upstream their drivers.
> Which means we have to integrate with drivers not in mainline kernel ...
> and we still want to open all our drivers, even if some external IPs
> don't.

This will be a lot tougher for you. External modules are generally
not accepted as a reason for designing code one way vs. another.
Whatever the solution is, you have to convince people that it would
still make sense if all drivers were part of the kernel itself.
Bonus points to you if you define it in a way that forces the 3d driver
people to put their code under the GPL in order to work with yours ;-)

> - GEM user space buffer API has a security model and IPC sharing not 
> compatible (at first glance and after short discussion with Chris 
> Wilson) with Android (binder fdup) or for protecting buffers from the 
> user. As I understand it correctly, GEM master, once client 
> authenticated, you have access to all buffers.

I have no idea what this means, but I trust that you and others
can come up with a solution.

> - Partial updates, overlay support and pushing any buffer to scanout. 
> Some might be possible with the latest ioctls in KMS, will look at this.

Remember that with ioctls, you can always add new ones if you need
them, though you cannot remove or change them in incompatible ways.

If you need the ioctl commands to do something they can't do today,
try defining new commands in a way that will also work with future
extensions without making the interface more complex than what you
need to do. It takes some experience to get this right and the first
versions will probably get rejected, but that doesn't mean people
are opposed to extending the interface.

> But as I said, I have not had time to look at this yet. Framebuffer was 
> just so much easier to implement and the only customer requirement.

Yes.

> > Ok. If your frame buffers are not children of the displays, they should
> > however be children of the controller:
> >
> > .../mcde_controller/
> >          /chnlA/
> >                  /displ_crtc0
> >                  /displ_dbi0
> >          /chnlB/
> >                  dspl_crtc1
> >          /fb0
> >          /fb1
> >          /fb2
> >          /v4l_0
> >          /v4l_1
> >
> > Does this fit better?
> >
> >    
> Maybe, will try to find a better structure for relations. Not something 
> I've considered before. But I see your point.
> BTW. Can this hierarchy be changed in runtime? When for example one 
> display move from one channel to another. There's a lot of muxing going 
> on in the HW and that is hard to visualize in a static tree structure. A 
> flat structure might be better then.

It can change at runtime in theory, but that's highly discouraged
because it tends to break user space programs working with the
path names.

Using a flatter structure indeed sounds better in that case,
showing only the displays.

> > What is the relation between a port/connector and a display?
> > If it's 1:1, it should be the same device.
> >
> >    
> A port is product specific display device data. Just a structure used to 
> describe the MCDE<->Display/panel physical connection. The display 
> device resource is you like. Port data describe the SoC-wires-display 
> connection. Where are the display platform device struct describe the on 
> SoC display configuration. Like initial color depth, what MCDE 
> channel/encoder to use etc.

It still sounds to me like it only needs to be one device for
the display then. The device can have properties for the wires and
for the settings, but since it's a one-to-one relationship, I would
represent it as a single object in the device tree.

> >>> * the dss driver gets loaded through udev and matches all the
> >>>    channels
> >>> * the dss driver creates the display devices below each channel,
> >>>    according to the configuration data it got passed.
> >>>        
> >> "All" display devices need static platform_data from
> >> mach-ux500/board-xx.c. This is why we have the bus,
> >> to bind display dev and driver.
> >>      
> > You don't need to instantiate the device from the board though,
> > just provide the data. When you add the display specific data
> > to the dss data, the dss can create the display devices:
> >
> > static struct mcde_display_data mcde_displays[2] = {
> > {
> >          ...
> > }, {
> >          ...
> > },
> > };
> >
> > static struct mcde_dss_data {
> >          int num_displays;
> >          struct mcde_display_data *displays;
> > } my_dss = {
> >          .num_displays = 2,
> >          .displays =&mcde_displays;
> > };
> >
> > The mcde_dss probe function then takes the dss_data and iterates
> > the displays, creating a new child device for each.
> >
> >    
> To me this is exactly the same as the static devices we now have. Same 
> amount of static data. And if you don't register the device, I don't see 
> the difference. I will follow the ARM discussions on c-static platform 
> devices and adopt.

There is a problem in the object life time rules if you instantiate
all the devices at boot time: It means that the devices lower in the
hierarchy can get used before the parent devices are fully initialized.

You can do the main mcde device as a static platform device if you
insist, but registering a hierarchy of static platform devices
is asking for trouble.

> >> Devices are static from mach-ux500/board-xx. And v4l2/fb setup
> >> is board/product specific and could change dynamically.
> >>      
> > Not sure how the fb setup can be both board specific and dynamic.
> > If it's statically defined per board, it should be part of the
> > dss data, and dss can then create the fb devices. If it's completely
> > dynamic, it gets created through user space interaction anyway.
> >
> >    
> The default is setup dynamically by static calls in board init code. 
> User space will then be able to change this config. This is one of the 
> features that is not heavily used and might get removed. Like Multihead 
> framebuffers or framebuffer cloning to multiple displays. This might be 
> controlled using KMS instead once adopted.

Ok, makes sense.

> >> No, see above. Just that we have mcde dss to support multiple user
> >> space apis by customer request. Then doing our own fb on top of
> >> that is very simple and adds flexibility.
> >>      
> > This sounds like an odd thing for a customer to ask for ;-)
> >
> > In my experience customers want to solve specific problems like
> > everyone else, they have little interest in adding complexity
> > for the sake of it. Is there something wrong with one of the
> > interfaces? If so, it would be better to fix that than to add
> > an indirection to allow more of them!
> >
> >    
> Ok, different customers use different platforms that have different 
> requirements. Read MeeGo vs. Android.

I see. This needs to be solved more generally though, since everyone
has the same requirements. If we conclude that we should do everything
with KMS infrastructure, we should also make sure that it works
for all the relevant users. That might be something worth discussing
in the Linaro graphics workgroup as well.

> >>> What does the v4l2 driver do? In my simple world, displays are for
> >>> output
> >>> and v4l is for input, so I must have missed something here.
> >>>        
> >> Currently nothing, since it is not finished. But the idea (and
> >> requirement) is that normal graphics will use framebuffer and
> >> video/camera overlays will use v4l2 overlays. Both using same
> >> mcde channel and display. Some users might also configure their
> >> board to use two framebuffers instead. Or maybe only use KMS etc ...
> >>      
> > I still don't understand, sorry for being slow. Why does a camera
> > use a display?
> >    
> Sorry, camera _application_ use V4L2 overlays for pushing YUV camera 
> preview or video buffers to screen composition in MCDE. V4L2 have output 
> devices too, it's not only for capturing, even if that is what most 
> desktops use it for.

Ok, I'm starting to remember this from the 90's when I used bttv on the
console framebuffer ;-).

Could you simply define a v4l overlay device for every display device,
even if you might not want to use it?
That might simplify the setup considerably.

	Arnd
