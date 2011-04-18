Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab1DRW0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 18:26:55 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:30521
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752203Ab1DRW0y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 18:26:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEBAKK5rE3LrQ63/2dsb2JhbAAMrxq9SIVxBJIQ
X-IronPort-AV: E=Sophos;i="4.64,236,1301846400"; 
   d="scan'208";a="700872334"
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <20110418132629.12d9a106@lxorguk.ukuu.org.uk>
Date: Tue, 19 Apr 2011 08:26:49 +1000
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <6C3F739A-A157-4796-9572-C6B0FAC2565E@niasdigital.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com> <3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com> <20110418091902.13345132@lxorguk.ukuu.org.uk> <92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com> <20110418132629.12d9a106@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 18/04/2011, at 10:26 PM, Alan Cox wrote:

>> Fair call, but bringing this back to the particular case in hand what in that enum is worth 'hinting' in a might-have-an-effect manner rather than just letting the board take care of it?
>> 
>> Still my question stands, where is the driver ever better placed to make these calls than the board code?
> 
> The logical extension to that is to delete the gpio layer because the
> board code can do it ?

Well anything that is done once at startup, yes, I think the board
code probably can and should.  The only functionality gpiolib currently
supplies is stuff that only the driver knows when to do, i.e. has to be
done during device operation not once-off at boot.

With that said if anyone can demonstrate why a driver would need to
change drive modes or bias strengths during operation then I'll my
argument is more or less gone and I'm happy enough to see this kind of
functionality end up in gpiolib one way or another.

> 
>>> Also your comment re simply in or out on or off is incorrect. Pins may
>>> also be in use by firmware and the like and in a 'neither' state.
>>> Something certain gpio people seem to be in denial over.
>> 
>> Quite right, but should a pin ever be in a neither state and simultaneously controlled by a gpiolib driver?  If so, how should it behave and if not, is it anything that stricter enforcement of gpio_request() semantics can't get around?
> 
> That won't fix sysfs.
> 
> It also doesn't solve the real problem which is that you've got to
> implement platform specific parallel gpio extensions all over the place
> when you really want it all using the same 'handle' and request logic.

Fair enough.  Forgive me if you've stated this in a previous conversation
then but what do you see as being the best way forward here?  Should
gpiolib enforce itself as the One True Allocator and require all firmware
drivers call back in to it to get access to the pins rather than gpiolib
calling back to the platform upon gpio_request()?

> 
> The gpio layer doesn't seem to know what it is doing. It's a fine resource
> allocator and call distributor but it can't make up its mind whether it
> wants to just do that job, or to be a proper extensible gpio layer.
> Instead it sits there being almost useful but incomplete and unwilling to
> either do the job needed or get out of the way.

I absolutely agree here and I suppose my responses to this patch are more
or less aimed at keeping gpiolib in the former role which was more or less
the creator's original vision.  If we want it to become anything more than
this then I certainly think that has merit but I don't want to go adding it
piece-wise to the existing style of gpiolib interfaces, I'd like people to
step back and have a think about what we want this thing to actually /do/
moving forward.

> 
> One possible way to tackle a lot of it would be to actually let the
> drivers make the choices instead of imposing arbitarily wrong sematics
> in the upper layers.
> 
> And for a lot of this stuff that the gpio layer really doesn't want
> internal knowledge of other chunks of the kernel have used models like
> 'get_property/set_property' (eg battery, video4linux etc) so that the mid
> layer can plumb in a conversation between the handle owner and the driver
> without getting involved in the conversation.

Yeah that sounds like a more reasonable way to expose this functionality if
the driver does indeed need it.

	--Ben.

> 
> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

