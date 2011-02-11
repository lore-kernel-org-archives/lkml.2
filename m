Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab1BKCFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 21:05:20 -0500
Received: from smtp-out.google.com ([74.125.121.67]:2986 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539Ab1BKCFT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 21:05:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=qVHPsAeqzkk2YlaOhlTKCaApRengnAcOSYz/hElCdrglMvELNnRXZPx3FnO3RNno1P
         iq213IIwQ6JYPOOS8Hcg==
MIME-Version: 1.0
In-Reply-To: <4D547236.6080702@google.com>
References: <4D547236.6080702@google.com>
From: Rob Lippert <rlippert@google.com>
Date: Thu, 10 Feb 2011 18:04:55 -0800
Message-ID: <AANLkTi=ievTRgtUHyEjTcXJ_08PZGFTaLsaj0UOcD+PX@mail.gmail.com>
Subject: Re: SMBIOS / DMI Event Logs in Linux?
To: Mike Waychison <mikew@google.com>
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Tim Hockin <thockin@google.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 3:18 PM, Mike Waychison <mikew@google.com> wrote:
> Hey guys,
>
> I need some guidance. Do either of you know of any attempts to have the
> kernel decode and display/interact with DMI type 15: System Event Log?
>

I don't know what the benefit of the having the kernel decode the SEL
would be besides the ability to printk() the contents during boot
time.
Since it generally contains vendor/OEM/machine specific data having to
have each vendor provide their own kernel module to decode seems like
a maintenance pain.  Also having the decoding in the kernel means that
adding any new event types requires respinning a kernel.

> The event log I'm dealing with while cleaning up the "gsmi" driver interacts
> with a log that is modeled after the System Event Log.  I'm wondering if
> there is any precedent for a clean way to expose the event log, I'd like to
> use it (replacing the ioctls from my earlier patch series send-out).
>
> FYI, we use OEM specific headers and descriptors, which probably doesn't
> help.
>
> Do most folks that need access to this data rely on /dev/mem and dmidecode?
>  I'd like to avoid going that route if possible.
>
> Lacking any better ideas though, I was thinking of something along the lines
> of the following:
>
>
> $ cat /sys/firmware/gsmi/eventlog
> <offset> <boot number> <recorded time> <quoted reason> <optional data>
> ...
>
> with a single event log entry per line.
>  <offset> would be the record number,
>  <boot number> is the recorded boot number
>  <recorded time> comes from each record,
>  <quoted reason> is the English translation of Event Log Types from the DMTF
> standard + vendor extended types we use.
>  <optional data> is space separated values associated with <quoted reason>
>

What about just exposing the "raw" bytes of the eventlog similar to
how the kernel currently exposes the ACPI tables at e.g.:

/sys/firmware/acpi/tables/DSDT

That would avoid the userspace app having to do the mmio or port io to
actually read the eventlog and the kernel can export it in a standard
fashion on any machine which supports an SMBIOS-style event log table.

> We also have a interfaces for clearing a fraction of the log, which I'm
> thinking is probably best expressed as a value of 0 through 100 written to a
> file, maybe /sys/firmware/gsmi/clear_eventlog ?
>

This is definitely a vendor-specific extension as I know some other
eventlog interfaces (like IPMI) support things like deleting
individual entries.

> As well, we need to export to userland a way to append data to the log.  I
> was thinking we could write a parser to take in an entry and ensure it is
> well-formatted, but I'm a little hesitant to go this route as our records
> embed a timestamp, which I'd rather not have to figure out from within the
> kernel.  Perhaps a raw (binary) interface to write records to the log would
> suffice?  /sys/firmware/gsmi/append_to_eventlog ?
>

Verification of the data is probably best left to the
BIOS/BMC/whatever that is storing the event data and that can return
an error back to userspace if a record is invalid.  Otherwise you're
again potentially duplicating the parsing/verifying work that is
already being done in userspace and the BIOS.

> If so, does /sys/firmware/gsmi/raw_eventlog make sense too?
>
>
> Thanks,
>
> Mike Waychison
>
