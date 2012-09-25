Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab2IYOVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 10:21:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36770 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab2IYOVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:21:17 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 2/2] ACPI: Override arbitrary ACPI tables via initrd for debugging
Date: Tue, 25 Sep 2012 16:17:04 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.20-desktop; KDE/4.6.0; x86_64; ; )
Cc: hpa@zytor.com, initramfs@vger.kernel.org, robert.moore@intel.com,
        lenb@kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, eric.piel@tremplin-utc.net, vojcek@tlen.pl
References: <1348234085-39220-1-git-send-email-trenn@suse.de> <1348234085-39220-3-git-send-email-trenn@suse.de> <CAE9FiQX64iRo9QjhEPYtEOhbEweKSmTssQ50VfPznWtHA345CQ@mail.gmail.com>
In-Reply-To: <CAE9FiQX64iRo9QjhEPYtEOhbEweKSmTssQ50VfPznWtHA345CQ@mail.gmail.com>
MIME-Version: 1.0
X-Length: 8593
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209251617.04840.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...
> > +       /*
> > +        * Only calling e820_add_reserve does not work and the
> > +        * tables are invalid (memory got used) later.
> > +        * memblock_x86_reserve_range works as expected and the tables
> > +        * won't get modified. But it's not enough because ioremap will
> > +        * complain later (used by acpi_os_map_memory) that the pages
> > +        * that should get mapped are not marked "reserved".
> > +        * Both memblock_x86_reserve_range and e820_add_region works fine.
> > +        */
> > +       memblock_reserve(acpi_tables_addr, acpi_tables_addr + all_tables_size);
> > +       e820_add_region(acpi_tables_addr, all_tables_size, E820_ACPI);
> > +       update_e820();
> 
> need to move those arch related to arch/x86

I agree it should get moved out.
I have split this into a separate patch.

> > +       p = early_ioremap(acpi_tables_addr, all_tables_size);
> > +
> > +       for (no = 0; no < table_nr; no++) {
> > +               memcpy(p + total_offset, early_initrd_files[no].data,
> > +                      early_initrd_files[no].size);
> > +               total_offset += early_initrd_files[no].size;
> > +       }
> 
> You may use one loop function, and it could take one call back.
> callback 1 will get item and size.
> callback 2 will do the copy...
> 
> so you can remove hard limit of ACPI_OVERRIDE_TABLES.
I do not fully understand this one.
Currently I have 3 steps:
  1) iterate over all tables and
      - remember address and size of each
      - sum up total size
  2) memblock reserve total size
  3) copy each table into the memblock reserved area

I cannot see how I could get around the limit easily.
Also the restriction is not a big deal, 10 tables is
a lot. It can also be increased without much bad side-effects,
because all xy[ACPI_OVERRIDE_TABLES] arrays are not global.

I'll sent a split up patchset...

> > +       early_iounmap(p, all_tables_size);
> > +}
> > +#endif /* CONFIG_ACPI_INITRD_TABLE_OVERRIDE */
> > +
> > +static void acpi_table_taint(struct acpi_table_header *table)
> > +{
> > +       pr_warn(PREFIX
> > +               "Override [%4.4s-%8.8s], this is unsafe: tainting kernel\n",
> > +               table->signature, table->oem_table_id);
> > +       add_taint(TAINT_OVERRIDDEN_ACPI_TABLE);
> > +}
> > +
> 
> can you split acpi_table_taint split change to another patch?
Yep.

> >  acpi_status
> >  acpi_os_table_override(struct acpi_table_header * existing_table,
> >                        struct acpi_table_header ** new_table)
> > @@ -547,24 +678,74 @@ acpi_os_table_override(struct acpi_table_header * existing_table,
> >         if (strncmp(existing_table->signature, "DSDT", 4) == 0)
> >                 *new_table = (struct acpi_table_header *)AmlCode;
> >  #endif
> > -       if (*new_table != NULL) {
> > -               printk(KERN_WARNING PREFIX "Override [%4.4s-%8.8s], "
> > -                          "this is unsafe: tainting kernel\n",
> > -                      existing_table->signature,
> > -                      existing_table->oem_table_id);
> > -               add_taint(TAINT_OVERRIDDEN_ACPI_TABLE);

One taint too much the one below is enough...

> > -       }
> > +       if (*new_table != NULL)
> > +               acpi_table_taint(existing_table);
> >         return AE_OK;
> >  }
> >
> >  acpi_status
> >  acpi_os_physical_table_override(struct acpi_table_header *existing_table,
> > -                               acpi_physical_address * new_address,
> > -                               u32 *new_table_length)
> > +                               acpi_physical_address *address,
> > +                               u32 *table_length)
> >  {
> > -       return AE_SUPPORT;
> > -}
> > +#ifndef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
> > +       *table_length = 0;
> > +       *address = 0;
> > +       return AE_OK;
> > +#else
> 
> also could hide macro in header file.
No, that's not possible.
This would be acpica, multi OS headers, I doubt they want
to have Linux specific macros in there...
 
I addressed all the rest and will sent out split up patches.

Thanks for your review!

   Thomas
