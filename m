Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906Ab2IEXmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:42:09 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35835 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab2IEXmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:42:07 -0400
MIME-Version: 1.0
In-Reply-To: <874nndl3ro.fsf@rustcorp.com.au>
References: <20120816013405.872.42381.stgit@warthog.procyon.org.uk>
 <87627ufi2h.fsf@rustcorp.com.au> <CAKi4VALezG7VccXJfwvzr2UZrmAjCUp9eZRjGwqq6cWcExNqXA@mail.gmail.com>
 <874nndl3ro.fsf@rustcorp.com.au>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Wed, 5 Sep 2012 20:41:44 -0300
Message-ID: <CAKi4VA+R0EY9OteOCc=JGOqtshAJd5_CWu9tyJqjjkvG6qZUjw@mail.gmail.com>
Subject: Re: [RFC] module: signature infrastructure
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 9:19 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Lucas De Marchi <lucas.de.marchi@gmail.com> writes:
>> Hi Rusty,
>>
>> On Tue, Sep 4, 2012 at 2:55 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>> @@ -2399,7 +2437,50 @@ static inline void kmemleak_load_module(const struct module *mod,
>>>  }
>>>  #endif
>>>
>>> -/* Sets info->hdr and info->len. */
>>> +#ifdef CONFIG_MODULE_SIG
>>> +static int module_sig_check(struct load_info *info,
>>> +                           void *mod, unsigned long *len)
>>> +{
>>> +       int err;
>>> +       unsigned long i, siglen;
>>> +       char *sig = NULL;
>>> +
>>> +       /* This is not a valid module: ELF header is larger anyway. */
>>> +       if (*len < sizeof(MODULE_SIG_STRING))
>>> +               return -ENOEXEC;
>>> +
>>> +       for (i = 0; i < *len - (sizeof(MODULE_SIG_STRING)-1); i++) {
>>> +               /* Our memcmp is dumb, speed it up a little. */
>>> +               if (((char *)mod)[i] != MODULE_SIG_STRING[0])
>>> +                       continue;
>>
>> Since the signature is appended to the module, why don't you go
>> backwards, starting from *len - strlen(sizeof(MODULE_SIG_STRING)) and
>> making this first comparison?
>
> We've had this discussion multiple times.  Simple wins.  It's so
> marginal, I don't really care, but I've changed it to:

Sorry to come up with this suggestion only now (and after you have
already talked to me at LPC). Only after seeing this implementation I
thought about the implications of having the module signed in this
format.

I'm worried about performance here. Module loading can take a fair
amount of boot time. It may not be critical for servers or desktops
that we rarely boot, but it is for embedded uses.

>         int err;
>         unsigned long i, siglen, markerlen;
>         char *sig = NULL;
>
>         markerlen = strlen(MODULE_SIG_STRING);
>         /* This is not a valid module: ELF header is larger anyway. */
>         if (*len < markerlen)
>                 return -ENOEXEC;
>
>         for (i = *len - markerlen; i > 0; i--) {
>                 /* Our memcmp is dumb, speed it up a little. */
>                 if (((char *)mod)[i] != MODULE_SIG_STRING[0])
>                         continue;
>                 if (memcmp(mod+i, MODULE_SIG_STRING, markerlen))
>                         continue;
>
>                 sig = mod + i + markerlen;
>                 siglen = *len - i - markerlen;
>                 *len = i;
>                 break;
>         }
>
> We could also implement memrchr(), or memrmem().  Hell, if we had
> memmem() in the kernel I'd gladly use it.
>
>> Or let the magic string as the last thing in the module and store the
>> signature length, too. In this case no scanning is needed
>
> Yes, they did that too, but append is simpler.  I don't even have to
> think about endianness (Dmitry chose be32) or parsing (David chose
> 5-digit ascii numeric encoding).

Letting it in be32 is the simplest solution IMO. it's way simpler then
the loop above. You have to check exactly 1 byte to have a first
decision if module is not signed (as opposed to scanning the entire
module). Then you compare the memory area with MODULE_SIG_STRING and
have a final decision. To get the signature length it is just a matter
of converting it to host endiannes.  And we do have functions for
doing that. If it's for simplicity in kernel side, this one could be
implemented in half of the code above.

>
> Scanning the module is the least of our issues since we've just copied
> it and we're about to SHA it.

Yeah, but I don't think we need to scan it one more time. On every
boot. For every module


Lucas De Marchi
