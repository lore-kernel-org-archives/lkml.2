Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab1FURMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 13:12:25 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40499 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab1FURMW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 13:12:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ERlP7HoNyrJ7QSG3CtHb/cUwcOaYkzUizzUiDVnVZn4rzxg1PzEeXyWyN9Dl6UCJEn
         iIg/SuFeqWkKYbQvSk7s0Z8Hoqmhpp/3+OZ17kGYnHuexTMoLCYUAAQbQ59tKSWonns5
         i2J9Th4nuBC1jwCVtFcEtyg2CPpVMoYh8OMAo=
MIME-Version: 1.0
In-Reply-To: <20110621151040.GB7476@srcf.ucam.org>
References: <1307389135-8150-1-git-send-email-mjg@redhat.com>
	<1307389135-8150-3-git-send-email-mjg@redhat.com>
	<4DFFEC3B.90001@google.com>
	<20110621151040.GB7476@srcf.ucam.org>
Date: Tue, 21 Jun 2011 10:12:21 -0700
X-Google-Sender-Auth: I2beBIogdRdG9S01bg9t16TNJ1Y
Message-ID: <BANLkTimh8dWmYJFJY9e5sPHfYuL_FK1vbQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] efi: Add support for using efivars as a pstore backend
From: Tony Luck <tony.luck@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Mike Waychison <mikew@google.com>, linux-kernel@vger.kernel.org,
        Matt_Domsch@dell.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> How do I configure this thing?
>
> You don't. I'll be posting a patch for pstore that lets you choose the
> backend - that can be used to disable this functionality at boot time.

For EFI - you need to configure CONFIG_PSTORE (which you may not be
able to see until you first set CONFIG_MISCFILESYSTEMS) ... and of course
you'll need CONFIG_EFIVARS.  At the moment (until Matthew provides the
new pstore boot time choosing argument, you might need to set CONFIG_ACPI_APEI=n
because otherwise its a link order race to see who gets to register
their back end first.

Once you boot into that kernel you can mount pstore:

 # mount -t pstore - /dev/pstore

and once you crash/shutdown/reboot and mount it again - you should see
some files
in /dev/pstore with the tail of the saved console log from the
previous kernel. Remove
the files to clear the underlying store (in your case delete the efi
variables that saved
the text of the console log).

>> >+    sprintf(stub_name, "dump-type%u-%u-", type, part);
>>
>> The format specifier here uses an unsigned, but your series passes
>> part around as a signed int.  If part is truely non-negative,
>> consider changing it to unsigned?
>
> The variable name is fundamentally meaningless. Just think of it as a
> binary representation of the data. Formatting it as a signed integer
> would break the parsing. But you're right that there's probably no
> reason for it to be signed in the first place - Tony?

part numbers are integers (1, 2, 3 ...) - so making it unsigned makes sense.

>> Hmm.  pstore doesn't have a pstore_unregister?  This is unfortunate
>> because this breaks efivars module unloading :(
>
> Userspace really ought to depend on efivars being available on EFI
> systems. I don't think losing the ability to unload it is a big loss.

If there is a strong demand for this - maybe someone will write a patch
for it?  But in general, once you attach a backend to pstore, I'd expect
you to leave it attached - you don't know whether the system is about
to crash, and you'd lose the kernel log if you crashed while the backend
was not registered.

-Tony
