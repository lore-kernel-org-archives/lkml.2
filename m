Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1CNIi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 04:38:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44296 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab1CNIi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 04:38:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=s8p3haDaMoZZNBCi6gMaQF98eVElkf6Wbk2s7kGXb5K0XP/GmGk+Bxh8JRTJvlBZoZ
         3CfGK/UEreKunsa/mvS6eiMwOwScMfhBs8wa3902YDcCTjJMgP4I0s9CPxFEWBiH/FNE
         WDjqRjraQPv6oLl2r9SjbBnhFtzpga6YnGge0=
Message-ID: <4D7DD41D.1070401@linaro.org>
Date: Mon, 14 Mar 2011 08:38:53 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110302 Fedora/3.1.8-3.fc16 Thunderbird/3.1.8
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [RFC PATCH 3/4] PLATFORM: Introduce async platform_data attach
 api
References: <20110312222633.27020.19543.stgit@otae.warmcat.com> <201103131141.07380.rjw@sisk.pl> <4D7CB15A.6030203@linaro.org> <201103131353.54612.rjw@sisk.pl> <4D7CC4D0.90305@linaro.org> <20110313161528.GB10718@kroah.com> <4D7CFB3B.8060008@linaro.org> <20110313174811.GA11504@kroah.com> <4D7D0933.9010502@linaro.org> <20110313232612.GA13784@kroah.com>
In-Reply-To: <20110313232612.GA13784@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2011 11:26 PM, Somebody in the thread at some point said:
> On Sun, Mar 13, 2011 at 06:13:07PM +0000, Andy Green wrote:
>> On 03/13/2011 05:48 PM, Somebody in the thread at some point said:
>>> On Sun, Mar 13, 2011 at 05:13:31PM +0000, Andy Green wrote:
>>>> So when there's a bit more of Device Tree in evidence, are you going
>>>> to accept Device-tree based patches in usbnet etc along these lines,
>>>> or does that trigger the "do it in userspace" response, in which
>>>> case we are both wasting each others' time continuing to discuss
>>>> this at all?
>>>
>>> As mentioned numerous times before, network naming stuff happens in
>>> userspace, not in the kernel, so no matter what infrastructure is added,
>>
>> The naming of that network interface happens in smsc95xx, in kernel:
>> it uses a dodgy heuristic to choose between usb%d eth%d and others
>> and gets it wrong in this case due to stuff outside its view.
>> There's nothing golden and wonderful about that which needs
>> protecting from outside hints.
>
> Then why not always do this in userspace correctly?  It's the _exact_
> same problem that the server companies have in naming their network
> devices in a proper manner (i.e. the port with the 0 label on it wants
> to always be eth0).  We have the tools today to solve this issue, in a
> consistant and proper manner, please use them.

It is not at all the same problem.

Here, the usbnet driver tries to figure out what kind of device label it 
should use, the numbering is then dependent on the label and there's no 
problem coming from the numbering, nor do the patches touch that.

The first issue for usbnet is right now, it has no real insight into 
what the appropriate interface name is because it is out of its view if 
the USB Ethernet bridge is soldered onboard or not.  You know, it is 
also not in a generic userspace's view what is soldered on that board 
either, so I can only read your pushing of that 'solution' as "get this 
out of my hair".  The one place that can properly know it right now is 
the board definition file in the kernel, maybe Device Tree too in the 
future.

To do it what you are calling the "correct" way in userland, you are 
okay with the driver selecting the wrong interface name, condemning 
userland to regenerate board-specific knowledge from grepping 
/proc/cpuinfo, inferring in userland what can easily and justly be known 
in the board definition file in kernel, and overriding the wrong 
interface name.  In all that, Caesar's hands are clean alright, but 
don't tell me this is a good job and the correct solution.

Despite not having the information, the driver does have go at a 
heuristic, but because net->dev_addr[] is always coming from 
random_ether_addr(), which rightly forces [0] & 2 to 1 indicating it's a 
private namespace MAC address, the heuristic is broken and never selects 
eth%d.

-               // heuristic:  "usb%d" for links we know are two-host,
-               // else "eth%d" when there's reasonable doubt.  userspace
-               // can rename the link if it knows better.
-               if ((dev->driver_info->flags & FLAG_ETHER) != 0 &&
-                   (net->dev_addr [0] & 0x02) == 0)
+               /*
+                * heuristic:  "usb%d" for links we know are two-host,
+                * else "eth%d" when there's reasonable doubt.  userspace
+                * can rename the link if it knows better.  Async
+                * platform_data can also override this if it knows better
+                * based on knowledge of what this link is wired up to.
+                */
+               if ((((dev->driver_info->flags & FLAG_ETHER) != 0 &&
+                   (net->dev_addr[0] & 0x02) == 0)) ||
+                   (pdata && pdata->flags &
+ 
USBNET_PLATDATA_FLAG__FORCE_ETH_IFNAME))
                         strcpy (net->name, "eth%d");


