Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab2IEIV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 04:21:56 -0400
Received: from ozlabs.org ([203.10.76.45]:54238 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab2IEIVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 04:21:52 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Kasatkin\, Dmitry" <dmitry.kasatkin@intel.com>
Cc: David Howells <dhowells@redhat.com>, zohar@linux.vnet.ibm.com,
        jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] module: signature infrastructure
In-Reply-To: <CALLzPKaA3MYncJD1X6B8f3p-R6FVA5-WDF-h6GGwdtinNpjqmw@mail.gmail.com>
References: <20120816013405.872.42381.stgit@warthog.procyon.org.uk> <87627ufi2h.fsf@rustcorp.com.au> <CALLzPKaA3MYncJD1X6B8f3p-R6FVA5-WDF-h6GGwdtinNpjqmw@mail.gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 05 Sep 2012 09:59:22 +0930
Message-ID: <871uihl3bx.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Kasatkin, Dmitry" <dmitry.kasatkin@intel.com> writes:
> Hi,
>
> Please read bellow...
>
> On Tue, Sep 4, 2012 at 8:55 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> OK, I took a look at the module.c parts of David and Dmitry's patchsets,
>> and didn't really like either, but I stole parts of David's to make
>> this.
>>
>> So, here's the module.c part of module signing.  I hope you two got time
>> to discuss the signature format details?  Mimi suggested a scheme where
>> the private key would never be saved on disk (even temporarily), but I
>> didn't see patches.  Frankly it's something we can do later; let's aim
>> at getting the format right for the next merge window.
>
> In our patches key is stored on the disc in encrypted format...

Oh, I missed that twist.  Thanks for the explanation.

On consideration, I prefer signing to be the final part of the "modules"
target rather than modules_install.  I run the latter as root, and that
is wrong for doing any code generation.

>> +       for (i = 0; i < *len - (sizeof(MODULE_SIG_STRING)-1); i++) {
>> +               /* Our memcmp is dumb, speed it up a little. */
>> +               if (((char *)mod)[i] != MODULE_SIG_STRING[0])
>> +                       continue;
>> +               if (memcmp(mod, MODULE_SIG_STRING, strlen(MODULE_SIG_STRING)))
>
> should be (mod+i)?

Yes, indeed.  Thanks, fixed.

>> +                       continue;
>> +
>> +               sig = mod + i + strlen(MODULE_SIG_STRING);
>> +               siglen = *len - i - strlen(MODULE_SIG_STRING);
>> +               *len = i;
>> +               break;
>> +       }
>
> In general please clarify why do you need such parsing at all?
> Why not to have MODULE_SIG_STRING as a last octets of the module and
> have signature length field before?
> Then it is easy to get the signature and rest of the module?
> That will be super fast...
>
> Please clarify.

Ignore performance, it's just not an issue here.  So the simplest code
wins.

And it's also simpler to sign a module this way.

        (echo '~Module signature appended~'; gpg --sign ....) >> mod.ko

Cheers,
Rusty.
