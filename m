Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab1BJXSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:18:23 -0500
Received: from smtp-out.google.com ([74.125.121.67]:37608 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab1BJXSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:18:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Njbr4uROlwULk8Z3jp0Im0E/te99TP74x8t1m0//mxKzdB+CkAHziLXyi7EyrRLgAk
         enfsGSnn/x+h7mNyql/A==
Message-ID: <4D547236.6080702@google.com>
Date: Thu, 10 Feb 2011 15:18:14 -0800
From: Mike Waychison <mikew@google.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Tim Hockin <thockin@google.com>, Robert Lippert <rlippert@google.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: SMBIOS / DMI Event Logs in Linux?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey guys,

I need some guidance. Do either of you know of any attempts to have the 
kernel decode and display/interact with DMI type 15: System Event Log?

The event log I'm dealing with while cleaning up the "gsmi" driver 
interacts with a log that is modeled after the System Event Log.  I'm 
wondering if there is any precedent for a clean way to expose the event 
log, I'd like to use it (replacing the ioctls from my earlier patch 
series send-out).

FYI, we use OEM specific headers and descriptors, which probably doesn't 
help.

Do most folks that need access to this data rely on /dev/mem and 
dmidecode?  I'd like to avoid going that route if possible.

Lacking any better ideas though, I was thinking of something along the 
lines of the following:


$ cat /sys/firmware/gsmi/eventlog
<offset> <boot number> <recorded time> <quoted reason> <optional data>
...

with a single event log entry per line.
   <offset> would be the record number,
   <boot number> is the recorded boot number
   <recorded time> comes from each record,
   <quoted reason> is the English translation of Event Log Types from 
the DMTF standard + vendor extended types we use.
   <optional data> is space separated values associated with <quoted reason>

We also have a interfaces for clearing a fraction of the log, which I'm 
thinking is probably best expressed as a value of 0 through 100 written 
to a file, maybe /sys/firmware/gsmi/clear_eventlog ?

As well, we need to export to userland a way to append data to the log. 
  I was thinking we could write a parser to take in an entry and ensure 
it is well-formatted, but I'm a little hesitant to go this route as our 
records embed a timestamp, which I'd rather not have to figure out from 
within the kernel.  Perhaps a raw (binary) interface to write records to 
the log would suffice?  /sys/firmware/gsmi/append_to_eventlog ?

If so, does /sys/firmware/gsmi/raw_eventlog make sense too?


Thanks,

Mike Waychison
