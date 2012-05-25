Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab2EYLQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 07:16:03 -0400
Received: from mga12.intel.com ([143.182.124.36]:43845 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751763Ab2EYLQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 07:16:01 -0400
MIME-Version: 1.0
In-Reply-To: <8762blyedn.fsf@rustcorp.com.au>
References: <87obpfxdpr.fsf@rustcorp.com.au>
	<20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
	<7474.1337782847@redhat.com>
	<8762blyedn.fsf@rustcorp.com.au>
Date: Fri, 25 May 2012 14:15:40 +0300
Message-ID: <CALLzPKYVahsgcsyF0zMP+wLNAp5TeiGeofy5KJyMHkjsdyvo9Q@mail.gmail.com>
Subject: Re: [PATCH 00/23] Crypto keys and module signing
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>, kyle@mcmartin.ca,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 3:04 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Wed, 23 May 2012 15:20:47 +0100, David Howells <dhowells@redhat.com> wrote:
>> Rusty Russell <rusty@rustcorp.com.au> wrote:
>>
>> >         That's pretty weird.  Why not put the "@This Is A Crypto Signed
>> > Module\n" before the signature?  Then module-size is implied: everything
>> > before that signature.  The signature size is implied: everything after
>> > that signature.
>>
>> This makes it simpler.  No scanning required.  The magic number can only be in
>> one place and you can find it by dead reckoning.
>
> Scanning isn't complicated.  Slow, sure, but I doubt you can really
> measure it when you're doing crypto.
>
> Compare:
>
> (1) Your scheme signing looks something like this:
>        gpg --sign $m > $m.sig
>        MSIZE=`ls -l $m | awk '{ print $5 }'`
>        SSIZE=`ls -l $m.sig | awk '{ print $5 }'`
>
>        printf '@%-10i@%-10i@This Is A Crypto Signed Module' $MSIZE $SSIZE >> $m
>
> (2) Your verification scheme looks like this:
>
>  +      magic_size = sizeof(modsign_magic) - 1;
>  +      if (size <= 11 + 11 + magic_size)
>  +              return 1;
>  +
>  +      if (memcmp(data + size - magic_size, modsign_magic, magic_size) != 0)
>  +              return 1;
>  +      size -= 11 + 11 + magic_size;
>  +
>  +      cp = data + size;
>  +      if (cp[ 0] != '@' && cp[ 9] != '@' && cp[10] != '\n' &&
>  +          cp[11] != '@' && cp[20] != '@' && cp[21] != '\n')
>  +              return -ELIBBAD;
>  +      mod_size = simple_strtoul(cp + 1, &end, 10);
>  +      if (mod_size > size || (*end != ' ' && *end != '@'))
>  +              return -ELIBBAD;
>  +      sig_size = simple_strtoul(cp + 12, &end, 10);
>  +      if (sig_size > size || (*end != ' ' && *end != '@'))
>  +              return -ELIBBAD;
>  +
>  +      pr_devel("sig at %zu, size %zu (to %zu)\n", mod_size, sig_size,
>  size);
>  +      if (size - mod_size != sig_size)
>  +              return -ELIBBAD;
>
> Now, the scheme I suggested looks like this:
>
> (1) Signing:
>        gpg --sign $m > $m.sig
>        (echo @This Is A Crypto Signed Module; cat $m.sig) >> $m
>
> (2) Verification:
>        size_t i;
>
>        if (i < modsign_magic)
>                return 1;
>
>        for (i = size - modsign_magic;
>             memcmp(data + i, modsign_magic, magic_size) != 0);
>             i++) {
>                if (i == 0)
>                        return 1;
>        }
>
>        /* module: "data", size "i".
>         * sig: "data + i + magic_size", size "size - (i + magic_size)" */
>
>> >         In fact, I'd modify this slightly, to allow multiple signatures.
>> > This would work nicely with a deterministic strip.  Find the signatures
>> > backward, and truncate as they fail.
>>
>> Why would you want multiple signatures?  That just complicates things.
>
> The code above stays pretty simple; if the signature fails, you set size
> to i, and loop again.  As I said, if you know exactly how you're going
> to strip the modules, you can avoid storing the stripped module and
> simply append both signatures.
>
>> If you're in FIPS mode, you probably have to panic if any of them fail.
>
> I had to look up what FIPS was, so I'm not qualified to comment.
>
>> I suppose I may as well punt the signature detection and removal to userspace
>> and pass the signature as an argument to init_module() as Dmitry suggested.
>> Then the signature need not be in the file at all (he wants to use an xattr or
>> hardware, I think).  mkinitrd and rpmbuild/kernel spec have to be changed to
>> accommodate enablement of these patches, so why not module-init-tools, dracut
>> and busybox whilst we're at it?

Actually it is not for hw.
I have implemented reading of signature from security.ima xattr and
from .sig file.

http://linux-ima.git.sourceforge.net/git/gitweb.cgi?p=linux-ima/module-init-tools.git;a=summary

>
> In some ways that is cleaner, but it's also nice to avoid adding another
> syscall.

There is no additional syscall.
signature is passed is 'ima=' parameter to init_module()
like

----------------------------------------------------------
root@ubuntu:~# modprobe -v button
insmod /lib/modules/3.4.0-rc5-kds+/kernel/drivers/acpi/button.ko
ima=016e7cbb4f00005d2b05fc633ee3e8010400ad30f2e50d52456ef4a4f0c540f3c8d9955b7ea125cd2dd0cb41216d1388801427c6bddc1431c82e4e82372e6a2101afdcf0daa4f59e1b3d9581d9f1fd0f003fede88d6679814a0887e056a7ddabf070e96cdf5901201d7a6cd4717af68500bd2af88d078a9f1cfc136f5e2d8d0df710121fbb5658c248714f77bb6879aba7b4
----------------------------------------------------------

- Dmitry
>
> Cheers,
> Rusty.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
