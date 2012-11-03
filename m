Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762020Ab2KCAkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 20:40:23 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:38838 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751228Ab2KCAkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 20:40:21 -0400
Message-ID: <509467EC.7090804@virtuousgeek.org>
Date: Fri, 02 Nov 2012 17:40:12 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [PATCH 1/2] PM: make VT switching to the suspend console optional
References: <1351892621-4840-1-git-send-email-jbarnes@virtuousgeek.org> <1351892621-4840-2-git-send-email-jbarnes@virtuousgeek.org> <20121102234302.28b773a7@pyramind.ukuu.org.uk> <5094636A.9050000@virtuousgeek.org> <20121103004205.4ba8b6b7@pyramind.ukuu.org.uk>
In-Reply-To: <20121103004205.4ba8b6b7@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/2012 5:42 PM, Alan Cox wrote:
>> that, but how would I even configure a VT split across two adapters
>> today?  For vgacon we just route VGA to a single adapter, but I'm not
>
> con2fb /dev/fb1 /dev/tty1
>
>> Dunno about suspend vs unload, how do we deal that in other drivers like
>> the disk driver for suspend for example?  Overall that case seems pretty
>> esoteric...
>>
>> What do you mean about hand over to multiple frame buffers?
>
> You have a global but I can insmod i915 move the consoles off it and
> unload it (at least in theory - last time I tried it crashed at
> least on gma500 which I need to fix 8))

i915 doesn't crash in that case, but you definitely don't get the 
console back as we don't restore all the VGA state.  Easy enough to 
restore the global at least though.

>
> So you've got a global you can't just set back but need to adjust on
> unload.
>
> And you've got races like suspend as we are changing framebuffer which
> your code doesn't consider as you have no locking.
>
> If we push the logic into the vt layer we can pretty easily dump it under
> the vt locks. It's not the whole story as there are all sorts of things
> it doesn't handle but it does mean we can handle the case of
>
> "if we are switching from a vt which is on a device that doesn't need it
> for suspend then do nothing"
>
> properly, and we can make any future features work right
>
>
> I think all we need is consw to have a con_sw_suspend/con_sw_resume
> method and the framebuffer layer to let kms get at it.

yay console layer... ok I'll check it out.

Overall it's probably worth some grotting around in the console layer. 
Avoiding a VT switch makes suspend/resume a lot nicer looking.  No more 
blinking cursor in the corner and ugly flickering.

Jesse
