Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743Ab2LMU0D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 15:26:03 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37293 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab2LMUZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 15:25:55 -0500
MIME-Version: 1.0
In-Reply-To: <20121213200857.GA24939@otc-wbsnb-06>
References: <1355412708-20046-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1355412708-20046-4-git-send-email-kirill.shutemov@linux.intel.com>
	<20121213184820.GC12105@kroah.com>
	<20121213200857.GA24939@otc-wbsnb-06>
Date: Thu, 13 Dec 2012 12:25:53 -0800
X-Google-Sender-Auth: 5FnIFOhHEm2LYxWFgIutuESvNGY
Message-ID: <CAE9FiQUMSnCPwgbupZ5cFWLMiVxA4FQ2dNWNk+XYhvtEn+F3Ag@mail.gmail.com>
Subject: Re: [PATCH 3/3] PCI Hotplug: workaround for Thunderbolt on Intel
 DZ77RE-75K motherboard
From: Yinghai Lu <yinghai@kernel.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Miles J Penner <miles.j.penner@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Tushar N Dave <tushar.n.dave@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Amos Kong <kongjianjun@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 12:08 PM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> On Thu, Dec 13, 2012 at 10:48:20AM -0800, Greg KH wrote:
>> On Thu, Dec 13, 2012 at 05:31:48PM +0200, Kirill A. Shutemov wrote:
>> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>> >
>> > BIOS on Intel DZ77RE-75K motherboard notifies OS about Thunderbolt
>> > hotplug before devices behind Thunderbolt are ready to be enumerated.
>> >
>> > Let's delay enumeration by 2 seconds.
>> >
>> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>> > ---
>> >  drivers/pci/hotplug/acpiphp_glue.c |   16 +++++++++++++++-
>> >  1 file changed, 15 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
>> > index 1a2b3ca..165987a 100644
>> > --- a/drivers/pci/hotplug/acpiphp_glue.c
>> > +++ b/drivers/pci/hotplug/acpiphp_glue.c
>> > @@ -49,6 +49,7 @@
>> >  #include <linux/mutex.h>
>> >  #include <linux/slab.h>
>> >  #include <linux/acpi.h>
>> > +#include <linux/dmi.h>
>> >
>> >  #include "../pci.h"
>> >  #include "acpiphp.h"
>> > @@ -1327,6 +1328,19 @@ out:
>> >  static void handle_hotplug_event_bridge(acpi_handle handle, u32 type,
>> >                                     void *context)
>> >  {
>> > +   unsigned long delay = 0;
>> > +   const char *board_name;
>> > +
>> > +   board_name = dmi_get_system_info(DMI_BOARD_NAME);
>> > +   /*
>> > +    * BIOS on Intel DZ77RE-75K motherboard notifies OS about Thunderbolt
>> > +    * hotplug before devices behind Thunderbolt are ready to be
>> > +    * enumerated.
>> > +    * Let's delay enumeration by 2 seconds.
>> > +    */
>> > +   if (board_name && !strcmp(board_name, "DZ77RE-75K"))
>> > +           delay = 2 * HZ;
>>

Linus will not be happy with those kind of delay.

is there any way for kernel to retry before device is declared not there.

pcie hotplug spec: need to retry several times in 1000ms before
delcaring the devices is not present.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=2f5d8e4ff947ad6673397083b48719cd6c59cd61
