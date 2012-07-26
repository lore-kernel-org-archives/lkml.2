Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab2GZC3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 22:29:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32781 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab2GZC3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 22:29:46 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxF_nSEZGp8h4oXhusJgQ+dvjNL2eMurJMaJFQMPCbu9g@mail.gmail.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
	<CA+55aFzKu6xhTPmKPTg+p36Su0GkZgzGWpnvhpsFXJzhp=R16w@mail.gmail.com>
	<CACVXFVMeRQ-Fwk03uVg5LOH193PF+AyCoAAxmXDpqjeZXi7nxw@mail.gmail.com>
	<CA+55aFypmnk8S4JkLui1Z7JxKae=-k88K-wEP9xDwrf1LOX-Vw@mail.gmail.com>
	<CACVXFVOiXRiqRsE46_xmOzK_dExNvkBaJVwjiZ9adhwqRRwY+g@mail.gmail.com>
	<CA+55aFxF_nSEZGp8h4oXhusJgQ+dvjNL2eMurJMaJFQMPCbu9g@mail.gmail.com>
Date: Thu, 26 Jul 2012 10:29:43 +0800
Message-ID: <CACVXFVPF3C9ksNSP5KMNsZg2qYWf+SQ4HLw-cb0abgC-wuunUQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13] firmware loader: introduce cache/uncache firmware
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 1:23 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So *if* the only problem wrt the USB hub code comes from this area,

IMO,  USB hub code may not be the only one because both device_add and
device_del can just be run in process context, so any hotplug bus
may have this kind of problem since the devices in the bus may be
unplugged and plugged again during suspend or experience power loss
, then the bus driver may take similar handling policy as USB.

> then I think the solution might be as simple as just moving the
> "usermodehelper_enable()" up a few lines, with a comment. Something
> like the *untested* and whitespace-damaged thing below..
>
> Rafael? Who has one of those isight things and has seen the warning to test?

I fake one USB device disconnect in reset_resume path and looks the patch
is good: the device driver can request firmware successfully in its .probe().

>
>                Linus
>
> ---
> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index 19db29f67558..5bf50e488196 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -181,6 +181,12 @@ void thaw_processes(void)
>         pm_freezing = false;
>         pm_nosig_freezing = false;
>
> +       /*
> +        * User mode helper are available again (or will be,
> +        * modulo scheduling)
> +        */
> +       usermodehelper_enable();

This may wake up tasks earlier than before, not sure if it might have
side effects.


Thanks,
--
Ming Lei
