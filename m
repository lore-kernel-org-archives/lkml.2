Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab0LQMDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:03:43 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:51357 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943Ab0LQMDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:03:42 -0500
Message-ID: <4D0B515F.4070500@stericsson.com>
Date: Fri, 17 Dec 2010 13:02:39 +0100
From: Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jimmy RUBIN <jimmy.rubin@stericsson.com>,
        Dan JOHANSSON <dan.johansson@stericsson.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 09/10] MCDE: Add build files and bus
References: <F45880696056844FA6A73F415B568C6953604E802E@EXDCVYMBSTM006.EQ1STM.local> <201011261224.59490.arnd@arndb.de> <4D0A59DD.5060707@stericsson.com> <201012171222.55444.arnd@arndb.de>
In-Reply-To: <201012171222.55444.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2010 12:22 PM, Arnd Bergmann wrote:
>>> * When I talk about a bus, I mean 'struct bus_type', which identifies
>>>     all devices with a uniform bus interface to their parent device
>>>     (think: PCI, USB, I2C). You seem to think of a bus as a specific
>>>     instance of that bus type, i.e. the device that is the parent of
>>>     all the connected devices. If you have only one instance of a bus
>>>     in any system, and they are all using the same driver, do not add
>>>     a bus_type for it.
>>>     A good reason to add a bus_type would be e.g. if the "display"
>>>     driver uses interfaces to the dss that are common among multiple
>>>     dss drivers from different vendors, but the actual display drivers
>>>     are identical. This does not seem to be the case.
>>>
>>>        
>> Correct, I refer to the device, not type or driver. I used a bus type
>> since it allowed me to setup a default implementation for each driver
>> callback. So all drivers get generic implementation by default, and
>> override when that is not enough. Meybe you have a better way of getting
>> the same behavior.
>>      
> One solution that I like is to write a module with the common code as
> a library, exporting all the default actions. The specific drivers
> can then fill their operations structure by listing the defaults
> or by providing their own functions to replace them, which in turn
> can call the default functions. This is e.g. what libata does.
>
>    
Will do.
>
>> We are now taking a step back and start "all over". We were almost as
>> fresh on this HW block as you are now when we started implementing the
>> driver earlier this year. I think all of us benefit from now having a
>> better understanding of customer requirements and the HW itself, there
>> are some nice quirks ;). Anyway, we will restart the patches and RFC
>> only the MCDE HW part of the driver, implementing basic fb support for
>> one display board as you suggested initially. It's a nice step towards
>> making the patches easier to review and give us some time to prepare the
>> DSS stuff. That remake was done today, so I think the patch will be sent
>> out soon. (I'm going on vacation for 3 weeks btw).
>>      
> Ok, sounds great! I'm also starting a 3 week vacation, but will be at the
> Linaro sprint in Dallas.
>
> My feeling now, after understanding about it some more, is that it would
> actually be better to start with a KMS implementation instead of a classic
> frame buffer. Ideally you wouldn't even need the frame buffer driver or
> the multiplexing between the two then, but still get all the benefits
> from the new KMS infrastructure.
>
>    
I will look at it, we might still post a fb->mcde_hw first though, since 
it's so little work.
>
>>>> DSS give access to all display devices probed on the virtual mcde
>>>> dss bus, or platform bus with specific type of devices if you like.
>>>> All calls to DSS operate on a display device, like create an
>>>> overlay(=framebuffer), request an update, set power mode, etc.
>>>> All calls to DSS related to display itself and not only framebuffer
>>>> scanout, will be passed on to the display driver of the display
>>>> device in question. All calls DSS only related to overlays, like
>>>> buffer pointers, position, rotation etc is handled directly by DSS
>>>> calling mcde_hw.
>>>>
>>>> You could see mcde_hw as a physical level driver and mcde_dss closer
>>>> to a logical driver, delegating display specific decisions to the
>>>> display driver. Another analogy is mcde_hw is host driver and display
>>>> drivers are client device drivers. And DSS is a collection of logic
>>>> to manage the interaction between host and client devices.
>>>>
>>>>          
>>> The way you describe it, I would picture it differently:
>>>
>>> +----------+ +----+-----+-----+ +-------+
>>> | mcde_hw  | | fb | kms | v4l | | displ |
>>> +----+----------------------------------+
>>> | HW |            mcde_dss              |
>>> +----+----------------------------------+
>>>
>>> In this model, the dss is the core module that everything else
>>> links to. The hw driver talks to the actual hardware and to the
>>> dss. The three front-ends only talk to the dss, but not to the
>>> individual display drivers or to the hw code directly (i.e. they
>>> don't use their exported symbols or internal data structures.
>>> The display drivers only talk to the dss, but not to the front-ends
>>> or the hw drivers.
>>>
>>> Would this be a correct representation of your modules?
>>>
>>>        
>> Hmm, mcde_hw does not link to dss. It should be FB->DSS->Display
>> driver->MCDE_HW->HW IO (+ DSS->MCDE_HW). My picture is how code should
>> be used. Anything else you find in code is a violation of that layering.
>>      
> I don't think it makes any sense to have the DSS sit on top of the
> display drivers, since that means it has to know about all of them
> and loading the DSS module would implicitly have to load all the
> display modules below it, even for the displays that are not present.
>
>    
DSS does not have a static dependency on display drivers. DSS is just a 
"convenience library" for handling the correct display driver call 
sequences, instead of each user (fbdev/KMS/V4L2) having to duplicate 
this code.

> Moreover, I don't yet see the reason for the split between mcde_hw and
> dss. If dss is the only user of the hardware module (aside from stuff
> using dss), and dss is written against the hw module as a low-level
> implementation, they can simply be the same module.
>
>    
They are the same module, just split into two files.
>
>> The other "issue" is the usual, 3D vendors don't upstream their drivers.
>> Which means we have to integrate with drivers not in mainline kernel ...
>> and we still want to open all our drivers, even if some external IPs
>> don't.
>>      
> This will be a lot tougher for you. External modules are generally
> not accepted as a reason for designing code one way vs. another.
> Whatever the solution is, you have to convince people that it would
> still make sense if all drivers were part of the kernel itself.
> Bonus points to you if you define it in a way that forces the 3d driver
> people to put their code under the GPL in order to work with yours ;-)
>
>    
I see this as a side effect of DRM putting a dependency between 3D HW 
and KMS HW driver. In most embedded systems, these two are no more 
coupled than any other HW block on the SoC. So by "fixing" this 
_possible_ flaw. I see no reason why a KMS driver can't stand on it's 
own. There's no reason not to support display in the kernel just because 
there's no 3D HW driver, right?
>
>>>>> What does the v4l2 driver do? In my simple world, displays are for
>>>>> output
>>>>> and v4l is for input, so I must have missed something here.
>>>>>
>>>>>            
>>>> Currently nothing, since it is not finished. But the idea (and
>>>> requirement) is that normal graphics will use framebuffer and
>>>> video/camera overlays will use v4l2 overlays. Both using same
>>>> mcde channel and display. Some users might also configure their
>>>> board to use two framebuffers instead. Or maybe only use KMS etc ...
>>>>
>>>>          
>>> I still don't understand, sorry for being slow. Why does a camera
>>> use a display?
>>>
>>>        
>> Sorry, camera _application_ use V4L2 overlays for pushing YUV camera
>> preview or video buffers to screen composition in MCDE. V4L2 have output
>> devices too, it's not only for capturing, even if that is what most
>> desktops use it for.
>>      
> Ok, I'm starting to remember this from the 90's when I used bttv on the
> console framebuffer ;-).
>
> Could you simply define a v4l overlay device for every display device,
> even if you might not want to use it?
> That might simplify the setup considerably.
>    
Sure, but that is currently up to board init code. Just as for frame 
buffers, mcde_fb_create(display, ...), we will have a 
"createV4L2device(display, ...)".

/BR
/Marcus

