Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab2KPEd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 23:33:29 -0500
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:27267 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2KPEd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 23:33:28 -0500
From: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linasvepstas@gmail.com" <linasvepstas@gmail.com>,
        Myron Stowe <myron.stowe@gmail.com>,
        "Ortiz, Lance E" <lance.oritz@hp.com>,
        Huang Ying <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "Patterson, Andrew D (LeftHand Networks)" <andrew.patterson@hp.com>,
        "Zhang Yanmin" <yanmin.zhang@intel.com>
Subject: RE: [ PATCH RESEND ] PCI-AER: Do not report successful error
 recovery for devices with AER-unaware drivers
Thread-Topic: [ PATCH RESEND ] PCI-AER: Do not report successful error
 recovery for devices with AER-unaware drivers
Thread-Index: AQHNvxa8hUTykftZIUuYHm9OnADUU5fqGGEAgABOxuCAAUh6AIAANCaA
Date: Fri, 16 Nov 2012 04:26:33 +0000
Message-ID: <F9E001219150CB45BEDC82A650F360C901469D3E@G9W0717.americas.hpqcorp.net>
References: <F9E001219150CB45BEDC82A650F360C90146794E@G9W0717.americas.hpqcorp.net>
 <20121115005100.GA6613@google.com>
 <F9E001219150CB45BEDC82A650F360C901469A26@G9W0717.americas.hpqcorp.net>
 <CAErSpo7gvo8rA1k25kn4put7Cky8LZK0OeWRCapH5f3sPb7srQ@mail.gmail.com>
