Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab1FUPKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 11:10:54 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38059 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab1FUPKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:10:53 -0400
Date: Tue, 21 Jun 2011 16:10:40 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mike Waychison <mikew@google.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org, Matt_Domsch@dell.com
Subject: Re: [PATCH 3/3] efi: Add support for using efivars as a pstore
 backend
Message-ID: <20110621151040.GB7476@srcf.ucam.org>
References: <1307389135-8150-1-git-send-email-mjg@redhat.com>
 <1307389135-8150-3-git-send-email-mjg@redhat.com>
 <4DFFEC3B.90001@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFFEC3B.90001@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 05:56:27PM -0700, Mike Waychison wrote:
> On 06/06/11 12:38, Matthew Garrett wrote:
> >EFI provides an area of nonvolatile storage managed by the firmware. We
> >can use this as a pstore backend to maintain copies of oopses, aiding
> >diagnosis.
> 
> How do I configure this thing?

You don't. I'll be posting a patch for pstore that lets you choose the 
backend - that can be used to disable this functionality at boot time.

> >@@ -387,12 +400,145 @@ static struct kobj_type efivar_ktype = {
> >  	.default_attrs = def_attrs,
> >  };
> >
> >+static struct efivar_entry *walk_entry;
> >+
> >+static struct pstore_info efi_pstore_info;
> 
> Can you move these into struct efivars in efi.h?

In theory, but I don't really understand the benefit. You can't have 
more than one efivars implementation on a system.

> >+static u64 efi_pstore_write(enum pstore_type_id type, int part, size_t size,
> >+			    struct pstore_info *psi)
> >+{
> >+	char name[DUMP_NAME_LEN];
> >+	char stub_name[DUMP_NAME_LEN];
> >+	efi_char16_t efi_name[DUMP_NAME_LEN];
> >+	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
> >+	struct efivars *efivars = psi->data;
> >+	struct efivar_entry *entry, *found = NULL;
> >+	int i;
> >+
> >+	sprintf(stub_name, "dump-type%u-%u-", type, part);
> 
> The format specifier here uses an unsigned, but your series passes
> part around as a signed int.  If part is truely non-negative,
> consider changing it to unsigned?

The variable name is fundamentally meaningless. Just think of it as a 
binary representation of the data. Formatting it as a signed integer 
would break the parsing. But you're right that there's probably no 
reason for it to be signed in the first place - Tony?

> >+	list_for_each_entry(entry,&efivars->list, list) {
> >+		get_var_data_locked(efivars,&entry->var);
> >+
> >+		for (i = 0; i<  DUMP_NAME_LEN; i++) {
> >+			if (efi_name[i] == 0) {
> 
> Test for entry->var.VariableName[i] == 0 too.  Actually, could we
> just turn this string comparing loop into a strncmp test?

The idea is to check for prefixes. If efi_name[i] is non-zero but 
VariableName[i] is zero then we'll break due to them not matching, which 
is the desired behaviour.

> >+				found = entry;
> >+				efi.set_variable(entry->var.VariableName,&entry->var.VendorGuid,
> 
> space after comma

Oops.

> >+						 EFI_VARIABLE_NON_VOLATILE | EFI_VARIABLE_BOOTSERVICE_ACCESS | EFI_VARIABLE_RUNTIME_ACCESS,
> >+						 0, NULL);
> 
> We shouldn't be calling the global efi ops structure here.  Instead,
> we should be using efivars->ops->set_variable(...)

Ok.

> >  static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
> >  			     struct bin_attribute *bin_attr,
> >@@ -763,6 +909,14 @@ int register_efivars(struct efivars *efivars,
> >  	if (error)
> >  		unregister_efivars(efivars);
> >
> >+	efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
> >+	if (efi_pstore_info.buf) {
> >+		efi_pstore_info.bufsize = 1024;
> >+		efi_pstore_info.data = efivars;
> >+		mutex_init(&efi_pstore_info.buf_mutex);
> >+		pstore_register(&efi_pstore_info);
> >+	}
> >+
> 
> Hmm.  pstore doesn't have a pstore_unregister?  This is unfortunate
> because this breaks efivars module unloading :(

Userspace really ought to depend on efivars being available on EFI 
systems. I don't think losing the ability to unload it is a big loss.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
