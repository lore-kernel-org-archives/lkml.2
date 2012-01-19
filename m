Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab2ASPrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 10:47:47 -0500
Received: from mx1.gd-ms.com ([153.11.250.40]:39210 "EHLO mx1.gd-ms.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756238Ab2ASPrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 10:47:42 -0500
X-Greylist: delayed 881 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jan 2012 10:47:41 EST
In-Reply-To: <20120117195841.48fe8236@pyramind.ukuu.org.uk>
References: <OF70B406E9.8D4A6789-ON85257988.0052C104-85257988.0053DE1E@gdeb.com> <20120117195841.48fe8236@pyramind.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kushal Koolwal <kushalkoolwal@gmail.com>,
        linux-kernel@vger.kernel.org, michael.d.labriola@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
        support@versalogic.com, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org
MIME-Version: 1.0
Subject: Re: [PATCH] x86, reboot: skip DMI checks if reboot set by user
X-KeepSent: D4BB6876:6D903346-8525798A:00550E62;
 type=4; name=$KeepSent
Message-ID: <OFD4BB6876.6D903346-ON8525798A.00550E62-8525798A.005562A3@gdeb.com>
From: Michael D Labriola <mlabriol@gdeb.com>
Date: Thu, 19 Jan 2012 10:32:36 -0500
X-GDMEncrypt: FALSE
X-GDMMarking: NOT_SENSITIVE
Content-Type: text/plain; charset="US-ASCII"
X-GDM-EVAL: score: /30; hits: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote on 01/17/2012 02:58:41 PM:

> On Tue, 17 Jan 2012 10:16:03 -0500
> Michael D Labriola <mlabriol@gdeb.com> wrote:
> 
> > This commit causes DMI checks for vendor specific reboot
> > quirks to be skipped if the user passed in a reboot= arg
> > on the command line.
> > 
> > Signed-off-by: Michael D Labriola <mlabriol@gdeb.com>
> > ---
> >  arch/x86/kernel/reboot.c |   16 ++++++++++++++--
> >  1 files changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> > index 37a458b..4240d58 100644
> > --- a/arch/x86/kernel/reboot.c
> > +++ b/arch/x86/kernel/reboot.c
> > @@ -38,6 +38,7 @@ static const struct desc_ptr no_idt = {};
> >  static int reboot_mode;
> >  enum reboot_type reboot_type = BOOT_ACPI;
> >  int reboot_force;
> > +int reboot_user;
> 
> static ...

Oops, good point.

> >                 case 'f':
> >                         reboot_force = 1;
> > +                       reboot_user = 1;
> 
> Cleaner would be to add a 
> 
> BOOT_ACPI_FORCE perhaps so you can tell ACPI v ACPI specified by user
> 
> >                         break;
> >                 }
> > 
> > @@ -316,7 +322,10 @@ static struct dmi_system_id __initdata 
> > reboot_dmi_table[] = {
> > 
> >  static int __init reboot_init(void)
> >  {
> > -       dmi_check_system(reboot_dmi_table);
> > +       /* Skip the DMI check if user set reboot= on the command line 
*/
> > +       if (!reboot_user) {
> 
> then do
> 
>    if (reboot_type == BOOT_ACPI)
> > +               dmi_check_system(reboot_dmi_table);
> > +       }

This seems a little less obvious to the casual observer than the way I
implemented it... but maybe that's just me.  It would indeed disable DMI
checking if reboot_type's value is anything other than BOOT_ACPI (which
is the default), but that does assume BOOT_ACPI is the default.  What if
that's ever changed?  Seems likely to me that whoever changes the default
in the future could very easily re-break this at that point.

Thoughts?

I'm going to resubmit this patche anyway, as Ingo pointed out I've got
line-wrap issues.

---
Michael D Labriola
Electric Boat
mlabriol@gdeb.com
401-848-8871 (desk)
401-848-8513 (lab)
401-316-9844 (cell)


 


