Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab1BVX6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 18:58:44 -0500
Received: from smtp-out.google.com ([74.125.121.67]:56829 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1BVX6n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 18:58:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=lQ12I0dE9WS6ttKbxKZWsgPgTSfHsaygXSYX7iEnGgR1cYoPW/pXQvpmiscElbGGC/
         Hhsi8t2EGzi89dr16q3A==
MIME-Version: 1.0
In-Reply-To: <AANLkTi=wpVRSxY0HTnnJEeEN-VEOBQ7XJM5TrUu9Chqd@mail.gmail.com>
References: <20110217212754.3967.98648.stgit@mike.mtv.corp.google.com>
 <20110217212805.3967.47547.stgit@mike.mtv.corp.google.com> <AANLkTi=wpVRSxY0HTnnJEeEN-VEOBQ7XJM5TrUu9Chqd@mail.gmail.com>
From: Mike Waychison <mikew@google.com>
Date: Tue, 22 Feb 2011 15:58:19 -0800
Message-ID: <AANLkTikTCCWLUVpQXXOVB+x0J_8VRgUVr52ZQ-oVwZBx@mail.gmail.com>
Subject: Re: [PATCH v1 2/5] firmware: Basic dmi-sysfs support
To: Rob Lippert <rlippert@google.com>
Cc: Greg KH <greg@kroah.com>, Olof Johansson <olofj@chromium.org>,
        Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jon Mayer <jonmayer@google.com>, Duncan Laurie <dlaurie@google.com>,
        Aaron Durbin <adurbin@google.com>, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, David Hendrix <dhendrix@chromium.org>,
        linux-api@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 3:49 PM, Rob Lippert <rlippert@google.com> wrote:
> On Thu, Feb 17, 2011 at 1:28 PM, Mike Waychison <mikew@google.com> wrote:
>> Introduce a new module "dmi-sysfs" that exports the broken out entries
>> of the DMI table through sysfs.
>>
>> Entries are enumerated via dmi_walk() on module load, and are populated
>> as kobjects rooted at /sys/firmware/dmi/entries.
>>
>> Entries are named "<type>-<instance>", where:
>>   <type>       : is the type of the entry, and
>>   <instance>   : is the ordinal count within the DMI table of that
>>                  entry type.  This instance is used in lieu the DMI
>>                  entry's handle as no assurances are made by the kernel
>>                  that handles are unique.
>>
>> All entries export the following attributes:
>
> Can you add an entry here for index/ordinal in the set of all tables?
> This way the user can walk the tables in the original order exported
> by the BIOS.  Some (buggy) BIOSes don't properly set up links between
> things like MEM_ARRAY and MEM_DEVICE tables but depend on the position
> of the table relative to other tables.
>

Oh weird.  I can add an attribute called "position" if that works?
I'd rather not put the position in the directory name itself if I can
help it though, it just looks -- odd.

>> +/*
>> + * Calculate and return the byte length of the dmi entry identified by
>> + * dh.  This includes both the formatted portion as well as the
>> + * unformatted string space, including the two trailing nul characters.
>> + */
>> +static size_t dmi_entry_length(const struct dmi_header *dh)
>> +{
>> +       const char *p = (const char *)dh;
>> +
>> +       p += dh->length;
>> +
>> +       while (p[0] || p[1])
>> +               p++;
>> +
>
> Is there any chance this could walk outside of SMBIOS space on a
> corrupted table?  I can point you at some machines with corrupted
> tables to test on if you want.

AFAICT, this should be safe to do.  dmi_table() is the code that
iterates through the table of entries, and will not callback any
entries if it can't find the double nul characters within dmi_len
bytes (as described by the dmi table header).

I'd be happy to test this on machines that get it wrong though.  Just
add me to the auth files and IM me the hostnames :)
