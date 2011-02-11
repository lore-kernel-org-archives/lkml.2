Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab1BKCVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 21:21:16 -0500
Received: from smtp-out.google.com ([216.239.44.51]:5913 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757070Ab1BKCVP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 21:21:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ly909FY5yyCMN2QCODctYVT4WMaR7p1DCVsyDefhrdzyZA4IxCiTn6RBEKQ6S8V5W3
         jsKeiJANmOvoeTDFFkVw==
MIME-Version: 1.0
In-Reply-To: <20110211012552.GA28995@kroah.com>
References: <4D547236.6080702@google.com> <20110211012552.GA28995@kroah.com>
From: Tim Hockin <thockin@google.com>
Date: Thu, 10 Feb 2011 18:20:52 -0800
Message-ID: <AANLkTi=tbYj_bonu2i+NHpNY3KUMpsTVT8YDsLhDz_Nm@mail.gmail.com>
Subject: Re: SMBIOS / DMI Event Logs in Linux?
To: Greg KH <greg@kroah.com>
Cc: Mike Waychison <mikew@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Robert Lippert <rlippert@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Caveat: I kind of loathe the proliferation of single use filesystems
for things that just aren't well mapped to the model.

That said, maybe smbiosfs is not so horrible of a mapping.  I'm
reticent to dredge up my spec, but I think it fits well enough, and
you can can leave most OEM-specific processing in userspace.

So for the type 15, something like:

/smbios/              # mountpoint
    15/                  # record type (decimal)
        0/                # instance number (decimal)
            change_token # change token from the type 15 struct
            header    # binary dump of the header section (if present)
            0/            # one dir for each record (decimal)
                id        # event ID (decimal)
                id_str  # event ID (stringified, if possible)
                size    # event size (decimal, bytes)
                timestamp   # year, month, day, hour, minute, second
                data   # binary dump of the payload
                raw    # binary dump of the whole event

This does not handle type descriptors, but I know *we* don't use them..

This does not address operations such as clearing the log or writing a
new event or locking/unlocking the log.  If there's an OEM-specific
driver loaded it could augment the above.

            clear_log       # write a number to this to clear some
percent of the log
            write_events # write a binary dump of an event, including timestamp?

I don't hate it.  IT would be cool to have all of SMBIOS available this way.

I'm not sure its worth the work, though.  Most Type 15 logs are in
memory-mapped ROM or in RAM, so tools can access it via /dev/mem (if
you have privs to do so).  I thought the SMI ioctl() interface worked
just fine for logging and clearing.  And hell, we could do that from
userspace if we had to, it's just IO ports, I think.  Maybe you need a
userspace V-to-P translation, too.

Tim


On Thu, Feb 10, 2011 at 5:25 PM, Greg KH <greg@kroah.com> wrote:
> On Thu, Feb 10, 2011 at 03:18:14PM -0800, Mike Waychison wrote:
>> Hey guys,
>>
>> I need some guidance. Do either of you know of any attempts to have
>> the kernel decode and display/interact with DMI type 15: System
>> Event Log?
>
> I don't have any experience in this area, but I do have one comment on
> your proposal below:
>
>> The event log I'm dealing with while cleaning up the "gsmi" driver
>> interacts with a log that is modeled after the System Event Log.
>> I'm wondering if there is any precedent for a clean way to expose
>> the event log, I'd like to use it (replacing the ioctls from my
>> earlier patch series send-out).
>>
>> FYI, we use OEM specific headers and descriptors, which probably
>> doesn't help.
>>
>> Do most folks that need access to this data rely on /dev/mem and
>> dmidecode?  I'd like to avoid going that route if possible.
>>
>> Lacking any better ideas though, I was thinking of something along
>> the lines of the following:
>>
>>
>> $ cat /sys/firmware/gsmi/eventlog
>> <offset> <boot number> <recorded time> <quoted reason> <optional data>
>> ...
>>
>> with a single event log entry per line.
>>   <offset> would be the record number,
>>   <boot number> is the recorded boot number
>>   <recorded time> comes from each record,
>>   <quoted reason> is the English translation of Event Log Types from
>> the DMTF standard + vendor extended types we use.
>>   <optional data> is space separated values associated with <quoted reason>
>
> Ick, no, remember, sysfs is "one value per file".  doing even a single
> line like you describe here isn't ok, not to mention a huge buffer of
> these lines.
>
> And no, a "binary" sysfs file is not ok either.
>
> Now your idea for such a log file is fine, I'm not saying that's not ok,
> or acceptable, just don't put it in sysfs, sorry.  Try using the ring
> buffer framework from the tracing code perhaps?
>
> Or use debugfs?  Or make a 'firmwarefs'?  I can easily knock that
> together if you need it.
>
> thanks,
>
> greg k-h
>
