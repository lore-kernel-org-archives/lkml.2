Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab2JSBla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 21:41:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58882 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab2JSBl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 21:41:29 -0400
MIME-Version: 1.0
In-Reply-To: <11374134.vToUn932b7@vostro.rjw.lan>
References: <1350403183-12650-1-git-send-email-ming.lei@canonical.com>
	<6431373.tJcdR3m2Df@vostro.rjw.lan>
	<CACVXFVP-JerxiTU9Kr9Lrwe2XkKBU=EsZJUcEiPVCQWw6iiw2Q@mail.gmail.com>
	<11374134.vToUn932b7@vostro.rjw.lan>
Date: Fri, 19 Oct 2012 09:41:27 +0800
Message-ID: <CACVXFVMBSzPiY_kRd75wPJMVb4YFQeVAnWDVyz6ua7OFsMBSTw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 2/3] PM / Runtime: force memory allocation with no
 I/O during runtime_resume callbcack
From: Ming Lei <ming.lei@canonical.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 7:16 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Well, the question is how many runtime resume callbacks actually allocate
> memory.  If they are not too many, we can just flag all of them.  Otherwise,

At least, almost all pci devices driver in some platform(acpi) and all usb
devices driver allocate memory with GFP_KERNEL which is done in
subsystem, see below:

       http://marc.info/?l=linux-kernel&m=135044522501229&w=2

I also found that many usb interface drivers(usblp, uvc, gspca, most of
dvb-usb-v2 media drivers, cpia2, az6007, ....) will do it too.

It is not good to convert all these GFP_KERNEL into GFP_NOIO
because the function doing that will be called in many other contexts.

That is just what I have found.  Unfortunately, this allocation can only be
found by human being now, maybe there are many not found since
any function in the resume path(call tree) may allocate memory with
GFP_KERNEL.

In fact, memalloc_noio() can convert some of current static GFP_NOIO
allocation into GFP_KERNEL in other contexts, at least almost all
GFP_NOIO in USB subsystem can be converted into GFP_KERNEL
after applying the approach and make allocation with GFP_IO
only happen in runtime resume/bus reset/block I/O transfer contexts
generally.

> adding a flag may be a better approach.  I'm not sure ATM.

OK, I will prepare -v2 with the flag approach for review.


Thanks,
--
Ming Lei
