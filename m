Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377Ab1LNW6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 17:58:14 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58012 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560Ab1LNW6N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 17:58:13 -0500
MIME-Version: 1.0
In-Reply-To: <20111214223950.GA29264@srcf.ucam.org>
References: <1323896791-10858-1-git-send-email-mjg@redhat.com>
 <1323896791-10858-4-git-send-email-mjg@redhat.com> <CAGTjWtCpt_1h6XMwCFkx1TQnQbagtSuFBejcp6XNr4yhKgNuLg@mail.gmail.com>
 <20111214223950.GA29264@srcf.ucam.org>
From: Mike Waychison <mikew@google.com>
Date: Wed, 14 Dec 2011 14:57:51 -0800
Message-ID: <CAGTjWtARm_OA0qy2Cvtc-rrPFpH2+2QdFw4CvBAo-PJsfX6t6w@mail.gmail.com>
Subject: Re: [PATCH 3/4] EFI: Add support for variables longer than 1024 bytes
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 2:39 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Dec 14, 2011 at 02:14:27PM -0800, Mike Waychison wrote:
>
>> >  static efi_status_t
>> > -get_var_data_locked(struct efivars *efivars, struct efi_variable *var)
>> > +get_var_data_locked(struct efivars *efivars, struct extended_efi_variable **var)
>> >  {
>> >        efi_status_t status;
>> > +       unsigned long length;
>> > +
>> > +       if (!*var)
>> > +               *var = kmalloc(sizeof(struct extended_efi_variable), GFP_KERNEL);
>>
>> Aren't we holding a spinlock here?
>
> Good point.
>
>> > +
>> > +       (*var)->header.DataSize = 0;
>> > +       status = efivars->ops->get_variable((*var)->header.VariableName,
>> > +                                           &(*var)->header.VendorGuid,
>> > +                                           &(*var)->header.Attributes,
>> > +                                           &(*var)->header.DataSize,
>> > +                                           (*var)->Data);
>>
>> This doesn't look right.  ->Data here is after the Data[1024] buffer
>> embedded in (*var)->header, and a read into this buffer will corrupt
>> the heap.
>
> DataSize is 0, so we'll never actually read anything back here.

Ah.  I missed that.  Hmm, I wonder if this actually works :)

>
>> > +
>> > +       if (status == EFI_BUFFER_TOO_SMALL) {
>> > +               *var = krealloc(*var, sizeof(struct extended_efi_variable) +
>> > +                               (*var)->header.DataSize, GFP_KERNEL);
>> > +               status = efivars->ops->get_variable((*var)->header.VariableName,
>> > +                                                   &(*var)->header.VendorGuid,
>> > +                                                   &(*var)->header.Attributes,
>> > +                                                   &(*var)->header.DataSize,
>> > +                                                   (*var)->Data);
>> > +       }
>> > +
>> > +       length = ((*var)->header.DataSize < 1024) ? (*var)->header.DataSize :
>> > +               1024;
>> > +
>> > +       memcpy(&(*var)->header.Data, &(*var)->Data, length);
>>
>> This memcpy clobbers the header.Data with the corrupted data when we
>> didn't use the second path.
>
> We'll always follow the second path providing there's actually data to
> read back. If there isn't then length will be 0.
>
>> > +       if (count == sizeof(struct efi_variable)) {
>> > +               tmp_var = (struct efi_variable *)buf;
>> > +               new_var = kmalloc(sizeof(struct efi_variable) +
>> > +                                 tmp_var->DataSize, GFP_KERNEL);
>> > +               memcpy(&new_var->header, tmp_var, sizeof(struct efi_variable));
>> > +               memcpy(&new_var->Data, tmp_var->Data, tmp_var->DataSize);
>> > +       } else if (count > sizeof(struct efi_variable)) {
>> > +               new_var = (struct extended_efi_variable *)buf;
>> > +       } else {
>> >                return -EINVAL;
>> > +       }
>>
>> Ugh.  This is difficult to follow, and complicates the memory freeing path :(
>
> Entirely agreed.
>
>> We need to be careful here.  The store_raw ABI is broken, in the sense
>> that the ABI from compat mode differs from that in 32bit mode (there
>> is a long in the efi_variable structure which changes the offsets).  I
>> don't know how to fix it properly and still maintain proper ABI
>> compatibility.
>
> True.
>
>> What are your thoughts on _not_ wrapping efi_variable with
>> extended_efi_variable, and instead just using a
>> "internal_efi_variable" structure that we copy stuff into/outof.  I
>> think that would make the memory management for dealing with the
>> different sizes a lot easier to follow.
>
> Hm. I think that'd only work if we expose a new interface. Writes would
> be easy enough to handle, but reads still need to work for old apps.

Well,l we could *not* support returning all the data field for
datasize > 1024, and simply truncate the field.  We are limited by
PAGE_SIZE by sysfs here anyway (so we don't really want to have a
variable size memcpy in efivar_show_raw).
