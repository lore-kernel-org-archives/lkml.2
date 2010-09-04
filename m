Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab0IDPHx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 11:07:53 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:49426 "EHLO
	mx01.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753443Ab0IDPHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 11:07:52 -0400
Date: Sat, 4 Sep 2010 11:07:43 -0400 (EDT)
From: caiqian@redhat.com
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Dave Anderson <anderson@redhat.com>, tj@kernel.org, gregkh@suse.de,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <644534732.119281283612863144.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <837631540.119231283612666731.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Subject: Re: crash failure with 2.6.36-rc3 vmcore
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the confusion. Here is some background. The test here was to use the crash utility to analyse a vmcore generated from kdump. This commit caused its subcommand mod -S failed to gather the module section data from the in-kernel data structure as it looks like it still depends on this field. I am not sure if that the crash utility just need to be adjusted to cope with this kernel change.

>From http://people.redhat.com/anderson/crash_sources/symbols.c
/*
 *  Gather the module section data from the in-kernel data structures.
 */
static int
add_symbol_file_kallsyms(struct load_module *lm, struct gnu_request *req)
{
        int len, buflen, done, nsections, retval;
        ulong vaddr, array_entry, attribute, owner, name, address;
        long name_type;
        char buf[BUFSIZE];
        char section_name[BUFSIZE];
        ulong section_vaddr;

        if (!(st->flags & (MODSECT_V1|MODSECT_V2|MODSECT_V3|MODSECT_UNKNOWN))) {
                STRUCT_SIZE_INIT(module_sect_attr, "module_sect_attr");
                MEMBER_OFFSET_INIT(module_sect_attrs,
                        "module", "sect_attrs");
                MEMBER_OFFSET_INIT(module_sect_attrs_attrs,
                        "module_sect_attrs", "attrs");
                MEMBER_OFFSET_INIT(module_sect_attrs_nsections,
                        "module_sect_attrs", "nsections");
                MEMBER_OFFSET_INIT(module_sect_attr_mattr,
                        "module_sect_attr", "mattr");
                MEMBER_OFFSET_INIT(module_sect_attr_name,
                        "module_sect_attr", "name");
                MEMBER_OFFSET_INIT(module_sect_attr_address,
                        "module_sect_attr", "address");
                MEMBER_OFFSET_INIT(module_attribute_attr,
                        "module_attribute", "attr");
                MEMBER_OFFSET_INIT(module_sect_attr_attr,
                        "module_sect_attr", "attr");
                MEMBER_OFFSET_INIT(module_sections_attrs,
                        "module_sections", "attrs");
                MEMBER_OFFSET_INIT(attribute_owner,
                        "attribute", "owner");
...
                owner = attribute + OFFSET(attribute_owner);


----- "Guenter Roeck" <guenter.roeck@ericsson.com> wrote:

> Hi,
> 
> On Sat, Sep 04, 2010 at 02:01:06AM -0400, CAI Qian wrote:
> > 
> > > crash> mod -S
> > > 
> > > mod: invalid structure member offset: attribute_owner
> > >      FILE: symbols.c  LINE: 8577  FUNCTION:
> add_symbol_file_kallsyms()
> > > 
> > >      MODULE       NAME                   SIZE  OBJECT FILE
> > > ffffffffa000de60  dm_mod                76230 
> > >
> /lib/modules/2.6.36-rc2-mm1-wqfix-mkdfix+/kernel/drivers/md/dm-mod.ko
> > > [/usr/bin/crash] error trace: 4affb0 => 4f3236 => 4f12b5 =>
> 4e587a
> > > 
> > >   4e587a: OFFSET_verify.clone.4+186
> > >   4f12b5: add_symbol_file+933
> > >   4f3236: load_module_symbols+566
> > >   4affb0: do_module_cmd+1264
> > > 
> > > mod: invalid structure member offset: attribute_owner
> > >      FILE: symbols.c  LINE: 8577  FUNCTION:
> add_symbol_file_kallsyms()
> 
> What do I have to do to reproduce this crash ? 
> 
> Was the module in question compiled w/ the kernel, or separately ?
> Did it use the correct kernel header files for compilation ?
> Was the kernel version -rc3, or some other patched version ?
> 
> Just wondering, since the above message says
> 2.6.36-rc2-mm1-wqfix-mkdfix+,
> which seems to indicate that it included some modifications.
> 
> Thanks,
> Guenter
> 
> > This failure was due to this commit,
> > 
> > commit 6fd69dc578fa0b1bbc3aad70ae3af9a137211707
> > Author: Guenter Roeck <guenter.roeck@ericsson.com>
> > Date:   Wed Jul 28 22:09:26 2010 -0700
> > 
> >     sysfs: Remove owner field from sysfs struct attribute
> >     
> >     Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> >     Acked-by: Tejun Heo <tj@kernel.org>
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
> > index 8bf06b6..3c92121 100644
> > --- a/include/linux/sysfs.h
> > +++ b/include/linux/sysfs.h
> > @@ -22,14 +22,8 @@ struct kobject;
> >  struct module;
> >  enum kobj_ns_type;
> >  
> > -/* FIXME
> > - * The *owner field is no longer used.
> > - * x86 tree has been cleaned up. The owner
> > - * attribute is still left for other arches.
> > - */
> >  struct attribute {
> >         const char              *name;
> > -       struct module           *owner;
> >         mode_t                  mode;
> >  #ifdef CONFIG_DEBUG_LOCK_ALLOC
> >         struct lock_class_key   *key;
