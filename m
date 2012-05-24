Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966020Ab2EXT7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 15:59:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37157 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966250Ab2EXT66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 15:58:58 -0400
Date: Thu, 24 May 2012 12:58:51 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 3.5-rc0
Message-ID: <20120524195851.GA15306@core.coreip.homeip.net>
References: <20120524083216.GD10562@core.coreip.homeip.net>
 <CA+55aFxw0HRpizzJZxhhA2oqPpzg4DPUvH2r7YoYfctXS6K=WQ@mail.gmail.com>
 <20120524180154.GA15036@core.coreip.homeip.net>
 <CA+55aFx0ww=BtYAj9WEbqMT2R30ZZpjd014cYCpC=b+HRtUf_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx0ww=BtYAj9WEbqMT2R30ZZpjd014cYCpC=b+HRtUf_A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 11:21:20AM -0700, Linus Torvalds wrote:
> On Thu, May 24, 2012 at 11:01 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> >
> > A couple of points:
> 
> *NEITHER* of your points actually address my issue.
> 
> If the "inputX" name is useless (and dammit, I agree), then why do you
> continue to use it then?
> 
> IOW, why the hell do you set a name that is so useful that no sane
> person would ever want to use it?
> 
> Basically, my complaint is that the input layer drivers end up doing
> stupid things ("dev_dbg(input->dev.parent..") because the input layer
> has done stupid things (dev_set_name(&dev->dev, "input%ld").
> 
> So let me be more blunt and direct: which part of "that's f*cking
> stupid" do you disagree with?
> 
> So instead of making drivers do stupid things because you've made the
> input layer names so damn useless, why don't you make the input layer
> use better naming? Doesn't that seem to be the *smart* thing to do?
> 
> Wouldn't everybody be much happier if they saw useful names in the
> device tree? And then the drivers could actually *use* those useful
> names, instead of clearly saying "our names are so shitty that we have
> to look up the parent name just to get a useful printout"?
> 
> Do people really *want* to see names like "input2" when working with a
> keyboard? Do we have some stupid userlevel interface that requires
> these useless and nondescriptive names that are so useless that even
> the input layer itself doesn't want to use them?
> 
> Wouldn't it be *much* nicer if the input layer would, for example, do
> something like
> 
>    dev_set_name(&dev->dev, "input-%s", dev_name(dev->dev.parent));
> 
> or whatever? Better yet, make it easy for the driver to say what it
> is, so that it really can just say "wacom %s" or whatever.
> 
> Because the basic reason you seem to want to use "dev.parent" instead
> of just "dev" *all* seem to boil down to a very simple reason:
> 
>  - other subsystems name their devices better, so you want to use
> those better names

NO. What you seem to be missing is that the driver does not operate on
an input device, input device is a _product_ of that driver. The error
condition did not arise in input stack or input handler, the error
condition happend on a physical device connected to a given USB port.
And that is why it is proper to associate the error (in this case) with
USB interface and USB driver that controls it. input_dev->dev.parent was
just a convenient way of getting to this object but if it irks you I can
stuff a device pointer in wacom_wac structure so that we use

	dev_xxx(wacom->dev, "blah);

instead.

On  the topic of naming - nobody cares what input devices are called as
long as they are unique. Userspace does not work with input devices
directly (there is no API), they are working with iterfaces (such as
evdev) that have their own interfaces and names. We could burden drivers
to make sure they provide unique names, but that would not be optimal
and most likely gotten wrong. Considering your

	dev_set_name(&dev->dev, "input-%s", dev_name(dev->dev.parent));

what happens if I unplug and replug my wacom tablet while event node is
still opened and therefore all kobjects are still pinned into memory?
The parent device's name is stuill the same so we'll fail to cretaed
device with duplicate name. Extending with global counter? We could I
guess, but why bother? If you check /sys/class/ most of the abstract
devices do not care to have unique names. Is /sys/class/block/loop5 or
/sys/class/rtc/rct0 or /sys/class/sound/card0 any better than
/sys/class/input/inputX?

Thanks.

-- 
Dmitry
