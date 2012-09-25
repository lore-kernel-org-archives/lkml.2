Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab2IYQPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:15:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758162Ab2IYQPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:15:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CALLzPKaMV=te6XWS5zi43RYa4uJ9sADDizcsM_3=sOa9wayGCQ@mail.gmail.com>
References: <CALLzPKaMV=te6XWS5zi43RYa4uJ9sADDizcsM_3=sOa9wayGCQ@mail.gmail.com> <5555.1348531649@warthog.procyon.org.uk>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au, rusty@rustcorp.com.au,
        pjones@redhat.com, jwboyer@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: [GIT PULL] Asymmetric keys and module signing
Date: Tue, 25 Sep 2012 17:15:06 +0100
Message-ID: <8373.1348589706@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kasatkin, Dmitry <dmitry.kasatkin@intel.com> wrote:

> Just one question about key description...
> request_asymmetric_key uses format for key  description: "<signer>: <key-id>".
> Preparsing code creates description from those values.
> I see that key id is not 8 bytes anymore but full hash size of 20 bytes.

Remember:  This is for viewing via /proc/keys and KEYCTL_DESCRIBE as much as
for matching.

> For practical reasons for IMA it might be nice to save some space in
> xattrs and use shorter key id/description.

That's reasonable.

> As I understand from implementation, if key name is provided with "keyctl
> add", it will not be replaced with preparsed value.

Correct.

> And we can actually use any keyid we want?

Yes.

Note: The key type ->match() function is not required to limit itself to a
direct strcmp().  It is at liberty to partially match the description or any
other data attached to the key.

Look at asymmetric_key_match() in crypto/asymmetric/asymmetric_type.c.  If you
do a search for:

	"id:<hex-string>"

this will do a partial tail match on the key fingerprint:

[root@andromeda ~]# keyctl padd asymmetric "" @s </tmp/uefi-x509 
289786205
[root@andromeda ~]# cat /proc/keys
1145c95d I--Q---     1 perm 39390000     0     0 asymmetri Red Hat Test Certificate: 3580cf35d76b3b667a40df66691cbcf87353b23c: X509.RSA 7353b23c []
...
[root@andromeda ~]# keyctl search @s asymmetric "id:53b23c"
289786205


As an optimisation, it might be worth internally calling keyring_search_aux()
with our own match function that takes a binary key ID and storing the
fingerprint as binary rather than hex (attached to key->type_data.p[1]).

The type match function can only take text strings as it has to be invoked
from userspace.

David
