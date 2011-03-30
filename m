Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab1C3Pdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 11:33:44 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62236 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab1C3Pdm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 11:33:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=oiVEjJq5MrWYkQfiAdmfLzC8bzaJFDnYlKzi/p8/CxTRcSsqf3WhCnDgGb/5ts+OwE
         oVwkseIYH4hE4NUMAOmu8MdbAbKMffjv/EkSfTj0PiLHV/56bDeFA1M6N42Aw4devVFA
         hYS/b2WiZvwbb22GeNYloKjt+UAGrQ+3vwqrI=
MIME-Version: 1.0
In-Reply-To: <4D934648.7040500@kernel.org>
References: <c79ac2a9a1caad9865ffa3c4a05438227c59f63e.1301408701.git.luto@mit.edu>
 <4D934648.7040500@kernel.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 30 Mar 2011 11:33:21 -0400
X-Google-Sender-Auth: qI9dQe4mZLv-NNU3JlMpygiq2zg
Message-ID: <AANLkTi=gbVQjHx34BaGEAt7bkf8uQbPzU+UbUKmDwFH5@mail.gmail.com>
Subject: Re: [PATCH] x86-64: Clean up vdso/kernel shared variables
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 11:03 AM, H. Peter Anvin <hpa@kernel.org> wrote:
> On 03/29/2011 07:29 AM, Andy Lutomirski wrote:
>> Variables that are shared between the vdso and the kernel are
>> currently a bit of a mess.  They are each defined with their own
>> magic, they are accessed differently in the kernel, the vsyscall page,
>> and the vdso, and one of them (vsyscall_clock) doesn't even really
>> exist.
>>
>> This changes them all to use a common mechanism.  All of them are
>> delcared in vvar.h with a fixed address (validated by the linker
>> script).  In the kernel (as before), they look like ordinary
>> read-write variables.  In the vsyscall page and the vdso, they are
>> accessed through a new macro VVAR, which gives read-only access.
>>
>> The vdso is now loaded verbatim into memory without any fixups.  As a
>> side bonus, access from the vdso is faster because a level of
>> indirection is removed.
>>
>> Signed-off-by: Andy Lutomirski <luto@mit.edu>
>
> How does this deal with variables which really should be shared with
> multiple vdsos (in particular the 32-bit vdso and the 64-bit vdso)?
> Part of me is wondering if it might not be simpler to put them all into
> a structure?

Good question.  As far as I can tell, the 32-bit VDSO doesn't access
the vsyscall page at all.  I think it just has the magic needed to
invoke syscalls.  I don't know whether there even is a 32-bit
vgettimeofday, etc.

If we wanted to *add* that (for a huge performance increase on systems
with stable TSC), then there would need to be a 32-bit visible address
for the vsyscall page, and I don't know enough about the architecture
to do that without a bit of research.  Nor do I really feel inclined
to start messing with magic functions called compat_vread :)

I think a structure would be a little simpler, but similar magic would
be needed to find the think as we have now.  The down side is that
most of the kernel expects there to be a symbol called "jiffies".  So
we'd need more linker magic to make jiffies exist and point to the
right place in the structure.

--Andy
