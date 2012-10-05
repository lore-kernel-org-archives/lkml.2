Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab2JEP1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:27:15 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:32935 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753216Ab2JEP1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:27:13 -0400
Message-ID: <1349450831.2008.71.camel@joe-AO722>
Subject: Re: [PATCH] revert "PCI: log vendor/device ID always"
From: Joe Perches <joe@perches.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Fri, 05 Oct 2012 08:27:11 -0700
In-Reply-To: <CAErSpo6=9vdoR=Z83jyDrHAc_4XAL+rHw55=UeXf8C+N=xUHrw@mail.gmail.com>
References: <1349187780-25692-1-git-send-email-nzimmer@sgi.com>
	 <CAErSpo7ZQEm9==nsGiH2c_ZG8LPP8MAA8M9xSPyWPtCW2EHUUQ@mail.gmail.com>
	 <506DB30F.2000704@sgi.com> <1349368662.2008.20.camel@joe-AO722>
	 <506EE6D5.4010603@sgi.com> <1349446478.2008.66.camel@joe-AO722>
	 <506EF48B.5070801@sgi.com>
	 <CAErSpo6=9vdoR=Z83jyDrHAc_4XAL+rHw55=UeXf8C+N=xUHrw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-05 at 09:16 -0600, Bjorn Helgaas wrote:
> On Fri, Oct 5, 2012 at 8:54 AM, Nathan Zimmer <nzimmer@sgi.com> wrote:
> > On 10/05/2012 09:14 AM, Joe Perches wrote:
> >> On Fri, 2012-10-05 at 08:55 -0500, Nathan Zimmer wrote:
> >>> On 10/04/2012 11:37 AM, Joe Perches wrote:
> >>>> On Thu, 2012-10-04 at 11:02 -0500, Nathan Zimmer wrote:
> >>>>> At many of our customer sites the log level is set to KERN_DEBUG. It
> >>>>> helps avoid reboots due to operator impatience.  Machines this large
> >>>>> take significantly longer then typical to boot and seeing the extra
> >>>>> messages reassures them that the kernel isn't hung.
> >>>>
> >>>> That argues for adding some KERN_INFO "still booting" messages
> >>>> not logging unnecessary KERN_DEBUG messages.
> >>>>
> >>> Actually I would think that argues for reducing boot times on these
> >>> large systems.
> >>
> >> Right.
> >>
> >> That's an independent argument, but sure, go ahead
> >> and do that too.
[]
> > Here is output for my workstation a simple 4x box
> >
> > -bash-4.1$ dmesg | grep "type [0-9][0-9] class" | wc
> >      12     108     804
> > -bash-4.1$ dmesg | wc
> >     744    6359   49474
> > Here is some output from one of the biggest boxes.
> > -bash-4.1$ dmesg | wc
> >   26503  235414 1811651
> > -bash-4.1$ dmesg | grep "type [0-9][0-9] class" | wc
> >   12085 108765  821780
> 
> Many vendors don't expose host bridges that lead to the CPU-related
> PCI devices because they don't want the OS to muck with them.  We
> currently blindly probe for these in domain 0, so we find them anyway
> (I think we should change this behavior).
> 
> I'd guess that having all these CPU-related devices around also really
> clutters up "lspci" output, and of course, consumes memory for all the
> pci_dev structs in the kernel.  It takes some time to enumerate them
> all, so avoiding that would speed up boot somewhat.
> 
> So I wonder if it might be more useful to figure out how to avoid
> enumerating those devices in the first place?  The first step would be
> to stop exposing PNP0A03/PNP0A08 host bridges that lead to them.  As I
> mentioned, we currently will probably find them anyway via blind
> probing.  You might be able to avoid that if you could place them in a
> PCI domain other than 0

And in the meantime, maybe something like this and not logging
at KERN_DEBUG when using verbose_boot would help avoid impatient
operator reboots.

 drivers/pci/hotplug/sgi_hotplug.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/hotplug/sgi_hotplug.c b/drivers/pci/hotplug/sgi_hotplug.c
index f64ca92..b3abd1a 100644
--- a/drivers/pci/hotplug/sgi_hotplug.c
+++ b/drivers/pci/hotplug/sgi_hotplug.c
@@ -368,6 +368,10 @@ static int enable_slot(struct hotplug_slot *bss_hotplug_slot)
 		}
 	}
 
+	if (some_verbose_boot_flag)
+		dev_info(&slot->pci_bus->self->dev, "Testing slot %d\n",
+			 slot->device_num + 1);
+
 	num_funcs = pci_scan_slot(slot->pci_bus,
 				  PCI_DEVFN(slot->device_num + 1, 0));
 	if (!num_funcs) {



