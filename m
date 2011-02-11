Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab1BKDUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 22:20:17 -0500
Received: from kroah.org ([198.145.64.141]:36138 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab1BKDUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 22:20:04 -0500
Date: Thu, 10 Feb 2011 19:20:49 -0800
From: Greg KH <greg@kroah.com>
To: Tim Hockin <thockin@google.com>
Cc: Mike Waychison <mikew@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Robert Lippert <rlippert@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: SMBIOS / DMI Event Logs in Linux?
Message-ID: <20110211032049.GB884@kroah.com>
References: <4D547236.6080702@google.com>
 <20110211012552.GA28995@kroah.com>
 <AANLkTi=tbYj_bonu2i+NHpNY3KUMpsTVT8YDsLhDz_Nm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=tbYj_bonu2i+NHpNY3KUMpsTVT8YDsLhDz_Nm@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 06:20:52PM -0800, Tim Hockin wrote:
> Caveat: I kind of loathe the proliferation of single use filesystems
> for things that just aren't well mapped to the model.
> 
> That said, maybe smbiosfs is not so horrible of a mapping.  I'm
> reticent to dredge up my spec, but I think it fits well enough, and
> you can can leave most OEM-specific processing in userspace.
> 
> So for the type 15, something like:
> 
> /smbios/              # mountpoint
>     15/                  # record type (decimal)
>         0/                # instance number (decimal)
>             change_token # change token from the type 15 struct
>             header    # binary dump of the header section (if present)
>             0/            # one dir for each record (decimal)
>                 id        # event ID (decimal)
>                 id_str  # event ID (stringified, if possible)
>                 size    # event size (decimal, bytes)
>                 timestamp   # year, month, day, hour, minute, second
>                 data   # binary dump of the payload
>                 raw    # binary dump of the whole event
> 
> This does not handle type descriptors, but I know *we* don't use them..
> 
> This does not address operations such as clearing the log or writing a
> new event or locking/unlocking the log.  If there's an OEM-specific
> driver loaded it could augment the above.
> 
>             clear_log       # write a number to this to clear some
> percent of the log
>             write_events # write a binary dump of an event, including timestamp?
> 
> I don't hate it.  IT would be cool to have all of SMBIOS available this way.
> 
> I'm not sure its worth the work, though.  Most Type 15 logs are in
> memory-mapped ROM or in RAM, so tools can access it via /dev/mem (if
> you have privs to do so).

Wait, if this is just a simple "pass through to the hardware", then just
export the thing, with the proper permissions, in a single binary sysfs
file, and do the parsing in userspace.

That would be the simplest thing to do, and fit the rules for valid
sysfs files, and keep people from having to dig through /dev/mem, right?

thanks,

greg k-h
