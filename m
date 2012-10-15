Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab2JOLiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 07:38:13 -0400
Received: from mail.atsec.com ([195.30.99.214]:35006 "EHLO mail.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934Ab2JOLhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 07:37:55 -0400
Message-ID: <507BF36F.10205@atsec.com>
Date: Mon, 15 Oct 2012 13:28:47 +0200
From: Stephan Mueller <stephan.mueller@atsec.com>
Organization: atsec information security GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Alex Lyashkov <umka@cloudlinux.com>, Arnd Bergmann <arnd@arndb.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Josh Boyer <jwboyer@redhat.com>, linux-crypto@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Milan Broz <mbroz@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: FIPS-mode panic? (was Re: [PULL] modules)
References: <CA+55aFyVcTT4tKTVvhzXz3t4uw=MDLU00NAAOacWt6i3xovERg@mail.gmail.com> <87fw5m7ipz.fsf@rustcorp.com.au> <CA+55aFyGuy8P4Uaanmv7DncjsN6cvQxvWrrMKKnF=67J+BkshQ@mail.gmail.com> <15269.1350287454@warthog.procyon.org.uk>
In-Reply-To: <15269.1350287454@warthog.procyon.org.uk>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.10.2012 09:50:54, +0200, David Howells <dhowells@redhat.com> wrote:

Hi David,

> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> Hmm. So this thing makes me wonder:
>>
>>         /* Not having a signature is only an error if we're strict. */
>>         if (err < 0 && fips_enabled)
>>                 panic("Module verification failed with error %d in FIPS mode\n",
>>                       err);
>>
>> do we really want to panic (even in fips_enabled mode)?
> 
> That's what the FIPS people want.  As I understand it, if there's some
> indication that the crypto stuff is compromised, the box should be shut down
> immediately.
> 
> I've added Stephan Mueller to see if he can illuminate further.
> 
> David
> 

The requirement for a FIPS 140-2 module is to disable the entire module
if any component of its self test or integrity test failed.

In the kernel, we have the FIPS 140-2 module of the kernel crypto API
(the API itself plus the relevant kernel modules implementing the
ciphers, block chaining modes, etc). Therefore, the requirement would be
translated into the following: the kernel crypto API must be disabled if
any of the self test or integrity tests failed. The self tests are the
known answer tests in the kernel crypto API test manager. The integrity
tests are the DSA signature checks of the kernel modules (at least the
kernel crypto API ones) plus the static kernel binary itself (for the
static kernel crypto API part -- this is done outside the kernel).

The requirement to disable the module implies that the module is
technically unavailable.

There are two solutions that were contemplated for disabling the module:
having a kind of global status of the crypto API that makes it
non-responsive in case of an integrity/self-test error. The other
solution is to simply terminate the entire kernel. As the former one
also will lead to a kernel failure eventually as many parts of the
kernel depend on the crypto API, the implementation of the latter option
was chosen.
