Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab2IRReg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 13:34:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738Ab2IRRed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 13:34:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120914103930.1e16ad8b@pyramind.ukuu.org.uk>
References: <20120914103930.1e16ad8b@pyramind.ukuu.org.uk> <20120913234802.3575.77103.stgit@warthog.procyon.org.uk> <20120913235005.3575.46218.stgit@warthog.procyon.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au, pjones@redhat.com,
        rusty@rustcorp.com.au, linux-crypto@vger.kernel.org, zohar@us.ibm.com,
        dmitry.kasatkin@intel.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/16] X.509: Add an ASN.1 decoder
Date: Tue, 18 Sep 2012 18:34:12 +0100
Message-ID: <13189.1347989652@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Why do this in the kernel.That appears to be completely insane.

A number of reasons:

 (1) The UEFI signature/key database may contain ASN.1 X.509 certificates and
     we may need to use those very early in the boot process, during initrd.

 (2) Even if userspace is available, offloading the key parsing to userspace
     means we have to have some way to trust what we get back.

 (3) Giving the kernel ASN.1 X.509 certs allows the kernel to verify the
     signature on that cert against a key it gets from the UEFI db.  For that,
     you need the raw cert.

> Can you prove it runs in a short bounded time for all inputs,

Possibly.  I'll have to think about that.  It may be relatively
straightforward.

 (1) The ASN.1 decoder is limited (currently) to a maximum of 64k of data to
     parse.

 (2) The decoder never goes backward through the data.

 (3) The decoder has a strictly limited recursion/nesting stack.

The decoder uses a state machine of a sort produced by the compiler.

 (1) Most nodes in this only have one transition.

 (2) Simple optional nodes are simply marked skippable.

 (3) There are some nodes that are like subroutine calls (for multiple-use
     constructed types), but these must return to the point directly after the
     call.

 (4) There are some nodes that have two transitions.  These are used for
     optional constructed type values (particularly multiple-use ones).
     Basically, they are jump-to-subroutine or skip.  The return must go back
     to the next node.

Writing a perl script to check the sanity of the compiler output should be easy
enough, though it would have to assume that the driver is sane.

> has it been fuzz tested extensively ?

Fuzz testing from a script is very easy, eg:

	#!/bin/sh
	cd /tmp
	sync
	declare -i n i j k
	while true
	do
	    n=$RANDOM
	    j=$RANDOM
	    j=j%10
	    k=0
	    echo $n $j
	    dd if=/dev/urandom of=/tmp/data bs=$n count=1
	    for ((i=1; i<n; i=i+k))
	    do
		dd if=/tmp/data bs=$i count=1 2>/dev/null |
		keyctl padd asymmetric foo @s 2>/dev/null
		k=k+1
		if [ $k -eq 10 ]
		    then
		    echo -n .
		    k=0
		fi
	    done
	    echo
	done

Though I haven't done a great deal of such testing as I want to be able to use
my test machine for other stuff too.  I can, however, run multiple fuzzers simultaneously.

I have also passed a number of bits of X.509 and PKCS#7 through it, and also
some valid ASN.1 that isn't what the decoder is expecting.

	#!/bin/sh

	file=/tmp/x509cert
	if [ "$1" != "" ]
	then
	    file=$1
	fi

	cd /tmp
	sync

	while true
	do
	    openssl req -new -x509 -outform PEM -keyout $file.pem -nodes -subj "/CN=GB/O=Red Hat/OU=Magrathea/CN=Slartibartfast" -out $file.x509 || exit $?

	    openssl x509 -in $file.x509 -inform PEM -outform DER >$file.x509.asn1 || exit $?
	    keyctl padd asymmetric bar @s <$file.x509.asn1 || exit $?

	    n=$RANDOM
	    if [ $n -lt 10 ]; then n=10; fi
	    dd if=/dev/urandom of=$file.stuff bs=$n count=1

	    openssl smime -sign -inkey $file.pem -signer $file.x509 -keyform PEM \
		-in $file.stuff -out $file.pkcs7 -binary -outform DER || exit $?

	    keyctl padd asymmetric baz @s <$file.pkcs7
	done

Unfortunately, the above is somewhat limited in what it can produce.

David
