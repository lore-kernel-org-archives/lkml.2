Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab1ATRDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:03:46 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59590 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab1ATRDo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:03:44 -0500
Date: Thu, 20 Jan 2011 18:03:14 +0100
From: Anisse Astier <anisse@astier.eu>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Pascal VITOUX <pascal@substantiel.fr>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH RFC] dmi-scan: Use little-endian for the first 3 fields
 of  the UUID.
Message-ID: <20110120180314.0bb74d65@destiny.ordissimo>
In-Reply-To: <20110119213936.06400e49@endymion.delvare>
References: <20110119185411.49668f81@destiny.ordissimo>
	<20110119213936.06400e49@endymion.delvare>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

Thank you for taking the time to answer and review,

On Wed, 19 Jan 2011 21:39:36 +0100, Jean Delvare <khali@linux-fr.org> wrote :

> Hi Anisse,
> 
> On Wed, 19 Jan 2011 18:54:11 +0100, Anisse Astier wrote:
> > 
> > From: Pascal VITOUX <pascal@substantiel.fr>
> > 
> >  - Get SMBIOS version.
> >  - Byte-swap the first 3 fields of the UUID (DMI type 1) as off SMBIOS
> >    version 2.6.
> > 
> > This patch is an adaptation of Jean Delvare patches for dmidecode
> > rev1.100, rev1.01 and rev1.119.
> > http://cvs.savannah.gnu.org/viewvc/dmidecode/dmidecode.c?root=dmidecode&view=log
> 
> Note that I am not particularly proud of this patch, and even thought
> of reverting it at some point. It is possible that dmidecode 2.12 will
> have different code for UUID decoding. The current behavior would stay
> the default, but the user would be able to force one decoding order
> through a command line option.  This was suggested a long time ago:
> http://www.mail-archive.com/dmidecode-devel@nongnu.org/msg00096.html
> I disregarded the proposal back then. Now... Well, I'm still not sure :(
> 
> > It is intended to get the same uuid from dmidecode tool as from sysfs kernel
> > tree, more compliant with SMBIOS specification.
> 
> I understand that it makes sense to have dmidecode and the kernel
> return the same value. But the problem is that it appears that, in
> practice, vendors don't follow the recommendations of the SMBIOS 2.6
> specifications. On most machines I've checked, the network byte order
> is used, per RFC4122.
> 
> Also, while the change in dmidecode was applied at the time SMBIOS 2.6
> implementations were rare, this is no longer true. So a change now may
> have consequences.

Yes, unfortunately.

> 
> > Therefore this patch will have the kernel return a different UUID if you
> > are using a recent BIOS implementing SMBIOS >= 2.6.
> > 
> > Signed-off-by: Pascal VITOUX <pascal@substantiel.fr>
> > Signed-off-by: Anisse Astier <anisse@astier.eu>
> > ---
> > Hi,
> > 
> > I'd like to get some feedback on this patch. It doesn't modify the
> > API/ABI, but modifies the value returned by kernel on a given hardware,
> > so it could potentially break a (very) badly written app.
> 
> I fail to see why an application relying on the UUID would qualify as
> "badly written". The UUID seems like a reasonable thing to use for any
Yep, my  bad, that's not what I meant. Replace "break" by "crash", and
badly written app by "app that doesn't fail graciously if returned a
different value".


> inventory application, as a mean to uniquely identify machines. Using
> it for licensing purpose also makes sense (whether you you like
> proprietary software or not is irrelevant.)
Glad we agree, that's what we use it for.

> 
> This is a desperate case anyway, there simply is no clean solution to
> this problem. Whoever suggested the addition of this note in the SMBIOS
> 2.6 specification should be banned permanently from ever contributing
> to any technical document.
What do you suggest we do ?

Something needs to be done about that. You already have a problem if
you're relying on DMI UUIDs. An example of an app  using HAL(obsolete, I
know): Old versions of HAL would call dmidecode to provide the fetch the
DMI UUID. But if you upgrade to a more recent version, it will get the
information directly from kernel. And now you have it, a different UUID
for the same hardware.


Now, I can see three different "solutions" to bring kernel and dmidecode
on par :
 (1) we keep the current kernel behavior and next dmidecode version changes
     its default. It will break applications relying on dmidecode.
 (2) we keep dmidecode default and change kernel behavior. It will break
     applications relying on kernel DMI UUID.
 (3) we add a new kernel sysfs file that provides the UUID with the
     SMBIOS 2.6 behavior. Current breakage is patchable in apps by
     switching them to the new file.

