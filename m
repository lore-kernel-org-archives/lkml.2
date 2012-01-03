Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751189Ab2ACFyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 00:54:11 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:47632 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2ACFyK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 00:54:10 -0500
MIME-Version: 1.0
In-Reply-To: <20120103032505.GA19702@srcf.ucam.org>
References: <20120102215028.GA15701@srcf.ucam.org> <Pine.LNX.4.44L0.1201022136190.20386-100000@netrider.rowland.org>
 <20120103032505.GA19702@srcf.ucam.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 Jan 2012 21:53:46 -0800
X-Google-Sender-Auth: QZMzAHGoj7yiH9M0V0LmN-vdZFM
Message-ID: <CA+55aFxnOBJZBb5KC7HC3z9Whk585SaHeCx9zyie3MMsfsvExw@mail.gmail.com>
Subject: Re: loading firmware while usermodehelper disabled.
To: Matthew Garrett <mjg@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jack Stone <jwjstone@fastmail.fm>,
        Oliver Neukum <oliver@neukum.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 2, 2012 at 7:25 PM, Matthew Garrett <mjg@redhat.com> wrote:
> On Mon, Jan 02, 2012 at 09:45:58PM -0500, Alan Stern wrote:
>
>> Wait a second.  Why does isight_firmware bind at this time?  Binding to
>> new devices is handled by khubd, which doesn't start running again
>> until after the resume is finished (the device appears to be new
>> because its descriptors have changed).  At that point there should be
>> no trouble reloading the firmware.
>
> Then why are we getting this warning? The firmware is only loaded in the
> probe function.

The USB suspend/resume function does that "unbind/rebind" dance, and
that causes a "device_attach()". Which causes a probe() to be called.

Should it do that? I think not, not if the ID's haven't changed. But I
don't know the USB layer all that well.

The whole USB suspend/resume code is also very confused in general.
See for example commit c043f1245654 ("USB: unbind all interfaces
before rebinding them") which talks about how the USB layer needs to
unbind all interfaces in order to rebind them later.  But then you
look at the *code*, and it actually does a DO_REBIND, not an unbind!

The USB suspend/resume code is full of those crazy "let's use one
function, and pass it as an *argument* what to do". It's a disease.
The PM layer used to do the same thing (PMSG_xyz crap), and we've
largely gotten rid of it, but USB still plays around with those things
and makes it even *worse* exactly with these kinds of
"do_unbind_rebind()" routines that then look at the argument instead
of having a sane routine for unbinding and another sane routine for
re-binding.

So I can't follow the crap. I *can* follow the fact that people who
write the code (or the commit messages) are clearly totally confused
by it, even when they maintain it, as exemplified by the above
example.

Alan?

                         Linus
