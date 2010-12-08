Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab0LHRMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 12:12:24 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36758 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab0LHRMW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 12:12:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=ukcNRa+2iUz7Ji851sZ1AMtLgOPW6RtQHdCEQUasSOhht7IHMZUnzwPCXSh59iwMJF
         BwO6QA7aew1TPkyhvbZK6Uw7lSXC+pIv5dumYv4zWrAJQCTbKY2tlBHQ9/nVpObvdHJx
         Tmf2GqYgfP4yEleqSMmxgeyGJGxA3jShbaoBg=
MIME-Version: 1.0
In-Reply-To: <20101208062433.GB29751@liondog.tnic>
References: <4cfd2b97258571235f@agluck-desktop.sc.intel.com>
	<20101208062433.GB29751@liondog.tnic>
Date: Wed, 8 Dec 2010 09:12:21 -0800
X-Google-Sender-Auth: aJdg5tk3s9W1tUsxT3opwrlC3tQ
Message-ID: <AANLkTin7xDWO8fU2WA7cxC55TNi2+kAb50ajCySCfg9G@mail.gmail.com>
Subject: Re: [RFC] persistent store (version 3) (part 1 of 2)
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, greg@kroah.com,
        akpm@linux-foundation.org, ying.huang@intel.com,
        David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 7, 2010 at 10:24 PM, Borislav Petkov <bp@alien8.de> wrote:
> looks good. Minor nitpicks below.

Thanks for looking at this.

>> 1) Is "struct file" too big to be on the stack? I can change it to kmalloc() it.
>
> Well, this happens during normal operation when we init the pstore and
> since we don't need it after pstore_mkwrite has returned (do we?), I
> guess we should be fine.
struct file is 184 bytes (with the CONFIG options I am using, it can get
a bit larger, but not much).

>> +             the dying moments.  In the case of a panic() the last part
>
>                                                    "panic" (I'd remove the
>                                                                     brackets)

Ok. Will do.

>> +     dentry = d_alloc_name(root, name);
>> +     if (!IS_ERR(dentry))
>> +             d_add(dentry, inode);
>
> what happens if it IS_ERR? Error handling like
>
>        goto d_alloc_error;
>
> d_alloc_error:
>        iput(inode);
>        return -ENOSPC;
>
>
> or similar, at least this is what ramfs seems to be doing.

Good point - I need to clean up if things fail (and akpm would
like to see me re-factor so that there is only one "return"
statement for better maintainabiliy).  I'll fix up stuff here.

>> +     kmsg_dump_register(&pstore_dumper);
>
> You don't check psi->write() method's existence anymore, I'm assuming
> this is implied now... ?

Andrew's comments on version 2 were:
>It doesn't seem appropriate to check this here.  It's a programming
>error!  Just install the thing and let the kernel oops - the programmer
>will notice.

So I dropped the tests ... just checking whether the function pointer
was NULL wasn't a very strong test anyway.

>> +     if (!psinfo)
>> +             return -ENODEV;
>
> newline.

OK.

>> +#define PSTOREFS_MAGIC               0x6165676C
>
> what does that mean anyway? "aegl" :)

My initials: Anthony Eric George Luck. I've been using "aegl"
as my Unix login since 1979 (6th Edition on a pdp11/34).

>> +/* types */
>> +#define      PSTORE_TYPE_DMESG       0
>> +#define      PSTORE_TYPE_MCE         1
>
> You could make this into a proper enum
>
> enum pstore_type_id {
>        PSTORE_TYPE_DMESG       = 0,
>        PSTORE_TYPE_MCE         = 1,
>        PSTORE_TYPE_MAX,
> };
OK. Type checking is nice.  I think I might need a
PSTORE_TYPE_UNKNOWN to handle the case
where a new platform driver saves a record to
persistent store, and then the user boots an older
kernel that doesn't know about the new type (in
the APEI/ERST driver the type turns into a UUID
in the UEFI header for the record - so there is some
mapping going on at that level).

>> +struct pstore_info {
>> +     struct module   *owner;
>> +     char            *name;
>> +     struct mutex    mutex;  /* serialize access to 'buf' */
>
>  [ maybe a more descriptive variable name like buf_mutex or whatever ]

Sure. Will change.

>> +#if defined(CONFIG_PSTORE) || defined(CONFIG_PSTORE_MODULE)
>
> What is CONFIG_PSTORE_MODULE? Can't seem to find it in your (2 of 2)
> message either.

This is a remnant of when PSTORE was tristate - when I chose 'm'
rather than 'y' in "make menuconfig" I ended up with CONFIG_PSTORE_MODULE
rather than CONFIG_PSTORE.  But now it is just a "bool" this isn't
needed any more. Will fix.

-Tony