> 
> > Disclaimer: Although I've applied my Signed-off-by, Pascal and I work for
> > the same company.
> > 
> > Regards,
> > Anisse
> > 
> > ---
> >  drivers/firmware/dmi_scan.c |   36 ++++++++++++++++++++++++++++++++++--
> >  1 files changed, 34 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> > index e28e41668..b6278a7 100644
> > --- a/drivers/firmware/dmi_scan.c
> > +++ b/drivers/firmware/dmi_scan.c
> > @@ -99,6 +99,7 @@ static void dmi_table(u8 *buf, int len, int num,
> >  static u32 dmi_base;
> >  static u16 dmi_len;
> >  static u16 dmi_num;
> > +static u16 dmi_ver;
> >  
> >  static int __init dmi_walk_early(void (*decode)(const struct dmi_header *,
> >  		void *))
> > @@ -169,7 +170,18 @@ static void __init dmi_save_uuid(const struct dmi_header *dm, int slot, int inde
> >  	if (!s)
> >  		return;
> >  
> > -	sprintf(s, "%pUB", d);
> > +	/*
> > +	 * As off version 2.6 of the SMBIOS specification, the first 3
> > +	 * fields of the UUID are supposed to be encoded on little-endian.
> > +	 * The specification says that this is the defacto standard,
> > +	 * however I've seen systems following RFC 4122 instead and use
> > +	 * network byte order, so I am reluctant to apply the byte-swapping
> > +	 * for older versions.
> > +	 */
> > +	if (dmi_ver >= 0x0206)
> > +		sprintf(s, "%pUL", d);
> > +	else
> > +		sprintf(s, "%pUB", d);
> >  
> >          dmi_ident[slot] = s;
> >  }
> > @@ -400,9 +412,29 @@ static int __init dmi_present(const char __iomem *p)
> >  		dmi_base = (buf[11] << 24) | (buf[10] << 16) |
> >  			(buf[9] << 8) | buf[8];
> >  
> > +		/* SMBIOS version */
> > +		dmi_ver = (*(u8 *)(p - 0x10 + 0x06) << 8) +
> > +			*(u8 *)(p - 0x10 + 0x07);
> 
> You can't do that, sorry. Only the 15 bytes of the _DMI_ entry point
> have been iomap'd, the 16 bytes of the _SM_ entry point (which may not
> even exist!) have not. I suspect you'll have to rework the loop in
> dmi_scan_machine() and the way it calls dmi_present() quite a bit.
Indeed, I didn't notice that.

I think the loop is safe, because we ioremap 64k of data. Only the
first call to dmi_present seems to be risky. (just FYI, code worked in
our tests)

> 
> > +
> > +		/* Some BIOS report weird SMBIOS version, fix that up */
> > +		switch (dmi_ver) {
> > +		case 0x021F:
> > +			printk(KERN_INFO "SMBIOS version fixup (2.%d -> 2.%d).\n",
> > +			       31, 3);
> > +			dmi_ver = 0x0203;
> > +			break;
> > +		case 0x0233:
> > +			printk(KERN_INFO "SMBIOS version fixup (2.%d -> 2.%d).\n",
> > +			       51, 6);
> > +			dmi_ver = 0x0206;
> > +			break;
> > +		}
> 
> Note that I've added one more fixup meanwhile:
>   http://cvs.savannah.gnu.org/viewvc/dmidecode/dmidecode.c?root=dmidecode&r1=1.145&r2=1.146
Yes, this should be added too. As you have guessed, we wrote this code
prior to this new fixup.

> 
> > +		printk(KERN_INFO "SMBIOS version %d.%d.\n", dmi_ver >> 8,
> > +		       dmi_ver & 0xFF);
> > +
> >  		/*
> >  		 * DMI version 0.0 means that the real version is taken from
> > -		 * the SMBIOS version, which we don't know at this point.
> > +		 * the SMBIOS version.
> 
> Changing the comment without changing the code that follows it makes no
> sense.
Indeed, the comment didn't make sense without changes, but the following
code (and previous printf) either.

Does this look better (removing previous printf):
                /*
                 * DMI version 0.0 means that the real version is taken from
                 * the SMBIOS version.
                 */
                if (buf[14] != 0)
                        printk(KERN_INFO "DMI %d.%d present.\n",
                               buf[14] >> 4, buf[14] & 0xF);
                else
                        printk(KERN_INFO "DMI %d.%d(SMBIOS) present.\n", dmi_ver >> 8,
                       dmi_ver & 0xFF);



Regards,
Anisse

> 
> >  		 */
> >  		if (buf[14] != 0)
> >  			printk(KERN_INFO "DMI %d.%d present.\n",
> 
> 
