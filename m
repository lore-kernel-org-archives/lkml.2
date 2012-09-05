Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab2IEIWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 04:22:54 -0400
Received: from ozlabs.org ([203.10.76.45]:41788 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab2IEIVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 04:21:52 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: David Howells <dhowells@redhat.com>, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] module: signature infrastructure
In-Reply-To: <CAKi4VALezG7VccXJfwvzr2UZrmAjCUp9eZRjGwqq6cWcExNqXA@mail.gmail.com>
References: <20120816013405.872.42381.stgit@warthog.procyon.org.uk> <87627ufi2h.fsf@rustcorp.com.au> <CAKi4VALezG7VccXJfwvzr2UZrmAjCUp9eZRjGwqq6cWcExNqXA@mail.gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 05 Sep 2012 09:49:55 +0930
Message-ID: <874nndl3ro.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucas De Marchi <lucas.de.marchi@gmail.com> writes:
> Hi Rusty,
>
> On Tue, Sep 4, 2012 at 2:55 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> @@ -2399,7 +2437,50 @@ static inline void kmemleak_load_module(const struct module *mod,
>>  }
>>  #endif
>>
>> -/* Sets info->hdr and info->len. */
>> +#ifdef CONFIG_MODULE_SIG
>> +static int module_sig_check(struct load_info *info,
>> +                           void *mod, unsigned long *len)
>> +{
>> +       int err;
>> +       unsigned long i, siglen;
>> +       char *sig = NULL;
>> +
>> +       /* This is not a valid module: ELF header is larger anyway. */
>> +       if (*len < sizeof(MODULE_SIG_STRING))
>> +               return -ENOEXEC;
>> +
>> +       for (i = 0; i < *len - (sizeof(MODULE_SIG_STRING)-1); i++) {
>> +               /* Our memcmp is dumb, speed it up a little. */
>> +               if (((char *)mod)[i] != MODULE_SIG_STRING[0])
>> +                       continue;
>
> Since the signature is appended to the module, why don't you go
> backwards, starting from *len - strlen(sizeof(MODULE_SIG_STRING)) and
> making this first comparison?

We've had this discussion multiple times.  Simple wins.  It's so
marginal, I don't really care, but I've changed it to:

	int err;
	unsigned long i, siglen, markerlen;
	char *sig = NULL;

	markerlen = strlen(MODULE_SIG_STRING);
	/* This is not a valid module: ELF header is larger anyway. */
	if (*len < markerlen)
		return -ENOEXEC;

	for (i = *len - markerlen; i > 0; i--) {
		/* Our memcmp is dumb, speed it up a little. */
		if (((char *)mod)[i] != MODULE_SIG_STRING[0])
			continue;
		if (memcmp(mod+i, MODULE_SIG_STRING, markerlen))
			continue;

		sig = mod + i + markerlen;
		siglen = *len - i - markerlen;
		*len = i;
		break;
	}

We could also implement memrchr(), or memrmem().  Hell, if we had
memmem() in the kernel I'd gladly use it.

> Or let the magic string as the last thing in the module and store the
> signature length, too. In this case no scanning is needed

Yes, they did that too, but append is simpler.  I don't even have to
think about endianness (Dmitry chose be32) or parsing (David chose
5-digit ascii numeric encoding).

Scanning the module is the least of our issues since we've just copied
it and we're about to SHA it.

Cheers,
Rusty.