static inline void random_ether_addr(u8 *addr)
{
         get_random_bytes (addr, ETH_ALEN);
         addr [0] &= 0xfe;       /* clear multicast bit */
         addr [0] |= 0x02;       /* set local assignment bit (IEEE802) */
}

If you look further down, it is making an attempt to choose the right 
name at interface creation time by taking information from other sources 
already

                 /* WLAN devices should always be named "wlan%d" */
                 if ((dev->driver_info->flags & FLAG_WLAN) != 0)

My patch just has it also look if there is a pdata->flags to see if the 
board definition file is guiding it to choose eth%d.

The second issue for usbnet which the patchset solves is that right now, 
it will always give a random MAC address that differs each boot, driving 
dhpcd insane.

Now once again, the existing code will take information from other 
sources to guide it about that too.  In smsc95xx usbnet driver, it looks 
to see if there is an EEPROM attached to the chip and will replace the 
random MAC address with the one from there if there is.  The patch 
extends that to check usbnet platform_data to see if a MAC address has 
been sent up from the board definition file.

  static void smsc95xx_init_mac_address(struct usbnet *dev)
  {
+       struct usbnet_platform_data *pdata = dev->udev->dev.platform_data;
+
+       /*
+        * if netdev platform data has taken responsibility for forcing
+        * the MAC then nothing to do here
+        */
+
+       if (pdata && pdata->flags & USBNET_PLATDATA_FLAG__USE_MAC)
+               return;
+
         /* try reading mac address from EEPROM */
         if (smsc95xx_read_eeprom(dev, EEPROM_MAC_OFFSET, ETH_ALEN,
                         dev->net->dev_addr) == 0) {

So given what it already does in a broken way for these valid 
implementations of smsc95xx with no EEPROM, I really do not understand 
what sanctity of these drivers is being violated by having it do the 
same things better using a couple of extra lines with platform_data.

For sure, in any other bus, we will never have this discussion about if 
the device driver should use relevant platform_data to be guided about 
what to do, that is what platform_data is for and it is very widely used 
indeed.

>>> insisting on naming the network device 'eth0' is not going to happen
>>> within the kernel.  Please use the tools we have today to do this with
>>> no kernel changes.
>>>
>>> As for other changes, it all depends on what you need to accomplish,
>>> right?  Those will be gladly reviewed on a case-by-case basis.
>>
>> The immediate thing I would have liked to accomplish is to help
>> smsc95xx make the right decision about naming and to use the MAC
>> address in platform_data.  It seemed this was a general issue
>> though, so I generalized how it was done.  But I don't have examples
>> on my desk of boards with soldered-on USB other than smsc95xx
>> Ethernet bridge.
>>
>> At least, I am grateful we get down to brass tacks now and you
>> clearly reject allowing the driver to take guidance to act more
>> appropriately for its environment in the first place.  Therefore,
>> this won't get fixed by Device Tree either.
>
> I beg to differ.  I'm stating that USB drivers can not use their
> numbering to do anything with them as that is never going to be
> deterministic.
>
> That's all.  You seem to disagree with this.

Actually as I indicated I am willing to pretend to agree it applies to 
these SoC cases (no argument it is certainly so in a non-SoC PC type 
situation where the board definition file / platform_data is not used), 
and offered to adapt the bus selection to use a usb host interface 
pointer from the board definition file that should solve that objection.

>> So, we don't need to discuss this any further: thanks again for your
>> time.
>
> Ok, so does this mean that you are convinced that I am correct here, or
> are just giving up and going to keep your patches outside of the kernel,
> or something else?

It means I acknowledge you are the guy in the way of solving these 
issues in usbnet, and that these patches will be discarded without your 
approval.  Normally, for me offering patches upstream is a side issue 
because I am trying to deliver some product, so with this level of 
pushback I would just shrug and hold it in my tree.  In this case though 
I am being paid to help TI solve issues upstream, the patches do solve 
real issues for them, but they're trying to eliminate BSP tree concept 
in favour of everything upstream, so there is no other place for them.

I'm willing to put in effort as I have in this thread explaining things 
more clearly when the proposal was not understood, and writing patches 
so it is unambiguous, adapting to feedback that improves things or even 
explains why the proposal isn't usable, but I also understand that where 
you are wrong and are simply filtering out the arguments to the contrary 
due to dogma, I am wasting my time, your time, you will stay wrong and 
the driver will stay broken.  In the meanwhile, I will sleep badly and 
my wife will be unhappy with me for burning a weekend on it, so if 
there's no useful path forward let's not protract the agony for either 
of us.

-Andy
