Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab2EDOpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 10:45:41 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:30511 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2EDOpj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 10:45:39 -0400
Date: Fri, 4 May 2012 10:39:48 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Marco Aurelio da Costa <costa@gamic.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] ACPI: Ignore invalid _PSS entries, but use valid
 ones
Message-ID: <20120504143948.GD1049@phenom.dumpdata.com>
References: <CAEe-dwgCR55urie0c1MdBWTS6-E=3faXj68=WMcb6NvQCQX0rg@mail.gmail.com>
 <20120504135217.GB1049@phenom.dumpdata.com>
 <CAEe-dwj4JP-U0tc3wpmHvzv=aQU5zy3cG_E9FrriPw_sdfg2bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAEe-dwj4JP-U0tc3wpmHvzv=aQU5zy3cG_E9FrriPw_sdfg2bg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 11:13:22AM -0300, Marco Aurelio da Costa wrote:
> Hi, Konrad.
> 
> On Fri, May 4, 2012 at 10:52 AM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > On Fri, May 04, 2012 at 10:46:01AM -0300, Marco Aurelio da Costa wrote:
> >> From: Marco Aurelio da Costa <costa@gamic.com>
> >> Signed-off-by: Marco Aurelio da Costa <costa@gamic.com>
> >>
> >> The EliteBook 8560W has non-initialized entries in its _PSS ACPI
> >> table. Instead of bailing out when the first non-initialized entry is
> >> found, ignore it and use only  the valid entries. Only bail out if there
> >> is no valid entry at all.
> >
> > Is that safe? Meaning re-use the other CPU's _PSS states? Perhaps the
> > warning at the end should say: "Trying to compensate by using the
> > other CPU's PSS state).
> 
> This case in question was created by HP removing the overclock options
> and leaving the entries in a invalid/empty situation. In this specific
> case, it is safe.
> I am not changing the table in any way, I just ignore the
> non-initialized entries. The code only use listed states. If they are
> CPU bound, the code doesn't assume anything.
> 
> >
> >>
> >> ---
> >> --- linux-3.3.3/drivers/acpi/processor_perflib.c.orig   2012-04-24
> >> 22:18:23.288041268 +0200
> >> +++ linux-3.3.3/drivers/acpi/processor_perflib.c        2012-04-24
> >> 22:19:25.912042603 +0200
> >> @@ -311,6 +311,7 @@ static int acpi_processor_get_performanc
> >>        struct acpi_buffer state = { 0, NULL };
> >>        union acpi_object *pss = NULL;
> >>        int i;
> >> +       int last_invalid = -1;
> >>
> >>
> >>        status = acpi_evaluate_object(pr->handle, "_PSS", NULL, &buffer);
> >> @@ -374,12 +375,30 @@ static int acpi_processor_get_performanc
> >>                        printk(KERN_ERR FW_BUG PREFIX
> >>                               "Invalid BIOS _PSS frequency: 0x%llx MHz\n",
> >>                               px->core_frequency);
> >> -                       result = -EFAULT;
> >> -                       kfree(pr->performance->states);
> >> -                       goto end;
> >> +                       if (-1 == last_invalid)
> >
> > Swap it around or just do it this way:
> 
> Ok.
> 
> >
> > if (last_invalid < 0)
> >
> >> +                               last_invalid = i;
> >> +               } else {
> >> +                       if (last_invalid != -1) {
> >
> > if (last_invalid >= 0)
> >
> >> +                               /*
> >> +                                * Copy this valid entry over last_invalid entry
> >> +                                */
> >> +                               memcpy(&(pr->performance->states[last_invalid]),
> >> +                                      px, sizeof(struct acpi_processor_px));
> >> +                               ++last_invalid;
> >> +                       }
> >>                }
> >>        }
> >>
> >> +       if (0 == last_invalid) {
> >
> > So if _PSS that is missing is at CPU2, this own't print it.
> 
> I don't get what do you mean by CPU. last_invalid is just the last
> invalid _PSS entry item. Nothing to do with the CPU.

The loop is based on CPU, oh wait. Not this loop. You are right - ignore
that comment please.
> 
> >
> > I think you want 'if (last_invalid >= 0)'
> 
> No, it is correct. If the last invalid found item is the item 0, than
> it means that no valid item was found.

I somehow thought that the 'i' was for the for_each_possible(cpu), but
that is another funtion.

> 
> >
> >> +               printk(KERN_ERR FW_BUG PREFIX
> >> +                      "No valid BIOS _PSS frequency found\n");
> >
> > And you should mention which CPU has it busted - as there are
> > some that are working.
> 
> No CPU here, just the _PSS item.

Add pr->id - that will tell us which of the _PSS entries is defective.

> 
> >
> >
> >> +               result = -EFAULT;
> >> +               kfree(pr->performance->states);
> >> +       }
> >> +
> >> +       if (last_invalid > 0)
> >
> > Don't you want 'last_invalid >= 0' ?
> 
> No. It is correct. If the last invalid item is greater than 0, then
> there was at least 1 valid _PSS entry. And the count of valid entries
> is the same as the last_invalid variable.
> 
> >
> >> +               pr->performance->state_count = last_invalid;
> >> +
> >>       end:
> >>        kfree(buffer.pointer);
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> I will send the corrected patch next.
> 
> 
> -- 
> Marco Costa
> Customer Support
> --
> GAMIC mbH
> Roermonder Strasse, 151
> 52072 Aachen
> Germany