In-Reply-To: <CAErSpo7gvo8rA1k25kn4put7Cky8LZK0OeWRCapH5f3sPb7srQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.201.58.29]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> Sent: Thursday, November 15, 2012 5:09 PM
> To: Pandarathil, Vijaymohan R
> Cc: linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org;
> linasvepstas@gmail.com; Myron Stowe; Ortiz, Lance E; Huang Ying; Hidetoshi
> Seto; Patterson, Andrew D (LeftHand Networks); Zhang Yanmin
> Subject: Re: [ PATCH RESEND ] PCI-AER: Do not report successful error
> recovery for devices with AER-unaware drivers
> 
> On Thu, Nov 15, 2012 at 12:09 AM, Pandarathil, Vijaymohan R
> <vijaymohan.pandarathil@hp.com> wrote:
> > Thanks for the comments. See my response below.
> >
> >> -----Original Message-----
> >> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> >> Sent: Wednesday, November 14, 2012 4:51 PM
> >> To: Pandarathil, Vijaymohan R
> >> Cc: linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org;
> >> linasvepstas@gmail.com; Myron Stowe; Ortiz, Lance E; Huang Ying;
> Hidetoshi
> >> Seto; Patterson, Andrew D (LeftHand Networks); Zhang Yanmin
> >> Subject: Re: [ PATCH RESEND ] PCI-AER: Do not report successful error
> >> recovery for devices with AER-unaware drivers
> >>
> >> [+cc Lance, Huang, Hidetoshi, Andrew, Zhang]
> >>
> >> On Sat, Nov 10, 2012 at 07:41:04AM +0000, Pandarathil, Vijaymohan R
> wrote:
> >> > When an error is detected on a PCIe device which does not have an
> >> > AER-aware driver, prevent AER infrastructure from reporting
> >> > successful error recovery.
> >> >
> >> > This is because the report_error_detected() function that gets
> >> > called in the first phase of recovery process allows forward
> >> > progress even when the driver for the device does not have AER
> >> > capabilities. It seems that all callbacks (in pci_error_handlers
> >> > structure) registered by drivers that gets called during error
> >> > recovery are not mandatory. So the intention of the infrastructure
> >> > design seems to be to allow forward progress even when a specific
> >> > callback has not been registered by a driver. However, if error
> >> > handler structure itself has not been registered, it doesn't make
> >> > sense to allow forward progress.
> >> >
> >> > As a result of the current design, in the case of a single device
> >> > having an AER-unaware driver or in the case of any function in a
> >> > multi-function card having an AER-unaware driver, a successful
> >> > recovery is reported.
> >> >
> >> > Typical scenario this happens is when a PCI device is detached
> >> > from a KVM host and the pci-stub driver on the host claims the
> >> > device. The pci-stub driver does not have error handling capabilities
> >> > but the AER infrastructure still reports that the device recovered
> >> > successfully.
> >> >
> >> > The changes proposed here leaves the device in an unrecovered state
> >> > if the driver for the device or for any function in a multi-function
> >> > card does not have error handler structure registered. This reflects
> >> > the true state of the device and prevents any partial recovery (or no
> >> > recovery at all) reported as successful.
> >> >
> >> > Please also see comments from Linas Vepstas at the following link
> >> > http://www.spinics.net/lists/linux-pci/msg18572.html
> >> >
> >> > Reviewed-by: Linas Vepstas <linasvepstas <at> gmail.com>
> >> > Reviewed-by: Myron Stowe <mstowe <at> redhat.com>
> >> > Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil <at>
> >> hp.com>
> >> >
> >> > ---
> >> >
> >> > drivers/pci/pcie/aer/aerdrv_core.c | 6 ++++++
> >> >  1 file changed, 6 insertions(+)
> >> >
> >> > diff --git a/drivers/pci/pcie/aer/aerdrv_core.c
> >> b/drivers/pci/pcie/aer/aerdrv_core.c
> >> > index 06bad96..030b229 100644
> >> > --- a/drivers/pci/pcie/aer/aerdrv_core.c
> >> > +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> >> > @@ -215,6 +215,12 @@ static int report_error_detected(struct pci_dev
> >> *dev, void *data)
> >> >
> >> >     dev->error_state = result_data->state;
> >> >
> >> > +   if ((!dev->driver || !dev->driver->err_handler) &&
> >> > +           !(dev->hdr_type & PCI_HEADER_TYPE_BRIDGE)) {
> >> > +           dev_info(&dev->dev, "AER: Error detected but no driver has
> >> claimed this device or the driver is AER-unaware\n");
> >> > +           result_data->result = PCI_ERS_RESULT_NONE;
> >> > +           return 1;
> >>
> >> This doesn't seem right because returning 1 here causes pci_walk_bus()
> >> to terminate, which means we won't set dev->error_state or notify
> >> drivers for any devices we haven't visited yet.
> >>
> >> > +   }
> >> >     if (!dev->driver ||
> >> >             !dev->driver->err_handler ||
> >> >             !dev->driver->err_handler->error_detected) {
> >>
> >> If none of the drivers in the affected hierarchy supports error
> handling,
> >> I think the call tree looks like this:
> >>
> >>     do_recovery                                 # uncorrectable only
> >>         broadcast_error_message(dev, ..., report_error_detected)
> >>             result_data.result = CAN_RECOVER
> >>             pci_walk_bus(..., report_error_detected)
> >>                 report_error_detected           # (each dev in subtree)
> >>                     return 0                    # no change to result
> >>             return result_data.result
> >>         broadcast_error_message(dev, ..., report_mmio_enabled)
> >>             result_data.result = PCI_ERS_RESULT_RECOVERED
> >>             pci_walk_bus(..., report_mmio_enabled)
> >>                 report_mmio_enabled             # (each dev in subtree)
> >>                     return 0                    # no change to result
> >>         dev_info("recovery successful")
> >>
> >> Specifically, there are no error_handler functions, so we never change
> >> result_data.result, and the default is that we treat the error as
> >> "recovered successfully."  That seems broken.  An uncorrectable error
> >> is by definition recoverable only by device-specific software, i.e.,
> >> the driver.  We didn't call any drivers, so we can't have recovered
> >> anything.
> >>
> >> What do you think of the following alternative?  I don't know why you
> >> checked for bridge devices in your patch, so I don't know whether
> >> that's important here or not.
> >>
> >> diff --git a/drivers/pci/pcie/aer/aerdrv_core.c
> >> b/drivers/pci/pcie/aer/aerdrv_core.c
> >> index 06bad96..a109c68 100644
> >> --- a/drivers/pci/pcie/aer/aerdrv_core.c
> >> +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> >> @@ -231,11 +231,11 @@ static int report_error_detected(struct pci_dev
> *dev,
> >> void *data)
> >>                                  dev->driver ?
> >>                                  "no AER-aware driver" : "no driver");
> >>               }
> >> -             return 0;
> >> +             vote = PCI_ERS_RESULT_DISCONNECT;
> >> +     } else {
> >> +             err_handler = dev->driver->err_handler;
> >> +             vote = err_handler->error_detected(dev, result_data-
> >state);
> >>       }
> >> -
> >> -     err_handler = dev->driver->err_handler;
> >> -     vote = err_handler->error_detected(dev, result_data->state);
> >>       result_data->result = merge_result(result_data->result, vote);
> >>       return 0;
> >>  }
> >
> > This would definitely set the error_state for all devices correctly.
> However, with the
> > current implementation of merge_result(), won't we still end up reporting
> successful
> > recovery ? The following case statement in merge_result() can set back
> the result
> > from PCI_ERS_RESULT_DISCONNECT to PCI_ERS_RESULT_NEED_RESET for a
> subsequent device
> > on the bus which returned PCI_ERS_RESULT_NEED_RESET from its
> error_detected callback .
> >
> > merge_result()
> > ...
> >         case PCI_ERS_RESULT_DISCONNECT:
> >                 if (new == PCI_ERS_RESULT_NEED_RESET)
> >                         orig = new;
> >                 break;
> >
> > This would mean do_recovery() proceeds along to the next
> broadcast_message and
> > ultimately report success. Right ? Let me know if I am missing something.
> 
> Yes, I think you're right.  I only looked at the case where none of
> the devices in the subtree had drivers.
> 
> > I looked at a few options and the following looked more promising.
> Thoughts ?
> >
> > Introduce a new pci_ers_result enum PCI_ERS_RESULT_NO_AER_DRIVER and make
> changes as follows.
> 
> I don't really like this new enum because it's not really obvious how
> it's different from PCI_ERS_RESULT_NONE and, more importantly, it
> makes merge_result() even more of a kludge than it already is.
> 
> It's hard to write a nice simple description of this algorithm
> (visiting all the devices in a subtree, collecting error handler
> results, and merging them).  It would be a lot easier to describe if
> merge_result() could be written simply as "max()", but I'm not sure
> the pci_ers_result codes could be ordered in a way that would make
> that possible.  And the desired semantics might make it impossible,
> too.
> 
> I think the intent of your patch is that if there's any device in the
> subtree that lacks an .error_detected() method, we do not call
> .mmio_enabled() or .slot_reset() or .resume() for *any* device in the
> subtree.  Right?

