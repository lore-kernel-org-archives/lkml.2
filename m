Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab2AADtQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 22:49:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64045 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab2AADtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 22:49:14 -0500
Message-ID: <4EFFD7B6.407@lwfinger.net>
Date: Sat, 31 Dec 2011 21:49:10 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Matthew Garrett <mjg@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
References: <20111230235421.GA6054@redhat.com> <CA+55aFyqm4FbW=--7U4ULk1EBb6RLP0sRgtokODBYnZNiJXWew@mail.gmail.com>
In-Reply-To: <CA+55aFyqm4FbW=--7U4ULk1EBb6RLP0sRgtokODBYnZNiJXWew@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2011 06:22 PM, Linus Torvalds wrote:
> On Fri, Dec 30, 2011 at 3:54 PM, Dave Jones<davej@redhat.com>  wrote:
>> We're getting a bunch of reports against Fedora 16
>> (still using 3.1) which look like some drivers are trying to
>> load firmware on resume from suspend, while usermodehelper
>> is disabled.
>
> Ok, buggy drivers. You *must*not* load firmware in your resume path,
> since there is no actual guarantee that any particular device will be
> resumed after the disk that contains the firmware images.
>
> So it's very simple: drivers that load firmware at resume time are
> buggy. No ifs, buts, or maybes about it.
>
>> Here are some example traces:
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=746411
>
> It's isight_firmware_load(), in the isight_firmware driver. The driver
> doesn't actually do anything but load the firmware, and is apparently
> not very good at that either.
>
> It should either fake a disconnect and reconnect of the device (and
> let the reconnect then load the firmware through udev or something) or
> it should just save the firmware image in memory from the original
> load, and make the resume just re-initialize it - not load it.
>
> It's also possible that it could be considered a USB layer bug, and
> the USB layer should just not rebind the devices directly in the
> resume function, but do it somehow later. HOWEVER, that would only
> work for "random" USB devices that aren't in use by user space (like
> disks etc might be). So I think that in general the real solution is
> always just "make sure that the firmware is in memory before the
> suspend even happens".
>
> Greg - has the USB resume logic been changed lately?
>
> Matthew? Any comments about that particular driver?
>
>> https://bugzilla.redhat.com/show_bug.cgi?id=771002
>
> Same issue, different driver. Again, it's USB, and it's possible that
> USB just makes it really hard to do this correctly (ie the "save
> firmware image across suspend so that you don't have to load it at
> resume time").
>
> It's also possible that we should blame the firmware code, which is
> expressly written to encourage these kinds of bugs. It may be that i
> tshould be the firmware code that has a "get_firmware()" +
> "put_firmware()" model, and it should cache the firmware explicitly if
> the config supports suspend, so that a firmware read at resume time
> would actually work. The whole "request_firmware()" interface really
> is very prone to these kinds of bugs.
>
> But it's possible this could be fixed at the driver level by doing the
> caching there.
>
> In this case it's the rtl8192cu driver, so Larry, Chaoming, John etc
> added to the cc for that one.

A patch that delays the firmware reading until the upload is needed when the 
interface is brought up will be sent to John very soon. My box loses its video 
when a suspend/resume cycle is done, but the WARNING is no longer printed by 
rtl8192cu.

Larry


