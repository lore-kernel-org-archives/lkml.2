Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab1BKDUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 22:20:04 -0500
Received: from kroah.org ([198.145.64.141]:36133 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab1BKDUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 22:20:02 -0500
Date: Thu, 10 Feb 2011 19:19:27 -0800
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Tim Hockin <thockin@google.com>,
        Robert Lippert <rlippert@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: SMBIOS / DMI Event Logs in Linux?
Message-ID: <20110211031927.GA884@kroah.com>
References: <4D547236.6080702@google.com>
 <20110211012552.GA28995@kroah.com>
 <4D549CC3.4050902@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D549CC3.4050902@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 06:19:47PM -0800, Mike Waychison wrote:
> On 02/10/11 17:25, Greg KH wrote:
> >On Thu, Feb 10, 2011 at 03:18:14PM -0800, Mike Waychison wrote:
> >>Hey guys,
> >>
> >>I need some guidance. Do either of you know of any attempts to have
> >>the kernel decode and display/interact with DMI type 15: System
> >>Event Log?
> >
> >I don't have any experience in this area, but I do have one comment on
> >your proposal below:
> >
> >>The event log I'm dealing with while cleaning up the "gsmi" driver
> >>interacts with a log that is modeled after the System Event Log.
> >>I'm wondering if there is any precedent for a clean way to expose
> >>the event log, I'd like to use it (replacing the ioctls from my
> >>earlier patch series send-out).
> >>
> >>FYI, we use OEM specific headers and descriptors, which probably
> >>doesn't help.
> >>
> >>Do most folks that need access to this data rely on /dev/mem and
> >>dmidecode?  I'd like to avoid going that route if possible.
> >>
> >>Lacking any better ideas though, I was thinking of something along
> >>the lines of the following:
> >>
> >>
> >>$ cat /sys/firmware/gsmi/eventlog
> >><offset>  <boot number>  <recorded time>  <quoted reason>  <optional data>
> >>...
> >>
> >>with a single event log entry per line.
> >>   <offset>  would be the record number,
> >>   <boot number>  is the recorded boot number
> >>   <recorded time>  comes from each record,
> >>   <quoted reason>  is the English translation of Event Log Types from
> >>the DMTF standard + vendor extended types we use.
> >>   <optional data>  is space separated values associated with<quoted reason>
> >
> >Ick, no, remember, sysfs is "one value per file".  doing even a single
> >line like you describe here isn't ok, not to mention a huge buffer of
> >these lines.
> >
> >And no, a "binary" sysfs file is not ok either.
> 
> Works fine for the /sys/firmware/efi stuff.

Do any of those files have multiple lines?  I don't have a system here
that has that directory.

> Works well enough for /sys/firmware/acpi too.

Those all look to be "one value per file" as well.

I don't see any long logs in these firmware types, or am I missing
something?

> >Now your idea for such a log file is fine, I'm not saying that's not ok,
> >or acceptable, just don't put it in sysfs, sorry.  Try using the ring
> >buffer framework from the tracing code perhaps?
> >
> >Or use debugfs?  Or make a 'firmwarefs'?  I can easily knock that
> >together if you need it.
> 
> Are you seriously asking for another filesystem?

What's to be afraid of another filesystem?  It's only 250 lines of code,
and trivial to create.

Remember, sysfs almost was a filesystem-per-device implementation, as
our superblock and mounting logic is very nice and easy to handle all
race conditions.  I objected to that as it would be a bit unwieldy for
some filesystem mount lists, but the idea is still quite sane and
reasonable.

And also, a filesystem-per-type is just fine.  It uniquely keeps things
separate, and defines interfaces properly.

> I don't get why you're holding me to these standards that that are
> totally missed by these same subsystems that you maintain.

I do not see any files in the subsystems I maintain that have multiple
values per lines, and have multiple lines, in sysfs files.  What have I
missed that you are noticing?

thanks,

greg k-h