Right. 

BTW, I did look at usage of PCI_ERS_RESULT_NONE in all places.
It seemed to me that the intended semantics of PCI_ERS_RESULT_NONE may 
not have been followed everywhere and I did not want to take a risk of 
breaking something else at this time. I will see if I can cleanup 
merge_result() as a separate patch in future.

> 
> So maybe this is the best we can do, and it certainly seems better
> than what we have now.  Can you repost this as a fresh v2 patch?

Okay. I will post a v2 patch.

> 
> > diff --git a/drivers/pci/pcie/aer/aerdrv.h
> b/drivers/pci/pcie/aer/aerdrv.h
> > index 94a7598..149ba79 100644
> > --- a/drivers/pci/pcie/aer/aerdrv.h
> > +++ b/drivers/pci/pcie/aer/aerdrv.h
> > @@ -87,6 +87,9 @@ struct aer_broadcast_data {
> >  static inline pci_ers_result_t merge_result(enum pci_ers_result orig,
> >                 enum pci_ers_result new)
> >  {
> > +       if (new == PCI_ERS_RESULT_NO_AER_DRIVER)
> > +               return new;
> 
> BTW, if you keep this, please just use "return
> PCI_ERS_RESULT_NO_AER_DRIVER" rather than "return new" since we *know*
> what we're returning.  I think there's another instance of this in
> merge_result() that you could fix, too.

Will do.

> 
> > +
> >         if (new == PCI_ERS_RESULT_NONE)
> >                 return orig;
> >
> > diff --git a/drivers/pci/pcie/aer/aerdrv_core.c
> b/drivers/pci/pcie/aer/aerdrv_core.c
> > index 06bad96..729580a 100644
> > --- a/drivers/pci/pcie/aer/aerdrv_core.c
> > +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> > @@ -231,11 +231,12 @@ static int report_error_detected(struct pci_dev
> *dev, void *data)
> >                                    dev->driver ?
> >                                    "no AER-aware driver" : "no driver");
> >                 }
> > -               return 0;
> > +               vote = PCI_ERS_RESULT_NO_AER_DRIVER;
> > +       } else {
> > +               err_handler = dev->driver->err_handler;
> > +               vote = err_handler->error_detected(dev, result_data-
> >state);
> >         }
> >
> > -       err_handler = dev->driver->err_handler;
> > -       vote = err_handler->error_detected(dev, result_data->state);
> >         result_data->result = merge_result(result_data->result, vote);
> >         return 0;
> >  }
> > diff --git a/include/linux/pci.h b/include/linux/pci.h
> > index ee21795..fb7e869 100644
> > --- a/include/linux/pci.h
> > +++ b/include/linux/pci.h
> > @@ -538,6 +538,9 @@ enum pci_ers_result {
> >
> >         /* Device driver is fully recovered and operational */
> >         PCI_ERS_RESULT_RECOVERED = (__force pci_ers_result_t) 5,
> > +
> > +       /* No AER capabilities registered for the driver */
> > +       PCI_ERS_RESULT_NO_AER_DRIVER = (__force pci_ers_result_t) 6,
> >  };
> >
> >  /* PCI bus error event callbacks */
> >
