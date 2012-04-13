Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab2DMQHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 12:07:10 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:45616 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab2DMQHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 12:07:07 -0400
Message-ID: <1334333152.20190.85.camel@misato.fc.hp.com>
Subject: Re: [PATCH 0/5] ACPI: Add _OST support for ACPI hotplug
From: Toshi Kani <toshi.kani@hp.com>
To: shuahkhan@gmail.com
Cc: Jiang Liu <liuj97@gmail.com>, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 13 Apr 2012 10:05:52 -0600
In-Reply-To: <1334330617.2250.4.camel@lorien2>
References: <1334096510-17319-1-git-send-email-toshi.kani@hp.com>
	 <1334161991.2226.18.camel@lorien2>
	 <1334170247.20190.34.camel@misato.fc.hp.com>
	 <1334240353.2222.3.camel@lorien2> <4F88371D.7030305@gmail.com>
	 <1334330617.2250.4.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-13 at 09:23 -0600, Shuah Khan wrote:
> On Fri, 2012-04-13 at 22:24 +0800, Jiang Liu wrote:
> > Hi Shuah and Toshi,
> > 	As I can tell, _OST method has been defined in ACPI4.0 spec and
> > there are some platforms already implemented the _OST method. For example,
> > Quanta QSSC-S4R server implements _OST for hot-pluggable PCI slots, but 
> > it's a little pity that it doesn't implement _OST for the memory board,
> > so we can't test Toshi's patch on that platform.
> > 	According to my understanding, other than notifying BIOS about the
> > event processing result, _OST could also be used to notify BIOS about the
> > IN_PROGRESS state, so BIOS could track the event handling progress and avoid
> > timeout. We have used _OST method to avoid timeout on one of our prototype
> > platforms.
> 
> Thanks Jiang. This is good information about _OST method's timeout
> use-case. Alos good to know there are platforms out there that already
> implement it. Too bad you don't have any platforms to test Toshis's
> patch. Maybe there are others that have one available.

Thanks Jiang for the valuable information!

I would like to explain more detail about my testing.  Unlike other ACPI
methods, the functionality of _OST method is not defined by the spec.
It is all up to the firmware implementation.  For instance, ACPI spec
describes the following example _OST.  It checks Arg0 and Arg1, and
conditionally stores values to control LED.  Other possible
implementation may be for the firmware to manage the progress /
completion of the operation.  In any case, the functionality is a black
box to the OS.

Method(_OST, 3, Serialized) {
                :
  Switch(And(Arg0,0xFF)) // Mask to retain low byte
  {
     Case(0x03)              // Ejection request
     {
        Switch(Arg1)
        {
           Case(Package(){0x80, 0x81, 0x82, 0x83})
           { // Ejection Failure for some reason
             Store(Zero, ^^S3LE) // Turn off Ejection Progress LED
             Store(One, ^^S3LF)  // Turn on Ejection Failure LED
           }
           Case(0x84) // Eject request pending
           {
             Store(One, ^^S3LE)  // Turn on Ejection Request LED
             Store(Zero, ^^S3LF) // Turn off Ejection Failure LED
           }
        }
     }
  }
}

My emulated _OST method is simple, but it essentially does a similar
operation in AML.  Store to Debug is displayed to the console when
aml_debug_output is enabled.  As far as the OS testing is concerned, it
verifies successful execution of the method.

Method (_OST, 3, NotSerialized)
{
     Store ("AML> _OST", Debug)
     Store (Arg0, Debug)
     Store (Arg1, Debug)
     Store (Arg2, Debug)
}

I have tested the emulated _OST method on both CPU and Memory hotplug
operations.  For memory hotplug, I have followed the steps below to
emulate memory hotplug operation as well (some details needed to be
updated for the latest kernel).  It also overrides DSDT to create a
memory device object, and emulates a SCI for the memory hotplug event. 
http://www.spinics.net/lists/hotplug/msg00613.html

Unfortunately, I do not have access to a platform that implements _OST
today.  If anyone has access to such platform, I am willing to work
together for the testing.  Also, if testing on emulated environment is
not adequate, please let me know.  I am open to the suggestion, and
would like to improve my test procedure going forward.

Thanks,
-Toshi

